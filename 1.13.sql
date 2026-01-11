
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    doctor_number VARCHAR(128),
    name VARCHAR(128),
    profession_name VARCHAR(128), -- this can be in a separate table
    working_years INT -- this can be in a separate table
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
    date_born TIMESTAMP,
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


CREATE TABLE junction_surgeries_infos (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP,
)

CREATE TABLE surgeries (
    surgery_info_id INT REFERENCES junction_surgeries_infos(id),
    patient_id INT REFERENCES patients(id),
    doctor_id INT REFERENCES doctors(id),
    PRIMARY KEY (surgery_info_id, patient_id, doctor_id)
)