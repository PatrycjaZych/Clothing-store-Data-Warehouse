--SET IDENTITY_INSERT dbo.Dim_AcceptationOfReturn ON;  
--GO 
INSERT INTO dbo.Dim_AcceptationOfReturn(
	  AcceptationID
	, wasAccepted
	, Reason
	, Condition) 
Values(-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN');
go

SET IDENTITY_INSERT dbo.Dim_Shop ON;  
GO 
INSERT INTO dbo.Dim_Shop(
	  SK_ShopID 
	, Street
	, PostalCode
	, City
	, StartDate
	, FinishDate
	, BK_ShopID) 
Values(-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', '2007-01-01', '2007-01-01', -1);
go

SET IDENTITY_INSERT dbo.Dim_Item ON;  
GO 
INSERT INTO dbo.Dim_Item(
	  ItemID 
	, Gender
	, Size
	, Material)
Values(-1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN');
go

SELECT * FROM Dim_AcceptationOfReturn;
SELECT * FROM Dim_Item;


