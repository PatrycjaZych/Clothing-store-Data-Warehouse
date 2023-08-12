use ConstelationDW;
go

If (object_id('vETLFReturns') is not null) Drop view vETLFReturns;
go

CREATE VIEW vETLFReturns
AS
SELECT 
	 FK_ShopID = DD.SK_ShopID
	,FK_ItemID = Dim_Item.ItemID 
	,FK_DateID = Dim_Date.DateID
	,FK_AcceptationID = Dim_AcceptationOfReturn.AcceptationID
    ,NumberOfDaysAfterPurchase = ST2.AfterHowManyDays
FROM
  DWDatabase.dbo.HISTORY as ST1
			JOIN dbo.Dim_Item on Dim_Item.ItemID = ST1.FK_ItemID
			JOIN DWDatabase.dbo.RETURNS ST2 on ST2.FK_HistoryID = ST1.HistoryID
			JOIN dbo.Dim_AcceptationOfReturn on Dim_AcceptationOfReturn.AcceptationID = ST2.ReturnID
			JOIN DWDatabase.dbo.ITEM SS on ST1.FK_ItemID = SS.ItemID 
			JOIN dbo.Dim_Shop as DD on DD.BK_ShopID = SS.FK_ShopID  
			JOIN dbo.Dim_Date on (Dim_Date.Date = ST2.DateOfReturn ) 
	GO	
MERGE INTO Fact_Return AS TT
USING vETLFReturns AS ST
ON
    TT.FK_ShopID = ST.FK_ShopID
	AND TT.FK_ItemID =ST.FK_ItemID
	AND TT.FK_DateID = ST.FK_DateID
	AND TT.FK_AcceptationID  = ST.FK_AcceptationID
	AND TT.NumberOfDaysAfterPurchase = ST.NumberOfDaysAfterPurchase
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (FK_ShopID, FK_ItemID, FK_DateID , FK_AcceptationID, NumberOfDaysAfterPurchase)
	VALUES (ST.FK_ShopID, ST.FK_ItemID, ST.FK_DateID, ST.FK_AcceptationID, ST.NumberOfDaysAfterPurchase);
Drop view vETLFReturns;

