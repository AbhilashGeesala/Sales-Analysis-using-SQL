# Creating a Database

create DATABASE Superstore;
use superstore;

# Changing local and server settings for importing

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 'ON';
SHOW VARIABLES LIKE 'local_infile';

# Creating table

CREATE TABLE orders (
    RowID INT PRIMARY KEY,
    OrderID VARCHAR(255),
    OrderDate DATE,
    ShipDate DATE,
    ShipMode TEXT,
    CustomerID VARCHAR(255),
    CustomerName CHAR(255),
    Segment CHAR(255),
    Country CHAR(255),
    City CHAR(255),
    State CHAR(255),
    PostalCode INT,
    Region CHAR(255),
    ProductID VARCHAR(255),
    Category CHAR(255),
    SubCategory CHAR(255),
    ProductName TEXT,
    Sales DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(5, 2),
    Profit DECIMAL(10, 2),
    INDEX idx_CustomerID (customerID)
);

#Importing csv into table

load data local infile 'C:\Users\abhil\Desktop\Superstore.csv' into table Orders fields terminated by ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' ignore 1 rows;

# Making sure that the data on the table is populated right

SELECT 
    *
FROM
    orders
LIMIT 10;

#Making sure all the rows are included without skipping

SELECT 
    COUNT(*)
FROM
    orders;
    
# Grouping and sorting Profit by Year

SELECT 
    YEAR(OrderDate) AS 'Year', SUM(profit) AS Total_Profit
FROM
    orders
GROUP BY YEAR(OrderDate)
ORDER BY Total_Profit DESC;

# Grouping and sorting Profit by Year, Category wise

SELECT 
    YEAR(OrderDate) AS 'Year',
    SUM(profit) AS Total_Profit,
    Category
FROM
    orders
GROUP BY YEAR(OrderDate) , Category
ORDER BY Total_Profit DESC;

#Sorting customers by maximum profit

SELECT 
    CustomerID, CustomerName, SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY CustomerID , CustomerName
ORDER BY Total_Profit DESC
LIMIT 10;

#Sales and Profit by Quarter

SELECT 
    CASE
        WHEN QUARTER(OrderDate) = 1 THEN 'Q1'
        WHEN QUARTER(OrderDate) = 2 THEN 'Q2'
        WHEN QUARTER(OrderDate) = 3 THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit
FROM
    orders
GROUP BY Quarter
ORDER BY Quarter;

# Profit by Category - Region wise

SELECT 
    Region, Category, SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY Region , Category
ORDER BY Total_Profit DESC
LIMIT 10;

#Profit by Category - State wise

SELECT 
    Category, State, SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY Category , State
ORDER BY Total_Profit DESC
LIMIT 10;

#Sales, Profit & Profit Margin by Region

SELECT 
    Region,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit,
    (SUM(profit) / SUM(sales)) * 100 AS Profit_Margin
FROM
    orders
GROUP BY Region
ORDER BY Profit_Margin;

#CTE for Total Sales and Profit per SubCategory

WITH SubCategory_Sales_Profits AS (
    SELECT
        SubCategory,
        Region,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM
        orders
    GROUP BY Region, SubCategory
)

, Region_Sales_Profits AS (
    SELECT
        Region,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM
        orders
    GROUP BY Region
)

#Top 15 Subcategories with the highest total sales and total profits in each region

SELECT
    orders.Region,
    SubCategory_Sales_Profits.SubCategory,
    SubCategory_Sales_Profits.Total_Sales AS SubCategory_Total_Sales,
    SubCategory_Sales_Profits.Total_Profit AS SubCategory_Total_Profit,
    Region_Sales_Profits.Total_Sales AS Total_Sales_Region,
    Region_Sales_Profits.Total_Profit AS Total_Profit_Region
FROM
    orders
JOIN
    SubCategory_Sales_Profits ON orders.Region = SubCategory_Sales_Profits.Region
                            AND orders.SubCategory = SubCategory_Sales_Profits.SubCategory
JOIN
    Region_Sales_Profits ON orders.Region = Region_Sales_Profits.Region
GROUP BY
    orders.Region, SubCategory_Sales_Profits.SubCategory
ORDER BY
    Total_Sales_Region DESC, Total_Profit_Region DESC
LIMIT 15;

#Sales and Profits by State, most profitable 

SELECT 
    State, SUM(sales) AS Total_Sales, SUM(profit) AS Total_Profit
FROM
    orders
GROUP BY State
ORDER BY Total_Profit DESC limit 10; 

#Sales and Profits by State, least profitable 

SELECT 
    State,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit
FROM
    orders
GROUP BY State
ORDER BY Total_Profit ASC
LIMIT 10; 

#Sales and Profits by City, most profitable 

SELECT 
    City,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit,
    (SUM(profit) / SUM(sales)) * 100 AS Profit_Margin
