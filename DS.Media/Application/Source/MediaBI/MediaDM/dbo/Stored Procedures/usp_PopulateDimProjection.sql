CREATE PROCEDURE [dbo].[usp_PopulateDimProjection]
AS
SET NOCOUNT ON;

DECLARE @DeletedOn AS DATETIME = GETDATE();

IF OBJECT_ID('tempdb..#DimProjection') IS NOT NULL DROP TABLE #DimProjection

SELECT * INTO #DimProjection FROM dbo.DimProjection WHERE 1 = 2;


INSERT INTO #DimProjection
SELECT 
	 ProjectionKey 
	,ProjectionNo
	,ProjectionNoT
	,ProjectionName
	,ProjectionNameT
	,SubjectCategory
    ,dbo.ufn_GetHashDimProjection(ProjectionKey, ProjectionNo, ProjectionNoT, ProjectionName, ProjectionNameT, SubjectCategory) AS HashKey
    ,NULL AS DeletedOn
FROM (
	SELECT DISTINCT
		dbo.CreateKeyFromSourceID(p.ProjectionNo + ':' +  COALESCE(p.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sc.[Id] AS VARCHAR(10) ), '-1')) ProjectionKey
		,p.ProjectionNo
		,COALESCE(p.ProjectionNoT, '-1') AS ProjectionNoT
		,COALESCE(pnr.[Description], 'N/A') AS ProjectionName
		,COALESCE(pnrt.[Description], 'N/A') AS ProjectionNameT
		,COALESCE(sc.[Description], 'N/A') AS SubjectCategory
	FROM [$(MediaDMStaging)].dbo.Product p
	LEFT JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pnr ON pnr.Id = p.ProjectionNo
	LEFT JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pnrt ON pnrt.Id = p.ProjectionNoT
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = p.SubjectCategoryId

	UNION 

	-- Projection without subject category
	Select DISTINCT
		dbo.CreateKeyFromSourceID(p.ProjectionNo +':' +  COALESCE(p.ProjectionNoT, '-1') +  ':' + '-1') ProjectionKey
		,p.ProjectionNo
		,COALESCE(p.ProjectionNoT, '-1') AS ProjectionNoT
		,pnr.[Description] AS ProjectionName
		,COALESCE(pnrt.[Description], 'N/A') AS ProjectionNameT
		,'N/A' AS SubjectCategory
	FROM [$(MediaDMStaging)].dbo.Product p
	LEFT JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pnr ON pnr.Id = p.ProjectionNo
	LEFT JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pnrt ON pnrt.Id = p.ProjectionNoT
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = p.SubjectCategoryId

	UNION
	-- combination of Projection and subject category from Property portfolio (maintain by user)
	Select DISTINCT
		dbo.CreateKeyFromSourceID(p.ProjectionNo + ':' +  COALESCE(p.ProjectionNoT, '-1') + ':' + COALESCE(CAST(sp.[SubjectCategory_ID] AS VARCHAR(10) ), '-1')) ProjectionKey
		,p.ProjectionNo
		,COALESCE(p.ProjectionNoT, '-1') AS ProjectionNoT
		,COALESCE(pnr.[Description], 'N/A') AS ProjectionName
		,COALESCE(pnrt.[Description], 'N/A') AS ProjectionNameT
		,COALESCE(sc.[Description], 'N/A') AS SubjectCategory
	FROM [$(MediaDMStaging)].dbo.MDS_SalesPortfolio sp
	INNER JOIN [$(MediaDMStaging)].dbo.Product p ON p.ProjectionNo = sp.T_Number
	LEFT JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pnr ON pnr.Id = p.ProjectionNo
	LEFT JOIN [$(MediaDMStaging)].dbo.ProjectionNumber pnrt ON pnrt.Id = p.ProjectionNoT
	LEFT JOIN [$(MediaDMStaging)].dbo.SubjectCategory_lu sc ON sc.Id = sp.[SubjectCategory_ID]

	UNION

	Select 
		dbo.CreateKeyFromSourceID('-1' + ':' +  '-1' + ':' + '-1') ProjectionKey
		,'-1'
		,'-1'
		,'N/A'
		,'N/A'
		,'N/A'
) tt;



MERGE 
    dbo.DimProjection t
USING 
    #DimProjection s ON (t.ProjectionKey = s.ProjectionKey)
WHEN MATCHED AND (t.HashKey <> s.HashKey oR t.HashKey IS NULL) THEN  
    UPDATE SET
		 t.ProjectionKey = s.ProjectionKey 
		,t.ProjectionNo = s.ProjectionNo
		,t.ProjectionNoT = s.ProjectionNoT
		,t.ProjectionName = s.ProjectionName
		,t.ProjectionNameT = s.ProjectionNameT
		,t.SubjectCategory = s.SubjectCategory
		,t.HashKey = s.HashKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProjectionKey, ProjectionNo, ProjectionNoT, ProjectionName, ProjectionNameT, SubjectCategory, HashKey)
    VALUES (s.ProjectionKey, s.ProjectionNo, s.ProjectionNoT, s.ProjectionName, s.ProjectionNameT, s.SubjectCategory, s.HashKey)
WHEN NOT MATCHED BY SOURCE AND t.DeletedOn IS NULL THEN
     UPDATE SET t.DeletedOn = @DeletedOn;


RETURN 0;

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_PopulateDimProjection] TO [ETLRole]
    AS [dbo];
GO

GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[usp_PopulateDimProjection] TO [DataServices]
    AS [dbo];
GO
