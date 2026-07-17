USE OnlineRetailAnalytics;
GO

SELECT
    COUNT(*) AS TransactionLines,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS IdentifiedCustomers,
    COUNT(DISTINCT StockCode) AS UniqueProducts,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS TotalRevenue,
    MIN(InvoiceDate) AS FirstTransaction,
    MAX(InvoiceDate) AS LastTransaction
FROM dbo.CompletedSales;

CREATE INDEX IX_CompletedSales_InvoiceNo
ON dbo.CompletedSales (InvoiceNo);

CREATE INDEX IX_CompletedSales_InvoiceDate
ON dbo.CompletedSales (InvoiceDate);

CREATE INDEX IX_CompletedSales_CustomerID
ON dbo.CompletedSales (CustomerID);

CREATE INDEX IX_CompletedSales_StockCode
ON dbo.CompletedSales (StockCode);

CREATE INDEX IX_CompletedSales_YearMonth
ON dbo.CompletedSales (YearMonth);
GO
--main kpis
SELECT
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS TotalRevenue,
    ROUND(
        SUM(LineRevenue) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS AverageOrderValue,
    ROUND(
        SUM(LineRevenue) /
        NULLIF(COUNT(DISTINCT CustomerID), 0),
        2
    ) AS RevenuePerCustomer
FROM dbo.CompletedSales;

--monthly performance
SELECT
    YearMonth,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS Revenue
FROM dbo.CompletedSales
GROUP BY YearMonth
ORDER BY YearMonth;

--month over month revenue growth
WITH MonthlyRevenue AS (
    SELECT
        YearMonth,
        SUM(LineRevenue) AS Revenue
    FROM dbo.CompletedSales
    GROUP BY YearMonth
),
RevenueComparison AS (
    SELECT
        YearMonth,
        Revenue,
        LAG(Revenue) OVER (
            ORDER BY YearMonth
        ) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    YearMonth,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(PreviousMonthRevenue, 2) AS PreviousMonthRevenue,
    ROUND(
        100.0 * (Revenue - PreviousMonthRevenue) /
        NULLIF(PreviousMonthRevenue, 0),
        2
    ) AS MoMChangePercentage
FROM RevenueComparison
ORDER BY YearMonth;

--top products by revenue
SELECT TOP 10
    StockCode,
    ProductDescription,
    SUM(Quantity) AS UnitsSold,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    ROUND(SUM(LineRevenue), 2) AS Revenue
FROM dbo.CompletedSales
WHERE StockCode NOT IN (
    'POST',
    'DOT',
    'M',
    'BANK CHARGES',
    'C2',
    'AMAZONFEE'
)
GROUP BY
    StockCode,
    ProductDescription
ORDER BY Revenue DESC;

--top products by quantity
SELECT TOP 10
    StockCode,
    ProductDescription,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS Revenue
FROM dbo.CompletedSales
WHERE StockCode NOT IN (
    'POST',
    'DOT',
    'M',
    'BANK CHARGES',
    'C2',
    'AMAZONFEE'
)
GROUP BY
    StockCode,
    ProductDescription
ORDER BY UnitsSold DESC;

--country performance
SELECT
    Country,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS Revenue,
    ROUND(
        SUM(LineRevenue) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS AverageOrderValue
FROM dbo.CompletedSales
GROUP BY Country
ORDER BY Revenue DESC;

--international markets excluding the uk
SELECT TOP 10
    Country,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    ROUND(SUM(LineRevenue), 2) AS Revenue
FROM dbo.CompletedSales
WHERE Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Revenue DESC;

--performance by weekday
SELECT
    WeekdayName,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS Revenue
FROM dbo.CompletedSales
GROUP BY
    WeekdayName,
    CASE WeekdayName
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END
ORDER BY
    CASE WeekdayName
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;

--peak ordering hours
SELECT
    HourNumber,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    SUM(Quantity) AS UnitsSold,
    ROUND(SUM(LineRevenue), 2) AS Revenue
FROM dbo.CompletedSales
GROUP BY HourNumber
ORDER BY Orders DESC;

--top customers
SELECT TOP 10
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Orders,
    SUM(Quantity) AS UnitsPurchased,
    ROUND(SUM(LineRevenue), 2) AS Revenue,
    ROUND(
        SUM(LineRevenue) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS AverageOrderValue
FROM dbo.CompletedSales
WHERE CustomerID IS NOT NULL
  AND LTRIM(RTRIM(CustomerID)) <> ''
GROUP BY CustomerID
ORDER BY Revenue DESC;









