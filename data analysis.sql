-- total sales, total profit, and total number of orders for each customer

WITH PerformanceAnalysis AS (
    SELECT
        YEAR(order_date_DateOrders) AS OrderYear,
        SUM(Sales) AS TotalSales,
        SUM(Order_Profit_Per_Order) AS TotalProfit,
        Customer_Segment,
        Product_Category_Id,
        COUNT(DISTINCT Order_Id) AS TotalOrders
    FROM
        Order o
    JOIN
        Customer c ON o.Order_Customer_Id = c.Customer_Id
    JOIN
        Product p ON o.Order_Item_Cardprod_Id = p.Product_Card_Id
    GROUP BY
        YEAR(order_date_DateOrders),
        Customer_Segment,
        Product_Category_Id
)

SELECT
    OrderYear,
    Customer_Segment,
    Product_Category_Id,
    TotalSales,
    TotalProfit,
    TotalOrders,
    ROW_NUMBER() OVER (ORDER BY TotalProfit DESC) AS Ranking
FROM
    PerformanceAnalysis
WHERE
    OrderYear = YEAR(GETDATE()) -- Filter for the current year
ORDER BY
    TotalProfit DESC;

-- Top-Selling Products

SELECT
    Product_Name,
    SUM(Order_Item_Quantity) AS TotalQuantitySold
FROM
    Order o
JOIN
    Product p ON o.Order_Item_Cardprod_Id = p.Product_Card_Id
WHERE
    YEAR(order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    Product_Name
ORDER BY
    TotalQuantitySold DESC;

-- Customer Segment Analysis

SELECT
    Customer_Segment,
    COUNT(DISTINCT Order_Customer_Id) AS TotalCustomers,
    AVG(Sales) AS AverageSalesPerCustomer
FROM
    Order o
JOIN
    Customer c ON o.Order_Customer_Id = c.Customer_Id
WHERE
    YEAR(order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    Customer_Segment;

-- Regional Sales Performance

SELECT
    Order_Region,
    SUM(Sales) AS TotalSales,
    AVG(Sales) AS AverageSales,
    MAX(Sales) AS MaxSales
FROM
    Order
WHERE
    YEAR(order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    Order_Region;

-- Order Status Analysis

SELECT
    Order_Status,
    COUNT(Order_Id) AS TotalOrders,
    SUM(Sales) AS TotalSales
FROM
    Order
WHERE
    YEAR(order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    Order_Status;

-- countries with highest number of orders with negative Benefit_per_order

WITH NegativeBenefitOrders AS (
    SELECT
        Order_Country,
        COUNT(Order_Id) AS NegativeBenefitOrderCount
    FROM
        Order
    WHERE
        Benefit_per_order < 0
    GROUP BY
        Order_Country
)

SELECT
    Order_Country,
    NegativeBenefitOrderCount
FROM
    NegativeBenefitOrders
ORDER BY
    NegativeBenefitOrderCount DESC;

-- profits per coutry
SELECT
    Order_Country,
    SUM(Order_Profit_Per_Order) AS TotalProfit
FROM
    Order
GROUP BY
    Order_Country
ORDER BY
    TotalProfit DESC;

-- order type per country

SELECT
    Order_Country,
    Order_Type,
    COUNT(Order_Id) AS OrderCount
FROM
    Order
GROUP BY
    Order_Country,
    Order_Type
ORDER BY
    Order_Country, Order_Type;
