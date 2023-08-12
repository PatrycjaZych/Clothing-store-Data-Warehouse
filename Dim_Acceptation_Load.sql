use ConstelationDW
go

If (object_id('vETLDimAcceptationData') is not null) Drop View vETLDimAcceptationData;
go

CREATE VIEW vETLDimAcceptationData
AS
SELECT
ReturnID,
wasAccepted,
Reason
FROM [DWDatabase].[dbo].[RETURNS]
go

MERGE INTO Dim_AcceptationOfReturn as TT
	USING vETLDimAcceptationData as ST
		ON TT.AcceptationID = ST.ReturnID
		AND TT.wasAccepted = ST.wasAccepted
		AND TT.Reason = ST.Reason
		AND TT.Condition = ST.Reason
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.ReturnID,
					ST.wasAccepted,
					ST.Reason,
					ST.Reason
					)
		--	WHEN Not Matched By Source
		--		Then
		--			DELETE
			;
Drop View vETLDimAcceptationData;
SELECT * FROM Dim_AcceptationOfReturn
