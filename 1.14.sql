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
    date TIMESTAMP,
    branch_id INT REFERENCES branches(id),
    CONSTRAINT fk_contract__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
)
CREATE TABLE rental_contracts (
    id SERIAL PRIMARY KEY,
    base_payment BIGINT,
    monthly_payment BIGINT,
    contract_id INT REFERENCES contracts(id) UNIQUE,
    CONSTRAINT fk_rental_contract__contract FOREIGN KEY (contract_id) REFERENCES contracts(id),
    duration INT CHECK (duration IN (6, 12, 24)),
    start_date TIMESTAMP,
    end_date TIMESTAMP
    
);

CREATE TABLE contract_renewals (
    id SERIAL PRIMARY KEY,
    renewal_number VARCHAR(128) UNIQUE,

    original_contract_id INT REFERENCES rental_contracts(id),
    CONSTRAINT fk_contract_renewal__rental_contract FOREIGN KEY (original_contract_id) REFERENCES rental_contracts(id),

    renewal_percentage FLOAT,
    start_date TIMESTAMP,
    end_date TIMESTAMP

)

CREATE TABLE purchase_contracts (
    id SERIAL PRIMARY KEY,
    purchase_payment BIGINT,
    contract_id INT REFERENCES contracts(id) UNIQUE,
    CONSTRAINT fk_purchase_contract__contract FOREIGN KEY (contract_id) REFERENCES contracts(id),
);



CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    national_id VARCHAR(128),
    name VARCHAR(128),
)


CREATE TABLE junction_customer_rental_contracts (
    customer_id INT REFERENCES customers(id),
    CONSTRAINT fk_junction_customer_rental_contract__customer FOREIGN KEY (customer_id) REFERENCES customers(id),

    contract_id INT REFERENCES rental_contracts(id),
    CONSTRAINT fk_junction_customer_contract__rental_contract FOREIGN KEY (contract_id) REFERENCES rental_contracts(id),

    PRIMARY KEY (customer_id, contract_id)
)


CREATE TABLE junction_customer_purchase_contracts (
    customer_id INT REFERENCES customers(id),
    CONSTRAINT fk_junction_customer_purchase_contract__customer FOREIGN KEY (customer_id) REFERENCES customers(id),

    contract_id INT REFERENCES purchase_contracts(id),
    CONSTRAINT fk_junction_customer_contract__purchase_contract FOREIGN KEY (contract_id) REFERENCES purchase_contracts(id),

    PRIMARY KEY (customer_id, contract_id)
)
