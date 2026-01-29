
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(128),
    department_no INT,
    UNIQUE (department_name, department_no)
);


CREATE TABLE beds (
    id SERIAL PRIMARY KEY,
    bed_no INT,
    department_id INT REFERENCES departments(id),
    UNIQUE (department_id, bed_no)
);

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE,
    department_id INT REFERENCES departments(id)
);


CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_id CHAR(10) UNIQUE,
    name VARCHAR(128),
    age INT
);


CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    medicine_no CHAR(10) UNIQUE,
    name VARCHAR(128),
    description VARCHAR(128),
    dosage_mg_ml NUMERIC(5,2)
);

CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(id),
    doctor_id INT REFERENCES doctors(id),
    admission_date DATE,
    dismissal_date DATE

)


CREATE TABLE prescriptions (
    id SERIAL PRIMARY KEY,
    medicine_id INT REFERENCES medicines(id),
    patient_id INT REFERENCES patients(id),
    doctor_id INT REFERENCES doctors(id),
    usage_type VARCHAR(8) CHECK (usage_type IN ('oral', 'injection')),
    n_daily_usage INT,
    start_date DATE,
    end_date DATE
)