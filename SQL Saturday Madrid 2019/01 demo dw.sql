
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE OR ALTER VIEW fact.AnsweredPost
AS SELECT p.[Id], 
          p.[AcceptedAnswerId], 
          p.OwnerUserId, 
          p.[AnswerCount], 
          CAST(p.[CreationDate] AS DATE) FromDate, 
          CAST(COALESCE(PostLeft.CreationDate, '20220527') AS DATE) ToDate
   FROM [dbo].[Posts] p
        LEFT JOIN dbo.Posts PostLeft ON p.AcceptedAnswerId = PostLeft.id;
GO
DROP TABLE dim.fecha;
DECLARE @DESDE DATE, @HASTA DATE;
SELECT @DESDE = MIN(CREATIONDATE), 
       @HASTA = MAX(CREATIONDATE)
FROM dbo.Posts;
DECLARE @distance INT;
SET @distance = DATEDIFF(day, @desde, @hasta);
WITH mycte
     AS (SELECT 0 AS id
         UNION ALL
         SELECT id + 1
         FROM mycte)
     SELECT TOP (@distance + 1000) DATEADD(day, id, @desde) AS Fecha
     INTO dim.fecha
     FROM mycte
     WHERE id < @distance + 10000 OPTION(MAXRECURSION 0);
	 GO
GO
ALTER TABLE dim.fecha
ADD Montkey AS MONTH(fecha);
ALTER TABLE dim.fecha
ADD DaynumberofMonth AS DATEPART(day, fecha);
ALTER TABLE dim.fecha
ADD Mont AS datename(month, fecha);
ALTER TABLE dim.fecha
ADD YearId AS YEAR(fecha);
GO
GO
CREATE OR ALTER VIEW dim.Users
AS SELECT id, 
          DisplayName, 
          UpVotes, 
          DownVotes
   FROM dbo.Users;
 go
 select @@SERVERNAME

 select * from dim.fecha order by 1 desc