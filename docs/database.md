# Database reference

[Back to README](../README.md)

This reference describes the implemented Oracle schema. Column types, nullability, and constraints below are extracted from the table definitions in [`01_schema_and_seed.sql`](../sql/01_schema_and_seed.sql). Primary keys are implicitly non-null.


## Admin

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `admin_id` | `NUMBER` | PRIMARY KEY |
| `admin_name` | `VARCHAR2(100)` | NOT NULL |
| `admin_address` | `VARCHAR2(200)` | Nullable |
| `admin_ph1` | `VARCHAR2(15)` | Nullable |
| `admin_ph2` | `VARCHAR2(15)` | Nullable |
| `admin_email` | `VARCHAR2(100)` | UNIQUE |
| `admin_password` | `VARCHAR2(100)` | NOT NULL |

## Applicant

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `applicant_id` | `NUMBER` | PRIMARY KEY |
| `applicant_name` | `VARCHAR2(100)` | NOT NULL |
| `fathers_name` | `VARCHAR2(100)` | Nullable |
| `mothers_name` | `VARCHAR2(100)` | Nullable |
| `nationality` | `VARCHAR2(50)` | Nullable |
| `religion` | `VARCHAR2(50)` | Nullable |
| `college_name` | `VARCHAR2(150)` | Nullable |
| `hsc_result` | `NUMBER(3,2)` | Nullable |
| `school_name` | `VARCHAR2(150)` | Nullable |
| `ssc_result` | `NUMBER(3,2)` | Nullable |
| `applicant_email` | `VARCHAR2(100)` | UNIQUE |
| `applicant_ph1` | `VARCHAR2(15)` | Nullable |
| `applicant_ph2` | `VARCHAR2(15)` | Nullable |
| `applicant_password` | `VARCHAR2(100)` | NOT NULL |
| `applicant_dob` | `DATE` | Nullable |
| `applicant_address` | `VARCHAR2(200)` | Nullable |

## Department

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `dept_id` | `NUMBER` | PRIMARY KEY |
| `dept_name` | `VARCHAR2(100)` | UNIQUE |

## Program

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `program_id` | `NUMBER` | PRIMARY KEY |
| `program_name` | `VARCHAR2(150)` | Nullable |
| `total_credit` | `NUMBER(4)` | Nullable |
| `per_credit_cost` | `NUMBER(10,2)` | Nullable |
| `program_duration` | `VARCHAR2(50)` | Nullable |
| `dept_id` | `NUMBER` | Nullable; FK → `Department(dept_id)` |

## Teacher

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `teacher_id` | `NUMBER` | PRIMARY KEY |
| `teacher_name` | `VARCHAR2(100)` | Nullable |
| `teacher_ph1` | `VARCHAR2(15)` | Nullable |
| `teacher_ph2` | `VARCHAR2(15)` | Nullable |
| `teacher_email` | `VARCHAR2(100)` | UNIQUE |
| `teacher_password` | `VARCHAR2(100)` | NOT NULL |
| `dept_id` | `NUMBER` | Nullable; FK → `Department(dept_id)` |

## Application

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `application_id` | `NUMBER` | PRIMARY KEY |
| `apply_date` | `DATE` | Nullable |
| `status` | `VARCHAR2(30)` | Nullable |
| `admin_id` | `NUMBER` | Nullable; FK → `Admin(admin_id)` |
| `applicant_id` | `NUMBER` | Nullable; FK → `Applicant(applicant_id)` |
| `dept_id` | `NUMBER` | Nullable; FK → `Department(dept_id)` |

## Student

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `student_id` | `NUMBER` | PRIMARY KEY |
| `student_email` | `VARCHAR2(100)` | UNIQUE |
| `student_password` | `VARCHAR2(100)` | NOT NULL |
| `admission_date` | `DATE` | Nullable |
| `applicant_id` | `NUMBER` | Nullable; FK → `Applicant(applicant_id)` |
| `dept_id` | `NUMBER` | Nullable; FK → `Department(dept_id)` |
| `program_id` | `NUMBER` | Nullable; FK → `Program(program_id)` |

