-- real state corporation design

CREATE TABLE branches (
    id SERIAL PRIMARY KEY
)


CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),

    branch_id INT REFERENCES branches(id),
    CONSTRAINT fk_employee__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
)


CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    national_id VARCHAR(128) UNIQUE NOT NULL,
    name VARCHAR(128) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(20)
)

CREATE TABLE flats (
    id SERIAL PRIMARY KEY,
    flat_number VARCHAR(128) UNIQUE,
    address VARCHAR(512),
    rental_price FLOAT,
    buy_price FLOAT,
    status VARCHAR(64) CHECK (status IN ('rent', 'buy')),

    branch_id INT REFERENCES branches(id),
    CONSTRAINT fk_flat__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
)



CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    contract_number VARCHAR(128) UNIQUE,
    contract_type VARCHAR(10) CHECK (contract_type IN ('rent', 'buy')) NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT NOW(),
    branch_id INT REFERENCES branches(id),
    CONSTRAINT fk_contract__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
    
    customer_id INT REFERENCES customers(id),
    CONSTRAINT fk_contract__customer FOREIGN KEY (customer_id) REFERENCES customers(id),


    flat_id INT REFERENCES flats(id),
    CONSTRAINT fk_contract__flat FOREIGN KEY (flat_id) REFERENCES flats(id),
);


CREATE TABLE purchase_contracts (
    contract_id INT PRIMARY KEY REFERENCES contracts(id) ON DELETE CASCADE,
    purchase_payment NUMERIC(15,2) NOT NULL
);

CREATE TABLE rental_contracts (
    contract_id INT PRIMARY KEY REFERENCES contracts(id) ON DELETE CASCADE,
    base_payment NUMERIC(15,2) NOT NULL,
    monthly_payment NUMERIC(15,2) NOT NULL,
    duration_months INT CHECK (duration_months IN (6, 12, 24)),
    start_date TIMESTAMP NOT NULL
    end_date TIMESTAMP NOT NULL
    
);

CREATE TABLE contract_renewals (
    id SERIAL PRIMARY KEY,
    renewal_number VARCHAR(64) UNIQUE NOT NULL,

    original_contract_id INT REFERENCES rental_contracts(contract_id) ON DELETE CASCADE,
    CONSTRAINT fk_contract_renewal__rental_contract FOREIGN KEY (original_contract_id) REFERENCES rental_contracts(contract_id),

    renewal_percentage NUMERIC(5,2) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL

)

CREATE TABLE revocations (
    id SERIAL PRIMARY KEY,
    revocation_number VARCHAR(64) UNIQUE,

    contract_id INT REFERENCES contracts(id) ON DELETE CASCADE,
    CONSTRAINT fk_revocation__contract FOREIGN KEY (contract_id) REFERENCES contracts(id)

    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    CONSTRAINT fk_revocation__customer FOREIGN KEY (customer_id) REFERENCES customers(id),

    revocation_fee NUMERIC(15,2) NOT NULL,
    revocation_date TIMESTAMP NOT NULL DEFAULT NOW()
)
