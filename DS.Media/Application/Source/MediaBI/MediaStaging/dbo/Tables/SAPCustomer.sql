CREATE TABLE [dbo].[SAPCustomer] (
    [Id]                   INT          NOT NULL,
    [CustomerId]           INT          NOT NULL,
    [CustomerAddressId]    INT          NOT NULL,
    [CustomerContactId]    INT          NOT NULL,
    [SAPCustomerNumber]    VARCHAR (10) NOT NULL,
    [SAPCustomerContactId] VARCHAR (10) NOT NULL,
    [POCCustomerNo]        VARCHAR (10) NULL,
    [StatusId]             INT          NOT NULL,
    [CreatedDate]          DATETIME     NOT NULL,
    [CreatedBy]            INT          NOT NULL,
    [UpdatedDate]          DATETIME     NULL,
    [UpdatedBy]            INT          NULL
);



