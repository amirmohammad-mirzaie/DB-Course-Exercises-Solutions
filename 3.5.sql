CREATE TABLE Employee (
    person_name VARCHAR(50) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

CREATE TABLE Works (
    person_name VARCHAR(50) PRIMARY KEY,
    company_name VARCHAR(50),
    salary DECIMAL(10, 2),
    FOREIGN KEY (person_name) REFERENCES Employee(person_name),
    FOREIGN KEY (company_name) REFERENCES Company(company_name)
);

CREATE TABLE Manages (
    person_name VARCHAR(50) PRIMARY KEY,
    manager_name VARCHAR(50),
    FOREIGN KEY (person_name) REFERENCES Employee(person_name),
    FOREIGN KEY (manager_name) REFERENCES Employee(person_name)
);

INSERT INTO Employee (person_name, street, city) VALUES ('Ali', 'Tehran St', 'Tehran');
INSERT INTO Employee (person_name, street, city) VALUES ('Reza', 'Mashhad Ave', 'Mashhad');
INSERT INTO Employee (person_name, street, city) VALUES ('Maryam', 'Isfahan Blvd', 'Isfahan');
INSERT INTO Employee (person_name, street, city) VALUES ('Hossein', 'Tehran St', 'Tehran');
INSERT INTO Employee (person_name, street, city) VALUES ('Sara', 'Shiraz St', 'Shiraz');
INSERT INTO Employee (person_name, street, city) VALUES ('Mohammad', 'Tehran St', 'Tehran');
INSERT INTO Employee (person_name, street, city) VALUES ('Narges', 'Mashhad Ave', 'Mashhad');
INSERT INTO Employee (person_name, street, city) VALUES ('Ali Reza', 'Isfahan Blvd', 'Isfahan');
INSERT INTO Employee (person_name, street, city) VALUES ('Farhad', 'Tehran St', 'Tehran');
INSERT INTO Employee (person_name, street, city) VALUES ('Leila', 'Shiraz St', 'Shiraz');

INSERT INTO Company (company_name, city) VALUES ('Iranian', 'Tehran');
INSERT INTO Company (company_name, city) VALUES ('Pars', 'Mashhad');
INSERT INTO Company (company_name, city) VALUES ('Saba', 'Isfahan');
INSERT INTO Company (company_name, city) VALUES ('Aria', 'Shiraz');

INSERT INTO Works (person_name, company_name, salary) VALUES ('Ali', 'Iranian', 120000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Reza', 'Pars', 90000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Maryam', 'Saba', 110000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Hossein', 'Iranian', 130000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Sara', 'Aria', 85000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Mohammad', 'Iranian', 140000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Narges', 'Pars', 95000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Ali Reza', 'Saba', 105000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Farhad', 'Iranian', 150000);
INSERT INTO Works (person_name, company_name, salary) VALUES ('Leila', 'Aria', 80000);

INSERT INTO Manages (person_name, manager_name) VALUES ('Ali', 'Hossein');
INSERT INTO Manages (person_name, manager_name) VALUES ('Reza', 'Hossein');
INSERT INTO Manages (person_name, manager_name) VALUES ('Maryam', 'Mohammad');
INSERT INTO Manages (person_name, manager_name) VALUES ('Hossein', 'Mohammad');
INSERT INTO Manages (person_name, manager_name) VALUES ('Sara', 'Ali Reza');
INSERT INTO Manages (person_name, manager_name) VALUES ('Mohammad', 'Farhad');
INSERT INTO Manages (person_name, manager_name) VALUES ('Narges', 'Ali Reza');
INSERT INTO Manages (person_name, manager_name) VALUES ('Ali Reza', 'Farhad');
INSERT INTO Manages (person_name, manager_name) VALUES ('Leila', 'Ali Reza');


--- 3.5.a -----
-- query 1 -- using WHERE after the joining
SELECT 
    e.person_name,
    e.street,
    e.city,
    w.salary
FROM employee e
JOIN works w ON w.person_name = e.person_name
WHERE w.company_name = 'FutureTech' AND w.salary > 76000;
-- query 2 -- using conditions inside the JOIN operation which is better in performance

SELECT 
    e.person_name,
    e.street,
    e.city,
    w.salary,
    w.company_name
FROM employee e
JOIN works w ON (w.person_name = e.person_name AND w.salary > 76000 AND w.company_name = 'FutureTech');

----- 3.5.b ------
-- query 1 -- using conditions inside the JOIN --> better in performance
SELECT 
    e.person_name,
    e.street,
    e.city,
    c.city AS company_city,
    w.salary,
    w.company_name
FROM employee e
JOIN works w ON (w.person_name = e.person_name)
JOIN company c ON (w.company_name = c.company_name AND c.city = e.city);

-- query 2 -- using WHERE clause after joining
SELECT 
    e.person_name,
    e.street,
    e.city,
    c.city AS company_city,
    w.salary,
    w.company_name
FROM employee e
JOIN works w ON (w.person_name = e.person_name)
JOIN company c ON (w.company_name = c.company_name)
WHERE c.city = e.city;

-- 3.5.c --

SELECT
    e.person_name AS name,
    e.city AS city,
    e.street AS street
FROM employee e
JOIN manages m ON e.person_name = m.person_name
JOIN employee em ON (m.manager_name = em.person_name AND e.city = em.city AND e.street = em.street);


-- 3.5.d --
 -- 1st algorithm --
SELECT
    *
FROM employee e
JOIN works w ON (e.person_name = w.person_name AND w.company_name != 'Iranian');

-- 2nd algorithm --
SELECT
    *
FROM employee e
JOIN (
    SELECT * FROM works w WHERE w.company_name != 'Iranian'
) AS filtered_w ON e.person_name = filtered_w.person_name;


-- 3rd algorithm --
SELECT *
FROM employee e
WHERE NOT EXISTS (
    SELECT 1
    FROM works w
    WHERE w.person_name = e.person_name AND w.company_name = 'Iranian'
);
