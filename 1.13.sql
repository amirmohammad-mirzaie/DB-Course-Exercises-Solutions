-- doctors related tables
CREATE TABLE specialties (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE,

)

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    doctor_number VARCHAR(128),
    name VARCHAR(128),
    specialty_id INT REFERENCES specialties(id),
    working_years INT
)

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_number VARCHAR(128) UNIQUE,
    name VARCHAR(128),
    type VARCHAR(64) CHECK (type IN ('surgery', 'medical'))
    
)

-- admission to the hospital

CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_number VARCHAR(128) UNIQUE,
    doctor_id INT REFERENCES doctors(id),
    name VARCHAR(128),
    age INT,
    sex_type VARCHAR(16) CHECK (sex_type IN ('male', 'female'))
    date_of_birth TIMESTAMP,
    department_id INT REFERENCES departments(id)
    address VARCHAR(256)
)


CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    admission_number VARCHAR(128),
    admission_date TIMESTAMP,
    discharge_date TIMESTAMP,
    patient_id INT REFERENCES patients(id)
)


CREATE TABLE beds (
    id SERIAL PRIMARY KEY,
    type VARCHAR(64) CHECK (type IN ('electrical', 'simple'))
    department_id INT REFERENCES departments(id)

)


CREATE TABLE surgeries (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP,
    patient_id INT REFERENCES patients(id)
)

CREATE TABLE junction_surgeries (
    id SERIAL PRIMARY KEY,
    surgery_id INT REFERENCES surgeries(id),
    doctor_id INT REFERENCES doctors(id),
    UNIQUE (surgery_id, doctor_id)
)