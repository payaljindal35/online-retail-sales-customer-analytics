USE OnlineRetailAnalytics
GO
CREATE OR ALTER VIEW dbo.CustomerRFM
AS

WITH ReferenceDate AS (
    SELECT DATEADD(
        DAY,
        1,
        MAX(InvoiceDate)
    ) AS AnalysisDate
    FROM dbo.CompletedSales
),
CustomerMetrics AS (
    SELECT
        S.CustomerID,
        DATEDIFF(
            DAY,
            MAX(S.InvoiceDate),
            R.AnalysisDate
        ) AS Recency,
        COUNT(DISTINCT S.InvoiceNo) AS Frequency,
        SUM(S.LineRevenue) AS Monetary
    FROM dbo.CompletedSales AS S
    CROSS JOIN ReferenceDate AS R
    WHERE S.CustomerID IS NOT NULL
      AND LTRIM(RTRIM(S.CustomerID)) <> ''
    GROUP BY
        S.CustomerID,
        R.AnalysisDate
),
RFMScores AS (
    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,
        6 - NTILE(5) OVER (
            ORDER BY Recency
        ) AS RScore,
        NTILE(5) OVER (
            ORDER BY Frequency
        ) AS FScore,
        NTILE(5) OVER (
            ORDER BY Monetary
        ) AS MScore
    FROM CustomerMetrics
)
SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    RScore,
    FScore,
    MScore,
    CASE
        WHEN RScore >= 4
         AND FScore >= 4
         AND MScore >= 4
            THEN 'Champions'

        WHEN RScore >= 3
         AND FScore >= 3
            THEN 'Loyal Customers'

        WHEN RScore >= 4
         AND FScore <= 2
            THEN 'Potential Loyalists'

        WHEN RScore <= 2
         AND FScore >= 3
            THEN 'At Risk'

        WHEN RScore <= 2
         AND FScore <= 2
            THEN 'Lost Customers'

        ELSE 'Other'
    END AS CustomerSegment
FROM RFMScores;
GO

--test
SELECT TOP 20 *
FROM dbo.CustomerRFM
ORDER BY Monetary DESC;

SELECT
    CustomerSegment,
    COUNT(*) AS Customers,
    ROUND(SUM(Monetary), 2) AS Revenue,
    ROUND(AVG(Monetary), 2) AS AverageCustomerValue
FROM dbo.CustomerRFM
GROUP BY CustomerSegment
ORDER BY Revenue DESC;