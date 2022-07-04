USE tempdb
GO
CREATE FUNCTION dbo.[UDF_Space_Before_Specified_Letter]
(
    @String VARCHAR(MAX), -- Variable for string
	@InputValue VARCHAR(MAX), -- Thing you want to change
	@OutputValue VARCHAR(MAX)  -- Thing you want to get
)
RETURNS VARCHAR(MAX)
BEGIN
DECLARE 
	@RETURN_STRING VARCHAR(MAX);
	
;WITH 
N1 (n) AS (SELECT 1 UNION ALL SELECT 1),
N2 (n) AS (SELECT 1 FROM N1 AS X, N1 AS Y),
N3 (n) AS (SELECT 1 FROM N2 AS X, N2 AS Y),
N4 (n) AS (SELECT ROW_NUMBER() OVER(ORDER BY X.n)
FROM N3 AS X, N3 AS Y)
 

SELECT @RETURN_STRING = ISNULL(@RETURN_STRING,'')+
(CASE WHEN CHARINDEX(@InputValue,@String) > 0 
AND Nums.n >1
THEN  REPLACE(@String,@InputValue, @OutputValue)
ELSE SUBSTRING(@String,Nums.n,1) END)
 
FROM N4 Nums
WHERE Nums.n<=LEN(@String)

--print @String 
RETURN @RETURN_STRING
END
GO


--  For Example :
--USE tempdb
--GO
--SELECT [StudentStatus]
--,dbo.[UDF_Space_Before_Specified_Letters]([Notes], 'This', ' This') As [StudentStatus]
--from [Student].[dbo].[StudentInfo]
--GO