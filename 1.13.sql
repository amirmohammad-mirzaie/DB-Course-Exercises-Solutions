


CREATE TABLE department (
    id SERIAL PRIMARY KEY,
    department_id CHAR(10) UNIQUE,
    name VARCHAR(128),
    type VARCHAR(16) CHECK (type IN ('surgery', 'treatment'))
)




CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),
    doctor_id CHAR(10) UNIQUE,
    expertise_domain VARCHAR(64),
    n_experience_years INT
)


CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_id CHAR(10) UNIQUE,
    name VARCHAR(128),
    age INT,
    gender VARCHAR(8) CHECK (gender IN ('male', 'female')),
    date_of_birth DATE,
    address VARCHAR(1024)
)


CREATE TABLE beds (
    id SERIAL PRIMARY KEY,
    bed_no CHAR(10),
    type VARCHAR(16) CHECK (type IN ('electrical', 'mechanical')),
    department_id INT REFERENCES departments(id)
)

CREATE TABLE supervisions (
    patient_id INT REFERENCES patients(id),
    doctor_id INT REFERENCES doctors(id),
    department_id INT REFERENCES departments(id),
    start_date DATE NOT NULL,
    end_date DATE,
    bed_id INT REFERENCES beds(id),
    PRIMARY KEY (patient_id, doctor_id, department_id, start_date)
)

CREATE TABLE surgery_info (
    id SERIAL PRIMARY KEY,
    surgery_no CHAR(10),
    surgery_date DATE,
    surgery_hour HOUR,
    patient_id INT REFERENCES patients(id),

)

CREATE TABLE surgery_participants (
    doctor_id INT REFERENCES doctors(id),
    surgery_info_id INT REFERENCES surgery_info(id),
    PRIMARY KEY(doctor_id, surgery_info_id)
)

CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(id) NOT NULL,
    admission_no CHAR(10) UNIQUE,
    admission_date DATE,
    dismissal_date DATE,
    
)
