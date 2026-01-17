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


-- Insert data into Employee table
INSERT INTO Employee (person_name, street, city) VALUES
('Alice Johnson', '123 Main St', 'New York'),
('Bob Smith', '456 Oak Ave', 'Los Angeles'),
('Carol Davis', '789 Pine Rd', 'Chicago'),
('David Wilson', '321 Elm St', 'Houston'),
('Eve Brown', '654 Maple Dr', 'Phoenix');

-- Insert data into Company table
INSERT INTO Company (company_name, city) VALUES
('TechCorp', 'New York'),
('Innovate Inc.', 'Los Angeles'),
('Global Solutions', 'Chicago'),
('FutureTech', 'Houston'),
('DataWorks', 'Phoenix');

-- Insert data into Works table
INSERT INTO Works (person_name, company_name, salary) VALUES
('Alice Johnson', 'TechCorp', 85000.00),
('Bob Smith', 'Innovate Inc.', 75000.00),
('Carol Davis', 'Global Solutions', 90000.00),
('David Wilson', 'FutureTech', 80000.00),
('Eve Brown', 'DataWorks', 78000.00);

-- Insert data into Manages table
INSERT INTO Manages (person_name, manager_name) VALUES
('Alice Johnson', 'Bob Smith'),
('Bob Smith', 'Carol Davis'),
('Carol Davis', 'David Wilson'),
('David Wilson', 'Eve Brown'),
('Eve Brown', 'Alice Johnson');

--- 3.5.a -----
SELECT 
    e.person_name,
    e.street,
    e.city,
    w.salary
FROM employee e
LEFT JOIN works w ON w.person_name = e.person_name
LEFT JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'FutureTech' AND w.salary > 76000;

SELECT 
    e.person_name,
    e.street,
    e.city,
    w.salary,
    w.company_name
FROM employee e
JOIN works w ON (w.person_name = e.person_name AND w.salary > 76000 AND w.company_name = 'FutureTech');