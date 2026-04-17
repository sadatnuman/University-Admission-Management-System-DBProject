-- ========================================================================
-- FUNCTION
-- ========================================================================

-- 1. Create and call a PL/SQL stored function that returns the total number of departments.

CREATE OR REPLACE FUNCTION total_depts
RETURN NUMBER
AS
    total NUMBER(4) := 0;
BEGIN
    SELECT COUNT(*) INTO total
    FROM Department;
    RETURN total;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN -1;
END;
/

DECLARE 
    c NUMBER(4); 
BEGIN 
    c := total_depts;
    IF c = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Function execution failed.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total number of departments: ' || c);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calling block: ' || SQLERRM);
END;
/


-- 2. Create and call a PL/SQL stored function that returns the total marks of an application.

CREATE OR REPLACE FUNCTION calculate_total_score (
    app_id IN Evaluation.application_id%TYPE
)
RETURN NUMBER
AS
    written Evaluation.written_marks%TYPE;
    viva    Evaluation.viva_marks%TYPE;
    total   NUMBER(5, 2);
BEGIN
    SELECT written_marks, viva_marks
    INTO written, viva
    FROM Evaluation
    WHERE application_id = app_id;
    total := written + viva;
    RETURN total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No evaluation found for application ' || app_id);
        RETURN -1;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple evaluations found for application ' || app_id);
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN -1;
END calculate_total_score;
/

DECLARE
    a_id NUMBER := 701; 
    total_marks NUMBER;
BEGIN
    total_marks := calculate_total_score(app_id => a_id);
    IF total_marks = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Failed to calculate total score.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total Score for Application ' || a_id || ' is: ' || total_marks);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calling block: ' || SQLERRM);
END;
/


-- ========================================================================
-- PROCEDURE
-- ========================================================================

-- 3. Create and call a PL/SQL stored procedure that takes an app_id and a updated_status as parameters and updates the status of the applicant's record in the Application table.

CREATE OR REPLACE PROCEDURE update_application_status (
    app_id IN Application.application_id%TYPE,
    updated_status IN Application.status%TYPE
)
AS
    e_no_record EXCEPTION;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Application
    WHERE application_id = app_id;
    
    IF v_count = 0 THEN
        RAISE e_no_record;
    END IF;
    
    UPDATE Application
    SET status = updated_status
    WHERE application_id = app_id;
    DBMS_OUTPUT.PUT_LINE('Success: Application ' || app_id || ' status updated to ' || updated_status || '.');
