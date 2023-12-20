WITH PerformanceAnalysis AS (
    SELECT
        YEAR(o.order_date_DateOrders) AS OrderYear,
        SUM(CAST(o.Sales AS float)) AS TotalSales,
        SUM(CAST(o.Order_Profit_Per_Order AS float)) AS TotalProfit,
        c.Customer_Segment,
        p.Product_Category_Id,
        COUNT(DISTINCT o.Order_Id) AS TotalOrders
    FROM
        [dbo].[OrderData] o
    INNER JOIN
        [dbo].[CustomerData] c ON o.Order_Customer_Id = c.Customer_Id
    INNER JOIN
        [dbo].[ProductData] p ON o.Order_Item_Cardprod_Id = p.Product_Card_Id
    GROUP BY
        YEAR(o.order_date_DateOrders),
        c.Customer_Segment,
        p.Product_Category_Id
)

SELECT
    OrderYear,
    Customer_Segment,
    Product_Category_Id,
    TotalSales,
    TotalProfit,
    TotalOrders
FROM
    PerformanceAnalysis
ORDER BY TotalProfit DESC;


-- Top-Selling Products

SELECT
    p.Product_Name,
    SUM(CAST(o.Order_Item_Quantity AS int)) AS TotalQuantitySold -- Assuming the quantity can be converted to int
FROM
    [dbo].[OrderData] o
JOIN
    dbo.ProductData p ON o.Order_Item_Cardprod_Id = p.Product_Card_Id
WHERE
    YEAR(o.order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    p.Product_Name
ORDER BY
    TotalQuantitySold DESC;


-- Customer Segment Analysis

SELECT
    c.Customer_Segment,
    COUNT(DISTINCT o.Order_Customer_Id) AS TotalCustomers,
    AVG(CAST(o.Sales AS float)) AS AverageSalesPerCustomer -- Convert nvarchar to float for average calculation
FROM
    [dbo].[OrderData] o
JOIN
    dbo.CustomerData c ON o.Order_Customer_Id = c.Customer_Id
WHERE
    YEAR(o.order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    c.Customer_Segment;
-- Regional Sales Performance

SELECT
    o.Order_Region,
    SUM(CAST(o.Sales AS float)) AS TotalSales,
    AVG(CAST(o.Sales AS float)) AS AverageSales,
    MAX(CAST(o.Sales AS float)) AS MaxSales
FROM
    [dbo].[OrderData] o
WHERE
    YEAR(o.order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    o.Order_Region;
-- Order Status Analysis

SELECT
    o.Order_Status,
    COUNT(o.Order_Id) AS TotalOrders,
    SUM(CAST(o.Sales AS float)) AS TotalSales -- Convert nvarchar to float for sum calculation
FROM
    [dbo].[OrderData] o
WHERE
    YEAR(o.order_date_DateOrders) = YEAR(GETDATE())
GROUP BY
    o.Order_Status;

-- countries with highest number of orders with negative Benefit_per_order

WITH NegativeBenefitOrders AS (
    SELECT
        o.Order_Country,
        COUNT(o.Order_Id) AS NegativeBenefitOrderCount
    FROM
        [dbo].[OrderData] o
    WHERE
        o.Benefit_per_order < 0
    GROUP BY
        o.Order_Country
)

SELECT
    Order_Country,
    NegativeBenefitOrderCount
FROM
    NegativeBenefitOrders
ORDER BY
    NegativeBenefitOrderCount DESC;
-- profits per country
SELECT
    o.Order_Country,
    SUM(CAST(o.Order_Profit_Per_Order AS float)) AS TotalProfit -- Convert nvarchar to float for sum calculation
FROM
    [dbo].[OrderData] o
GROUP BY
    o.Order_Country
ORDER BY
    TotalProfit DESC;
-- order type per country

SELECT
    o.Order_Country,
    o.Type,
    COUNT(o.Order_Id) AS OrderCount
FROM
    [dbo].[OrderData] o
GROUP BY
    o.Order_Country,
    o.Type
ORDER BY
    o.Order_Country, o.Type;
