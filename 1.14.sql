-- real state corporation design
CREATE TABLE branches (
    id SERIAL PRIMARY KEY,
    branch_number VARCHAR(64) UNIQUE NOT NULL,
    name VARCHAR(128) NOT NULL,
    address VARCHAR(512) NOT NULL
);


CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128),
    branch_id INT REFERENCES branches(id),
    CONSTRAINT fk_employee__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
);


CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    national_id CHAR(16) UNIQUE NOT NULL,
    name VARCHAR(128) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(128)
);

CREATE TABLE flats (
    id SERIAL PRIMARY KEY,
    flat_number VARCHAR(128) UNIQUE,
    address VARCHAR(512),
    rental_price NUMERIC(15,2),
    buy_price NUMERIC(15,2),
    status VARCHAR(64) CHECK (status IN ('rent', 'buy')),
    branch_id INT REFERENCES branches(id),
    CONSTRAINT fk_flat__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
);



CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    contract_number VARCHAR(128) UNIQUE,
    contract_type VARCHAR(10) CHECK (contract_type IN ('rent', 'buy')) NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT NOW(),    
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    flat_id INT REFERENCES flats(id) ON DELETE CASCADE,
    branch_id INT REFERENCES branches(id) ON DELETE CASCADE, -- Add the branch to the contract so that we can directly find the branch related to a contract without the need to join with the flat table
    
    CONSTRAINT fk_contract__customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_contract__flat FOREIGN KEY (flat_id) REFERENCES flats(id),
    CONSTRAINT fk_contract__branch FOREIGN KEY (branch_id) REFERENCES branches(id)
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
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    CHECK (EXTRACT(MONTH FROM (end_date - start_date))) = duration_months
    
);

CREATE TABLE contract_renewals (
    id SERIAL PRIMARY KEY,
    renewal_number VARCHAR(64) UNIQUE NOT NULL,
    original_contract_id INT REFERENCES contracts(id) ON DELETE CASCADE,
    parent_renewal_id INT REFERENCES contract_renewals(id) DEFERRABLE INITIALLY DEFERRED,
    renewal_percentage NUMERIC(5,2) NOT NULL,
    current_montly_payment NUMERIC(15,2) NOT NULL,  -- Automatically calculated with the trigger function
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    CONSTRAINT fk_contract_renewal__contract FOREIGN KEY (original_contract_id) REFERENCES contracts(id),
    CONSTRAINT fk_contract_renewal__contract_renewal_parent FOREIGN KEY (parent_renewal_id) REFERENCES contract_renewals(id),
    
);

CREATE TABLE revocations (
    id SERIAL PRIMARY KEY,
    revocation_number VARCHAR(64) UNIQUE,
    contract_id INT REFERENCES contracts(id) ON DELETE CASCADE,
    revocation_fee NUMERIC(15,2) NOT NULL,
    revocation_date TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_revocation__contract FOREIGN KEY (contract_id) REFERENCES contracts(id)
);


-- create a trigger to check no two rental contracts overlap with each other


CREATE INDEX idx_contracts_contract_number ON contracts(contract_number);
CREATE INDEX idx_customers_national_id ON customers(national_id);
CREATE INDEX idx_flats_flat_number ON flats(flat_number);
CREATE INDEX idx_contracts_flat_id ON contracts(flat_id);
CREATE INDEX idx_contracts_customer_id ON contracts(customer_id);




CREATE OR REPLACE FUNCTION check_rental_contract_overlap()
RETURNS TRIGGER AS $$
DECLARE
    overlap_count INT;
BEGIN
    -- Count existing rental contracts for the same flat that overlap with the new contract
    SELECT COUNT(*) INTO overlap_count
    FROM rental_contracts rc
    JOIN contracts c ON rc.contract_id = c.id
    WHERE 
        c.flat_id = NEW.flat_id AND
        (
            NEW.start_date < rc.end_date
            AND NEW.end_date > rc.start_date
        ) AND 
        rc.contract_id != NEW.contract_id;
    
    -- If any overlap found, raise error
    IF overlap_count > 0 THEN
        RAISE EXCEPTION 'Cannot create or update rental contract: overlap with existing contract for this flat.';
    END IF;

    RETURN NEW
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_renewal_price()
RETURNS TRIGGER AS $$
DECLARE
    original_monthly_payment NUMERIC(15,2);
BEGIN
    -- If this is the first renewal (no parent), use original contract's monthly payment
    IF NEW.parent_renewal_id IS NULL THEN
        SELECT monthly_payment INTO original_monthly_payment
        FROM rental_contracts
        WHERE contract_id = NEW.original_contract_id;

        IF original_monthly_payment IS NULL THEN
            RAISE EXCEPTION 'Original contract not found for renewal: %', NEW.contract_id;
        END IF;

        NEW.current_monthly_payment := original_monthly_payment * (1 + NEW.renewal_percentage / 100);
    ELSE
        -- Get the previous renewal's current monthly payment
        SELECT current_monthly_payment INTO NEW.current_monthly_payment
        FROM contract_renewals
        WHERE id = NEW.parent_renewal_id;

        IF NEW.current_monthly_payment IS NULL THEN
            RAISE EXCEPTION 'Previous renewal not found for renewal ID: %', NEW.parent_renewal_id;
        END IF;

        -- Apply the renewal percentage
        NEW.current_monthly_payment := NEW.current_monthly_payment * (1 + NEW.renewal_percentage / 100);
    END IF;

    RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_renewal_price
BEFORE INSERT OR UPDATE ON contract_renewals
FOR EACH ROW
EXECUTE FUNCTION calculate_renewal_price();



-- TODO: Implement triggers to ensure that a new renewal contract does not overlap with any existing renewal contracts
-- (for the same flat or a different flat), nor with any active rental contracts in the rental_contracts table.
-- so we have to check if the contract is not overlapping with any previous renewal_contract, rental_contract or even purchase_contract

-- TODO: To add a trigger that checks if a contract type is aligned with the corresponding flat

-- TODO: To use a view or computed column instead of the trigger for calculating the current_monthly_payment for the 
-- renewal contracts

-- TODO: Add a constraint to check if the flat_id for the renewal contracts refer to the same flat from the original contract

-- TODO: Add a trigger to update the status to 'expired' when the end_date < NOW()