EXCEPTION
    WHEN e_no_record THEN
        DBMS_OUTPUT.PUT_LINE('Error: Application ' || app_id || ' does not exist.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END update_application_status;
/

DECLARE
    a_id CONSTANT NUMBER := 702;
BEGIN
    update_application_status(
        app_id         => a_id,
        updated_status => 'Accept'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calling block: ' || SQLERRM);
END;
/


-- 4. Create a PL/SQL stored procedure that validates the admin login and test it with both right and wrong passwords for admin Rubana Newaz.

CREATE OR REPLACE PROCEDURE validate_admin_login (
    a_email IN Admin.admin_email%TYPE,
    a_password IN Admin.admin_password%TYPE,
    is_valid OUT VARCHAR2
)
AS
    ad_id Admin.admin_id%TYPE;
BEGIN
    SELECT admin_id INTO ad_id
    FROM Admin
    WHERE admin_email = a_email AND admin_password = a_password;
    is_valid := 'Success';
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        is_valid := 'Failed';
    WHEN TOO_MANY_ROWS THEN
        is_valid := 'Error: Multiple records found';
    WHEN OTHERS THEN
        is_valid := 'Error: ' || SQLERRM;
END validate_admin_login;
/

DECLARE
    message VARCHAR2(100);
BEGIN
    -- Right password
    validate_admin_login(
        a_email    => 'rubananewaz@aiub.edu',
        a_password => '1234',
        is_valid   => message
    );
    DBMS_OUTPUT.PUT_LINE('Login ' || message);

    -- Wrong password
    validate_admin_login(
        a_email    => 'rubananewaz@aiub.edu',
        a_password => '1235',
        is_valid   => message
    );
    DBMS_OUTPUT.PUT_LINE('Login ' || message);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calling block: ' || SQLERRM);
END;
/


-- ========================================================================
-- TABLE-BASED RECORD
-- ========================================================================

-- 5. Display full information of a specific applicant using a table-based record from the Applicant table.

DECLARE
    app_rec Applicant%ROWTYPE;
BEGIN
    SELECT *
    INTO app_rec
    FROM Applicant
    WHERE applicant_id = 1001;

    DBMS_OUTPUT.PUT_LINE(
        app_rec.applicant_name || ' ' ||
        app_rec.applicant_email || ' ' ||
        app_rec.hsc_result || ' ' ||
        app_rec.applicant_address
    );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Applicant not found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple applicants found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- 6. Retrieve and display complete program details for a given program using a table-based record from the Program table.

DECLARE
    prog_rec Program%ROWTYPE;
BEGIN
    SELECT *
    INTO prog_rec
    FROM Program
    WHERE program_id = 2001;

    DBMS_OUTPUT.PUT_LINE(
        prog_rec.program_name || ' ' ||
        prog_rec.total_credit || ' ' ||
        prog_rec.per_credit_cost || ' ' ||
        prog_rec.program_duration
    );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Program not found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple programs found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- ========================================================================
-- EXPLICIT CURSOR
-- ========================================================================

-- 7. Display student admission information using an explicit cursor from the Student table.

DECLARE
    CURSOR c_student IS
        SELECT * FROM Student WHERE student_id = 3001;
    stu_rec Student%ROWTYPE;
    e_invalid_cursor EXCEPTION;
BEGIN
    OPEN c_student;
    FETCH c_student INTO stu_rec;
    
    IF c_student%NOTFOUND THEN
        RAISE e_invalid_cursor;
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        stu_rec.student_id || ' ' ||
        stu_rec.student_email || ' ' ||
        stu_rec.admission_date
    );

    CLOSE c_student;
EXCEPTION
    WHEN e_invalid_cursor THEN
        DBMS_OUTPUT.PUT_LINE('Error: Student record not found.');
        IF c_student%ISOPEN THEN
            CLOSE c_student;
        END IF;
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid cursor operation.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF c_student%ISOPEN THEN
            CLOSE c_student;
        END IF;
END;
/


-- 8. Retrieve application status details using an explicit cursor from the Application table.

DECLARE
    CURSOR c_app IS
        SELECT * FROM Application WHERE application_id = 701;
    app_rec Application%ROWTYPE;
    e_no_data EXCEPTION;
BEGIN
    OPEN c_app;
    FETCH c_app INTO app_rec;
    
    IF c_app%NOTFOUND THEN
        RAISE e_no_data;
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        app_rec.application_id || ' ' ||
        app_rec.apply_date || ' ' ||
        app_rec.status
    );

    CLOSE c_app;
EXCEPTION
    WHEN e_no_data THEN
        DBMS_OUTPUT.PUT_LINE('Error: Application record not found.');
        IF c_app%ISOPEN THEN
            CLOSE c_app;
        END IF;
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid cursor operation.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF c_app%ISOPEN THEN
            CLOSE c_app;
        END IF;
END;
/


-- ========================================================================
-- CURSOR-BASED RECORD
-- ========================================================================

-- 9. Display the applicant name, written marks, viva marks, and final evaluation status given by a specific teacher using a cursor-based record.

DECLARE
    CURSOR c_eval IS
        SELECT a.applicant_name,
               e.written_marks,
               e.viva_marks,
               e.final_status
        FROM Evaluation e
        JOIN Application ap ON e.application_id = ap.application_id
        JOIN Applicant a ON ap.applicant_id = a.applicant_id
        WHERE e.teacher_id = 1001;

    eval_rec c_eval%ROWTYPE;
    e_no_evaluation EXCEPTION;
BEGIN
    OPEN c_eval;
    FETCH c_eval INTO eval_rec;
    
    IF c_eval%NOTFOUND THEN
        RAISE e_no_evaluation;
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        eval_rec.applicant_name || ' ' ||
        eval_rec.written_marks || ' ' ||
        eval_rec.viva_marks || ' ' ||
        eval_rec.final_status
    );

    CLOSE c_eval;
