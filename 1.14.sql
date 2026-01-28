CREATE TABLE branches (
    id SERIAL PRIMARY KEY,
    branch_no CHAR(10) UNIQUE
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    branch_id INT REFERENCES branches(id)
);

CREATE TABLE houses (
    id SERIAL PRIMARY KEY,
    house_no CHAR(10) UNIQUE,
    address VARCHAR(256),
    rental_price NUMERIC(15, 2),
    purchase_price NUMERIC(15, 2),
    status VARCHAR(8) CHECK (status IN ('purchase', 'rent')),
    branch_id INT REFERENCES branches(id)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    national_id CHAR(10) UNIQUE,
    name VARCHAR(128)
);

CREATE TABLE base_contracts (
    id SERIAL PRIMARY KEY,
    contract_no CHAR(10) UNIQUE,
    type VARCHAR(8) CHECK (type IN ('purchase', 'rent')),
    contract_date DATE, -- Renamed from 'date'
    branch_id INT REFERENCES branches(id),
    customer_id INT REFERENCES customers(id),
    house_id INT REFERENCES houses(id)
);

CREATE TABLE rental_contracts (
    id SERIAL PRIMARY KEY,
    base_contract_id INT REFERENCES base_contracts(id) UNIQUE,
    advance_payment NUMERIC(15,2),
    monthly_rent NUMERIC(15,2),
    start_date DATE,
    duration_months INT CHECK (duration_months IN (6, 12, 24))
);

CREATE TABLE purchase_contracts (
    id SERIAL PRIMARY KEY,
    base_contract_id INT REFERENCES base_contracts(id) UNIQUE,
    price NUMERIC(15,2)
);



---------------------------------------------------------------------
-- design pattern 1 for renewals using sparse method-----------------
---------------------------------------------------------------------

CREATE TABLE renewals (
    id SERIAL PRIMARY KEY,
    renewal_no CHAR(10) UNIQUE,
    original_rental_contract_id INT REFERENCES rental_contracts(id),
    parent_renewal_contract_id INT REFERENCES renewals(id),
    percentage_added_to_monthly_money NUMERIC(5,2),
    CHECK (
        (original_rental_contract_id IS NOT NULL AND parent_renewal_contract_id IS NULL) OR
        (original_rental_contract_id IS NULL AND parent_renewal_contract_id IS NOT NULL)
    )

);



--------------------------------------------------------------------------
-- design pattern 2 for renewals using polymorphism method-----------------
--------------------------------------------------------------------------

CREATE TABLE renewals_polymorphic (
    id SERIAL PRIMARY KEY,
    renewal_no CHAR(10) UNIQUE,
    parent_contract_id INT NOT NULL,
    contract_type VARCHAR(16) CHECK (contract_type IN ('renewal', 'original'))
    
);



---------------------------------------------------------------------
-- design pattern 1 for REVOCATIONS using sparse method--------------
---------------------------------------------------------------------

CREATE TABLE rental_revocations (
    id SERIAL PRIMARY KEY,
    revocation_no CHAR(10) UNIQUE,
    cost NUMERIC(15,2),
    customer_id INT REFERENCES customers(id),
    contract_id INT REFERENCES rental_contracts(id),
    renewal_id INT REFERENCES renewals(id),
    -- Ensures a revocation targets either the contract OR a renewal, not both/neither
    CHECK (
        (contract_id IS NOT NULL AND renewal_id IS NULL) OR 
        (contract_id IS NULL AND renewal_id IS NOT NULL)
    )
);

CREATE TABLE purchase_revocations (
    id SERIAL PRIMARY KEY,
    revocation_no CHAR(10) UNIQUE,
    cost NUMERIC(15,2),
    customer_id INT REFERENCES customers(id),
    contract_id INT REFERENCES purchase_contracts(id)
);

-------------------------------------------------------------------
-- design pattern 2 for REVOCATIONS using polymorphic--------------
-------------------------------------------------------------------

CREATE TABLE revocations_polymorphic (
    id SERIAL PRIMARY KEY,
    revocation_no CHAR(10) UNIQUE,
    cost NUMERIC(15,2),
    object_type VARCHAR (16) CHECK (object_type IN ('purchase', 'rent', 'renewal'))
    object_id INT NOT NULL
)