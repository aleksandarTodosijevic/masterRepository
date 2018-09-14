CREATE LOGIN [svc_bi] WITH PASSWORD = 'naL{CtgvjcqpzDd01i:yQ`vkmsFT7_&#$!~<czdzh7oWa,on'
Go
CREATE USER [svc_bi] FOR LOGIN [svc_bi];
GO
GRANT CONNECT TO [svc_bi];
GO
ALTER ROLE [db_datareader]
	ADD MEMBER [svc_bi];
GO
ALTER ROLE [db_datawriter]
	ADD MEMBER [svc_bi];
GO
