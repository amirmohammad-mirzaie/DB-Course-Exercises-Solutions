
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE
)


CREATE TABLE divisions (
    id SERIAL PRIMARY KEY,
    division_name INT UNIQUE,
    department_id INT REFERENCES departments(id)
)

CREATE TABLE beds (
    id SERIAL PRIMARY KEY,
    division_id INT REFERENCES divisions(id)
)

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE
)


CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_id CHAR(10) UNIQUE,
    name VARCHAR(128),
    department_id INT REFERENCES departments(id) -- this is intentionally added since it also can be fetched from the corresponding bed
    division_id INT REFERENCES divisions(id), -- this is intentionally added since it also can be fetched from the corresponding bed
    bed_id INT REFERENCES beds(id)
)

CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    medicine_no INT,
    name VARCHAR(16),
    description VARCHAR(128)

    )

CREATE TABLE admissions (
    medicine_id INT REFERENCES medicines(id),
    dosage VARCHAR(64),
    usage_type VARCHAR(8) CHECK (usage_type IN ('mouth', 'muscle'))
    n_daily_usage INT,
    start_date DATE,
    end_date DATE
)


