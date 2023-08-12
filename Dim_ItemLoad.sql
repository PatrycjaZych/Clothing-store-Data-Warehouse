use ConstelationDW
go

If (object_id('vETLDimItemData') is not null) Drop View vETLDimItemData;
go

CREATE VIEW vETLDimItemData
AS
SELECT
ItemID,
Gender,
Size,
Material
FROM [DWDatabase].[dbo].[Item]
go
/*INSERT INTO [ConstelationDW].[dbo].[Dim_Item] (ItemID, Gender, Size, Material)
SELECT ItemID,
	   Gender,
		Size,
		Material
FROM [DWDatabase].[dbo].[Item]
go*/
MERGE INTO Dim_Item as TT
	USING vETLDimItemData as ST
		ON TT.ItemID = ST.ItemID
		AND TT.Gender = ST.Gender
		AND TT.Size = ST.Size
		AND TT.Material = ST.Material
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.ItemID,
					ST.Gender,
					ST.Size,
					ST.Material
					)
		--WHEN Not Matched By Source
		--	Then
		--		DELETE
			;
Drop View vETLDimItemData;
