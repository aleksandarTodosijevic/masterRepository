Create FUNCTION [dbo].[ufn_GetHashDimUser]
(
	 @UserKey BIGINT
	,@SourceUserId INT
	,@FirstName VARCHAR(50)
	,@LastName VARCHAR(50)
	,@FullName VARCHAR(100)
	,@LoginId VARCHAR(20)
	,@SystemRole VARCHAR(50)
	,@Locked CHAR(3)
	,@Status VARCHAR(20)
	,@LastLoginDate DATE
	,@Email VARCHAR(80)
	,@PreferencesJson NVARCHAR(MAX)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @UserKey AS USerKey
	,@SourceUserId AS SourceUserId
	,@FirstName AS FirstName
	,@LastName AS LastName
	,@FullName AS FullName
	,@LoginId AS LoginId
	,@SystemRole AS SystemRole
	,@Locked AS Locked
	,@Status AS Status
	,@LastLoginDate AS LastLoginDate
	,@Email AS Email
	,@PreferencesJson AS PreferencesJson
	FOR XML RAW('r')))
END