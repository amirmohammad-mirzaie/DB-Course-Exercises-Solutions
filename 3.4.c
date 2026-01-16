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