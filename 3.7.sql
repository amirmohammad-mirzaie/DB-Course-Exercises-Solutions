CREATE TABLE R (
    A INT,
    B INT,
    PRIMARY KEY (A, B)
);

CREATE TABLE S (
    A INT,
    C INT,
    PRIMARY KEY (A, C)

);

INSERT INTO R (A, B) VALUES 
(1, 2), (2, 17), (3, 17), (4, 1), (2, 18);


-- 3.7.a --

SELECT 
    A,
    B
FROM R
WHERE B = 17;


-- 3.7.b --

