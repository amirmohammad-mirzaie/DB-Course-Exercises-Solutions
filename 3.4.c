CREATE TABLE Student (
    snum INT PRIMARY KEY,
    sname VARCHAR(255),
    major VARCHAR(255),
    level VARCHAR(50),
    age INT
);

CREATE TABLE Class (
    name VARCHAR(255) PRIMARY KEY,
    meets_at TIME,
    room VARCHAR(100),
    fid INT,
    FOREIGN KEY (fid) REFERENCES Faculty(fid)
);

CREATE TABLE Enrolled (
    snum INTEGER,
    cname VARCHAR(255),
    PRIMARY KEY (snum, cname),
    FOREIGN KEY (snum) REFERENCES Student(snum),
    FOREIGN KEY (cname) REFERENCES Class(name)
);

CREATE TABLE Faculty (
    fid INTEGER PRIMARY KEY,
    fname VARCHAR(255),
    deptid INTEGER
);


INSERT INTO Faculty (fid, fname, deptid) VALUES
(101, 'Dr. Alice Johnson', 201),
(102, 'Prof. Bob Smith', 202),
(103, 'Dr. Carol White', 201),
(104, 'Prof. David Lee', 203);

INSERT INTO Class (name, meets_at, room, fid) VALUES
('CS101', '09:00:00', 'A101', 101),
('MATH205', '10:30:00', 'B202', 102),
('PHYS102', '14:00:00', 'C303', 103),
('ENG301', '11:00:00', 'D404', 104);

INSERT INTO Student (snum, sname, major, level, age) VALUES
(1001, 'John Doe', 'Computer Science', 'Freshman', 18),
(1002, 'Jane Smith', 'Mathematics', 'Sophomore', 19),
(1003, 'Mike Brown', 'Physics', 'Junior', 20),
(1004, 'Lisa Wang', 'English', 'Senior', 21),
(1005, 'Tom Lee', 'Computer Science', 'Sophomore', 19);

INSERT INTO Enrolled (snum, cname) VALUES
(1001, 'CS101'),
(1001, 'MATH205'),
(1002, 'MATH205'),
(1002, 'PHYS102'),
(1003, 'PHYS102'),
(1003, 'ENG301'),
(1004, 'ENG301'),
(1005, 'CS101'),
(1005, 'ENG301');