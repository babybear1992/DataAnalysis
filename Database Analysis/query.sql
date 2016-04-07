SET FEEDBACK OFF LINESIZE 130 PAGESIZE 60
COLUMN "Employee" FORMAT A25
COLUMN "Skill" FORMAT A10
COLUMN "Department" FORMAT A10
COLUMN "Project Name" FORMAT A35
COLUMN Emp_First FORMAT A10
COLUMN Emp_Last FORMAT A10
COLUMN "Employees Assigned" HEADING "Employees|Assigned"
COLUMN "Training Name" FORMAT A28
COLUMN "Training Date" HEADING "Training|Date"
COLUMN "Most Recent Training" HEADING "Most|Recent|Training" FORMAT A10
COLUMN "No. of Training" HEADING "No. of|Training"
COLUMN "No. of Projects" HEADING "No. of|Projects"
COLUMN "Days Since Training" HEADING "Days|Since|Training" 
COLUMN "Months Since Training" HEADING "Months|Since|Training" 
COLUMN "Last Date Accquired" HEADING "Last|Date|Accquired" FORMAT A9
COLUMN "Number of Skills" HEADING "Number|of|Skills"
COLUMN Status FORMAT A10
COLUMN "Employee Name" FORMAT A17
COLUMN "Number of Trainings" HEADING "Number of|Trainings"
COLUMN ID FORMAT A3
SPOOL D:\Query_Result.txt
-- Question 1

SELECT	Emp_Num || ': ' ||  Emp_First || ' ' || Emp_Last "Employee",
		Description "Skill",
		COUNT(Train_Num) "No. of Training",
		MAX(Date_Accquired) "Most Recent Training",
		TRUNC(MONTHS_BETWEEN(SYSDATE, MAX(Date_Accquired))) "Months Since Training"
FROM 	Training 	JOIN 	Skill 	USING(Code)
					RIGHT OUTER JOIN 	Employee 	USING(Emp_Num)
GROUP BY 	Emp_Num, Emp_First, Emp_Last, Code, Description;

-- Question 2

SELECT	LEVEL,
		LPAD(' ', 3*(LEVEL -1)) || Emp_Num || '   ' || 
		Emp_First || ' ' || Emp_Last "Employee",
		Name "Department"
FROM 	Employee 	JOIN 	Department 	USING(Dept_Code)
START WITH 	Emp_Num	IN (SELECT Emp_Num FROM Employee WHERE Super_ID IS NULL)
CONNECT BY PRIOR Emp_Num = Super_ID;

-- Question 3
SELECT 	Name "Project Name",
		Start_Date "Start_Date",
		Month "Month",
		COUNT(DISTINCT Emp_Num) "Employees Assigned",
		SUM(Hours_Used) "Hours Spent"
FROM  	(SELECT	Name,
				Start_Date,
				EXTRACT(month FROM Date_Assigned) Month,
				Emp_Num,
				Hours_Used
		FROM 	Project 	JOIN 	Assignment 	USING (Proj_Number)
		WHERE 	Total_Cost IS NULL)
GROUP BY	GROUPING SETS ((Name, Start_Date, Month), (Name, Start_Date))
ORDER BY	Name, Month;

-- Question 4
ALTER TABLE Employee ADD Bonus Number(*,2);
UPDATE 	Employee E1
SET 	Bonus = (SELECT 	Bonus
				FROM	(SELECT 	Emp_Num, NVL(A.Bonus, 0) Bonus
						FROM 	(SELECT	Emp_Num, COUNT(DISTINCT Proj_Number) * 200 Bonus
								FROM 	Assignment 	JOIN 	Project 	USING(Proj_Number)
													JOIN 	Employee 	USING(Emp_Num)
								WHERE 	EXTRACT(year FROM Start_Date) = EXTRACT(year FROM SYSDATE) - 1
								GROUP BY 	Emp_Num, Proj_Number
								HAVING 	SUM(Hours_Used) >= 40) A
								RIGHT OUTER JOIN 	Employee 	USING(Emp_Num)) E2
		WHERE 	E2.Emp_Num = E1.Emp_Num);
SELECT * FROM Employee;

-- Question 5
SELECT 	Emp_Num || ': ' || Emp_First || ' ' || Emp_Last "Employee",
		Hire_Date "Hire Date", 
		Training.Name "Training Name",
		Date_Accquired "Training Date",
		TRUNC(SYSDATE - Date_Accquired) "Days Since Training",
		Num_Proj "No. of Projects"
