# Oracle setup and execution

[Back to README](../README.md)

## Prerequisites

- An Oracle Database instance that you can connect to.
- SQL Developer, SQLcl, or SQL*Plus.
- An administrator who can create a project user and assign a tablespace quota.

The repository does not provision Oracle or specify an exact tested server version. Host, port, service name, and tablespace depend on your installation. On a multitenant installation, create the project user in the intended pluggable database (PDB).

## 1. Create a dedicated schema

Connect as an administrator to the intended database/PDB. Replace the password below before running. `USERS` must be an existing permanent tablespace; substitute the appropriate tablespace if necessary.

```sql
CREATE USER UAMSP
    IDENTIFIED BY "REPLACE_WITH_YOUR_OWN_PASSWORD"
    DEFAULT TABLESPACE USERS
    QUOTA 50M ON USERS;

GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE,
      CREATE PROCEDURE, CREATE TRIGGER
TO UAMSP;
```

These grants support the supplied scripts in the user's own schema. Packages and functions use the `CREATE PROCEDURE` privilege.

The [original classroom setup notes](reference/original_user_setup.txt) are retained for historical reference. They mix administrator, owner, and test-user actions, grant broad `ANY TABLE` privileges, and include prose and a missing statement terminator. They are not a script to execute end-to-end.

## 2. Connect as UAMSP

Create a connection using your local connection details. For SQL*Plus or SQLcl, enter the password interactively rather than placing it in shell history:

```text
sqlplus UAMSP@//HOST:PORT/SERVICE_NAME
```

Start your command-line client from the repository root so relative script paths resolve. In SQL Developer, choose the UAMSP connection when opening the files.

## 3. Create tables and load sample data

```sql
SET SERVEROUTPUT ON;
@sql/01_schema_and_seed.sql
```

This creates nine sequences and nine tables, inserts the sample data, commits it, and prints table descriptions and contents. Run it only once in an empty project schema. Rerunning it produces existing-object and duplicate-key errors.

## 4. Run the exercises

```sql
@sql/02_basic_plsql.sql
@sql/03_advanced_plsql.sql
@sql/04_exception_handling.sql
```

For SQL Developer, execute each file with **F5 / Run Script** and enable DBMS Output. The `/` delimiters submit PL/SQL blocks in script mode.

- Basic examples use the seeded IDs and print query results.
- Advanced examples define objects and invoke demonstration blocks. The application-status example issues an `UPDATE`; it does not explicitly commit that update.
- The exception-handling file uses `CREATE OR REPLACE` for the same named objects. Run it last to keep those versions installed.
- Some handlers report errors through `DBMS_OUTPUT` or return `-1`. Review output as well as compilation errors; completing a script does not prove every example succeeded.

## Verify the installation

```sql
SELECT table_name FROM user_tables ORDER BY table_name;

SELECT 'ADMIN' AS table_name, COUNT(*) AS row_count FROM Admin
UNION ALL SELECT 'APPLICANT', COUNT(*) FROM Applicant
UNION ALL SELECT 'DEPARTMENT', COUNT(*) FROM Department
UNION ALL SELECT 'PROGRAM', COUNT(*) FROM Program
UNION ALL SELECT 'TEACHER', COUNT(*) FROM Teacher
UNION ALL SELECT 'APPLICATION', COUNT(*) FROM Application
UNION ALL SELECT 'PAYMENT', COUNT(*) FROM Payment
UNION ALL SELECT 'EVALUATION', COUNT(*) FROM Evaluation
UNION ALL SELECT 'STUDENT', COUNT(*) FROM Student;

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('FUNCTION', 'PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER')
ORDER BY object_type, object_name;

SELECT name, type, line, position, text
FROM user_errors
ORDER BY name, sequence;

SELECT total_depts() AS department_count FROM dual;
SELECT calculate_total_score(701) AS application_701_score FROM dual;
```

Expected values from the supplied seed data:

| Table | Rows |
| --- | ---: |
| Admin | 5 |
| Applicant | 10 |
| Department | 5 |
| Program | 5 |
| Teacher | 5 |
| Application | 10 |
| Payment | 10 |
| Evaluation | 7 |
| Student | 5 |
| **Total** | **62** |

`total_depts()` should return **5**, and `calculate_total_score(701)` should return **90**. These expectations are derived from source data, not a fresh Oracle test run.

## Optional read-only role demonstration

After the tables exist, an administrator can create a role and a separate test account:

```sql
CREATE ROLE UAMS_READONLY;
CREATE USER UAMS_READER IDENTIFIED BY "REPLACE_WITH_ANOTHER_PASSWORD";
GRANT CREATE SESSION TO UAMS_READER;
GRANT UAMS_READONLY TO UAMS_READER;
```

Then connect as **UAMSP**, the table owner:

```sql
GRANT SELECT ON Admin TO UAMS_READONLY;
GRANT SELECT ON Applicant TO UAMS_READONLY;
GRANT SELECT ON Department TO UAMS_READONLY;
GRANT SELECT ON Program TO UAMS_READONLY;
GRANT SELECT ON Teacher TO UAMS_READONLY;
GRANT SELECT ON Application TO UAMS_READONLY;
GRANT SELECT ON Payment TO UAMS_READONLY;
GRANT SELECT ON Evaluation TO UAMS_READONLY;
GRANT SELECT ON Student TO UAMS_READONLY;
```

Connect as **UAMS_READER** and verify:

```sql
SELECT * FROM USER_ROLE_PRIVS;
SELECT applicant_id, applicant_name FROM UAMSP.Applicant;
```

This demonstration grants access to complete tables, including their sample credential columns. A real application should expose only the required columns through an appropriate access design.

## Common issues

| Symptom | Check |
| --- | --- |
| No printed PL/SQL messages | Enable `SERVEROUTPUT` or the connection's DBMS Output panel |
| User creation fails in a multitenant database | Connect to the intended PDB, rather than the root container |
| Insufficient privileges or tablespace quota | Check the account grants and quota with your administrator |
| Existing objects or duplicate seed keys | Use a fresh dedicated schema; the setup is not repeatable in place |
| Invalid procedure/package/trigger | Inspect `USER_ERRORS` for compilation details |
| Multiple rows returned by a lookup | Several exercises assume one application/payment per applicant; see the design notes |

Do not use a sequence's initial `NEXTVAL` to add new records after seeding without first reconciling its value with the existing IDs.
