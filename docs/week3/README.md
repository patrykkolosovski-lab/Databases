# Week 3: implementation and SQL queries

We converted the four entities in the Week 2 ERD into MySQL tables. Each prescription connects one student, one doctor and one drug. The primary keys identify records, and the foreign keys prevent prescriptions from referring to missing records. The full attribute and constraint explanation is in [SCHEMA.md](../../SCHEMA.md).

## Requirements

- MySQL Server 8.0.16 or later, running locally or on a server you can access. MySQL 8.4 is suitable.
- A MySQL account that can create a database and tables, insert and modify rows, and run queries.
- MySQL's command-line client, or MySQL Workbench for running the same scripts.

No Python or additional library is required to use the database. Python 3 is only needed for the optional automated verification script.

## Set up a fresh Week 3 database

Run the following from the repository root. Replace `YOUR_USER` with your MySQL username. `-p` prompts for the password; do not put passwords in the repository. Add `-h HOST -P PORT` to each MySQL command if your server is remote.

```sh
mysql -u YOUR_USER -p -e "CREATE DATABASE student_prescriptions_week3 CHARACTER SET utf8mb4;"
mysql -u YOUR_USER -p student_prescriptions_week3 < sql/01_schema.sql
mysql -u YOUR_USER -p student_prescriptions_week3 < sql/02_mock_data.sql
mysql -u YOUR_USER -p student_prescriptions_week3 < sql/03_basic_operations.sql
mysql -u YOUR_USER -p student_prescriptions_week3 < sql/04_advanced_queries.sql
```

Create the schema and load the mock data once in an empty database. If the database or tables already exist, use a new database name for a fresh run. This setup does not delete an existing database.

In Workbench, create/select the database, then open and run the four numbered files in the same order. Run the entire basic-operations file in one connection so its transaction and generated-ID variables remain available.

The Week 5 script is separate and drops/recreates these four tables. Do not run it in this Week 3 database if you want to reproduce the results below.

## Mock data and basic operations

The data contains 8 students, 4 doctors, 4 fictional drug products and 13 prescriptions. It uses plausible names, programmes, dates and event patterns, but does not represent real patients or clinical recommendations. Students 7 and 8 have no prescriptions, doctor 4 and drug 4 have no prescriptions, and several students receive repeat prescriptions. Two prescriptions for student 6 share a date, which tests the latest-record query. One dose is 2.50, which tests decimal storage.

The basic-operations script:

1. Inserts a student and a prescription using the generated IDs.
2. Reads the inserted prescription.
3. Updates its quantity from 14 to 28 and reads it again.
4. Deletes the prescription before deleting its student, respecting the foreign keys.
5. Shows that no demonstration student remains, then rolls back the transaction.

The original rows remain unchanged. Auto-increment counters can advance during the demonstration even after rollback, so gaps in later generated IDs are normal.

## Advanced queries and expected results

| Query | Question | SQL features | Expected result on Week 3 mock data |
| --- | --- | --- | --- |
| 1 | What is each student's prescription history? | JOINs across all four tables, ORDER BY | 13 prescription rows, including the student, doctor and drug names. |
| 2 | Which drugs have at least four prescriptions? | GROUP BY, COUNT, COUNT DISTINCT, SUM, HAVING | Drug 3: 5 prescriptions, 3 students, 102 tablets; drug 1: 4, 3, 88; drug 2: 4, 3, 98. |
| 3 | Which registered students have no prescriptions? | Correlated NOT EXISTS | Students 7 (Amira Hassan) and 8 (Oliver Peters). |
| 4 | What is each prescribed student's latest prescription? | CTE, ROW_NUMBER, PARTITION BY | Prescription IDs 11, 8, 9, 10, 12 and 13 for students 1–6 respectively. |

Query 4 resolves equal dates by selecting the higher prescription ID. This gives a deterministic result; it does not establish which event happened later within that day. Students without prescriptions are intentionally absent from that query and appear in Query 3.

Prescription counts and total tablet quantities describe recorded activity. They do not establish misuse, clinical appropriateness or actual consumption. Different products and strengths are not clinically comparable solely by tablet count.

## Validation

[RESULTS.md](RESULTS.md) contains actual outputs from a fresh MySQL 8.4.0 run, including the CRUD demonstration, all four advanced queries and rejected invalid records. Schema creation, row counts, fractional-dose preservation, deterministic date ties, and 11 constraint rejection checks passed.

The optional verifier uses Python 3 and the mysql client. It creates a uniquely named temporary database and removes only that database when finished. It needs permission to create and drop its test database. Configure a local MySQL login path first, because the verifier opens several connections and does not handle interactive password prompts:

```sh
mysql_config_editor set --login-path=week3 --host=localhost --user=YOUR_USER --password
python3 tools/verify_week3.py --login-path=week3
```

The login configuration stays on your machine. The verifier writes fresh outputs to `docs/week3/RESULTS.md`.
