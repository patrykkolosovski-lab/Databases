# Week 3: relational schema

PK = primary key; FK = foreign key. All fields are required.

- **Student:** student_id (PK), program_name, study_year, name, age.
- **StudyDrug:** drug_id (PK), drug_producer, drug_name.
- **Doctor:** doctor_id (PK), role, department, name, age.
- **Prescription:** prescription_id (PK), student_id (FK), drug_id (FK), doctor_id (FK), prescription_date, dose_mg, quantity_tablets.

Each prescription refers to one student, drug and doctor; each of these can have zero or many prescriptions. IDs use unsigned integers, text uses VARCHAR(100), dates use DATE, and doses use DECIMAL(6,2).

Constraints: student age 16–100, doctor age 23–100, study year 1–8, positive dose and quantity, unique drug name–producer pairs, and restricted deletion of referenced parent rows.

Use MySQL 8.0.16+ and run [schema](../../sql/01_schema.sql), [mock data](../../sql/02_mock_data.sql), [basic operations](../../sql/03_basic_operations.sql), then [advanced queries](../../sql/04_advanced_queries.sql) in a fresh database.
