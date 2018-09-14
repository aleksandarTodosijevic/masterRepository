CREATE FUNCTION [dbo].[CreateKeyFromDate] (
	@Date DATE
)
RETURNS INT
AS
BEGIN
	RETURN CAST(CONVERT(VARCHAR(10), @Date, 112) AS INT);
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CreateKeyFromDate] TO [DataServices]
    AS [dbo];

