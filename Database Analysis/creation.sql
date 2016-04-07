DROP TABLE Training;
DROP TABLE Skill;
DROP TABLE Assignment;
DROP TABLE Project;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Client;

-- Table creation
CREATE TABLE Skill (
	Code			CHAR(4),
	Description		VARCHAR2(20),
	CONSTRAINT Skill_code_PK PRIMARY KEY (Code)
);

CREATE TABLE Department (
	Dept_Code 		CHAR(4),
	Name			VARCHAR2(40),
	Location 		VARCHAR2(40),
	Phone			VARCHAR2(15),
	Manager_ID		CHAR(4),
	CONSTRAINT Department_deptCode_PK PRIMARY KEY (Dept_Code)
);

CREATE TABLE Employee (
	Emp_Num 		CHAR(4),
	Emp_Last		VARCHAR2(20),
	Emp_First		VARCHAR2(20),
	DOB 			DATE,
	Hire_Date		DATE DEFAULT SYSDATE,
	Super_ID		CHAR(4),
	Dept_Code		CHAR(4),
	CONSTRAINT Employee_empNum_PK PRIMARY KEY (Emp_Num),
	CONSTRAINT employee_department_FK FOREIGN KEY (Dept_Code) 
		REFERENCES Department (Dept_Code),
	CONSTRAINT employee_manager_FK FOREIGN KEY (Super_ID)
		REFERENCES Employee (Emp_Num),
	CONSTRAINT employee_dob_CK 
		CHECK (ADD_MONTHS(DOB, 17 * 12) < Hire_Date)
);

ALTER TABLE Department
ADD CONSTRAINT department_employee_FK
FOREIGN KEY (Manager_ID) REFERENCES Employee (Emp_Num);

CREATE TABLE Training (
	Train_Num 		CHAR(4)
					CONSTRAINT Training_trainNum_PK PRIMARY KEY,
	Code 			CHAR(4),
	Emp_Num			CHAR(4),
	Date_Accquired 	Date,
	Name 			VARCHAR2(50),
	Commments 		VARCHAR2(50),
	CONSTRAINT training_skill_FK FOREIGN KEY (Code) 
		REFERENCES Skill (Code),
	CONSTRAINT training_employee_FK FOREIGN KEY (Emp_Num) 
		REFERENCES Employee (Emp_Num)
);


CREATE TABLE Client (
	Client_ID				CHAR(4),
	Name					VARCHAR2(40),
	Street					VARCHAR2(40),
	City					VARCHAR2(20),
	State					VARCHAR2(4),
	Zip_Code				VARCHAR2(5),
	Industry				VARCHAR2(15),
	Web_Address				VARCHAR2(80),
	Phone					VARCHAR2(15),
	Contact_Name			VARCHAR2(40),
	CONSTRAINT Client_clientID_PK PRIMARY KEY (Client_ID)
);

CREATE TABLE Project (
	Proj_Number 	CHAR(4),
	Name 			CHAR(40),
	Start_Date 		Date DEFAULT SYSDATE,
	Total_Cost 		Number(*,2),
	Dept_Code 		CHAR(4),
	Client_ID 		CHAR(4),
	CONSTRAINT Project_projNum_PK PRIMARY KEY (Proj_Number),
	CONSTRAINT project_deparment_FK FOREIGN KEY (Dept_Code)
		REFERENCES Department (Dept_Code),
	CONSTRAINT project_client_FK FOREIGN KEY (Client_ID)
		REFERENCES Client (Client_ID),
	CONSTRAINT project_totalCost_CK 
		CHECK (Total_Cost > 0)
);

CREATE TABLE Assignment (
	Assign_Num		CHAR(4),
	Proj_Number 	CHAR(4),
	Emp_Num 		CHAR(4),
	Date_Assigned	DATE DEFAULT SYSDATE,
	Date_Ended 		DATE,
	Hours_Used 		Number(4,0),
	CONSTRAINT Assignment_assignNum_PK PRIMARY KEY (Assign_Num),
	CONSTRAINT assignment_project_FK FOREIGN KEY (Proj_Number)
		REFERENCES Project (Proj_Number),
	CONSTRAINT assignment_employee_FK FOREIGN KEY (Emp_Num)
		REFERENCES Employee (Emp_Num),
	CONSTRAINT assignment_dateEnded_CK 
		CHECK (Date_Ended >= Date_Assigned),
	CONSTRAINT assingment_hoursUsed_CK 
		CHECK (Hours_Used > 0)
);

-- Insert data 
-- Skill
INSERT INTO Skill VALUES ('100', 'Java');
INSERT INTO Skill VALUES ('101', 'Marketing');
INSERT INTO Skill VALUES ('102', 'C#');
INSERT INTO Skill VALUES ('103', 'SQL');

