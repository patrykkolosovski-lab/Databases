# Student Prescription Database

A relational database project tracking prescriptions for study drugs (e.g. Adderall, Ritalin) among university students.

---

## Project Overview

* **Week 1:** Problem definition
* **Week 2:** ERD and normalization
* **Week 3:** Relational schema and test queries
  * [`SCHEMA.md`](SCHEMA.md) – relational schema and constraints
  * [`sql/01_schema.sql`](sql/01_schema.sql) – table creation and constraints
  * [`sql/02_mock_data.sql`](sql/02_mock_data.sql) – initial small test data
  * [`sql/03_basic_operations.sql`](sql/03_basic_operations.sql) – basic queries (INSERT, UPDATE, DELETE)
  * [`sql/04_advanced_queries.sql`](sql/04_advanced_queries.sql) – advanced queries (JOINs, aggregations, window functions)
* **Week 4:** Stakeholder video presentation
* **Week 5:** Real-world data integration & testing
  * [`sql/05_real_world_data.sql`](sql/05_real_world_data.sql) – real datasets (>50 rows per dataset)

---

## Week 5: Real-World Data Integration

### 1. Data Sources
We selected two complementary datasets ($A \not\subseteq B$) to test our schema:

1. **Dataset 1: FDA Approved Drug Products (NDC Directory)**
   * **Source:** U.S. FDA Open Data
   * **License:** Public Domain
   * **Usage:** Populates `StudyDrug` (52 rows). Contains real medication names (Adderall XR, Concerta, Vyvanse, Modafinil) and their pharmaceutical manufacturers.

2. **Dataset 2: Student Health & Prescription Records (Synthea Open Cohort)**
   * **Source:** Synthea Open Health Records
   * **License:** CC-BY 4.0
   * **Usage:** Populates `Student` (60 rows), `Doctor` (12 rows), and `Prescription` (75 rows).

### 2. Data Cleaning & Transformation
Before loading the data into MySQL, we cleaned and formatted it:
* **Missing data:** Any raw prescription entries with missing dosages or tablet quantities were removed, since our schema requires `NOT NULL` and positive values.
* **Dates:** All dates were formatted to SQL standard `YYYY-MM-DD`.
* **Duplicates:** Repeated drug entries with different package IDs were deduplicated so that each drug name and producer pair is unique.
* **Inconsistent naming:** Capitalization and spelling for doctor departments and drug names were standardized.

### 3. Schema & Normalization Check (3NF)
* All data satisfies our table constraints:
  * Student age: 16–100
  * Doctor age: 23–100
  * Study year: 1–8
  * Dosage and tablet quantity: > 0
* The database remains in **3NF** — each non-key attribute depends only on the primary key, and there are no transitive dependencies.

### 4. Query Testing
We ran the 4 queries from Week 3 (`04_advanced_queries.sql`) on the new data:
* **Query 1 (History JOIN):** Correctly lists all prescriptions with student, doctor, and drug names.
* **Query 2 (Frequent drugs):** Groups drugs with $\ge 4$ prescriptions and sums total tablets.
* **Query 3 (Students without prescriptions):** Successfully finds students in the registry who have not been prescribed any medication.
* **Query 4 (Latest prescription per student):** Uses `ROW_NUMBER()` to return only the most recent prescription for each student.
