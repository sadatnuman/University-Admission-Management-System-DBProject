----------------------------------------------------------
-- SEQUENCES
----------------------------------------------------------
CREATE SEQUENCE admin_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE applicant_seq START WITH 1001 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE application_seq START WITH 701 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE program_seq START WITH 2001 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE teacher_seq START WITH 1001 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE student_seq START WITH 3001 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE payment_seq START WITH 9001 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE evaluation_seq START WITH 3301 INCREMENT BY 1 NOCACHE NOCYCLE;

----------------------------------------------------------
-- TABLES
----------------------------------------------------------

CREATE TABLE Admin (
    admin_id NUMBER PRIMARY KEY,
    admin_name VARCHAR2(100) NOT NULL,
    admin_address VARCHAR2(200),
    admin_ph1 VARCHAR2(15),
    admin_ph2 VARCHAR2(15),
    admin_email VARCHAR2(100) UNIQUE,
    admin_password VARCHAR2(100) NOT NULL
);

CREATE TABLE Applicant (
    applicant_id NUMBER PRIMARY KEY,
    applicant_name VARCHAR2(100) NOT NULL,
    fathers_name VARCHAR2(100),
    mothers_name VARCHAR2(100),
    nationality VARCHAR2(50),
    religion VARCHAR2(50),
    college_name VARCHAR2(150),
    hsc_result NUMBER(3,2),
    school_name VARCHAR2(150),
    ssc_result NUMBER(3,2),
    applicant_email VARCHAR2(100) UNIQUE,
    applicant_ph1 VARCHAR2(15),
    applicant_ph2 VARCHAR2(15),
    applicant_password VARCHAR2(100) NOT NULL,
    applicant_dob DATE,
    applicant_address VARCHAR2(200)
);

CREATE TABLE Department (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(100) UNIQUE
);

