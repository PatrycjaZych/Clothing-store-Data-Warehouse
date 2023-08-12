USE ConstelationDW
GO

If (object_id('dbo.ShopTemp') is not null) DROP TABLE dbo.ShopTemp;
CREATE TABLE dbo.ShopTemp( Street varchar(255),PostalCode varchar(100), City varchar(60), StartDate date, FinishDate date, BK_ShopID INT);
go

BULK INSERT dbo.ShopTemp
    FROM 'C:\Users\patry\OneDrive\Pulpit\DataWarehousesLabs\ShopzPrzecinkami.csv'
    WITH
    (
    FIRSTROW = 2,
	DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )


If (object_id('vETLDimShopData') is not null) Drop View vETLDimShopData;
go

CREATE VIEW vETLDimShopData
AS
SELECT
Street,
PostalCode,
City,
StartDate,
FinishDate,
BK_ShopID
FROM ShopTemp
go

MERGE INTO Dim_Shop AS TT
USING vETLDimShopData AS ST
ON TT.BK_ShopID = ST.BK_ShopID
WHEN NOT MATCHED THEN
    INSERT ( 
			Street,
			PostalCode,
			City, 
			StartDate,
			FinishDate,
			BK_ShopID)
    VALUES (
			ST.Street,
			ST.PostalCode, 
			ST.City, 
			StartDate,--GETDATE(),
			FinishDate,--CONVERT(DATETIME, NULL),
			ST.BK_ShopID)
WHEN MATCHED AND (ST.Street <> TT.Street) THEN
    UPDATE SET TT.FinishDate = GetDate() 
WHEN NOT MATCHED BY SOURCE AND TT.BK_ShopID != -1 THEN
    UPDATE SET TT.FinishDate = GetDate() ;
INSERT INTO Dim_Shop (
    Street,
    PostalCode,
    City,
    StartDate,
    FinishDate,
    BK_ShopID
)
SELECT 
    Street,
    PostalCode,
    City,
    GetDate(),
    NULL,
    BK_ShopID
FROM vETLDimShopData
EXCEPT
SELECT 
    Street,
    PostalCode,
    City,
    GetDate(),
    NULL,
    BK_ShopID
FROM Dim_Shop;

SELECT * FROM Dim_Shop

