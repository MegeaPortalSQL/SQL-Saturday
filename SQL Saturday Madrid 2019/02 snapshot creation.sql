USE StackOverflow;
GO
--- All users repots all month
DROP TABLE fact.usersnap;
GO
SELECT id AS iduser, 
       fecha, 
       CAST(upvotes * RAND(YEAR(fecha) * 100 + MONTH(fecha)) * 100 AS INT) upvotes, 
       CAST(DownVotes * RAND(YEAR(fecha) * 100 + MONTH(fecha)) * 100 AS INT) DownVotes
INTO fact.usersnap
FROM
(
    SELECT TOP (10) *
    FROM dim.Users
    ORDER BY id
) u
CROSS JOIN
(
    SELECT fecha
    FROM dim.fecha
    WHERE DAY(fecha) = 1
) n;
GO
SELECT *
FROM fact.usersnap;
GO
UPDATE fact.usersnap
  SET 
      fecha = DATEADD(day, -1, fecha);
-- optimization 1
-- borrar repetidos
WITH repes
     AS (SELECT iduser, 
                fecha, 
                LEAD(fecha, 1) OVER(PARTITION BY iduser
                ORDER BY fecha) sigufecha, 
                LEAD(downvotes, 1) OVER(PARTITION BY iduser
                ORDER BY fecha) downvotesnext, 
                DownVotes
         FROM fact.usersnap)
     --SELECT *
     DELETE f
     FROM repes
          INNER JOIN fact.usersnap f ON repes.iduser = f.iduser
                                        AND repes.Fecha = f.Fecha
     WHERE downvotesnext = repes.DownVotes;
	 GO
SELECT *
FROM fact.usersnap;