## Payment

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `payment_id` | `NUMBER` | PRIMARY KEY |
| `payment_amount` | `NUMBER(10,2)` | Nullable |
| `payment_method` | `VARCHAR2(30)` | Nullable |
| `payment_type` | `VARCHAR2(30)` | Nullable |
| `payment_date` | `DATE` | Nullable |
| `application_id` | `NUMBER` | Nullable; FK → `Application(application_id)` |

## Evaluation

| Column | Oracle type | Constraints |
| --- | --- | --- |
| `evaluation_id` | `NUMBER` | PRIMARY KEY |
| `written_marks` | `NUMBER(5,2)` | Nullable |
| `viva_marks` | `NUMBER(5,2)` | Nullable |
| `final_status` | `VARCHAR2(30)` | Nullable |
| `application_id` | `NUMBER` | Nullable; FK → `Application(application_id)` |
| `teacher_id` | `NUMBER` | Nullable; FK → `Teacher(teacher_id)` |
| `admin_id` | `NUMBER` | Nullable; FK → `Admin(admin_id)` |

## Relationships

- `Application` references `Applicant`, `Admin`, and `Department`.
- `Program` and `Teacher` reference `Department`.
- `Payment` references `Application`.
- `Evaluation` references `Application`, `Teacher`, and `Admin`.
- `Student` references `Applicant`, `Department`, and `Program`.

The ER diagram describes intended business cardinalities. A foreign key by itself does not enforce one-to-one relationships or mandatory participation.

## Sequences

| Sequence | Starting value |
| --- | ---: |
| `admin_seq` | 1 |
| `applicant_seq` | 1001 |
| `dept_seq` | 1 |
| `application_seq` | 701 |
| `program_seq` | 2001 |
| `teacher_seq` | 1001 |
| `student_seq` | 3001 |
| `payment_seq` | 9001 |
| `evaluation_seq` | 3301 |

All increment by 1 and use `NOCACHE NOCYCLE`. Inserts use explicit IDs; no column default or ID-generating trigger consumes these sequences.

## Design notes and known gaps

These observations describe the current coursework scripts; they are not implemented fixes.

1. **One-to-one rules:** the report describes one payment and one evaluation per application, and at most one student per applicant. `Payment.application_id`, `Evaluation.application_id`, and `Student.applicant_id` have no unique constraint, so the database permits multiple matches.
2. **Required relationships:** foreign keys are nullable. The schema permits records without links that the conceptual workflow expects.
3. **Department consistency:** both `Student.dept_id` and `Program.dept_id` are stored. No constraint ensures a student's department matches the department of their program.
4. **Phone numbers:** the implementation stores two fixed phone columns for admins, teachers, and applicants. The diagrams use a single multivalued phone attribute. A separate phone relation would support an arbitrary number of phones.
5. **Validation:** there are no check constraints for GPA ranges, marks, positive payment amounts, or allowed status values.
6. **Result consistency:** seed application `706` has 55 written marks and 5 viva marks, but its evaluation status is `Waiting`. The basic PL/SQL example classifies totals of 60 or above as `PASSED`. Stored status and calculated status can therefore disagree.
7. **Sequence alignment:** seed IDs overlap sequence starting values. Using the first `NEXTVAL` after setup can collide with an existing primary key.
8. **Lookup cardinality:** `applicant_payment_pkg.show_payment_info` selects into scalar variables despite the model allowing multiple applications per applicant. The student-evaluation package also uses a scalar application subquery. Multiple matching records can raise errors; exception handlers do not resolve the ambiguity.
9. **Cursor coverage:** the teacher-evaluation and rejected-application cursor examples fetch one row rather than looping through all matches.
10. **Trigger behavior:** messages go to `DBMS_OUTPUT`, not a durable audit table. `OLD.status <> NEW.status` does not detect transitions involving `NULL`. A statement-level message is not proof that a row was changed or a transaction committed.
11. **Credentials and privileges:** sample passwords are plain text. The archived setup notes grant privileges beyond what the project needs; the setup guide uses narrower owner-schema grants.
12. **Exception behavior:** some handlers print errors or return `-1` rather than propagating failure to a caller. Client code must account for those conventions.

The project report is preserved as submitted, including its original table of contents and claims. Its table-of-contents page numbers do not track all later sections in the 98-page PDF. The executable SQL is the reference for the implemented schema.
