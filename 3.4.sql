CREATE TABLE Student (
    snum INT PRIMARY KEY,
    sname VARCHAR(255),
    major VARCHAR(255),
    level VARCHAR(50),
    age INT
);

CREATE TABLE Faculty (
    fid INTEGER PRIMARY KEY,
    fname VARCHAR(255),
    deptid INTEGER
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


INSERT INTO Faculty (fid, fname, deptid) VALUES
(101, 'Dr. Alice Johnson', 201),
(102, 'Prof. Bob Smith', 202),
(103, 'Dr. Carol White', 201),
(104, 'Prof. David Lee', 203);


INSERT INTO Faculty (fid, fname, deptid) VALUES
(105, 'Dr. James Johnson', 202);


INSERT INTO Faculty (fid, fname, deptid) VALUES
(106, 'Dr. Bob Johnson', 202);


INSERT INTO Class (name, meets_at, room, fid) VALUES
('CS101', '09:00:00', 'A101', 101),
('MATH205', '10:30:00', 'B202', 102),
('PHYS102', '14:00:00', 'C303', 103),
('ENG301', '11:00:00', 'D404', 104);


INSERT INTO Class (name, meets_at, room, fid) VALUES
('CS102', '16:00:00', 'A102', 101);


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

-- 3.4.1 ----
-- sql query ---
SELECT * FROM
(
    SELECT
        COUNT(snum) AS n_students,
        cname
    FROM enrolled
    GROUP BY cname
)
WHERE n_students < 5 OR n_students > 30;

--- trigger ---     
CREATE OR REPLACE FUNCTION n_students_not_more_than_30()
RETURNS TRIGGER AS $$
DECLARE 
    n_students INT;
BEGIN

    SELECT 
        COUNT(*) INTO n_students
    FROM enrolled
    WHERE cname = NEW.cname;

    IF n_students > 30 THEN
        RAISE EXCEPTION 'class is full';
    END IF

    RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER trg_n_students_not_more_than_30
BEFORE INSERT OR UPDATE ON enrolled
FOR EACH ROW
EXECUTE FUNCTION n_students_not_more_than_30();

----- 3.4.2 ---------------
---- sql query ------------
SELECT
    f.fid AS faculty_id,
    COUNT(c.name) AS no_of_courses

FROM faculty f
LEFT JOIN class c ON f.fid = c.fid
GROUP BY f.fid
HAVING COUNT(c.name) < 2;

----- 3.4.3 ---------------
---- sql query ------------

----- 3.4.4 ---------------
---- sql query ------------

----- 3.4.5 ---------------
---- sql query ------------
CREATE OR REPLACE FUNCTION no_overlap_class_locations()
RETURNS TRIGGER AS $$
DECLARE 
    n_classes_in_the_same_room INT;
    new_dept_id INT;
BEGIN
    
    SELECT deptid INTO new_dept_id
    FROM faculty 
    WHERE fid = NEW.fid;

    SELECT COUNT(*) INTO n_classes_in_the_same_room
    FROM class c
    WHERE NEW.meets_at = c.meets_at AND c.deptid = new_dept_id AND NEW.room = c.room AND c.name != NEW.name;

    IF n_classes_in_the_same_room > 0 THEN
        RAISE EXCEPTION 'class is already taken';
    END IF;

    RETURN NEW;
END;
$$LANGUAGE plpgsql;


CREATE TRIGGER trg_no_overlap_class_locations
BEFORE INSERT OR UPDATE ON class
FOR EACH ROW
EXECUTE FUNCTION no_overlap_class_locations();
