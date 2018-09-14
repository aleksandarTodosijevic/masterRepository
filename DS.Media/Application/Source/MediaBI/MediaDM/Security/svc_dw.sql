CREATE USER [svc_dw] FOR LOGIN [svc_dw];
GO
GRANT CONNECT TO [svc_dw];
GO
ALTER ROLE [db_datareader]
	ADD MEMBER [svc_dw];
GO
ALTER ROLE [db_datawriter]
	ADD MEMBER [svc_dw];
GO