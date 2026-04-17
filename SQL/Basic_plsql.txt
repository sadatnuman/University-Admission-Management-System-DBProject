
--Project Name: University Admission Management System 
--Semester: 2025-2026, Fall
--Course Name: Advance Database Management System
--Section: C



--1. Question: Write a PL/SQL block using local variables to display an applicant’s name and email for applicant ID 1001.

DECLARE
    var_applicant_id NUMBER := 1001;
BEGIN
    DECLARE
        var_applicant_name  Applicant.applicant_name%TYPE;
        var_applicant_email Applicant.applicant_email%TYPE;
    BEGIN
        SELECT applicant_name, applicant_email
        INTO var_applicant_name, var_applicant_email
        FROM Applicant
        WHERE applicant_id = var_applicant_id;

        DBMS_OUTPUT.PUT_LINE('Applicant Name: ' || var_applicant_name);
        DBMS_OUTPUT.PUT_LINE('Applicant Email: ' || var_applicant_email);
    END;
END;
/

--2. Question: Write a PL/SQL block using global variables to display a teacher's phone numbers and email for teacher name Juena Ahmed.
DECLARE
    var_teacher_ph1   Teacher.teacher_ph1%TYPE;
    var_teacher_ph2   Teacher.teacher_ph2%TYPE;
    var_teacher_email Teacher.teacher_email%TYPE;
BEGIN
    SELECT teacher_ph1, teacher_ph2, teacher_email
    INTO var_teacher_ph1, var_teacher_ph2, var_teacher_email
    FROM Teacher
    WHERE teacher_name = 'Juena Ahmed';

    DECLARE
        var_message VARCHAR2(200);
    BEGIN
        var_message := 'Phone 1: ' || var_teacher_ph1 ||
                       ', Phone 2: ' || var_teacher_ph2 ||
                       ', Email: ' || var_teacher_email;
        DBMS_OUTPUT.PUT_LINE(var_message);
    END;
END;
/

--3. Question: Write a PL/SQL block to calculate total marks by adding written marks and viva marks for application id 701.
DECLARE
    v_written  Evaluation.written_marks%TYPE;
    v_viva     Evaluation.viva_marks%TYPE;
    v_total    NUMBER;
BEGIN
    SELECT written_marks, viva_marks
    INTO v_written, v_viva
    FROM Evaluation
    WHERE application_id = 701;

    v_total := v_written + v_viva;

    DBMS_OUTPUT.PUT_LINE('Written Marks: ' || v_written);
    DBMS_OUTPUT.PUT_LINE('Viva Marks: ' || v_viva);
    DBMS_OUTPUT.PUT_LINE('Total Marks: ' || v_total);
END;
/

--4. Question: Write a PL/SQL block to check whether an applicant passed, waiting, or failed based on total marks using relational operators for application ID = 702.

DECLARE
    v_written  Evaluation.written_marks%TYPE;
    v_viva     Evaluation.viva_marks%TYPE;
    v_total    NUMBER;
BEGIN
    SELECT written_marks, viva_marks
    INTO v_written, v_viva
    FROM Evaluation
    WHERE application_id = 702;

    v_total := v_written + v_viva;

    IF v_total >= 60 THEN
        DBMS_OUTPUT.PUT_LINE('Status: PASSED');
    ELSIF v_total >= 55 THEN
        DBMS_OUTPUT.PUT_LINE('Status: WAITING');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Status: FAILED');
    END IF;
END;
/

--5. Question: Write a PL/SQL block using single-row functions to display applicant name in uppercase, email and length of email for applicant ID 1001.
DECLARE
    v_name_upper VARCHAR2(100);
    v_email      VARCHAR2(100);
    v_email_len  NUMBER;
BEGIN
    SELECT UPPER(applicant_name), applicant_email, LENGTH(applicant_email)
    INTO v_name_upper, v_email, v_email_len
    FROM Applicant
    WHERE applicant_id = 1001;

    DBMS_OUTPUT.PUT_LINE('Applicant Name (Uppercase): ' || v_name_upper);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Email Length: ' || v_email_len);
