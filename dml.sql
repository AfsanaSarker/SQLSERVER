
---Start DML Script---

USE dbRailwaysystem
GO
SELECT * FROM Station
SELECT * FROM Passenger
SELECT * FROM Trip
SELECT * FROM Ticket
SELECT * FROM Train
SELECT * FROM [Route]
SELECT * FROM Coach_Yard
--Data Insert--
INSERT INTO Station VALUES
('Masr', 'Cairo','NRamses',1),
('ElRaml','Alexandria','ElRaml',2),
('Dhaka','Bangladesh','Dhaka', 56)
GO
INSERT INTO Passenger VALUES
('Ahmed','ahmed@gmail.com',01478956328,'Dhaka'),
('Fahim','fahim@gmail.com',01718956328,'Khulna'),
('Mamun','mamun@gmail.com',01378956328,'Dhaka')
GO
INSERT INTO Trip  VALUES
(11/12/2019,  12/12/2019,560,1,5,4,9),
(13/12/2019, 14/12/2019,660,2,6,5,8),
(15/12/2019, 16/12/2019,760,3,7,4,9)
GO
INSERT INTO Ticket VALUES
('B',250,12/10/2019,1,1),
('C',250,13/10/2019,2,2),
('D',260,11/12/2019,3,3)
GO
INSERT INTO Train VALUES
('dhktu','MKT',1,'White',100),
('Indiag','LOL',1,'Yellow',10),
('UK-S','MKT-3',1,'Blue',100)
GO
INSERT INTO [Route] VALUES
(1,1,10),
(2,2,200)
GO
INSERT INTO Coach_Yard VALUES
(1,100),
(2,200)
GO


-------- 2. Data Update(Via SP) -----------
UPDATE Station
SET [Name]='Masr'
where stationId=1
go

UPDATE Passenger
SET First_name='Ahmed'
WHERE PassengerID=1
GO

UPDATE Train
SET TrainName='dhktu'
WHERE TrainId=1
GO

---data delete--
DELETE FROM Station
WHERE Name='Dhaka'
GO

DELETE FROM Passenger
WHERE First_name='Ahmed'
Go

DELETE FROM Train
WHERE TrainName='dhktu'
Go

DELETE FROM Station
WHERE city='Cairo'
GO






