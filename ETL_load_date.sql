use ConstelationDW
go
SET IDENTITY_INSERT dbo.Dim_Date ON; 
-- Fill DimDates Lookup Table
-- Step a: Declare variables use in processing
Declare @StartDate date; 
Declare @EndDate date;
Declare @DateID int = 1;

-- Step b:  Fill the variable with values for the range of years needed
SELECT @StartDate = '2005-01-01', @EndDate = '2023-05-12';

-- Step c:  Use a while loop to add dates to the table
Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
	Begin
	--Add a row into the date dimension table for this date
		Insert Into [dbo].[Dim_Date] 
		( [DateID]
		, [Year]
		, [Month]
		, [Day]
		, [DayOfWeek]
		, [Date]
		, [MonthNo]
		, [isWeekend]
		--, [isHoliday]
		)
		Values (  @DateID
		, Cast( Year(@DateInProcess) as varchar(4)) -- [Year]
		  , Cast( DATENAME(month, @DateInProcess) as varchar(10)) -- [Month]
		  , Cast( Day(@DateInProcess) as int) -- [Day]
		  , Cast( DATENAME(dw,@DateInProcess) as varchar(15)) -- [DayOfWeek]
		  , @DateInProcess -- [Date]
		  , Cast( Month(@DateInProcess) as int) -- [MonthNo]
		  , CASE
				WHEN DATEPART(dw, @DateInProcess) = 1 THEN 'day off'
				ELSE 'working day'
			END
		  --, 'weekBefore' -- will be put in te next steps
		);  
		-- Add a day and loop again
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
		Set @DateID = @DateID +1;
	End
go

/*    -- insert into holidays and vacations
    -------------------------------------------------------------
    -- auxiliary tables should be created first!
   IF OBJECT_ID('vETLDimDatesData') IS NOT NULL DROP VIEW vETLDimDatesData;

    CREATE VIEW vETLDimDatesData
    AS
    SELECT 
        dd.DateID,
        dd.Year,
        dd.Month,
        dd.Day,
        dd.DayOfWeek,
        dd.Date,
        dd.MonthNo,
        CASE    
            WHEN ah1.wolne = 1 THEN 'day off'
            WHEN dd.isWeekend = 'day off' THEN 'day off'
            ELSE 'working day'
        END AS [isWeekend],
        CASE    
            WHEN ah1.swieto IS NOT NULL THEN ah1.swieto
            ELSE 'non-holiday'
        END AS [Holiday],
        CASE 
            WHEN ah2.BeforeHolidayDay IS NOT NULL THEN ah2.BeforeHolidayDay
            ELSE 'Brak'
        END AS [BeforeHolidayDay]
    
    FROM auxiliary.dbo.swieta ah1
    RIGHT JOIN Dim_Date AS dd ON dd.Date = ah1.data
    LEFT JOIN 
        (
            SELECT DATEADD("dd", -7, data) AS d, 'Jutro ' + swieto AS BeforeHolidayDay 
            FROM auxiliary.dbo.swieta
        ) AS ah2 ON dd.Date = ah2.d

    LEFT JOIN auxiliary.dbo.wakacje AS w ON dd.Date BETWEEN w.start AND w.koniec;
    
    DROP VIEW IF EXISTS vETLDimDatesData;
	
-- Merge view with updated information about holidays and before holiday days with already existing DimDate rows

MERGE INTO Dim_Date as TT
	USING vETLDimDatesData as ST
		ON TT.date = ST.date
			WHEN Matched -- when dates match...
			THEN -- update WorkingDay, Holiday and BeforeHolidayDay columns
				UPDATE
				SET TT.isWeekend = ST.isWeekend,
					--TT.Vacation = ST.Vacation,
					TT.isHoliday = ST.Holiday;
					--TT.BeforeHolidayDay = ST.BeforeHolidayDay;
Drop View vETLDimDatesData;
SELECT * FROM Dim_Date
*/