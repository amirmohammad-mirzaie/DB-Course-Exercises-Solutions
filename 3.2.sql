
CREATE TABLE Employee (
    Ssn CHAR(12) PRIMARY KEY,
    fname VARCHAR(128),
    lname VARCHAR(128),
    Bdate TIMESTAMP,
    Address VARCHAR(256),
    Gender VARCHAR CHECK (Gender In ('male', 'female')),
    salary NUMERIC(15,2),
    Super_ssn CHAR(12) REFERENCES Employee(Ssn) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Department (
    Dno CHAR(12) PRIMARY KEY,
    Dname VARCHAR(128) NOT NULL,
    manager_ssn CHAR(12) REFERENCES Employee(Ssn) ON DELETE SET NULL ON UPDATE CASCADE,
    manager_start_date TIMESTAMP NOT NULL
);

ALTER TABLE Employee ADD COLUMN Dno CHAR(12) NOT NULL REFERENCES Department(Dno);

CREATE TABLE Dept_locations (
    Dno CHAR(12) REFERENCES Department(Dno),
    Dlocation VARCHAR(256) NOT NULL,
    PRIMARY KEY (Dno, Dlocation)
);

CREATE TABLE Project (
    Pnumber CHAR(12) PRIMARY KEY,
    Pname VARCHAR(128) NOT NULL,
    Plocation VARCHAR(128),
    Dno CHAR(12) NOT NULL REFERENCES Department(Dno)
);

CREATE TABLE Works_on (
    Employee_ssn CHAR(12) REFERENCES Employee(Ssn),
    Pnumber CHAR(12) REFERENCES Project(Pnumber),
    hours NUMERIC(5,2),
    PRIMARY KEY (Employee_ssn, Pnumber)
);

CREATE TABLE Dependent (
    Essn CHAR(12) REFERENCES Employee(Ssn),
    Dependent_name VARCHAR(128) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('male', 'female')),
    Bdate TIMESTAMP,
    Relationship VARCHAR(128) CHECK (Relationship IN ('spouse', 'child', 'parent', 'sibling', 'other')),
    PRIMARY KEY (Essn, Dependent_name)
);

CREATE INDEX idx_project_Dno ON Project(Dno);
CREATE INDEX idx_department_manager_ssn ON Department(manager_ssn);
CREATE INDEX idx_employee_super_ssn ON Employee(Super_ssn);
CREATE INDEX idx_employee_dno ON Employee(Dno);


-- data ---

-- Insert Department data
INSERT INTO Department (Dno, Dname, manager_ssn, manager_start_date) VALUES
('1', 'Human Resources', NULL, '1399-01-01'),
('4', 'Engineering', NULL, '1398-03-15'),
('5', 'Marketing', NULL, '1397-07-20');


-- Insert Employee data
INSERT INTO Employee (Ssn, fname, lname, Bdate, Address, Gender, salary, Super_ssn, Dno) VALUES
('1', 'Reza', 'Kamali', '1360-12-23', 'Tehran', 'male', 1000000, '10', '5'),
('10', 'Hasan', 'Moradi', '1355-01-25', 'Tehran', 'male', 1500000, '15', '5'),
('5', 'Zahra', 'Askari', '1365-07-07', 'Tehran', 'female', 1000000, '20', '4'),
('20', 'Ali', 'Ahmadi', '1345-04-20', 'Tehran', 'male', 2000000, NULL, '4'),
('12', 'Fatemeh', 'Alavi', '1359-05-31', 'Tehran', 'female', 1200000, '10', '5'),
('15', 'Mohammad', 'Mohammadi', '1340-06-13', 'Tehran', 'male', 2500000, NULL, '5'),
('13', 'Vali', 'Zareh', '1368-02-02', 'Tehran', 'male', 1000000, '20', '4'),
('16', 'Maryam', 'Donyavi', '1365-05-20', 'Tehran', 'female', 1500000, NULL, '1');

UPDATE Department SET manager_ssn = '16' WHERE Dno = '1';
UPDATE Department SET manager_ssn = '20' WHERE Dno = '4';
UPDATE Department SET manager_ssn = '10' WHERE Dno = '5';



-- Insert Project data
INSERT INTO Project (Pnumber, Pname, Plocation, Dno) VALUES
('P1', 'Website Redesign', 'Tehran', '5'),
('P2', 'Mobile App Development', 'Tehran', '4'),
('P3', 'HR System Upgrade', 'Tehran', '1'),
('P4', 'Data Analytics Platform', 'Tehran', '4');

-- Insert Dept_locations data
INSERT INTO Dept_locations (Dno, Dlocation) VALUES
('1', 'Tehran, Azadi Street'),
('4', 'Tehran, Enqelab Street'),
('5', 'Tehran, Vali-e-Asr Avenue'),
('4', 'Shiraz, Shahid Bahonar Blvd');

-- Insert Works_on data
INSERT INTO Works_on (Employee_ssn, Pnumber, hours) VALUES
('1', 'P1', 10.5),
('10', 'P1', 20.0),
('5', 'P2', 15.0),
('20', 'P2', 30.0),
('12', 'P3', 12.0),
('15', 'P4', 25.0),
('13', 'P4', 18.0),
('16', 'P3', 8.0);

-- Insert data into Dependent table
INSERT INTO Dependent (Essn, Dependent_name, Gender, Bdate, Relationship) VALUES
('1', 'Sara Kamali', 'female', '1380-05-10', 'spouse'),
('1', 'Ali Kamali', 'male', '1395-08-15', 'child'),
('10', 'Narges Moradi', 'female', '1375-11-20', 'spouse'),
('10', 'Mehdi Moradi', 'male', '1390-03-05', 'child'),
('20', 'Leila Ahmadi', 'female', '1370-09-12', 'spouse'),
('20', 'Sina Ahmadi', 'male', '1392-01-30', 'child'),
('16', 'Hossein Donyavi', 'male', '1378-07-01', 'spouse'),
('16', 'Neda Donyavi', 'female', '1398-12-25', 'child');

---------------------------------------------------------------------------
-------------------------- regarding answering questions ------------------
---------------------------------------------------------------------------


-- گراف ارجاع -----




-------------------------
--- creating views -----
------------------------


-- i----

DROP VIEW IF EXISTS departent_manger_info;
CREATE VIEW departent_manger_info AS
SELECT 
    dep.dno,
    dep.dname,
    dep.manager_ssn,
    CONCAT(manager.fname, ' ', manager.lname) AS full_name,
    manager.salary

FROM department dep
LEFT JOIN employee manager ON dep.manager_ssn = manager.ssn;

-- ii --
DROP VIEW IF EXISTS project_details;

-- query 1 --
CREATE VIEW project_details AS
SELECT 
    prj_dep.pnumber,
    prj_dep.pname,
    prj_dep.dno,
    wo.employee_ssn,
    wo.pnumber AS we_pnumber,
    wo.hours
FROM 
    (
        SELECT 
            p.pnumber,
            p.pname,
            d.dno

        FROM project p
        LEFT JOIN department d ON (p.dno = d.dno)
    ) AS prj_dep

LEFT JOIN works_on wo ON (wo.pnumber = prj_dep.pnumber);





-- query 2 --
DROP VIEW IF EXISTS project_details;

CREATE VIEW project_details AS
SELECT 
    p.pnumber,
    p.pname,
    dep.dno,
    wo.employee_ssn,
    wo.hours
FROM 
    project p
LEFT JOIN department dep ON p.dno = dep.dno
LEFT JOIN works_on wo ON (wo.pnumber = p.pnumber);