FROM 	Employee 	LEFT OUTER JOIN 	Training 	USING(Emp_Num)
					LEFT OUTER JOIN 	(SELECT Emp_Num, COUNT(DISTINCT Proj_Number) Num_Proj
										FROM Assignment JOIN Project USING(Proj_Number)
										WHERE Total_Cost IS NOT NULL
										GROUP BY Emp_Num) USING(Emp_Num)
WHERE 	EXTRACT(year FROM Hire_Date) = EXTRACT(year FROM SYSDATE) - 1
ORDER BY 	"Employee";

-- Question 6
SELECT 	Name "Project Name", 
		Start_Date "Start Date", 
		NVL2(Total_Cost, 'Completed', 'On-going') "Status"
FROM 	Project
WHERE 	Proj_Number IN (SELECT 	Proj_Number
						FROM 	Assignment	
						GROUP BY 	Proj_Number
						HAVING 	ROUND(MONTHS_BETWEEN(MAX(Date_Ended), MIN(Date_Assigned))) != 
								COUNT(DISTINCT EXTRACT(month FROM Date_Assigned)));

-- Question 7
SELECT 	Quarter "Quarter", 
		COUNT(DISTINCT Proj_Number) "Project Started",
		COUNT(DISTINCT Emp_Num) "Employees Assigned",
		SUM(Hours_Used) / COUNT(DISTINCT Emp_Num) "Avg Hours"
FROM 	(SELECT 	Proj_Number, Name, Emp_Num, 
				CASE 
					WHEN EXTRACT(month FROM Start_Date) <= 3 THEN 1
					WHEN EXTRACT(month FROM Start_Date) <= 6 THEN 2
					WHEN EXTRACT(month FROM Start_Date) <= 9 THEN 3
					ELSE 4
				END Quarter,
				Hours_Used
		FROM 	Project 	LEFT OUTER JOIN 	Assignment	USING (Proj_Number)
		WHERE 	EXTRACT(year FROM Start_Date) = EXTRACT(year FROM SYSDATE) - 1
		AND 	EXTRACT(month FROM Date_Assigned) <= EXTRACT(month FROM Start_Date) + 2)
GROUP BY 	Quarter;

-- Question 8
SELECT 	Emp_Num "ID",
		DECODE (Emp_Name, NULL, '# of Trainings', Emp_Name) "Employee Name",
		NVL(SUM(DECODE(Code, 100, 1)), 0) "Java",
		NVL2(Emp_Num, MAX(DECODE(Code, 100, Date_Accquired)), '') "Last Date Accquired",
		NVL(SUM(DECODE(Code, 101, 1)), 0) "Marketing",
		NVL2(Emp_Num, MAX(DECODE(Code, 101, Date_Accquired)), '') "Last Date Accquired",
		NVL(SUM(DECODE(Code, 102, 1)), 0) "C#",
		NVL2(Emp_Num, MAX(DECODE(Code, 102, Date_Accquired)), '') "Last Date Accquired",
		NVL(SUM(DECODE(Code, 103, 1)), 0) "SQL",
		NVL2(Emp_Num, MAX(DECODE(Code, 103, Date_Accquired)), '') "Last Date Accquired",
		NVL2(Emp_Num, COUNT(DISTINCT Code), '') "Number of Skills"
FROM  	(SELECT 	Emp_Num, 
					Emp_First || ' ' || Emp_Last Emp_Name, 
					Date_Accquired,
					Code
			FROM 	Employee 	LEFT OUTER JOIN 	Training 	USING(Emp_Num)
								LEFT OUTER JOIN 	Skill 	USING(Code))
GROUP BY 	GROUPING SETS ((Emp_Num, Emp_Name), ())
ORDER BY 	Emp_Num;

-- Question 9
SELECT 	Name "Department", 
		Description "Skill", 
		NVL(Num_Training, 0) "No. Trainings",
		DENSE_RANK() OVER (PARTITION BY Dept_Code ORDER BY NVL(Num_Training, 0) DESC) "Rank"
FROM 	(SELECT DISTINCT Dept_Code, Name, Code, Description FROM Department, Skill) 
		LEFT OUTER JOIN 
		(SELECT 	Dept_Code, 	Code, COUNT(DISTINCT Train_Num) Num_Training
		FROM 	Employee 	JOIN 	Department 	USING(Dept_Code)
							JOIN 	Training 	USING(Emp_Num)
							JOIN 	Skill 	USING(Code)
		GROUP BY 	Dept_Code, Code) 
		USING (Dept_Code, Code)
ORDER BY 	Name, "Rank";
SPOOL OFF

SET FEEDBACK ON LINESIZE 130 PAGESIZE 30