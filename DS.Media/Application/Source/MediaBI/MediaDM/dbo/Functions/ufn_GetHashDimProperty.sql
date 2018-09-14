CREATE FUNCTION [dbo].[ufn_GetHashDimProperty]
(
	 @PropertyKey BIGINT
	,@SourceProductId INT
	,@OPANumber VARCHAR(12)
	,@OPANumberT VARCHAR(12)
	,@PropertyName VARCHAR(50)
	,@ShortName VARCHAR(30)
	,@GenericName VARCHAR(30)
	,@AreaOfBusiness VARCHAR(50)
	,@AreaOfBusinessT VARCHAR(50)
	,@AreaOfBusinessSuffix VARCHAR(50)
	,@AreaOfBusinessSuffixT VARCHAR(50)
	,@PropertyCategoryType VARCHAR(50)
	,@PropertyCategory VARCHAR(50)
	,@SubjectCategory VARCHAR(50)
	,@BillingCompany VARCHAR(80)
	,@IssueSite VARCHAR(50)
	,@AccountantResponsible VARCHAR(110)
	,@ExecResponsible VARCHAR(110)
	,@ProjectionYear CHAR(4)
	,@IncomeProjectionDate VARCHAR(10)
	,@IncomeProjectionDateINT INT
	,@SalesCategoryMDS NCHAR(50)
	,@AbbreviationMDS NCHAR(30)
	,@CommissionMDS NCHAR(10)
	,@CommissionNumMDS NUMERIC(10,2)
	,@CommentMDS NVARCHAR(250)
	,@LegalContact VARCHAR(110)
	,@InvoiceCategory VARCHAR(50)
	,@HeadOfSport VARCHAR(110)
	,@HeadOfBusinessUnit VARCHAR(110)
	,@IsReplayReport CHAR(3)
	,@IsOmitException CHAR(3)
	,@ClientCountry VARCHAR(500)
	,@ClientName VARCHAR(500)
	,@ClientNo VARCHAR(500)
	,@Licensor VARCHAR(50)
	,@ContractingParty VARCHAR(50)
	,@BroadcastDateFrom DATETIME
	,@BroadcastDateTo DATETIME
	,@IsIMGClient VARCHAR(31)
	,@ClientAddress VARCHAR(2479)
	,@ParentPropertyKey BIGINT
	,@ReportingType VARCHAR(80)
	,@PremiereDate DATETIME
	,@AvailabilityDate DATETIME
	,@CreatedDate DATETIME
    ,@CreatedBy VARCHAR(110)
    ,@UpdatedDate DATETIME
    ,@UpdatedBy VARCHAR(110)
    ,@Comment VARCHAR(600)
	,@CommentCreatedBy VARCHAR(110)
	,@CommentCreatedDate DATETIME
	,@ImgAsAuthorisedSignatory CHAR(3)
	,@LicensorInDeal VARCHAR(300)
	,@IncludeInOutputDeal CHAR(3)
	,@SellAtRisk CHAR(3)
	,@LegalOnlineNo INT
	,@ContractStatus VARCHAR(50)
)
RETURNS VARBINARY(8000)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512',(
	SELECT 
	 @PropertyKey AS PropertyKey
	,@SourceProductId AS SourceProductId
	,@OPANumber AS OPANumber
	,@OPANumberT AS OPANumberT
	,@PropertyName AS PropertyName
	,@ShortName AS ShortName
	,@GenericName AS GenericName
	,@AreaOfBusiness AS AreaOfBusiness
	,@AreaOfBusinessT AS AreaOfBusinessT
	,@AreaOfBusinessSuffix AS AreaOfBusinessSuffix
	,@AreaOfBusinessSuffixT AS AreaOfBusinessSuffixT
	,@PropertyCategoryType AS PropertyCategoryType
	,@PropertyCategory AS PropertyCategory
	,@SubjectCategory AS SubjectCategory
	,@BillingCompany AS BillingCompany
	,@IssueSite AS IssueSite
	,@AccountantResponsible AS AccountantResponsible
	,@ExecResponsible AS ExecResponsible
	,@ProjectionYear AS ProjectionYear
	,@IncomeProjectionDate AS IncomeProjectionDate
	,@IncomeProjectionDateINT AS IncomeProjectionDateINT
	,@SalesCategoryMDS AS SalesCategoryMDS
	,@AbbreviationMDS AS AbbreviationMDS
	,@CommissionMDS AS CommissionMDS
	,@CommissionNumMDS AS CommissionNumMDS
	,@CommentMDS AS CommentMDS
	,@LegalContact AS LegalContact
	,@InvoiceCategory AS InvoiceCategory
	,@HeadOfSport AS HeadOfSport
	,@HeadOfBusinessUnit AS HeadOfBusinessUnit
	,@IsReplayReport AS IsReplayReport
	,@IsOmitException AS IsOmitException
	,@ClientCountry AS ClientCountry
	,@ClientName AS ClientName
	,@ClientNo AS ClientNo
	,@Licensor AS Licensor
	,@ContractingParty AS ContractingParty
	,@BroadcastDateFrom AS BroadcastDateFrom
	,@BroadcastDateTo AS BroadcastDateTo
	,@IsIMGClient AS IsIMGClient
	,@ClientAddress AS ClientAddress
	,@ParentPropertyKey AS ParentPropertyKey
	,@ReportingType AS ReportingType
	,@PremiereDate AS PremiereDate
	,@AvailabilityDate AS AvailabilityDate
	,@CreatedDate AS CreatedDate
    ,@CreatedBy AS CreatedBy
    ,@UpdatedDate AS UpdatedDate
    ,@UpdatedBy AS UpdatedBy
    ,@Comment AS Comment
	,@CommentCreatedBy AS CommentCreatedBy
	,@CommentCreatedDate AS CommentCreatedDate
	,@ImgAsAuthorisedSignatory AS ImgAsAuthorisedSignatory
	,@LicensorInDeal AS LicensorInDeal
	,@IncludeInOutputDeal AS IncludeInOutputDeal
	,@SellAtRisk AS SellAtRisk
	,@LegalOnlineNo AS LegalOnlineNo
	,@ContractStatus AS ContractStatus
	FOR XML RAW('r')))
END