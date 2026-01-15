
-- Create the Hotel table
CREATE TABLE Hotel (
    hotelNo SERIAL PRIMARY KEY,
    hotelName VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- Create the Guest table
CREATE TABLE Guest (
    guestNo SERIAL PRIMARY KEY,
    guestName VARCHAR(100) NOT NULL,
    guestAddress TEXT
);

-- Create the Room table
CREATE TABLE Room (
    roomNo SERIAL PRIMARY KEY,
    hotelNo INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo) ON DELETE CASCADE
);

-- Create the Booking table
CREATE TABLE Booking (
    hotelNo INT NOT NULL,
    guestNo INT NOT NULL,
    dateFrom DATE NOT NULL,
    dateTo DATE NOT NULL,
    roomNo INT NOT NULL,
    PRIMARY KEY (hotelNo, guestNo, dateFrom),
    FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo) ON DELETE CASCADE,
    FOREIGN KEY (guestNo) REFERENCES Guest(guestNo) ON DELETE CASCADE,
    FOREIGN KEY (roomNo) REFERENCES Room(roomNo) ON DELETE CASCADE,
    CHECK (dateFrom <= dateTo)
);



-- Insert sample data into Hotel table
INSERT INTO Hotel (hotelName, city) VALUES
('Grand Plaza Hotel', 'London'),
('Sunset Inn', 'Paris'),
('Ocean View Resort', 'Sydney');

-- Insert sample data into Guest table
INSERT INTO Guest (guestName, guestAddress) VALUES
('Alice Johnson', '123 Main St, London, UK'),
('Bob Smith', '456 Elm St, Paris, France'),
('Carol White', '789 Oak Ave, Sydney, Australia'),
('David Brown', '101 Pine Rd, London, UK'),
('Eva Green', '202 Maple Dr, Paris, France');

-- Insert sample data into Room table
INSERT INTO Room (hotelNo, type, price) VALUES
(1, 'Single', 85.00),     -- Grand Plaza Hotel
(1, 'Double', 120.00),    -- Grand Plaza Hotel
(1, 'Suite', 250.00),     -- Grand Plaza Hotel
(2, 'Single', 75.00),     -- Sunset Inn
(2, 'Double', 110.00),    -- Sunset Inn
(3, 'Suite', 300.00);     -- Ocean View Resort

-- Insert sample data into Booking table
INSERT INTO Booking (hotelNo, guestNo, dateFrom, dateTo, roomNo) VALUES
(1, 1, '2024-06-01', '2024-06-05', 1),  -- Alice books Single room at Grand Plaza
(2, 2, '2024-06-03', '2024-06-07', 4),  -- Bob books Single room at Sunset Inn
(1, 3, '2024-06-10', '2024-06-15', 2),  -- Carol books Double room at Grand Plaza
(3, 4, '2024-06-12', '2024-06-18', 6);  -- David books Suite at Ocean View Resort
DELETE FROM booking WHERE hotelno=1 and guestno=2 and dateFrom='2024-06-02';

DROP TRIGGER IF EXISTS trg_cannot_reserve_again_the_already_reserved_room ON booking;
DROP TRIGGER IF EXISTS trg_cannot_have_reserve_with_overlap ON booking;
DROP TRIGGER IF EXISTS trg_price_for_two_person_room_more_than_the_most_expensive_1_person_room ON room;

------------------------------------------------------------------------
-- TRIGGERS -----------------------------------------------------------


----------------------------------
--- 3.3.1 -------------------------
------------------------------
CREATE OR REPLACE FUNCTION cannot_have_reserve_with_overlap()
RETURNS TRIGGER AS $$
DECLARE 
    overlap_count INT;
BEGIN
    SELECT COUNT(*) INTO overlap_count
    FROM booking b 
    WHERE 
        b.guestno = NEW.guestno AND 
        b.dateto >= NEW.datefrom AND
        b.datefrom <= NEW.dateto AND
        (b.hotelNo, b.guestNo, b.dateFrom) != (NEW.hotelNo, NEW.guestNo, NEW.dateFrom);

    
    IF overlap_count > 0 THEN
        RAISE EXCEPTION 'Cannot register new booking since the guest alreay has another active booking';
    END IF;

    RETURN NEW;
    
END;
$$LANGUAGE plpgsql;


----------------------------------
--- 3.3.2 -------------------------
------------------------------

CREATE OR REPLACE FUNCTION cannot_reserve_again_the_already_reserved_room()
RETURNS TRIGGER AS $$
DECLARE
    overlap_room_count INT;
BEGIN
    SELECT COUNT(*) INTO overlap_room_count
    FROM booking b
    WHERE 
        NEW.hotelNo = b.hotelNo AND 
        NEW.roomNo = b.roomNo AND
        NEW.dateFrom <= b.dateTo AND
        NEW.dateTo >= b.dateFrom AND
        (NEW.hotelNo, New.guestNo, New.dateFrom) != (b.hotelNo, b.guestNo, b.dateFrom);
    IF overlap_room_count > 0 THEN
        RAISE EXCEPTION 'Cannot reserve the already reserved room';
    END IF;
    RETURN NEW;
END;
$$LANGUAGE plpgsql;


----------------------------------
--- 3.3.3 -------------------------
------------------------------

CREATE OR REPLACE FUNCTION price_for_two_person_room_more_than_the_most_expensive_1_person_room()
RETURNS TRIGGER AS $$
DECLARE
    most_expensive_1_person_room_price NUMERIC(15,2);
BEGIN
    
    IF NEW.type != 'Double' THEN
        RETURN NEW;
    END IF;

    SELECT 
        MAX(r.price) INTO most_expensive_1_person_room_price
    FROM room r
    WHERE 
        r.type = 'Single' AND
        r.hotelNo = NEW.hotelNo;
    IF NEW.price <= most_expensive_1_person_room_price THEN
        RAISE EXCEPTION 'the price for a 2-person room cannot be less than the maximum price for a 1-person room';
    END IF;
    RETURN NEW;
END;
$$LANGUAGE plpgsql;




CREATE TRIGGER trg_price_for_two_person_room_more_than_the_most_expensive_1_person_room
BEFORE INSERT OR UPDATE ON room
FOR EACH ROW
EXECUTE FUNCTION price_for_two_person_room_more_than_the_most_expensive_1_person_room();
 
CREATE TRIGGER trg_cannot_reserve_again_the_already_reserved_room
BEFORE INSERT OR UPDATE ON booking
FOR EACH ROW
EXECUTE FUNCTION cannot_reserve_again_the_already_reserved_room();

CREATE TRIGGER trg_cannot_have_reserve_with_overlap
BEFORE INSERT OR UPDATE ON booking
FOR EACH ROW
EXECUTE FUNCTION cannot_have_reserve_with_overlap();


