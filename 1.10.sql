
CREATE TABLE departments(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE
)

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(64),
    id_card_number VARCHAR(64) UNIQUE,
    gender BOOLEAN,
    date_born TIMESTAMP,
    address VARCHAR(1024),
    
)

-- assuming a user can be student in different departments concurrently
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    department_id INT REFERENCES departments(id),
    level VARCHAR(8) CHECK (level IN ('bsc', 'msc', 'phd'))
    start_date DATE,
    end_date DATE,
    UNIQUE(user_id, department_id)
)


CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) UNIQUE,
    type VARCHAR(32) CHECK (type IN ('professor', 'staff', 'assistant')),
    salary NUMERIC(15,2)
)


CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id) UNIQUE,
    level VARCHAR(32) CHECK (level IN ('entry_professor', 'mid_professor', 'full_professor'))
)


CREATE TABLE staffs (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id) UNIQUE,
    job_title VARCHAR(64) NOT NULL,

)

CREATE TABLE courses(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),
    department_id INT REFERENCES departments(id) ON DELETE CASCADE,
    study_level VARCHAR(8) CHECK(study_level IN ('bsc', 'msc', 'phd')),
    instructor_id INT REFERENCES professors(id)
)
-- teaching assistants are TAs that teach courses to students
CREATE TABLE teaching_assistants (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id),
    UNIQUE(student_id, course_id)
)
-- research assistants are TAs who work with a professor on a research topic
CREATE TABLE research_assistants (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    student_id INT REFERENCES base_student(id),
    professor_id INT REFERENCES professors(id),
    research_topic VARCHAR(256),
    UNIQUE(employee_id, student_id, professor_id)
)


CREATE TABLE graduates (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id)
    date_received DATE,
    degree_name VARCHAR(128),
    department_id INT REFERENCES departments(id),
    graduate_id INT REFERENCES graduates(id),
    UNIQUE(user_id, department_id)
)