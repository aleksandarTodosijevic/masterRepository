/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/



EXEC dbo.usp_PopulateDimDate @start = '1900-01-01', @end = '1900-01-01';
EXEC dbo.usp_PopulateDimDate @start = '1970-01-01', @end = '2000-12-31';
EXEC dbo.usp_PopulateDimDate @start = '2001-01-01', @end = '2070-12-31';
EXEC dbo.usp_PopulateDimDate @start = '9999-12-31', @end = '9999-12-31';

EXEC dbo.usp_PopulateDimProjectionYear;