EXCEPTION
    WHEN e_no_evaluation THEN
        DBMS_OUTPUT.PUT_LINE('Error: No evaluation found for teacher.');
        IF c_eval%ISOPEN THEN
            CLOSE c_eval;
        END IF;
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid cursor operation.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF c_eval%ISOPEN THEN
            CLOSE c_eval;
        END IF;
END;
/


-- 10. Display the applicant ID and applicant name whose applications were rejected by a specific admin using a cursor-based record.

DECLARE
    CURSOR c_reject IS
        SELECT a.applicant_id,
               a.applicant_name
        FROM Application ap
        JOIN Applicant a ON ap.applicant_id = a.applicant_id
        WHERE ap.status = 'Reject'
          AND ap.admin_id = 4;

    rej_rec c_reject%ROWTYPE;
    e_no_rejection EXCEPTION;
BEGIN
    OPEN c_reject;
    FETCH c_reject INTO rej_rec;
    
    IF c_reject%NOTFOUND THEN
        RAISE e_no_rejection;
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        rej_rec.applicant_id || ' ' ||
        rej_rec.applicant_name
    );

    CLOSE c_reject;
EXCEPTION
    WHEN e_no_rejection THEN
        DBMS_OUTPUT.PUT_LINE('Error: No rejected applications found for admin.');
        IF c_reject%ISOPEN THEN
            CLOSE c_reject;
        END IF;
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid cursor operation.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF c_reject%ISOPEN THEN
            CLOSE c_reject;
        END IF;
END;
/


-- ========================================================================
-- ROW LEVEL TRIGGER
-- ========================================================================

-- 11. Create a PL/SQL row level trigger that sends a notification message containing application id, old status and new status when the status of the application is updated.

CREATE OR REPLACE TRIGGER application_status_change
BEFORE UPDATE ON Application
FOR EACH ROW
WHEN (OLD.status <> NEW.status)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Application Status Changed!');
    DBMS_OUTPUT.PUT_LINE('Application ID: ' || :NEW.application_id);
    DBMS_OUTPUT.PUT_LINE('Old Status: ' || :OLD.status);
    DBMS_OUTPUT.PUT_LINE('New Status: ' || :NEW.status);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger: application_status_change');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
        RAISE;
END;
/



-- 12. Create a PL/SQL row level trigger that sends a notification message when new student is added.

CREATE OR REPLACE TRIGGER student_added
AFTER INSERT ON Student
FOR EACH ROW
WHEN (NEW.student_id > 0)
BEGIN
    DBMS_OUTPUT.PUT_LINE('New Student Added!');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger: student_added');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
        RAISE;
END;
/



-- ========================================================================
-- STATEMENT LEVEL TRIGGER
-- ========================================================================

-- 13. Create a PL/SQL statement level trigger that sends a notification message when an applicant is deleted.

CREATE OR REPLACE TRIGGER delete_alert
BEFORE DELETE ON Applicant
BEGIN
    DBMS_OUTPUT.PUT_LINE('Applicant is deleted permanently!');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger: delete_alert');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
        RAISE;
END;
/



-- 14. Create a statement-level trigger on the Payment table that automatically logs a message whenever any payment is inserted, updated, or deleted.

CREATE OR REPLACE TRIGGER payment_stmt_trigger
AFTER INSERT OR UPDATE OR DELETE ON Payment
BEGIN
    DBMS_OUTPUT.PUT_LINE('A statement affecting the Payment table has been executed.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Trigger: payment_stmt_trigger');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
        RAISE;
END;
/



-- ========================================================================
-- PACKAGE
-- ========================================================================

-- 15. Create a PL/SQL package that displays an applicant's ID, name and the corresponding payment amount and payment date of that applicant using applicant ID as input.

CREATE OR REPLACE PACKAGE applicant_payment_pkg AS
    PROCEDURE show_applicant_info(p_applicant_id Applicant.applicant_id%TYPE);
    PROCEDURE show_payment_info(p_applicant_id Applicant.applicant_id%TYPE);
END applicant_payment_pkg;
/

