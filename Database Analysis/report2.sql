-- Report 2
-- "Table Summary Report"
SET FEEDBACK OFF LINESIZE 130 PAGESIZE 60

-- set up the appropriate parameters to increase readability
COLUMN 	"Table Name" 	FORMAT A12
COLUMN 	"Column Name" 	FORMAT A15
COLUMN 	"Constraint Name" 	FORMAT A25
COLUMN 	"Constraint Type"	HEADING 	'Constraint|Type'	FORMAT A10
COLUMN 	"Search Condition"	WORD_WRAPPED FORMAT A25
COLUMN 	"FK Table"	FORMAT A15
COLUMN 	"FK Column"	FORMAT A15

TTITLE 	'Summary of Table'
BTITLE 	CENTER 	'End of Summary' -
		RIGHT 	'Run By: ' SQL.USER FORMAT A7

BREAK 	ON "Table Name" ON "Column Name"

SPOOL C:\SQLProject\Report_2.txt

SELECT	A.Table_Name "Table Name",
		A.Column_Name "Column Name", 
		B.Constraint_Name "Constraint Name", 
		CASE Constraint_Type
			WHEN 'P' THEN 'PK'
			WHEN 'R' THEN 'FK'
			WHEN 'C' THEN 'CK'
			WHEN 'U' THEN 'UK'
			ELSE Constraint_Type
		END "Constraint Type",
		Search_Condition "Search Condition",
		D.Table_Name "FK Table", 
		D.Column_Name "FK Column"
FROM 	User_Tab_Columns A	LEFT OUTER JOIN 	User_Cons_Columns B	
								ON A.Table_Name = B.Table_Name AND A.Column_Name = B.Column_Name
							LEFT OUTER JOIN 	User_Constraints C	
								ON A.Table_Name = B.Table_Name AND B.Constraint_Name = C.Constraint_Name
							LEFT OUTER JOIN 	(SELECT 	Constraint_Name R_Constraint_Name,
															Table_Name, 
															Column_Name
												FROM 	User_Cons_Columns) D
								ON C.R_Constraint_Name = D.R_Constraint_Name
ORDER BY 	A.Table_Name, Column_ID;

SPOOL OUT

-- clean up the parameter values before any other statements
CLEAR 	BREAK COLUMN
TTITLE 	OFF
BTITLE 	OFF
SET FEEDBACK ON LINESIZE 130 PAGESIZE 30
