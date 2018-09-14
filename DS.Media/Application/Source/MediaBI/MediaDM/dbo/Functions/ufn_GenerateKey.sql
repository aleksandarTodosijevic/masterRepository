CREATE FUNCTION [dbo].[ufn_GenerateKey]
(@input INT, @input2 INT) 
RETURNS TABLE
AS

RETURN
	SELECT
		@input sourcevalue,
		@input2 sourcevalue2,
		CAST(HASHBYTES('SHA1',CAST(COALESCE(@input,'-1') AS VARCHAR(8000))) AS BIGINT) generatedkey,
		CAST(HASHBYTES('SHA1',CAST(COALESCE(@input2,'-1') AS VARCHAR(8000))) AS BIGINT) generatedkey2