FROM
    orders
GROUP BY City
ORDER BY Total_Profit DESC
LIMIT 10;

#Sales and Profits by City, least profitable 

SELECT 
    City,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit,
    (SUM(profit) / SUM(sales)) * 100 AS Profit_Margin
FROM
    orders
GROUP BY City
ORDER BY Total_Profit ASC
LIMIT 10;

#Relationship between discount and sales, product wise

SELECT 
    ProductName,
    SUM(Discount) AS Total_Discount,
    SUM(Sales) AS Total_Sales
FROM
    orders
GROUP BY ProductName
ORDER BY Total_Sales DESC , Total_Discount DESC
LIMIT 10;

#Relationship between discount and sales, Category wise

SELECT 
    Category,
    SUM(Discount) AS Total_Discount,
    SUM(Sales) AS Total_Sales
FROM
    orders
GROUP BY Category
ORDER BY Total_Sales DESC , Total_Discount DESC
LIMIT 10;

#Relationship between discount and sales, Category and SubCategory wise 

SELECT 
    Category,
    SubCategory,
    SUM(Discount) AS Total_Discount,
    SUM(Sales) AS Total_Sales
FROM
    orders
GROUP BY Category , SubCategory
ORDER BY Total_Sales DESC , Total_Discount DESC
LIMIT 10;

# Highest total sales and profits per Category and SubCategory in each state

SELECT 
    State,
    Category,
    SubCategory,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY State, Category, SubCategory
ORDER BY Total_Sales DESC , Total_Profit DESC
LIMIT 10;

# Lowest total sales and profits per Category and SubCategory  in each state

SELECT 
    State,
    Category,
    SubCategory,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY State , Category , SubCategory
ORDER BY Total_Sales ASC , Total_Profit ASC
LIMIT 10;

# Top 15 Subcategories with the highest total sales and total profits in each region

SELECT 
    Region,
    SubCategory,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY Region, SubCategory
ORDER BY Total_Sales DESC, Total_Profit DESC
LIMIT 15;

# Top 15 Subcategories with the lowest total sales and total profits in each region

SELECT 
    Region,
    SubCategory,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY Region, SubCategory
ORDER BY Total_Sales ASC, Total_Profit ASC
LIMIT 15;

# Top 15 Highest total sales and profits per Subcategory in each state

SELECT 
    State,
    SubCategory,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY State, SubCategory
ORDER BY Total_Sales DESC, Total_Profit DESC
LIMIT 15;

# Top 15 Highest total sales and profits per Subcategory in each state 

SELECT 
    State,
    SubCategory,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY State, SubCategory
ORDER BY Total_Sales ASC, Total_Profit ASC
LIMIT 15;

# Top 15 most profitable products 

SELECT 
    ProductName, SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY ProductName
ORDER BY Total_Profit DESC
LIMIT 15;

#Top 15 least profitable products 

SELECT 
    ProductName, SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY ProductName
ORDER BY Total_Profit ASC
LIMIT 15;

# Segment with most profits and sales

SELECT 
    Segment,
    SUM(Profit) AS Total_Profit,
    SUM(sales) AS Total_Sales
FROM
    orders
GROUP BY Segment
ORDER BY Total_Profit DESC , Total_Sales DESC
LIMIT 10;

# Total Number of customers

SELECT 
    COUNT(DISTINCT CustomerID) AS Total_Customers
FROM
    orders
ORDER BY Total_Customers;

# Number of customers per region

SELECT 
    Region, COUNT(DISTINCT CustomerID) AS Total_Customers
FROM
    orders
GROUP BY Region
ORDER BY Total_Customers DESC;

# Number of customers per State

SELECT 
    State, COUNT(DISTINCT CustomerID) AS Total_Customers
FROM
    orders
GROUP BY State
ORDER BY Total_Customers DESC;

# Top 15 states with most number of customers

SELECT 
    State, COUNT(DISTINCT CustomerID) AS Total_Customers
FROM
    orders
GROUP BY State
ORDER BY Total_Customers DESC
LIMIT 15;

# 15 states with lowest number of customers

SELECT 
    State, COUNT(DISTINCT CustomerID) AS Total_Customers
FROM
    orders
GROUP BY State
ORDER BY Total_Customers ASC
LIMIT 15;

# Top 15 customers that generated the most sales compared to total profits

SELECT 
    CustomerID,
    CustomerName,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY CustomerID , CustomerName
ORDER BY Total_Sales DESC, Total_Profit DESC
LIMIT 15;

# Average shipping time per class 

SELECT 
    ShipMode, Round(AVG(ShipDate - OrderDate)/24, 2) AS Avg_Ship_Speed
FROM
    orders
GROUP BY ShipMode
ORDER BY Avg_Ship_Speed ASC;