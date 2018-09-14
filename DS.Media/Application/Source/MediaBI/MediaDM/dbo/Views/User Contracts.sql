CREATE VIEW [dbo].[User Contracts]
	AS 
SELECT 
	UserContractKey AS [User Contract Key],
	UserKey AS [User Key],
	CountOfContracts AS [CountOfContracts_]
FROM [FactUsersContracts]

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[User Contracts] TO [DataServices]
    AS [dbo];

