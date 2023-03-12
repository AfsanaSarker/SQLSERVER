/*			
			SQL Project Name : Railway Management System 
			    Trainee Name : Afsana Sarker 
		    	  Trainee ID : 1269447     
				    Batch ID : ESAD-CS/PNTL-M/51/01 

																											*/
--=====================   START OF DDL SCRIPT   ==========================--


USE MASTER
GO
--- CREATE DATABASE
/************************************************************************************************/Use Master 
CREATE DATABASE dbRailwaysystem
ON
(
	NAME= dbRailwaysystem_data,
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\dbRailwaysystem_data.mdf',
	SIZE=50MB,
	MAXSIZE=100MB,
	FILEGROWTH=10MB
)
LOG ON
(
NAME= dbRailwayManagementsystem_log,
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\dbRailwaysystem_log.ldf',
	SIZE=15MB,
	MAXSIZE=30MB,
	FILEGROWTH=5%
)
GO
USE dbRailwaysystem
GO

--------------2.Table Creation-----------------

CREATE TABLE Station 
(
	stationId INT  IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR (50) NOT NULL ,
	city VARCHAR(50) NOT NULL,
	[State] VARCHAR(50) NOT NULL,
	Street INT NOT NULL
)
GO
CREATE TABLE [Route] 
(
	Source_ID INT NOT NULL,
	Destination_ID INT NOT NULL,
	Distance INT NOT NULL,
	foreign key(Source_ID) REFERENCES Station(StationId),
	foreign key(Destination_ID) REFERENCES Station(StationId)
)
GO
CREATE TABLE Passenger
(
	PassengerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	First_name VARCHAR(50) NOT NULL,
	Email VARCHAR(50)  NULL UNIQUE,
	Phone NVARCHAR(25) NOT NULL,
	[Address] varchar(200)  NULL
)
GO

CREATE TABLE Train
(
	TrainId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TrainName VARCHAR(50) NOT NULL,
	Model VARCHAR(50) NOT NULL,
	[Status] BIT NOT NULL DEFAULT 1,  --Using Default Constraint
	Color VARCHAR(50) NOT NULL,
	Speed INT NOT NULL
)
GO

CREATE TABLE Trip
(
	TripId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Dept_Time datetime NOT NULL, ----Using Check Constraint
	Arr_Time datetime NOT NULL, 
	No_Seats INT NOT NULL,
	[Type] INT NOT NULL,
	Source_ID INT NOT NULL,
	Destintaion_ID INT NOT NULL,
	Train_ID INT NOT NULL
)  
GO

CREATE TABLE Ticket 
(
	TicketId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Class CHAR(100) NOT NULL,
	Price  INT NOT NULL,
	Journey_Date DATETIME NOT NULL ,
	Passenger_ID  INT,
	Trip_ID  INT NOT NULL,
	foreign key(Passenger_ID) REFERENCES Passenger(passengerId),
	foreign key(Trip_ID) REFERENCES Trip(TripID) on delete cascade
)
GO

CREATE TABLE Coach_Yard
(
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Station_ID INT NOT NULL,
	Size integer NOT NULL,
	foreign key(Station_ID) references Station
)
GO



--============     ALTER TABLE (ADD, DELETE COLUMN, DROP COLUMN)   ===============--
ALTER TABLE Passenger 
ADD  Last_name varchar(50),
unique(First_name, Last_name)
GO

--DELETE COLUMN FROM A EXISTING TABLE
ALTER TABLE Passenger
DROP COLUMN Address
GO

--DROP A TABLE
IF OBJECT_ID('tblcity') IS NOT NULL
DROP TABLE tblCity
GO

----------------------4.Constraint(Primary Key,FK,Default,Check,Nullibility)------------


----------------------- 5.Drop Table  --------------

DROP TABLE Coach_Yard
GO
------------------------ 6.Create Index ---------------

CREATE INDEX idx_Passenger
ON Passenger 
(First_name,Phone, Email)

------------------------- 7.Create Sequence ---------------
CREATE SEQUENCE Seq_SeatNo
START WITH 1000
INCREMENT BY 1
MAXVALUE 2000
NO CYCLE
Go

------------ 8.View ------------

CREATE VIEW vStation
AS
SELECT Name,city,[State],Street FROM Station
GO
SELECT * FROM vStation
GO
EXEC sp_help vStation
GO
---------- 9.Create Procedure -------------
CREATE PROCEDURE InsertStation
	@name VARCHAR(50),
	@state VARCHAR(50),
	@city VARCHAR(50),
	@street INT
AS
BEGIN
	
	SET NOCOUNT ON;
    INSERT INTO Station
	VALUES (@name, @city, @state, @street);
	RETURN @@identity
END
GO
-- store procedure on route
CREATE PROCEDURE InsertRoute
	@Source_ID INT,
	@Destination_ID INT,
	@Distance INT
AS
BEGIN
	SET NOCOUNT ON
    INSERT INTO Route
	VALUES (@Source_ID, @Destination_ID, @Distance)
END
GO
CREATE PROCEDURE InsertTicket
	@class char,
	@price int,
	@date date,
	@pid int, 
	@tid int
AS
BEGIN
	
	SET NOCOUNT ON;
	insert into Ticket
	values(@class, @price , @date, @pid , @tid);
END
GO

CREATE PROCEDURE InsertPassenger
	@fname varchar(50),
	@lname varchar(50),
	@Email varchar(50),
	@Phone varchar(25),
	@Address varchar(200)
AS
BEGIN
    insert into Passenger
	values(@fname, @lname,@Email,@Phone);

END
GO
---------------- 10. Create Trigger -------------
Create Trigger tr_SeatBooking
ON Ticket
FOR INSERT 
AS
BEGIN
DECLARE @Class varchar(1), 
    @Price int,
	@Date date,
	@Passenger_ID int,
	@Trip_ID int

SELECT @Class = Class,@Price = Price,@Date = [Journey_Date],@Passenger_ID = Passenger_ID,@Trip_ID = Trip_ID FROM inserted
UPDATE Trip 
SET No_Seats = No_Seats- 1
WHERE TripId = @Trip_ID
END
GO

------------------ Scalar valued UDF----------------
CREATE FUNCTION fnCalcArrivalTime
(@Distance INT, @Speed INT,@Dept_Time datetime)
RETURNS datetime
AS
BEGIN
DECLARE @Arr_Time datetime;
DECLARE @T float = (CAST(@Distance AS float) / CAST(@Speed AS float)) -- HOURS IN FLOAT
	SET @T = @T * 60 * 60
	SET @Arr_Time = DATEADD(SECOND, @T, @Dept_Time)
RETURN @Arr_Time
END
GO

																											



