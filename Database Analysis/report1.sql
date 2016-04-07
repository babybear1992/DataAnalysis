SET FEEDBACK OFF LINESIZE 130 PAGESIZE 60

COLUMN "Employee Name" FORMAT A20
COLUMN "Superviser Name" FORMAT A20
COLUMN "Training Name" FORMAT A26
COLUMN "Training Date" HEADING "Training|Date" FORMAT A15
COLUMN "Months Since Training" HEADING "Months|Since|Training"
COLUMN "Skill" FORMAT A10
COMPUTE COUNT LABEL 'Num of Trainings' OF "Training Name" ON "Employee Name"
TTITLE 'Employee Information Summary'
BTITLE CENTER 'End of Summary' RIGHT  'Run By:' SQL.USER FORMAT A7
BREAK ON "Employee Name" SKIP 1 ON "Superviser Name" SKIP 1
COMPUTE COUNT LABEL "Number of Trainings" OF "Name" ON "Employee Name"

SPOOL D:\Report_1.txt
SELECT E.Emp_First||' '||E.Emp_Last "Employee Name",
       DECODE(E.Super_ID,    NULL, NULL,
       	             E.Super_ID, S.Emp_First || ' ' || S.Emp_Last) "Superviser Name",
       Name AS "Training Name",
       Date_Accquired AS "Training Date",
       Description AS "Skill",
       TRUNC(MONTHS_BETWEEN(SYSDATE, MAX(Date_Accquired))) "Months Since Training"
FROM TRAINING JOIN SKILL USING (Code)
              RIGHT OUTER JOIN Employee E USING (Emp_Num)
              RIGHT OUTER JOIN Employee S ON S.Emp_Num = E.Super_ID 
GROUP BY E.Emp_First, E.Emp_Last,Name,Description, E.Super_ID, Date_Accquired, S.Emp_First, S.Emp_Last
ORDER BY "Employee Name";
SPOOL OFF
-- clean up the parameter values before any other statements
CLEAR BREAK COLUMN COMPUTE
TTITLE OFF
BTITLE OFF
SET FEEDBACK ON LINESIZE 130 PAGESIZE 30