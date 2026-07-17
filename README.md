# Online Retail Sales & Customer Analytics

An end-to-end data analytics project using Python, SQL Server, and Power BI to analyze online retail sales, product performance, purchasing patterns, and customer value.

## Project Overview

This project analyzes 541,909 transaction records from a UK-based online retailer. The objective is to transform raw transactional data into actionable business insights through data cleaning, exploratory analysis, SQL queries, RFM customer segmentation, and interactive Power BI dashboards.

The analysis focuses on:

- Revenue and order trends
- Product sales performance
- Peak ordering periods
- Geographic market performance
- Customer purchasing frequency
- Repeat-customer behaviour
- RFM-based customer segmentation

## Dashboard Preview




<img width="1415" height="856" alt="Screenshot (805)" src="https://github.com/user-attachments/assets/2715e3cf-dfe5-4180-881f-3dc2599f8a8a" />
<img width="1409" height="848" alt="Screenshot (806)" src="https://github.com/user-attachments/assets/b7ab4903-56b4-4976-be67-ab6b30f602c5" />
<img width="1415" height="857" alt="Screenshot (807)" src="https://github.com/user-attachments/assets/dfd79869-c7f5-4a79-985b-3267a47a4309" />



## Tools and Technologies

- **Python:** Pandas, NumPy, Matplotlib, Seaborn
- **SQL Server:** Data storage, validation, business queries, CTEs, window functions, views
- **Power BI:** Data modelling, DAX measures, interactive dashboards
- **Jupyter Notebook:** Data cleaning and exploratory data analysis
- **Git and GitHub:** Version control and project documentation

## Dataset

This project uses the [Online Retail dataset from the UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online-retail).

Dataset details:

- **Transaction lines:** 541,909
- **Period:** December 2010 to December 2011
- **Business:** UK-based non-store online retailer
- **Geographic coverage:** United Kingdom and international markets
- **Licence:** CC BY 4.0

The source dataset contains the following fields:

| Field | Description |
|---|---|
| `InvoiceNo` | Unique invoice identifier |
| `StockCode` | Unique product identifier |
| `Description` | Product description |
| `Quantity` | Number of units purchased |
| `InvoiceDate` | Transaction date and time |
| `UnitPrice` | Price per unit in GBP |
| `CustomerID` | Customer identifier |
| `Country` | Customer’s country |

The raw dataset is not included in this repository. Download it from UCI and place it in the project directory before running the notebook.

## Business Questions

The project addresses the following questions:

1. How does revenue change across months?
2. Which products generate the most revenue?
3. Which products sell the greatest number of units?
4. Which days and hours receive the most orders?
5. Which countries generate the highest revenue?
6. What percentage of identified customers make repeat purchases?
7. Which customers generate the most revenue?
8. How can customers be segmented using recency, frequency, and monetary value?

## Key Results

- Total revenue: £10642110.80
- Total completed orders: 19960
- Identified customers: 4338
- Average order value: £533.17
- Repeat-customer rate: 65.58%
- Highest-revenue month: December, 2010
- Peak ordering hour: 12pm
- Highest-revenue product: DOTCOM POSTAGE
- Highest-revenue international market: Netherlands
- Highest-revenue RFM segment: Champions

## Data Cleaning

Python was used to prepare the dataset before loading it into SQL Server.

The cleaning process included:

- Converting invoice dates to datetime values
- Correcting column data types
- Removing exact duplicate records
- Standardizing product descriptions
- Identifying cancellation invoices
- Separating completed sales from cancellations
- Excluding non-positive quantities and prices from completed sales
- Preserving anonymous purchases for overall sales analysis
- Creating a separate identified-customer dataset
- Calculating line-level revenue
- Deriving year, month, weekday, date, and hour fields
- Validating missing values, duplicates, quantities, prices, and revenue

The following formula was used to calculate revenue:

```text
Line Revenue = Quantity × Unit Price
```

## Exploratory Data Analysis

The Python analysis examines:

- Monthly revenue and order trends
- Orders by weekday and hour
- Revenue by country
- Top products by revenue
- Top products by quantity sold
- Unit-price distribution
- Cancellation patterns
- One-time versus repeat customers
- New versus returning customers
- Customer order-frequency distribution
- Revenue concentration among high-value customers
- Recency, frequency, and monetary distributions

The EDA notebook is available at:

```text
datacleaning_and_eda.ipynb
```

## SQL Analysis

