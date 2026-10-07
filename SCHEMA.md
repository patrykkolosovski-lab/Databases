# Relational schema

`PK` = primary key; `FK` = foreign key. All attributes are required.

- **Student** (**student_id** PK, program_name, study_year, name, age)
- **StudyDrug** (**drug_id** PK, drug_producer, drug_name)
- **Doctor** (**doctor_id** PK, role, department, name, age)
- **Prescription** (**prescription_id** PK, student_id FK → Student.student_id, drug_id FK → StudyDrug.drug_id, doctor_id FK → Doctor.doctor_id, prescription_date, dose_mg, quantity_tablets)

Each prescription refers to exactly one student, one drug and one doctor. Each student, drug and doctor can have multiple prescriptions. Parents may exist before their first prescription. A minimum of one child is not enforced by these foreign keys.

Assumed validation rules: student ages 16–100, doctor ages 23–100, study years 1–8, and positive doses and tablet quantities. Parent deletion is restricted while a prescription references it.

## Types and implementation

The executable definition is [sql/01_schema.sql](sql/01_schema.sql). It targets MySQL 8.0.16 or later, uses InnoDB for foreign-key enforcement, and uses utf8mb4 for international names. [MySQL documentation](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html) explains the minimum version needed for enforced CHECK constraints.

| Attributes | Type | Reason |
| --- | --- | --- |
| Each primary ID | `INT UNSIGNED AUTO_INCREMENT` | Stable generated identifier; explicit IDs are used in the mock examples. |
| Prescription foreign IDs | `INT UNSIGNED` | Same type as the referenced primary keys. |
| Names, programme, producer, role and department | `VARCHAR(100)` | Bounded text rather than the unsupported MySQL `STRING` type. |
| Age and study year | `INT UNSIGNED` | Whole numbers with explicit range checks. |
| Prescription date | `DATE` | A calendar date, entered as `YYYY-MM-DD`. |
| Dose in milligrams | `DECIMAL(6,2)` | Exact values with two decimal places, including fractional doses. |
| Tablet quantity | `INT UNSIGNED` | A positive whole number. |

All fields are `NOT NULL` (primary keys are implicitly required). `UNIQUE (drug_producer, drug_name)` prevents duplicate product definitions under the Week 2 product assumption. This is a database modelling rule, not a statement that all real products are uniquely identified by those labels.

Foreign keys use `ON DELETE RESTRICT ON UPDATE RESTRICT`. A referenced student, doctor or drug cannot be deleted or have its ID changed while prescriptions refer to it. Unreferenced parent rows are allowed, which matches the ERD's zero-or-many participation. Each prescription row requires all three parent references.

## Consistency with Week 2

The four stored tables and their attributes match [Week2.pdf](docs/week2/Week2.pdf). StudentReport and DoctorReport are calculated outputs, not stored entities. Age is maintained as a current recorded value; dates of birth and historical programme or department changes are outside this version's scope. Multiple prescriptions for the same student and drug are allowed because each event has its own primary key.