-- Client 
INSERT INTO Client VALUES (
	'123', 'PNC Bank', 'N Craig Street', 'Pittsburgh', 'PA', '15122', 
	'Finance', 'www.pnc.com', '412-213-2999', 'Noel Wu'
);

INSERT INTO Client VALUES (
	'124', 'University of Pittsburgh', 'Apple Street', 'Pittsburgh', 'PA', '15123', 
	'Education', 'www.upitt.com', '412-313-4499', 'James Potter'
);

INSERT INTO Client VALUES (
	'125', 'University of Chicago', 'Sheridan Street', 'Chicago', 'IL', '52123', 
	'Education', 'www.chicago-univeristy.com', '312-323-4799', 'Alex Bert'
);

INSERT INTO Client VALUES (
	'126', 'Deloitte', 'Pear Street', 'Pittsburgh', 'PA', '15992', 
	'Finance', 'www.deloitte.com', '412-373-8799', 'Mary Kate'
);

INSERT INTO Client VALUES (
	'127', 'Greyhound', 'Bus Street', 'Pittsburgh', 'PA', '15718', 
	'Transportation', 'www.greyhound.com', '412-820-2012', 'Susan Jones'
);

INSERT INTO Client VALUES (
	'128', 'Carnegie Mellon University', 'Forbes Road', 'Pittsburgh', 'PA', '15213', 
	'Education', 'www.cmu.edu', '412-920-7123', 'Harry Thomas'
);

INSERT INTO Client VALUES (
	'129', 'Giant Eagle', 'Market Road', 'Pittsburgh', 'PA', '15982', 
	'Groceries', 'www.gianteagle.com', '412-912-2352', 'Gregory Louis'
);

INSERT INTO Client VALUES (
	'130', 'Target', 'Newell Road', 'New York', 'NY', '15002', 
	'Consumer Goods', 'www.target.com', '212-192-8713', 'Thomas Parker'
);

INSERT INTO Client VALUES (
	'131', 'Kate Spade', 'Michigan Road', 'New York', 'NY', '71234', 
	'Fashion', 'www.katespade.com', '812-019-7210', 'Peter Kilgrave'
);

INSERT INTO Client VALUES (
	'132', 'Couch', 'Michigan Road', 'New York', 'NY', '71234', 
	'Fashion', 'www.couch.com', '812-812-7012', 'Gavin Nelson'
);

-- Department
INSERT INTO Department (Dept_Code, Name, Location, Phone) VALUES ('110', 'Technology', 'Level 3', '412-902-1000');
INSERT INTO Department (Dept_Code, Name, Location, Phone) VALUES ('111', 'Marketing', 'Level 2', '412-902-1001');
INSERT INTO Department (Dept_Code, Name, Location, Phone) VALUES ('112', 'Operations', 'Level 3', '412-902-1005');
INSERT INTO Department (Dept_Code, Name, Location, Phone) VALUES ('113', 'Research', 'Level 3', '412-902-1007');

-- Employee
INSERT INTO Employee VALUES ('110', 'James', 'Peter', DATE '1988-10-21', DATE '2010-01-02', NULL, '110');
INSERT INTO Employee VALUES ('111', 'Ted', 'Mosby', DATE '1989-12-23', DATE '2012-07-12', NULL, '111');
INSERT INTO Employee VALUES ('112', 'Sheldon', 'Cooper', DATE '1972-02-23', DATE '2012-11-22', NULL, '112');
INSERT INTO Employee VALUES ('113', 'Leonard', 'Hofstede', DATE '1986-09-05', DATE '2012-07-12', NULL, '113');

INSERT INTO Employee VALUES ('114', 'Penny', 'Cucoo', DATE '1989-03-12', DATE '2014-07-02', '110', '110');
INSERT INTO Employee VALUES ('115', 'Barney', 'Stinson', DATE '1991-06-09', DATE '2014-01-18', '110', '110');
INSERT INTO Employee VALUES ('117', 'Edward', 'Cullen', DATE '1987-07-09', DATE '2014-11-07', '113', '113');

INSERT INTO Employee VALUES ('116', 'Marshall', 'Erikson', DATE '1992-11-13', DATE '2012-02-12', '112', '112');
INSERT INTO Employee VALUES ('118', 'Brenda', 'Lee', DATE '1965-08-12', DATE '2015-12-27', '111', '111');
INSERT INTO Employee VALUES ('119', 'Lily', 'Adams', DATE '1988-06-07', DATE '2015-09-23', '111', '111');

