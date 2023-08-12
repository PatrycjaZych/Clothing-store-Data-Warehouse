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
	DROP 