CREATE VIEW [dbo].[Projection Anticipated]
	AS 

SELECT 
	[ProjectionAnticipatedKey] AS [Projection Anticipated Key]
	,[CreatedDateOfAnticipated] AS [Created Date Of Anticipated]
	,[AnticipatedAmountCreatedBy] AS [Anticipated Amount Created By]
	,[UpdatedDateOfAnticipated] AS [Updated Date Of Anticipated]
	,[AnticipatedAmountUpdatedBy] AS [Anticipated Amount Updated By]
	,[IsAppearInTotal] AS [Is Appear In Total]
FROM [dbo].[DimProjectionAnticipated]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Projection Anticipated] TO [DataServices]
    AS [dbo];

