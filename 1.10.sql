
CREATE TABLE departments(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),
)

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(64),
    id_card_number VARCHAR(64) UNIQUE,
    gender BOOLEAN,
    date_born TIMESTAMP,
    address VARCHAR(1024),
    
)

-------------------------
-- Students related tables ----
-------------------------

CREATE TABLE degrees (
    id SERIAL PRIMARY KEY,
    study_level VARCHAR(64),
    degree_name VARCHAR(128),
    department_id INT REFERENCES departments(id),
    UNIQUE (study_level, department_id),
    UNIQUE (degree_name, department_id)
    
)

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    degree_id INT REFERENCES degrees(id),
    status VARCHAR(32) CHECK (status IN ('active', 'graduated', 'withdrawn', 'transferred')) DEFAULT 'active',
    UNIQUE (user_id, degree_id)
)

-------------------------
-- Graduated students related tables ----
-------------------------
CREATE TABLE graduates (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id),
    degree_id INT REFERENCES degrees(id),
)


CREATE TABLE graduates_degrees (
    graduate_id INT REFERENCES graduates(id),
    degree_id INT REFERENCES degrees(id),
    graduation_date TIMESTAMP,
    PRIMARY KEY (graduate_id, degree_id)
)

-------------------------
-- TA related tables ----
-------------------------

CREATE TABLE teaching_assistants (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id),
    course_title VARCHAR(256) NOT NULL
)


CREATE TABLE research_assistants (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id),
    project_title VARCHAR(256) NOT NULL
)



-------------------------
-- Employees related tables ----
-------------------------
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) UNIQUE,
    salary FLOAT,
    employee_type VARCHAR(64) CHECK (employee_type IN ('professor', 'staff'))
)


-------------------------
-- Professors related tables ----
-------------------------
CREATE TABLE professor_levels (
    id SERIAL PRIMARY KEY,
    level_name VARCHAR(64)
);

CREATE TABLE professors (
    id INT SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    level_id INT REFERENCES professor_levels(id)
)


-------------------------
-- staff related tables ----
-------------------------
CREATE TABLE job_titles(
    id SERIAL PRIMARY KEY,
    job_name VARCHAR(64)
);

CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    job_id INT REFERENCES job_titles(id)
)
