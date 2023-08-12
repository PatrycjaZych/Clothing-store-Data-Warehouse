CREATE TABLE Dim_AcceptationOfReturn (
    AcceptationID INT NOT NULL PRIMARY KEY,
    wasAccepted CHAR(20) NOT NULL,
    Reason CHAR(20) NOT NULL ,
    Condition CHAR(40) NOT NULL,
);

CREATE TABLE Dim_Shop (
    SK_ShopID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Street nvarchar(20) NOT NULL ,
    PostalCode nvarchar(20) NOT NULL,
	City nvarchar(30) NOT NULL ,
    StartDate date NOT NULL,
	FinishDate date ,
	BK_ShopID INT NOT NULL,
);

CREATE TABLE Dim_Item (
    ItemID INT NOT NULL PRIMARY KEY,
    Gender CHAR(20) NOT NULL,
    Size CHAR(20) NOT NULL ,
    Material CHAR(20) NOT NULL,
);

CREATE TABLE Dim_Date (
    DateID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Year INT NOT NULL,
    Month CHAR(20) NOT NULL,
	Day INT NOT NULL,
    DayOfWeek CHAR(20) NOT NULL,
	Date date NOT NULL,
	MonthNo INT NOT NULL,
    isWeekend CHAR(20) NOT NULL,
--	isHoliday CHAR(60) NOT NULL,
);

CREATE TABLE Fact_Purchase (
    FK_ItemID INT NOT NULL FOREIGN KEY REFERENCES Dim_Item(ItemID) ON DELETE CASCADE,
	FK_DateID INT NOT NULL FOREIGN KEY REFERENCES Dim_Date(DateID) ON DELETE CASCADE,
	PRIMARY KEY (FK_ItemID, FK_DateID) --PK_Purchase INT 
);

CREATE TABLE Fact_Return (
    FK_ShopID INT NOT NULL FOREIGN KEY REFERENCES Dim_Shop(SK_ShopID) ON DELETE CASCADE,
	FK_ItemID INT NOT NULL FOREIGN KEY REFERENCES Dim_Item(ItemID) ON DELETE CASCADE,
	FK_DateID INT NOT NULL FOREIGN KEY REFERENCES Dim_Date(DateID) ON DELETE CASCADE,
	FK_AcceptationID INT NOT NULL FOREIGN KEY REFERENCES Dim_AcceptationOfReturn(AcceptationID) ON DELETE CASCADE,
	PRIMARY KEY (FK_ShopID, FK_ItemID, FK_DateID, FK_AcceptationID), --PK_Return INT
	NumberOfDaysAfterPurchase INT ,
);


SELECT * FROM Dim_AcceptationOfReturn;
SELECT * FROM Dim_Shop;
SELECT * FROM Dim_Item;
SELECT * FROM Dim_Date;
SELECT * FROM Fact_Purchase;
SELECT * FROM Fact_Return;

DROP TABLE Fact_Return;
DROP TABLE Fact_Purchase;
DROP TABLE Dim_Date;
DROP TABLE Dim_Item;
DROP TABLE Dim_Shop;
DROP TABLE Dim_AcceptationOfReturn;
