Create FUNCTION [dbo].[ufn_GetHashDimContract]
(
	 @ContractKey BIGINT
	,@ContractDescription VARCHAR(62)
	,@AgreementType VARCHAR(30)
	,@AgreementBy VARCHAR(50)
	,@ContractType VARCHAR(255)
	,@LicensorParty VARCHAR(80)
	,@LegalOnline INT
	,@LegalContractStatus VARCHAR(50)
	,@Licensor VARCHAR(50)
	,@ContractText VARCHAR(1024)
	,@ContractInstructions VARCHAR(1024)
	,@IssueSite VARCHAR(50)
	,@City VARCHAR(50)
	,@Region VARCHAR(50)
	,@Country VARCHAR(50)
	,@LegalOnlineContact VARCHAR(120)
	,@IssueSiteId INT
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @ContractKey AS ContractKey
	,@ContractDescription AS ContractDescription
	,@AgreementType AS AgreementType
	,@AgreementBy AS AgreementBy
	,@ContractType AS ContractType
	,@LicensorParty AS LicensorParty
	,@LegalOnline AS LegalOnline
	,@LegalContractStatus AS LegalContractStatus
	,@Licensor AS Licensor
	,@ContractText AS ContractText
	,@ContractInstructions AS ContractInstructions
	,@IssueSite AS IssueSite
	,@City AS City
	,@Region AS Region
	,@Country AS Country
	,@LegalOnlineContact AS LegalOnlineContact
	,@IssueSiteId AS IssueSiteId
	FOR XML RAW('r')))
END