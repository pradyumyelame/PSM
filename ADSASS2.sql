-- PART 2 ASSIGNMENT 2

CREATE OR REPLACE TYPE NameType AS OBJECT (
    name VARCHAR2(50),

    -- Member function declaration
    MEMBER FUNCTION countNoOfWords RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY NameType AS
    MEMBER FUNCTION countNoOfWords RETURN NUMBER IS
        word_count NUMBER := 0;
    BEGIN
        -- Use REGEXP_COUNT to count words separated by spaces
        word_count := REGEXP_COUNT(name, '\S+');
        RETURN word_count;
    END;
END;
/

CREATE TABLE NameTable OF NameType;


INSERT INTO NameTable VALUES (NameType('John Doe'));
INSERT INTO NameTable VALUES (NameType('Alice'));
INSERT INTO NameTable VALUES (NameType('Robert Downey Jr'));
INSERT INTO NameTable VALUES (NameType('Dr. A P J Abdul Kalam'));


SELECT VALUE(n).name AS NameField, 
       VALUE(n).countNoOfWords() AS WordCount
FROM NameTable n ;


-- -- QUESTION 2 -- -- 


CREATE OR REPLACE TYPE AddressType AS OBJECT (
    address VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    pincode NUMBER(6),
    MEMBER FUNCTION getAddressesByKeyword(keyword IN VARCHAR2) RETURN VARCHAR2,
    MEMBER FUNCTION countWords(fieldName IN VARCHAR2) RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AddressType AS
    MEMBER FUNCTION getAddressesByKeyword(keyword IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF INSTR(LOWER(address), LOWER(keyword)) > 0 THEN
            RETURN address;
        ELSE
            RETURN NULL;
        END IF;
    END;
    MEMBER FUNCTION countWords(fieldName IN VARCHAR2) RETURN NUMBER IS
        word_count NUMBER := 0;
    BEGIN
        CASE LOWER(fieldName)
            WHEN 'address' THEN
                word_count := REGEXP_COUNT(address, '\S+');
            WHEN 'city' THEN
                word_count := REGEXP_COUNT(city, '\S+');
            WHEN 'state' THEN
                word_count := REGEXP_COUNT(state, '\S+');
            WHEN 'pincode' THEN
                word_count := 1; 
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Invalid field name');
        END CASE;
        RETURN word_count;
    END;
END;
/

CREATE TABLE AddressTable OF AddressType;

INSERT INTO AddressTable VALUES (AddressType('123 Main Street', 'Mumbai', 'Maharashtra', 400001));
INSERT INTO AddressTable VALUES (AddressType('45 Residency Road', 'Bengaluru', 'Karnataka', 560025));
INSERT INTO AddressTable VALUES (AddressType('Plot 32, Green Avenue', 'Hyderabad', 'Telangana', 500081));
INSERT INTO AddressTable VALUES (AddressType('10 MG Road', 'Chennai', 'Tamil Nadu', 600034));
COMMIT;

SELECT VALUE(a).address AS FullAddress,
       VALUE(a).getAddressesByKeyword('Road') AS MatchingAddress
FROM AddressTable a;


Select VALUE(a).address AS FullAddress,
       VALUE(a).countWords('address') AS WordCountInAddress,
       VALUE(a).countWords('city') AS WordCountInCity,
       VALUE(a).countWords('state') AS WordCountInState,
       VALUE(a).countWords('pincode') AS WordCountInPincode
       
FROM AddressTable a;

-- QUESTION 3

CREATE OR REPLACE TYPE course_Type AS OBJECT (
    course_id NUMBER(5),
    description VARCHAR2(100)
);

CREATE TABLE courseTable OF course_Type;

-- Insert technical courses
INSERT INTO courseTable VALUES (course_Type(101, 'Introduction to Programming'));
INSERT INTO courseTable VALUES (course_Type(102, 'Object-Oriented Programming Concepts'));
INSERT INTO courseTable VALUES (course_Type(103, 'Advanced Database Management Systems'));

-- Insert soft skills courses
INSERT INTO courseTable VALUES (course_Type(201, 'Effective Communication Skills'));
INSERT INTO courseTable VALUES (course_Type(202, 'Leadership and Team Management'));

-- Insert industry-specific courses
INSERT INTO courseTable VALUES (course_Type(301, 'Healthcare Data Analysis'));
INSERT INTO courseTable VALUES (course_Type(302, 'Financial Risk Management'));
-- Commit the data
COMMIT;

SELECT t.course_id, t.description
FROM courseTable t;

--Count Courses by Type
SELECT COUNT(*) AS TechnicalCourses
FROM courseTable c
WHERE c.course_id BETWEEN 100 AND 199;

--Search Courses by Keywords
SELECT c.course_id, c.description
FROM courseTable c
WHERE LOWER(c.description) LIKE '%management%';