END;
/

--6. Question: Write a PL/SQL block using single-row functions to display program name and duration in uppercase.
DECLARE
    v_program_name VARCHAR2(150);
    v_duration     VARCHAR2(50);
BEGIN
    SELECT UPPER(program_name), UPPER(program_duration)
    INTO v_program_name, v_duration
    FROM Program
    WHERE program_id = 2001;

    DBMS_OUTPUT.PUT_LINE('Program Name: ' || v_program_name);
    DBMS_OUTPUT.PUT_LINE('Duration: ' || v_duration);
END;
/

--7. Question: Write a PL/SQL block to display total number of applicants using group function.
DECLARE
    v_total_applicants NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_applicants
    FROM Applicant;

    DBMS_OUTPUT.PUT_LINE('Total Applicants: ' || v_total_applicants);
END;
/

--8. Question: Write a PL/SQL block to display average written marks of all evaluations using group function.
DECLARE
    v_avg_marks NUMBER(5,2);
BEGIN
    SELECT AVG(written_marks)
    INTO v_avg_marks
    FROM Evaluation;

    DBMS_OUTPUT.PUT_LINE('Average Written Marks: ' || v_avg_marks);
END;
/

--9. Question: Write a PL/SQL block using WHILE loop to display the first 5 applicant IDs along with their name, HSC GPA, and SSC GPA.
DECLARE
    v_id        NUMBER := 1001;
    v_name      Applicant.applicant_name%TYPE;
    v_hsc_gpa   Applicant.hsc_result%TYPE;
    v_ssc_gpa   Applicant.ssc_result%TYPE;
BEGIN
    WHILE v_id <= 1005 LOOP

        SELECT applicant_name, hsc_result, ssc_result
        INTO v_name, v_hsc_gpa, v_ssc_gpa
        FROM Applicant
        WHERE applicant_id = v_id;

        DBMS_OUTPUT.PUT_LINE(
            'Applicant ID: ' || v_id ||
            ', Name: ' || v_name ||
            ', HSC GPA: ' || v_hsc_gpa ||
            ', SSC GPA: ' || v_ssc_gpa
        );

        v_id := v_id + 1;
    END LOOP;
END;
/

--10. Question: Write a PL/SQL block using FOR loop to display all program name, credit , per credit cost and duration.
BEGIN
    FOR prog_rec IN (SELECT program_name, total_credit, per_credit_cost, program_duration 
                     FROM Program)
    LOOP
        DBMS_OUTPUT.PUT_LINE('Program Name: ' || prog_rec.program_name);
        DBMS_OUTPUT.PUT_LINE('Total Credit: ' || prog_rec.total_credit);
        DBMS_OUTPUT.PUT_LINE('Cost per Credit: ' || prog_rec.per_credit_cost);
        DBMS_OUTPUT.PUT_LINE('Duration: ' || prog_rec.program_duration);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/

--11.Question: Write a PL/SQL block using CASE statement to display evaluation result for application ID 703.
DECLARE
    v_status Evaluation.final_status%TYPE;
BEGIN
    SELECT final_status
    INTO v_status
    FROM Evaluation
    WHERE application_id = 703;

    CASE v_status
        WHEN 'Passed' THEN
            DBMS_OUTPUT.PUT_LINE('Result: PASSED');
        WHEN 'Waiting' THEN
            DBMS_OUTPUT.PUT_LINE('Result: WAITING');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Result: FAILED');
    END CASE;
END;
/

--12. Question: Write a PL/SQL block to check the admission eligibility of an applicant based on their HSC and SSC GPA which id is 1003.
DECLARE
    v_hsc_gpa      Applicant.hsc_result%TYPE;
    v_ssc_gpa      Applicant.ssc_result%TYPE;
    v_eligibility  VARCHAR2(50);
