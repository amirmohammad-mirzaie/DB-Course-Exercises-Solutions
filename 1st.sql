
CREATE TABLE departments(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),
)

CREATE TABLE people(
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
    person_id INT REFERENCES people(id),
    study_level_id INT REFERENCES study_levels(id),
    department_id INT REFERENCES departments(id),
    UNIQUE (study_level_id, department_id)
)

-------------------------
-- TA related tables ----
-------------------------

CREATE TABLE assistant_jobs(
    id SERIAL PRIMARY KEY,
    is_ta BOOLEAN,
    name VARCHAR(128),
    salary FLOAT,
)


CREATE TABLE assistants (
    id SERIAL PRIMARY KEY,
    person_id INT REFERENCES people(id),
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
    person_id INT REFERENCES people(id),
    level_id INT REFERENCES professor_levels(id)
)


-------------------------
-- Graduated students related tables ----
-------------------------
CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    person_id INT REFERENCES people(id),
    name VARCHAR(128) UNIQUE,
    department_id INT REFERENCES departments(id),
    UNIQUE (person_id, name, department_id)
    
)
CREATE TABLE graduates (
    person_id INT REFERENCES people(id),
    certificate_id INT REFERENCES certificates(id),
    UNIQUE (person_id, certificate_id)
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
    person_id INT REFERENCES people(id),
    job_id INT REFERENCES job_titles(id),
    UNIQUE (person_id, job_id)
)