-- Training
INSERT INTO Training VALUES ('100', '100', '114', DATE '2015-07-23', 'Java Training Workshop I', 'Completed with Distinction grade.');
INSERT INTO Training VALUES ('101', '100', '115', DATE '2015-08-12', 'Java Training Workshop II', 'Completed with Merit grade.');
INSERT INTO Training VALUES ('102', '100', '115', DATE '2015-02-05', 'Java Training Workshop III', 'Completed with Distinction grade.');
INSERT INTO Training VALUES ('103', '101', '118', DATE '2015-04-01', 'Marketing Conference', '3 Day conference in San Francisco');
INSERT INTO Training VALUES ('104', '101', '119', DATE '2015-08-01', 'Marketing Workshop', 'Conducted by Market Me Co.');
INSERT INTO Training VALUES ('105', '102', '118', DATE '2015-10-11', 'C# Training I', 'Approved by HR.');
INSERT INTO Training VALUES ('106', '102', '114', DATE '2015-11-02', 'C# Training II', 'Course recevived good evaluation.');
INSERT INTO Training VALUES ('107', '102', '111', DATE '2015-01-03', 'C# Training III', 'Course covered good details.');
INSERT INTO Training VALUES ('108', '103', '110', DATE '2015-09-23', 'SQL Training I', 'Difficult course.');
INSERT INTO Training VALUES ('110', '101', '119', DATE '2015-05-27', 'Marketing Workshop II', 'More useful than workshop I.');

-- Project
INSERT INTO Project VALUES ('110', 'Marketing Project 1', DATE '2014-01-01', 1000, '111', '123');
INSERT INTO Project VALUES ('111', 'Technology Project 1', DATE '2015-04-13', 5000, '110', '124');
INSERT INTO Project VALUES ('112', 'Process Improvmenet', DATE '2014-02-16', 1500, '110', '123');
INSERT INTO Project VALUES ('113', 'Improving Service Response Time', DATE '2015-08-23', NULL, '112', '126');
INSERT INTO Project VALUES ('114', 'Manufacturing Project', DATE '2014-02-12', NULL, '112', '128');
INSERT INTO Project VALUES ('115', 'Supply Chain Project', DATE '2014-09-15', 200, '112', '125');
INSERT INTO Project VALUES ('116', 'Delivery Reliability Improvment', DATE '2015-03-12', 500, '112', '126');
INSERT INTO Project VALUES ('117', 'ERP Implementation', DATE '2015-10-22', 700, '110', '129');
INSERT INTO Project VALUES ('118', 'Database Consulting', DATE '2014-08-09', NULL, '110', '130');
INSERT INTO Project VALUES ('119', 'Software Design', DATE '2015-01-15', 9000, '110', '128');
INSERT INTO Project VALUES ('120', 'ECommerce Consulting', DATE '2014-07-17', NULL, '110', '132');

-- Assignment	
-- Completed project worked continuously for more than 40 hours with no gap
INSERT INTO Assignment VALUES ('110', '110', '118', DATE '2014-01-01', DATE '2014-01-31', 20);
INSERT INTO Assignment VALUES ('111', '110', '118', DATE '2014-02-01', DATE '2014-02-29', 30);
-- Completed Worked continuously for less than 40 hours with no gap
INSERT INTO Assignment VALUES ('112', '110', '119', DATE '2014-01-01', DATE '2014-01-31', 10);
INSERT INTO Assignment VALUES ('113', '110', '119', DATE '2014-02-01', DATE '2014-02-28', 20);

-- Ongoing discontinuous 
INSERT INTO Assignment VALUES ('114', '120', '110', DATE '2014-07-01', DATE '2014-07-31', 20);
INSERT INTO Assignment VALUES ('115', '120', '115', DATE '2014-10-01', DATE '2014-10-31', 20);

-- Ongoing project
INSERT INTO Assignment VALUES ('116', '118', '110', DATE '2015-08-01', DATE '2015-08-31', 50);
INSERT INTO Assignment VALUES ('119', '113', '116', DATE '2015-08-01', DATE '2015-08-30', 22);
INSERT INTO Assignment VALUES ('120', '114', '112', DATE '2014-02-01', DATE '2014-02-28', 21);

-- Completed discontinuous 
INSERT INTO Assignment VALUES ('117', '112', '116', DATE '2014-02-01', DATE '2014-02-28', 20);
INSERT INTO Assignment VALUES ('118', '112', '116', DATE '2014-06-01', DATE '2014-06-30', 20);

INSERT INTO Assignment VALUES ('121', '115', '112', DATE '2014-09-01', DATE '2014-09-30', 25);
INSERT INTO Assignment VALUES ('122', '116', '116', DATE '2015-03-01', DATE '2015-03-31', 34);
INSERT INTO Assignment VALUES ('123', '117', '115', DATE '2015-10-01', DATE '2015-10-31', 26);
INSERT INTO Assignment VALUES ('124', '119', '110', DATE '2015-01-01', DATE '2015-01-31', 72);

commit;