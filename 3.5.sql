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


-- Insert additional data into Employee table
INSERT INTO Employee (person_name, street, city) VALUES
('Frank Miller', '101 Birch Ln', 'Seattle'),
('Grace Lee', '202 Cedar St', 'San Francisco'),
('Henry Kim', '303 Willow Ave', 'Denver'),
('Ivy Patel', '404 Jasmine Rd', 'Miami'),
('Jack Thompson', '505 Rose Dr', 'Atlanta'),
('James James', '102 Repository Avenue', 'California');

-- Insert additional data into Company table
INSERT INTO Company (company_name, city) VALUES
('CloudNet', 'Seattle'),
('SmartSystems', 'San Francisco'),
('NextGen Corp', 'Denver'),
('UrbanTech', 'Miami'),
('Alpha Solutions', 'Atlanta');

-- Insert additional data into Works table
INSERT INTO Works (person_name, company_name, salary) VALUES
('Frank Miller', 'CloudNet', 72000.00),
('Grace Lee', 'SmartSystems', 88000.00),
('Henry Kim', 'NextGen Corp', 76000.00),
('Ivy Patel', 'UrbanTech', 83000.00),
('Jack Thompson', 'Alpha Solutions', 79000.00);

-- Insert additional data into Manages table
INSERT INTO Manages (person_name, manager_name) VALUES
('Frank Miller', 'Grace Lee'),
('Grace Lee', 'Henry Kim'),
('Henry Kim', 'Ivy Patel'),
('Ivy Patel', 'Jack Thompson'),
('Jack Thompson', 'Frank Miller');

-- Insert more employees into Employee table
INSERT INTO Employee (person_name, street, city) VALUES
('Lena Chen', '606 Oak Hill Dr', 'Seattle'),
('Miles Reed', '707 Pine Valley Rd', 'San Francisco'),
('Nina Patel', '808 Maple Grove St', 'Denver'),
('Oscar Diaz', '909 Cedar Lane', 'Miami'),
('Pamela Young', '1010 Willow Creek Ave', 'Atlanta'),
('Quinn Taylor', '1111 Birchwood Dr', 'New York'),
('Riley Foster', '1212 Elm Street', 'Los Angeles'),
('Sophie Kim', '1313 Rosewood Ave', 'Chicago'),
('Trevor Lee', '1414 Jasmine Lane', 'Houston'),
('Uma Singh', '1515 Pine Ridge Dr', 'Phoenix');

-- Insert more data into Works table (assigning employees to existing companies)
INSERT INTO Works (person_name, company_name, salary) VALUES
('Lena Chen', 'CloudNet', 74000.00),
('Miles Reed', 'SmartSystems', 86000.00),
('Nina Patel', 'NextGen Corp', 77000.00),
('Oscar Diaz', 'UrbanTech', 81000.00),
('Pamela Young', 'Alpha Solutions', 75000.00),
('Quinn Taylor', 'TechCorp', 82000.00),
('Riley Foster', 'Innovate Inc.', 73000.00),
('Sophie Kim', 'Global Solutions', 89000.00),
('Trevor Lee', 'FutureTech', 78000.00),
('Uma Singh', 'DataWorks', 84000.00);

-- Insert more data into Manages table (establishing management relationships among new employees)
INSERT INTO Manages (person_name, manager_name) VALUES
('Lena Chen', 'Frank Miller'),
('Miles Reed', 'Grace Lee'),
('Nina Patel', 'Henry Kim'),
('Oscar Diaz', 'Ivy Patel'),
('Pamela Young', 'Jack Thompson'),
('Quinn Taylor', 'Alice Johnson'),
('Riley Foster', 'Bob Smith'),
('Sophie Kim', 'Carol Davis'),
('Trevor Lee', 'David Wilson'),
('Uma Singh', 'Eve Brown');





-- Insert more employees into Employee table
INSERT INTO Employee (person_name, street, city) VALUES
('Zara White', '1616 Sunset Blvd', 'Seattle'),
('Ben Carter', '1717 River Dr', 'San Francisco'),
('Chloe Evans', '1818 Oak Hill Ave', 'Denver'),
('Derek Moore', '1919 Pine Street', 'Miami'),
('Elena Reed', '2020 Maple Lane', 'Atlanta');

-- Insert more data into Works table (assigning employees to Alpha Solutions and CloudNet)
INSERT INTO Works (person_name, company_name, salary) VALUES
('Zara White', 'CloudNet', 76000.00),
('Ben Carter', 'SmartSystems', 87000.00),
('Chloe Evans', 'NextGen Corp', 79000.00),
('Derek Moore', 'UrbanTech', 82000.00),
('Elena Reed', 'Alpha Solutions', 77000.00);

-- Insert more data into Manages table (establishing management relationships for new employees)
INSERT INTO Manages (person_name, manager_name) VALUES
('Zara White', 'Lena Chen'),
('Ben Carter', 'Miles Reed'),
('Chloe Evans', 'Nina Patel'),
('Derek Moore', 'Oscar Diaz'),
('Elena Reed', 'Pamela Young');
--- 3.5.a -----
SELECT 
    e.person_name,
    e.street,
    e.city,
    w.salary
FROM employee e
LEFT JOIN works w ON w.person_name = e.person_name
LEFT JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'Alpha Solutions' AND w.salary > 76000;



SELECT 
    e.person_name,
    e.street,
    e.city,
    w.salary
FROM employee e
LEFT JOIN works w ON w.person_name = e.person_name
LEFT JOIN company c ON w.company_name = c.company_name
GROUP BY c.company_name, e.person_name, e.street, e.city, w.salary
HAVING c.company_name = 'Alpha Solutions' AND w.salary > 76000;
