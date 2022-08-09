USE tempdb
GO
CREATE FUNCTION dbo.[UDF_Space_Before_Specified_Letter]
(
    @String NVARCHAR(MAX), -- Variable for string
	@InputValue NVARCHAR(MAX), -- Thing you want to change
	@OutputValue NVARCHAR(MAX)  -- Thing you want to get

)
RETURNS NVARCHAR(MAX)
BEGIN
	DECLARE 
	@RETURN_STRING NVARCHAR(MAX) = @String;;

IF (@String = @InputValue)
	BEGIN
		;WITH 
		N1 (n) AS (SELECT 1 UNION ALL SELECT 1),
		N2 (n) AS (SELECT 1 FROM N1 AS X, N1 AS Y),
		N3 (n) AS (SELECT 1 FROM N2 AS X, N2 AS Y),
		N4 (n) AS (SELECT ROW_NUMBER() OVER(ORDER BY X.n)
		FROM N3 AS X, N3 AS Y)
 


		SELECT @RETURN_STRING =
		(CASE WHEN CHARINDEX(@InputValue,@String) > 0 
		AND Nums.n >1
		THEN  REPLACE(@String,@InputValue, @OutputValue)
		ELSE SUBSTRING(@String,Nums.n,1) END)
 
		FROM N4 Nums
		WHERE Nums.n<=LEN(@String)

		--print @String 
		RETURN @RETURN_STRING	
	
	END
RETURN @RETURN_STRING

END
GO

  --For Example : You can write into a #tmp table and see the changes
USE tempdb
GO
SELECT [ID], [Test_Column]
,dbo.[UDF_Space_Before_Specified_Letter] ([Notes], 'This', ' This') As [New_Column] into #tmp
from [Database].[dbo].[Table_Name]
GO

select * from #tmp

-- This script give you to update statement for the changes that you want from your #tmp table
-- You can run it and you can copy the update scripts 

SELECT ('UPDATE ' 
+ 'table_name (the table that you wanna change)' 
+ ' SET '
+ 'column_name (column should have been changed)'
+ ' = ' 
+ CONVERT(VARCHAR(MAX), test_column)
+ ' WHERE ' 
+ 'id' 
+ ' = ' 
+ CONVERT(VARCHAR(MAX),ID)) 
FROM  #tmp