BEGIN
    SELECT hsc_result, ssc_result
    INTO v_hsc_gpa, v_ssc_gpa
    FROM Applicant
    WHERE applicant_id = 1003;

    IF v_hsc_gpa >= 3.50 AND v_ssc_gpa >= 3.50 THEN
        v_eligibility := 'Eligible for Admission';
    ELSE
        v_eligibility := 'Not Eligible for Admission';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Applicant ID: 1001');
    DBMS_OUTPUT.PUT_LINE('HSC GPA: ' || v_hsc_gpa);
    DBMS_OUTPUT.PUT_LINE('SSC GPA: ' || v_ssc_gpa);
    DBMS_OUTPUT.PUT_LINE('Admission Status: ' || v_eligibility);
END;
/



--13. Question: Write a PL/SQL block using multiple-row subquery to display applicants who applied to Computer Science department.
DECLARE
    v_name Applicant.applicant_name%TYPE;
BEGIN
    FOR r IN (
        SELECT applicant_name
        FROM Applicant
        WHERE applicant_id IN (
            SELECT applicant_id
            FROM Application
            WHERE dept_id = 1
        )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Applicant: ' || r.applicant_name);
    END LOOP;
END;
/

--14.Write a PL/SQL block using a multiple-column subquery to display the applicant name, student ID, department name, and program name for applicant ID 1001.

DECLARE
    v_applicant_name Applicant.applicant_name%TYPE;
    v_student_id     Student.student_id%TYPE;
    v_dept_name      Department.dept_name%TYPE;
    v_program_name   Program.program_name%TYPE;
BEGIN
    SELECT a.applicant_name, s.student_id, d.dept_name, p.program_name
    INTO v_applicant_name, v_student_id, v_dept_name, v_program_name
    FROM Applicant a, Student s, Department d, Program p
    WHERE (s.applicant_id, s.dept_id, s.program_id) = (
        SELECT applicant_id, dept_id, program_id
        FROM Student
        WHERE applicant_id = 1001
    )
    AND a.applicant_id = s.applicant_id
    AND d.dept_id = s.dept_id
    AND p.program_id = s.program_id;

    DBMS_OUTPUT.PUT_LINE('Applicant Name: ' || v_applicant_name);
    DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_student_id);
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
    DBMS_OUTPUT.PUT_LINE('Program: ' || v_program_name);
END;
/



--15. Question: Write a PL/SQL block to display the names of all students along with their corresponding department name and program name.


BEGIN
    FOR rec IN (
        SELECT a.applicant_name AS student_name,
               d.dept_name,
               p.program_name
        FROM Student s
        LEFT JOIN Applicant a ON s.applicant_id = a.applicant_id
        LEFT JOIN Department d ON s.dept_id = d.dept_id
        LEFT JOIN Program p ON s.program_id = p.program_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Student Name: ' || rec.student_name);
        DBMS_OUTPUT.PUT_LINE('Department: ' || NVL(rec.dept_name, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Program: ' || NVL(rec.program_name, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
    END LOOP;
END;
/

--16.Question: Write a PL/SQL block to display each applicant’s ID and name along with their evaluation details: written marks, viva marks, total marks (sum of written and viva), and final status.

BEGIN
    FOR rec IN (
        SELECT a.applicant_id,
               a.applicant_name,
               e.written_marks,
               e.viva_marks,
               (e.written_marks + e.viva_marks) AS total_marks,
               e.final_status
        FROM Applicant a
        INNER JOIN Application ap ON a.applicant_id = ap.applicant_id
        INNER JOIN Evaluation e ON ap.application_id = e.application_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Applicant ID: ' || rec.applicant_id);
        DBMS_OUTPUT.PUT_LINE('Name: ' || rec.applicant_name);
        DBMS_OUTPUT.PUT_LINE('Written Marks: ' || rec.written_marks);
        DBMS_OUTPUT.PUT_LINE('Viva Marks: ' || rec.viva_marks);
        DBMS_OUTPUT.PUT_LINE('Total Marks: ' || rec.total_marks);
        DBMS_OUTPUT.PUT_LINE('Final Status: ' || rec.final_status);
        DBMS_OUTPUT.PUT_LINE('-------------------------------');
    END LOOP;
END;
/


