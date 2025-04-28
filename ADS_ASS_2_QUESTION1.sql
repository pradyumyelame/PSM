-- ASSIGNMENT 2 PART 1 22510063
-- PSM QUESTION 1

CREATE TABLE test_table (
    RecordNumber NUMBER(3),
    CurrentDate DATE
);

DROP PROCEDURE InsertRecords;

CREATE OR REPLACE PROCEDURE InsertRecords
AS
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO test_table (RecordNumber, CurrentDate)
        VALUES (i, SYSDATE);
    END LOOP;
    COMMIT;
END;
/

BEGIN
    InsertRecords;
END;

SELECT * FROM test_table;

-- Question 2
CREATE TABLE products (
    ProductID NUMBER(4),
    category CHAR(3),
    detail VARCHAR2(30),
    price NUMBER(10,2),
    stock NUMBER(5)
);

INSERT INTO products (ProductID, category, detail, price, stock) VALUES (3001, 'ELE', 'Wireless Earbuds', 3000.00, 120);
INSERT INTO products (ProductID, category, detail, price, stock) VALUES (3002, 'ELE', 'Gaming Console', 45000.00, 25);
INSERT INTO products (ProductID, category, detail, price, stock) VALUES (3003, 'FUR', 'Bookshelf', 5000.00, 50);
INSERT INTO products (ProductID, category, detail, price, stock) VALUES (3004, 'FUR', 'Office Desk', 8000.00, 35);
INSERT INTO products (ProductID, category, detail, price, stock) VALUES (3005, 'CLO', 'Jacket', 2500.00, 80);

COMMIT;

CREATE OR REPLACE PROCEDURE UpdatePriceByCategory (
    X IN NUMBER,  
    Y IN CHAR     
)
AS
BEGIN
    UPDATE products
    SET price = price + (price * X / 100)
    WHERE category = Y;

    COMMIT;
END;
/

BEGIN
    UpdatePriceByCategory(10, 'ELE');
END;

SELECT * FROM products;
