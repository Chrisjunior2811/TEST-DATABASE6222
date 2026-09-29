USE master;
GO

IF DB_ID('DEBATES') IS NOT NULL
BEGIN
    ALTER DATABASE DEBATES SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DEBATES;
END
GO

CREATE DATABASE DEBATES;
GO

USE DEBATES;
GO

-- ==========================================
-- Q1.1 CREATE TABLES
-- ==========================================

CREATE TABLE FACULTY (
    FACULTY_ID VARCHAR(4) PRIMARY KEY,
    FACULTY_NAME VARCHAR(100) NOT NULL
);

CREATE TABLE VENUE (
    VENUE_ID VARCHAR(4) PRIMARY KEY,
    VENUE_NAME VARCHAR(100) NOT NULL,
    VENUE_ADDRESS VARCHAR(200) NOT NULL
);

CREATE TABLE DEBATE (
    DEBATE_ID VARCHAR(4) PRIMARY KEY,
    FACULTY_ID_A VARCHAR(4) NOT NULL,
    FACULTY_ID_B VARCHAR(4) NOT NULL,
    VENUE_ID VARCHAR(4) NOT NULL,
    DEBATE_DATE DATE NOT NULL,
    DEBATE_TIME TIME NOT NULL,
    DEBATE_DURATION INT NOT NULL,

    CONSTRAINT FK_DEBATE_FACULTY_A
        FOREIGN KEY (FACULTY_ID_A) REFERENCES FACULTY(FACULTY_ID),

    CONSTRAINT FK_DEBATE_FACULTY_B
        FOREIGN KEY (FACULTY_ID_B) REFERENCES FACULTY(FACULTY_ID),

    CONSTRAINT FK_DEBATE_VENUE
        FOREIGN KEY (VENUE_ID) REFERENCES VENUE(VENUE_ID)
);
GO

-- ==========================================
-- Q1.2 INSERT DATA
-- ==========================================

INSERT INTO FACULTY (FACULTY_ID, FACULTY_NAME)
VALUES
    ('F001', 'Faculty of Science'),
    ('F002', 'Faculty of Engineering'),
    ('F003', 'Faculty of Humanities'),
    ('F004', 'Faculty of Law'),
    ('F005', 'Faculty of Commerce');

INSERT INTO VENUE (VENUE_ID, VENUE_NAME, VENUE_ADDRESS)
VALUES
    ('V001', 'Newton Hall', '12 University Road, Cape Town'),
    ('V002', 'Curie Centre', '44 Innovation Avenue, Gqeberha'),
    ('V003', 'Plato Auditorium', '88 Knowledge Street, Durban'),
    ('V004', 'Darwin Hall', '15 Research Lane, Johannesburg'),
    ('V005', 'Aristotle Theatre', '9 Academic Crescent, Tshwane');

INSERT INTO DEBATE
    (DEBATE_ID, FACULTY_ID_A, FACULTY_ID_B, VENUE_ID,
     DEBATE_DATE, DEBATE_TIME, DEBATE_DURATION)
VALUES
    ('D001', 'F001', 'F002', 'V001', '2026-08-10', '10:00:00', 60),
    ('D002', 'F003', 'F005', 'V004', '2026-08-11', '14:00:00', 90),
    ('D003', 'F002', 'F003', 'V005', '2026-08-12', '18:00:00', 90),
    ('D004', 'F001', 'F005', 'V003', '2026-08-13', '16:00:00', 120),
    ('D005', 'F002', 'F005', 'V001', '2026-08-14', '17:00:00', 120);
GO

-- ==========================================
-- Q1.3 ADD TICKETS AVAILABLE
-- ==========================================

ALTER TABLE DEBATE
ADD TICKETS_AVAILABLE INT;
GO

-- ==========================================
-- Q1.4 UPDATE D003
-- ==========================================

UPDATE DEBATE
SET TICKETS_AVAILABLE = 400
WHERE DEBATE_ID = 'D003';
GO

-- ==========================================
-- SHOW ALL CREATED TABLES
-- ==========================================

SELECT 'FACULTY TABLE' AS TABLE_SHOWN;
SELECT * FROM FACULTY;

SELECT 'VENUE TABLE' AS TABLE_SHOWN;
SELECT * FROM VENUE;

SELECT 'DEBATE TABLE' AS TABLE_SHOWN;
SELECT * FROM DEBATE;
GO

-- ==========================================
-- Q2.1 VENUES WITH NO DEBATES
-- ==========================================

SELECT 'Q2.1 - VENUES WITH NO DEBATES' AS QUESTION;
SELECT V.VENUE_NAME
FROM VENUE V
LEFT JOIN DEBATE D
    ON V.VENUE_ID = D.VENUE_ID
WHERE D.VENUE_ID IS NULL;
GO

-- ==========================================
-- Q2.2 TOTAL DURATION PER VENUE
-- ==========================================

SELECT 'Q2.2 - TOTAL DURATION PER VENUE' AS QUESTION;
SELECT
    V.VENUE_NAME,
    SUM(D.DEBATE_DURATION) AS TOTAL_DURATION
FROM VENUE V
LEFT JOIN DEBATE D
    ON V.VENUE_ID = D.VENUE_ID
GROUP BY V.VENUE_ID, V.VENUE_NAME
ORDER BY V.VENUE_NAME ASC;
GO

-- ==========================================
-- Q2.3 LONGEST DEBATE AT V001
-- ==========================================

SELECT 'Q2.3 - LONGEST DEBATE AT V001' AS QUESTION;
SELECT
    V.VENUE_NAME,
    D.DEBATE_DATE,
    D.DEBATE_DURATION
FROM VENUE V
JOIN DEBATE D
    ON V.VENUE_ID = D.VENUE_ID
WHERE V.VENUE_ID = 'V001'
  AND D.DEBATE_DURATION = (
      SELECT MAX(DEBATE_DURATION)
      FROM DEBATE
      WHERE VENUE_ID = 'V001'
  );
GO