CREATE OR REPLACE PACKAGE BODY applicant_payment_pkg AS

    PROCEDURE show_applicant_info(p_applicant_id Applicant.applicant_id%TYPE) IS
        a_name Applicant.applicant_name%TYPE;
    BEGIN
        SELECT applicant_name 
        INTO a_name 
        FROM Applicant 
        WHERE applicant_id = p_applicant_id;

        DBMS_OUTPUT.PUT_LINE('Applicant ID: ' || p_applicant_id || ' Name: ' || a_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Applicant not found.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Multiple applicants found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END show_applicant_info;

    PROCEDURE show_payment_info(p_applicant_id Applicant.applicant_id%TYPE) IS
        p_amount Payment.payment_amount%TYPE;
        p_date   Payment.payment_date%TYPE;
    BEGIN
        SELECT pay.payment_amount, pay.payment_date
        INTO p_amount, p_date
        FROM Payment pay
        JOIN Application app ON pay.application_id = app.application_id
        WHERE app.applicant_id = p_applicant_id;

        DBMS_OUTPUT.PUT_LINE('Payment Amount: ' || p_amount || ' Payment Date: ' || p_date);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Payment not found for applicant.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Multiple payments found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END show_payment_info;

END applicant_payment_pkg;
/

BEGIN
    applicant_payment_pkg.show_applicant_info(1001);
    applicant_payment_pkg.show_payment_info(1001);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calling block: ' || SQLERRM);
END;
/


-- 16. Create a PL/SQL package that takes an applicant ID and displays the student's ID, student name, viva marks, written marks, department name, and program name.

CREATE OR REPLACE PACKAGE student_evaluation_pkg AS
    PROCEDURE show_student_evaluation(p_applicant_id Applicant.applicant_id%TYPE);
    FUNCTION get_total_marks(p_applicant_id Applicant.applicant_id%TYPE) RETURN NUMBER;
END student_evaluation_pkg;
/

CREATE OR REPLACE PACKAGE BODY student_evaluation_pkg AS

    PROCEDURE show_student_evaluation(p_applicant_id Applicant.applicant_id%TYPE) IS
        s_id      Student.student_id%TYPE;
        s_name    Applicant.applicant_name%TYPE;
        v_mark    Evaluation.viva_marks%TYPE;
        w_mark    Evaluation.written_marks%TYPE;
        d_name    Department.dept_name%TYPE;
        p_name    Program.program_name%TYPE;
    BEGIN
        SELECT s.student_id, a.applicant_name, e.viva_marks, e.written_marks, d.dept_name, pr.program_name
        INTO s_id, s_name, v_mark, w_mark, d_name, p_name
        FROM Student s
        JOIN Applicant a ON s.applicant_id = a.applicant_id
        JOIN Evaluation e ON e.application_id = (SELECT application_id FROM Application WHERE applicant_id = a.applicant_id)
        JOIN Department d ON s.dept_id = d.dept_id
        JOIN Program pr ON s.program_id = pr.program_id
        WHERE a.applicant_id = p_applicant_id;

        DBMS_OUTPUT.PUT_LINE('Student ID: ' || s_id || 
                             ', Name: ' || s_name || 
                             ', Viva Marks: ' || v_mark || 
                             ', Written Marks: ' || w_mark || 
                             ', Department: ' || d_name || 
                             ', Program: ' || p_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Student evaluation data not found.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Multiple records found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END show_student_evaluation;

    FUNCTION get_total_marks(p_applicant_id Applicant.applicant_id%TYPE) RETURN NUMBER IS
        total_marks NUMBER;
    BEGIN
        SELECT (e.viva_marks + e.written_marks)
        INTO total_marks
        FROM Evaluation e
        JOIN Application app ON e.application_id = app.application_id
        WHERE app.applicant_id = p_applicant_id;

        RETURN total_marks;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Evaluation not found.');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Multiple evaluations found.');
            RETURN -1;
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Error: Division by zero.');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RETURN -1;
    END get_total_marks;

END student_evaluation_pkg;
/

DECLARE
    t_marks NUMBER;
BEGIN
    student_evaluation_pkg.show_student_evaluation(1001);
    t_marks := student_evaluation_pkg.get_total_marks(1001);
    IF t_marks = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Failed to calculate total marks.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total Marks: ' || t_marks);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calling block: ' || SQLERRM);
END;
/