CREATE TABLE Program (
    program_id NUMBER PRIMARY KEY,
    program_name VARCHAR2(150),
    total_credit NUMBER(4),
    per_credit_cost NUMBER(10,2),
    program_duration VARCHAR2(50),
    dept_id NUMBER,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Teacher (
    teacher_id NUMBER PRIMARY KEY,
    teacher_name VARCHAR2(100),
    teacher_ph1 VARCHAR2(15),
    teacher_ph2 VARCHAR2(15),
    teacher_email VARCHAR2(100) UNIQUE,
    teacher_password VARCHAR2(100) NOT NULL,
    dept_id NUMBER,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Application (
    application_id NUMBER PRIMARY KEY,
    apply_date DATE,
    status VARCHAR2(30),
    admin_id NUMBER,
    applicant_id NUMBER,
    dept_id NUMBER,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
    FOREIGN KEY (applicant_id) REFERENCES Applicant(applicant_id),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Student (
    student_id NUMBER PRIMARY KEY,
    student_email VARCHAR2(100) UNIQUE,
    student_password VARCHAR2(100) NOT NULL,
    admission_date DATE,
    applicant_id NUMBER,
    dept_id NUMBER,
    program_id NUMBER,
    FOREIGN KEY (applicant_id) REFERENCES Applicant(applicant_id),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (program_id) REFERENCES Program(program_id)
);

CREATE TABLE Payment (
    payment_id NUMBER PRIMARY KEY,
    payment_amount NUMBER(10,2),
    payment_method VARCHAR2(30),
    payment_type VARCHAR2(30),
    payment_date DATE,
    application_id NUMBER,
    FOREIGN KEY (application_id) REFERENCES Application(application_id)
);

CREATE TABLE Evaluation (
    evaluation_id NUMBER PRIMARY KEY,
    written_marks NUMBER(5,2),
    viva_marks NUMBER(5,2),
    final_status VARCHAR2(30),
    application_id NUMBER,
    teacher_id NUMBER,
    admin_id NUMBER,
    FOREIGN KEY (application_id) REFERENCES Application(application_id),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

----------------------------------------------------------
-- DATA INSERTION
----------------------------------------------------------

-- Admin
INSERT INTO Admin VALUES (1,'Rubana Newaz','AIUB Campus','01710000001','01810000001','rubananewaz@aiub.edu','1234');
INSERT INTO Admin VALUES (2,'Kamal Hossain','AIUB Campus','01710000002','01810000002','kamalhossain@aiub.edu','1234');
INSERT INTO Admin VALUES (3,'Farhana Rahman','AIUB Campus','01710000003','01810000002','farhanarahman@aiub.edu','1234');
INSERT INTO Admin VALUES (4,'Tanvir Ahmed','AIUB Campus','01710000004','01810000002','tanvirahmed@aiub.edu','1234');
INSERT INTO Admin VALUES (5,'Nusrat Jahan','AIUB Campus','01710000005','01810000002','nusratjahan@aiub.edu','1234');

-- Department
INSERT INTO Department VALUES (1,'Computer Science');
INSERT INTO Department VALUES (2,'EEE');
INSERT INTO Department VALUES (3,'Business');
INSERT INTO Department VALUES (4,'Arts');
INSERT INTO Department VALUES (5,'Architecture');

-- Program
INSERT INTO Program VALUES (2001,'BSc in CSE',148,6500,'4 Years',1);
INSERT INTO Program VALUES (2002,'BSc in EEE',160,6200,'4 Years',2);
INSERT INTO Program VALUES (2003,'BBA',126,5600,'4 Years',3);
INSERT INTO Program VALUES (2004,'BA in English',120,5000,'4 Years',4);
INSERT INTO Program VALUES (2005,'BArch',180,7000,'5 Years',5);

-- Teacher
INSERT INTO Teacher VALUES (1001,'Juena Ahmed','01760000001','01760000001','juena@aiub.edu','1234',1);
INSERT INTO Teacher VALUES (1002,'Farida Begum','01760000002','01760000002','farida@aiub.edu','1234',2);
INSERT INTO Teacher VALUES (1003,'Dr Javed','01760000003','01760000003','javed@aiub.edu','1234',3);
INSERT INTO Teacher VALUES (1004,'Shireen Akter','01760000004','01760000004','shireen@aiub.edu','1234',4);
INSERT INTO Teacher VALUES (1005,'Rahman Chowdhury','01760000005','01760000005','rahman@aiub.edu','1234',5);

-- Applicant
INSERT INTO Applicant VALUES (1001,'Nazmus Sadat','Abdus Shukur','Nazma','Bangladeshi','Islam','Trust College',5.00,'Pangsha High',5.00,'numan@gmail.com','01710000011','01610000011','1234',DATE '2003-08-30','Rajbari');
INSERT INTO Applicant VALUES (1002,'Papia Prianka','Ujjol','Rotna','Bangladeshi','Islam','VNC',5.00,'Royal School',5.00,'papia@gmail.com','01710000012','01610000012','1234',DATE '2003-11-04','Brahmanbaria');
INSERT INTO Applicant VALUES (1003,'Sultan Ahmed','Shamsul','Rita','Bangladeshi','Islam','NDC',4.75,'Gregory',4.60,'sultan@gmail.com','01710000013','01610000013','1234',DATE '2005-01-15','Banani');
INSERT INTO Applicant VALUES (1004,'Nusrat Jahan','Kamal','Hasina','Bangladeshi','Islam','Holy Cross',4.82,'Model School',4.70,'nusrat@gmail.com','01510000014','01710000014','1234',DATE '2005-06-20','Dhanmondi');
INSERT INTO Applicant VALUES (1005,'Rafiq Chowdhury','Anwar','Rehana','Bangladeshi','Islam','Cambrian',4.60,'Zeenat High',4.55,'rafiq@gmail.com','01710000015','01310000015','1234',DATE '2004-11-30','Mirpur');
INSERT INTO Applicant VALUES (1006,'Imran Hossain','Jalal','Shirin','Bangladeshi','Islam','City College',3.90,'Ideal',3.80,'imran@gmail.com','01310000016','01710000016','1234',DATE '2004-01-01','Uttara');
INSERT INTO Applicant VALUES (1007,'Sabbir Khan','Rashid','Lima','Bangladeshi','Islam','Dhaka College',4.10,'Science School',4.05,'sabbir@gmail.com','01710000017','01510000017','1234',DATE '2004-02-02','Mohammadpur');
INSERT INTO Applicant VALUES (1008,'Rumana Akter','Salam','Khadija','Bangladeshi','Islam','Eden',3.50,'City',3.40,'rumana@gmail.com','01710000018','01610000018','1234',DATE '2004-03-03','Farmgate');
INSERT INTO Applicant VALUES (1009,'Hasan Mahmud','Latif','Rina','Bangladeshi','Islam','Govt College',4.20,'Govt School',4.10,'hasan@gmail.com','01710000019','01810000019','1234',DATE '2004-04-04','Keraniganj');
INSERT INTO Applicant VALUES (1010,'Tania Sultana','Kader','Mina','Bangladeshi','Islam','Model College',3.60,'Model School',3.50,'tania@gmail.com','01710000111','01910000111','1234',DATE '2004-05-05','Gazipur');

-- Application
INSERT INTO Application VALUES (701,DATE '2025-02-01','Accept',1,1001,1);
INSERT INTO Application VALUES (702,DATE '2025-02-02','Accept',1,1002,3);
INSERT INTO Application VALUES (703,DATE '2025-02-03','Accept',2,1003,1);
INSERT INTO Application VALUES (704,DATE '2025-02-04','Accept',2,1004,5);
INSERT INTO Application VALUES (705,DATE '2025-02-05','Accept',3,1005,2);
INSERT INTO Application VALUES (706,DATE '2025-02-06','Accept',3,1007,1);
INSERT INTO Application VALUES (707,DATE '2025-02-07','Accept',4,1009,3);
INSERT INTO Application VALUES (708,DATE '2025-02-08','Reject',4,1006,2);
INSERT INTO Application VALUES (709,DATE '2025-02-09','Reject',5,1008,4);
INSERT INTO Application VALUES (710,DATE '2025-02-10','Reject',5,1010,5);

-- Payment
INSERT INTO Payment VALUES (9001,1500,'Bkash','Application Fee',DATE '2025-02-01',701);
INSERT INTO Payment VALUES (9002,1500,'Nagad','Application Fee',DATE '2025-02-02',702);
INSERT INTO Payment VALUES (9003,1500,'Card','Application Fee',DATE '2025-02-03',703);
INSERT INTO Payment VALUES (9004,1500,'Bkash','Application Fee',DATE '2025-02-04',704);
INSERT INTO Payment VALUES (9005,1500,'Card','Application Fee',DATE '2025-02-05',705);
INSERT INTO Payment VALUES (9006,1500,'Nagad','Application Fee',DATE '2025-02-06',706);
INSERT INTO Payment VALUES (9007,1500,'Bkash','Application Fee',DATE '2025-02-07',707);
INSERT INTO Payment VALUES (9008,1500,'Card','Application Fee',DATE '2025-02-08',708);
INSERT INTO Payment VALUES (9009,1500,'Bkash','Application Fee',DATE '2025-02-09',709);
INSERT INTO Payment VALUES (9010,1500,'Nagad','Application Fee',DATE '2025-02-10',710);

-- Evaluation
INSERT INTO Evaluation VALUES (3301,75,15,'Passed',701,1001,1);
INSERT INTO Evaluation VALUES (3302,70,14,'Passed',702,1003,1);
INSERT INTO Evaluation VALUES (3303,68,13,'Passed',703,1001,2);
INSERT INTO Evaluation VALUES (3304,72,14,'Passed',704,1005,2);
INSERT INTO Evaluation VALUES (3305,65,15,'Passed',705,1002,3);
INSERT INTO Evaluation VALUES (3306,55,5,'Waiting',706,1001,3);
INSERT INTO Evaluation VALUES (3307,40,10,'Failed',707,1003,4);

-- Student
INSERT INTO Student VALUES (3001,'3001@student.aiub.edu','1234',DATE '2025-02-20',1001,1,2001);
INSERT INTO Student VALUES (3002,'3002@student.aiub.edu','1234',DATE '2025-02-21',1002,3,2003);
INSERT INTO Student VALUES (3003,'3003@student.aiub.edu','1234',DATE '2025-02-22',1003,1,2001);
INSERT INTO Student VALUES (3004,'3004@student.aiub.edu','1234',DATE '2025-02-23',1004,5,2005);
INSERT INTO Student VALUES (3005,'3005@student.aiub.edu','1234',DATE '2025-02-24',1005,2,2002);

COMMIT;

DESC Admin;
SELECT * FROM Admin;

DESC Applicant;
SELECT * FROM Applicant;

DESC Department;
SELECT * FROM Department;

DESC Program;
SELECT * FROM Program;

DESC Teacher;
SELECT * FROM Teacher;

DESC Application;
SELECT * FROM Application;

DESC Student;
SELECT * FROM Student;

DESC Payment;
SELECT * FROM Payment;

DESC Evaluation;
SELECT * FROM Evaluation;