The cleaned dataset was imported into SQL Server for validation and business analysis.

The SQL work demonstrates:

- Aggregate functions
- Distinct counts
- Common table expressions
- Window functions
- `LAG()` for month-over-month comparisons
- Product and country rankings
- Conditional aggregation
- Customer purchase-frequency analysis
- Reusable SQL views
- RFM customer segmentation

The main KPI queries are available in:

```text
mainkpiqueries.sql
```

The RFM analysis is available in:

```text
rfm.sql
```

## RFM Customer Segmentation

Customers were segmented using three metrics:

- **Recency:** Number of days since the customer’s latest purchase
- **Frequency:** Number of unique orders placed by the customer
- **Monetary:** Total revenue generated by the customer

Customers received scores from 1 to 5 using SQL window functions and were classified into segments such as:

- Champions
- Loyal Customers
- Potential Loyalists
- At Risk
- Lost Customers
- Other

These segments can support retention campaigns, customer prioritization, and targeted marketing strategies.

## Data Model

The Power BI model contains:

- `FactSales`: Completed transaction-level sales
- `DimCustomer`: Customer-level RFM metrics and segments
- `DimDate`: Calendar table supporting time-intelligence calculations

Key relationships:

```text
DimDate[Date]          1 ─── * FactSales[OrderDate]

DimCustomer[CustomerID] 1 ─── * FactSales[CustomerID]
```

## Power BI Measures

Important DAX measures include:

- Total Revenue
- Total Orders
- Identified Customers
- Units Sold
- Average Order Value
- Revenue per Customer
- Previous-Month Revenue
- Month-over-Month Revenue Change
- Repeat Customers
- Repeat-Customer Rate
- Customer-Segment Revenue
- Average Customer Value

## Dashboard Pages

### 1. Executive Overview

Displays:

- Total revenue
- Total orders
- Identified customers
- Units sold
- Average order value
- Monthly revenue trend
- Revenue by country
- Orders by weekday

### 2. Product and Time Analysis

Displays:

- Top 10 products by revenue
- Top 10 products by units sold
- Orders by hour
- Revenue by hour
- Product-level performance table
- Interactive product filters

### 3. Customer Analysis

Displays:

- Repeat-customer rate
- Revenue per customer
- Customers by RFM segment
- Revenue by customer segment
- Average value by customer segment
- Customer-level RFM details

## Project Files

```text
.
├── Dashboards.pbix
├── datacleaning_and_eda.ipynb
├── excel_to_csv.py
├── mainkpiqueries.sql
├── rfm.sql
├── requirements.txt
├── .gitignore
└── README.md
```

## How to Run the Project

### 1. Clone the repository

```bash
git clone (https://github.com/payaljindal35/online-retail-sales-customer-analytics).git
cd online-retail-sales-customer-analytics
```

### 2. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 3. Download the dataset

Download the dataset from the UCI repository and place `Online Retail.xlsx` in your local data folder.

### 4. Run the notebook

Open:

```text
datacleaning_and_eda.ipynb
```

Run the cells in order to clean, validate, analyze, and export the data.

### 5. Load the cleaned data into SQL Server

Create an SQL Server database named:

```text
OnlineRetailAnalytics
```

Import the cleaned CSV into the `CompletedSales` table.

### 6. Run the SQL scripts

Run:

```text
mainkpiqueries.sql
rfm.sql
```

### 7. Open the dashboard

Open:

```text
Dashboards.pbix
```

Update the SQL Server connection if necessary and refresh the data.

## Limitations

- Product costs are unavailable, so genuine profit and profit margin cannot be calculated.
- Customer demographic information is unavailable.
- Some transactions do not contain customer identifiers.
- Product categories are not provided.
- The dataset covers approximately one year.
- December 2011 contains partial-month data.
- RFM segments are relative to this dataset and are not universal customer-value thresholds.
- The analysis identifies associations and patterns, not causal relationships.

## Future Improvements

Possible extensions include:

- Cancellation and return analysis
- Cohort-retention analysis
- Market-basket analysis
- Product grouping using description keywords
- Automated SQL Server refresh
- Power BI drill-through and tooltip pages
- Deployment through the Power BI Service

## Author

**Payal Jindal**

Data Analytics Project | Python, SQL Server, Power BI

## Acknowledgement

Dataset provided by the UCI Machine Learning Repository:

> Chen, D. (2015). Online Retail [Dataset]. UCI Machine Learning Repository.  
> DOI: 10.24432/C5BW33
