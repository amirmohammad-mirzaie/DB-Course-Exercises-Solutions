
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

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    student_id CHAR(10) UNIQUE
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

CREATE TABLE teaching_assistants (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id),
    UNIQUE(employee_id, student_id, course_id)
)

CREATE TABLE research_assistants (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    student_id INT REFERENCES students(id),
    professor_id INT REFERENCES professors(id),
    research_topic VARCHAR(256),
    UNIQUE(employee_id, student_id, professor_id)
)


CREATE TABLE graduates (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
)

CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    date_received DATE,
    department_id INT REFERENCES departments(id),
    graduate_id INT REFERENCES graduates(id),
    UNIQUE(graduate_id, department_id)
)