use ConstelationDW;
go

If (object_id('vETLFPurchase') is not null) Drop view vETLFPurchase;
go
CREATE VIEW vETLFPurchase
AS
SELECT 
	FK_ItemID = Dim_Item.ItemID,
    FK_DateID = Dim_Date.DateID
FROM DWDatabase.dbo.ITEM as ST1
JOIN dbo.Dim_Item on Dim_Item.ItemID = ST1.ItemID
JOIN DWDatabase.dbo.HISTORY  TT on  TT.FK_ItemID  = ST1.ItemID
JOIN DWDatabase.dbo.PURCHASE ST2 on ST2.PurchaseID = TT.HistoryID
JOIN dbo.Dim_Date on Dim_Date.Date = ST2.DateOfPurchase
; 
go
SELECT * FROM vETLFPurchase
MERGE INTO Fact_Purchase AS TT
USING vETLFPurchase AS ST
    ON TT.FK_ItemID = ST.FK_ItemID
   AND TT.FK_DateID = ST.FK_DateID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (FK_ItemID, FK_DateID)
    VALUES (ST.FK_ItemID, ST.FK_DateID);

Drop view vETLFPurchase;


