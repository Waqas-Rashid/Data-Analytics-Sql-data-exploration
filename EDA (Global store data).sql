		------------------------------ EDA ---------------------------
--- Data count in our Orders table
SELECT COUNT (*)
FROM PortfolioProject1..[Orders]

---- Select All from Table Orders and order by Row ID
SELECT *
FROM PortfolioProject1..[Orders]
ORDER BY 1

------Checking if the Order ID is the primiry key ?-------If yes we should have only one enter for each id
SELECT [Order ID],count(*)
FROM PortfolioProject1..[Orders]
GROUP by[Order ID]
having count(*) > 1

--------WE get multiple entries against one order ID, now lets explore an ID a bit to under more what is going on

SELECT *
FROM PortfolioProject1..[Orders]
WHERE [Order ID] = 'BU-2013-9480'--- So order ID is not primary key.

-- Let see if we can use a composite key
SELECT [Row ID],[Order ID]
FROM PortfolioProject1..[Orders]
GROUP by [Row ID],[Order ID]
having count(*) > 1

-- verifiying data ship date and order date entries.

SELECT *
FROM PortfolioProject1..[Orders]
WHERE [Ship Date]<[Order Date]

---- Different ship modes
SELECT DISTINCT [Ship Mode]
FROM PortfolioProject1..[Orders] 

---- How Many days they took to ship each order in Second Class shipment mode
SELECT DATEDIFF (DAY, [Order Date],[Ship Date]) as DispachDays, *
FROM PortfolioProject1..[Orders] 
WHERE [Ship Mode] = 'Second Class'

---- Lets find the minimum and maximum number of days  they took to dispach in this category
SELECT MIN(a.DispachDays), MAX(a.DispachDays)
FROM (
SELECT DATEDIFF (DAY, [Order Date],[Ship Date]) as DispachDays, *
FROM PortfolioProject1..[Orders] 
WHERE [Ship Mode] = 'Second Class') a

--- Lets see the one other Mode of shipment, like for Same day mode.
SELECT MIN(a.DispachDays), MAX(a.DispachDays)
FROM (
SELECT DATEDIFF (DAY, [Order Date],[Ship Date]) as DispachDays, *
FROM PortfolioProject1..[Orders] 
WHERE [Ship Mode] = 'Same Day') a
