
CREATE TABLE departments(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),
)

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(64),
    id_card_number VARCHAR(64) UNIQUE,
    sex_type BOOLEAN,
    date_born TIMESTAMP,
    address VARCHAR(1024),
    
)

-------------------------
-- Students related tables ----
-------------------------
CREATE TABLE study_levels(
    id SERIAL PRIMARY KEY,
    level_name VARCHAR(64)
);

CREATE TABLE students (
    user_id INT REFERENCES users(id),
    study_level_id INT REFERENCES study_levels(id),
    department_id INT REFERENCES departments(id),
    UNIQUE (study_level_id, department_id)
)

-------------------------
-- TA related tables ----
-------------------------

CREATE TABLE tas (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(user_id),
    ta_type VARCHAR(64) CHECK (ta_type IN ('Research Assistant', 'Teaching Assistant')),
    project_title VARCHAR(256),
    course_title VARCHAR(256),

    CHECK(
        (ta_type = 'Research Assistant' AND project_title IS NOT NULL) OR
        (ta_type = 'Teaching Assistant' AND course_title IS NOT NULL)
    )
)


CREATE TABLE assistant_jobs(
    id SERIAL PRIMARY KEY,
    is_ta BOOLEAN,
    name VARCHAR(128),
    salary FLOAT,
)


CREATE TABLE assistants (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    job_id INT REFERENCES assistant_jobs(id)
)


-------------------------
-- Professors related tables ----
-------------------------
CREATE TABLE professor_levels (
    id SERIAL PRIMARY KEY,
    level_name VARCHAR(64),
    salary FLOAT,
);

CREATE TABLE professors (
    user_id INT REFERENCES users(id),
    level_id INT REFERENCES professor_levels(id)
)


-------------------------
-- Graduated students related tables ----
-------------------------
CREATE TABLE degrees (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    name VARCHAR(128) UNIQUE,
    department_id INT REFERENCES departments(id),
    UNIQUE (user_id, name, department_id)
    
)
CREATE TABLE graduates (
    user_id INT REFERENCES users(id),
    certificate_id INT REFERENCES degrees(id),
    UNIQUE (user_id, certificate_id)
)

-------------------------
-- employee related tables ----
-------------------------
CREATE TABLE job_titles(
    id SERIAL PRIMARY KEY,
    name VARCHAR(64),
    salary FLOAT,
);

CREATE TABLE employees (
    user_id INT REFERENCES users(id),
    job_id INT REFERENCES job_titles(id),
    UNIQUE (user_id, job_id)
)
