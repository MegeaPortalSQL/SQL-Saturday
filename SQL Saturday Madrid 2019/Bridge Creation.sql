
/*
drop TABLE dbo.SalesBridgeCompresion
CREATE TABLE dbo.SalesBridgeCompresion
(id       INT IDENTITY(1, 1) PRIMARY KEY, 
 [SalesOrderNumber] nvarchar(20),
 products NVARCHAR(4000),
 Multiple int
);
*/

GO
CREATE OR ALTER VIEW dbo.FactInternetSalesCompletion
AS WITH completion
        AS (SELECT [SalesOrderNumber],
                   CASE
                       WHEN COUNT(*) = 1
                       THEN 0
                       ELSE 1
                   END Multiple, 
                   STUFF(
            (
                SELECT ',' + CAST(ProductKey AS NVARCHAR(10))
                FROM [dbo].[FactInternetSales] f2
                WHERE f.SalesOrderNumber = f2.SalesOrderNumber FOR XML PATH('')
            ), 1, 1, '') products
            FROM [dbo].[FactInternetSales] f
            GROUP BY [SalesOrderNumber])
        SELECT f.SalesOrderNumber, 
               c.Multiple, 
               c.products
        FROM dbo.FactInternetSales f
             INNER JOIN completion c ON f.SalesOrderNumber = c.SalesOrderNumber;
GO
TRUNCATE TABLE dbo.SalesBridgeCompresion;
GO 
INSERT INTO dbo.SalesBridgeCompresion
(SalesOrderNumber, 
 products, 
 Multiple
)
       SELECT DISTINCT 
              SalesOrderNumber, 
              Products, 
              Multiple
       FROM dbo.FactInternetSalesCompletion;
GO
SELECT *
FROM dbo.SalesBridgeCompresion;
GO
CREATE OR ALTER VIEW dbo.FactInternetSalesBridge
AS WITH dp
        AS (SELECT DISTINCT 
                   id, 
                   products
            FROM dbo.SalesBridgeCompresion)
        SELECT dp.id, 
               v.value AS ProductId
        FROM dp
             CROSS APPLY STRING_SPLIT(products, ',') v;
GO 
SELECT *
FROM dbo.FactInternetSalesBridge;
GO
CREATE OR ALTER VIEW dbo.FActInternetSalesHeader
AS WITH fish
        AS (SELECT DISTINCT 
                   [OrderDateKey], 
                   [DueDateKey], 
                   [ShipDateKey], 
                   [CustomerKey], 
                   [PromotionKey], 
                   [CurrencyKey], 
                   [SalesTerritoryKey], 
                   SalesOrderNumber
            FROM dbo.FactInternetSales)
        SELECT fish.*,f.id
        FROM fish
             INNER JOIN dbo.SalesBridgeCompresion f ON fish.SalesOrderNumber = f.SalesOrderNumber;
GO
SELECT *
FROM FActInternetSalesHeader

