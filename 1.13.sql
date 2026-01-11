-- doctors related tables
CREATE TABLE specialties (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE
);

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    doctor_number VARCHAR(128) UNIQUE, -- assigned by the hospital itself
    name VARCHAR(128),
    specialty_id INT REFERENCES specialties(id),
    CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id) REFERENCES specialties(id),
    working_years INT
);

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_number VARCHAR(128) UNIQUE, -- assigned by the hospital itself
    name VARCHAR(128),
    type VARCHAR(64) CHECK (type IN ('surgery', 'medical'))
    
)

-- admission to the hospital

CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_number VARCHAR(128) UNIQUE, -- assigned by the hospital itself
    
    doctor_id INT REFERENCES doctors(id),
    CONSTRAINT fk_patient_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    
    name VARCHAR(128),
    sex_type VARCHAR(16) CHECK (sex_type IN ('male', 'female')),
    date_of_birth TIMESTAMP,
    address VARCHAR(256)
)


CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    admission_number VARCHAR(128) UNIQUE, -- assigned by the hospital itself
    admission_date TIMESTAMP,
    discharge_date TIMESTAMP,
    patient_id INT REFERENCES patients(id),
    CONSTRAINT fk_admission_patient FOREIGN KEY (patient_id) REFERENCES patients(id),


    department_id INT REFERENCES departments(id),
    CONSTRAINT fk_admission_department FOREIGN KEY (department_id) REFERENCES departments(id),
    
    
    bed_id INT REFERENCES beds(id),
    CONSTRAINT fk_admission_bed FOREIGN KEY (bed_id) REFERENCES beds(id)
    
)


CREATE TABLE beds (
    id SERIAL PRIMARY KEY,
    type VARCHAR(64) CHECK (type IN ('electrical', 'simple')),
    department_id INT REFERENCES departments(id),
    CONSTRAINT fk_bed_department FOREIGN KEY (department_id) REFERENCES departments(id)
)


CREATE TABLE surgeries (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP,
    patient_id INT REFERENCES patients(id),
    CONSTRAINT fk_surgery_patient FOREIGN KEY (patient_id) REFERENCES patients(id)
    
)

CREATE TABLE junction_surgeries (

    surgery_id INT REFERENCES surgeries(id),
    CONSTRAINT fk_junction_surgery FOREIGN KEY (surgery_id) REFERENCES surgeries(id),
    

    doctor_id INT REFERENCES doctors(id),
    CONSTRAINT fk_junction_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    
    PRIMARY KEY (surgery_id, doctor_id)
)