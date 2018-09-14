CREATE PROCEDURE [dbo].[usp_TruncateTable]
	@Schema NVARCHAR(100),
	@TableName NVARCHAR(100)
AS

DECLARE @cmd NVARCHAR(MAX)
DECLARE @ParentSchema NVARCHAR(MAX)
DECLARE @Check INT
DECLARE @ErrorMessage NVARCHAR(MAX)

PRINT 'Check Table exists'

SELECT @Check = count(*) FROM sys.tables WHERE name = @TableName and OBJECT_SCHEMA_NAME(object_id) = @Schema

IF @Check = 0
BEGIN
	PRINT 'Table does not exist';
	SET @ErrorMessage = @TableName + ' does not exist.';
	THROW 51000, @ErrorMessage , 1; /*Forces an error to halt future operations*/
END
ELSE
BEGIN
	PRINT 'Creating temp table to hold foreign key details'

	SELECT
		fkc.constraint_object_id,
		OBJECT_NAME(fkc.constraint_object_id) AS ForeignKeyName,
		t_p.name AS ParentTable,
		t_r.name AS RefTable,
		'[' + c_p.name + ']' AS ParentColumn,
		'[' + c_r.name + ']' AS RefColumn,
		SCHEMA_NAME(t_p.schema_id) AS ParentSchema,
		SCHEMA_NAME(t_r.schema_id) AS RefSchema
	INTO #tmpForeignKeyColumns
	FROM sys.foreign_key_columns fkc with (nolock)
		INNER JOIN sys.columns c_p with (nolock) ON c_p.object_id = fkc.parent_object_id and c_p.column_id = fkc.parent_column_id
		INNER JOIN sys.tables t_p with (nolock) ON t_p.object_id = fkc.parent_object_id
		INNER JOIN sys.columns c_r with (nolock) ON c_r.object_id = fkc.referenced_object_id and c_r.column_id = fkc.referenced_column_id
		INNER JOIN sys.tables t_r with (nolock) ON t_r.object_id = fkc.referenced_object_id
	WHERE
		t_r.name = @TableName and SCHEMA_NAME(t_r.schema_id) = @Schema

	ORDER BY OBJECT_NAME(fkc.constraint_object_id);

	PRINT 'Remove foreign key contraints'

	DECLARE fk_cursor CURSOR
		FOR SELECT ('ALTER TABLE [' + fkc.ParentSchema + '].[' + fkc.ParentTable + '] DROP CONSTRAINT [' + fkc.ForeignKeyName + ']') FROM #tmpForeignKeyColumns AS fkc GROUP BY fkc.ParentSchema, fkc.ParentTable, fkc.ForeignKeyName
	OPEN fk_cursor
	FETCH NEXT FROM fk_cursor INTO @cmd
	WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT 'Executing ' + @cmd
			EXEC (@cmd)
			FETCH NEXT FROM fk_cursor INTO @cmd
		END
	CLOSE fk_cursor
	DEALLOCATE fk_cursor

	PRINT 'Truncate Table'

	EXEC ('TRUNCATE TABLE [' + @Schema + '].[' + @TableName + ']')

	PRINT 'Recreate foreign key contraints'

	DECLARE fk_cursor CURSOR
		FOR SELECT ('ALTER TABLE [' + fkc.ParentSchema + '].['+fkc.ParentTable+'] WITH NOCHECK ADD CONSTRAINT ['+fkc.ForeignKeyName+'] FOREIGN KEY('+ STUFF((SELECT ',' + fkc1.ParentColumn FROM #tmpForeignKeyColumns fkc1 WHERE fkc1.constraint_object_id = fkc.constraint_object_id FOR XML PATH ('')), 1, 1, '') +') REFERENCES [' + fkc.RefSchema + '].['+fkc.RefTable+'] ('+STUFF((SELECT ',' + fkc1.RefColumn FROM #tmpForeignKeyColumns fkc1 WHERE fkc1.constraint_object_id = fkc.constraint_object_id FOR XML PATH ('')), 1, 1, '')+');ALTER TABLE [' + fkc.ParentSchema + '].['+fkc.ParentTable+'] CHECK CONSTRAINT ['+fkc.ForeignKeyName+'];') FROM #tmpForeignKeyColumns AS fkc GROUP BY fkc.constraint_object_id, fkc.ForeignKeyName, fkc.ParentSchema, fkc.ParentTable, fkc.RefSchema, fkc.RefTable
	OPEN fk_cursor
	FETCH NEXT FROM fk_cursor INTO @cmd
	WHILE @@FETCH_STATUS=0
		BEGIN
			EXEC (@cmd)
			FETCH NEXT FROM fk_cursor INTO @cmd
		END
	CLOSE fk_cursor
	DEALLOCATE fk_cursor

	PRINT 'Drop temp table'
	DROP TABLE #tmpForeignKeyColumns;
END;

RETURN 0;
GO
GRANT EXECUTE ON OBJECT::[dbo].[usp_TruncateTable] TO [ETLRole] AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_TruncateTable] TO [DataServices]
    AS [dbo];
GO

