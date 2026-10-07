
# Student Prescription Database

A relational database project tracking prescriptions for study drugs (e.g. Adderall, Ritalin) among university students.

---

## The Issue We Address

The societal problem we are investigating is the misuse of prescription "performance" drugs among university students.

Prescription stimulants such as Adderall, Ritalin or Medikinet are intended to treat conditions like ADHD. Their non-medical use as so-called "study drugs" raises concerns about student wellbeing and academic pressure, although prevalence estimates depend on the population and sampling method.

Our [Week 1 report](docs/week1/Week1.pdf) contains the societal problem definition and supporting literature.

As students ourselves, we experience the pressure to perform at the highest level almost every day. It is not uncommon to hear that someone we know has tried these substances to study longer or concentrate better.

---

## Why It Matters

This issue worries us in two ways:

- **Health risks:** we are concerned about friends and peers experimenting with substances that can have serious side effects when used without medical supervision.
- **Academic pressure:** students who do not use these drugs may fear falling behind academically. This creates a snowball effect in which more and more students feel pushed to use them.

Because these drugs are legally prescribed, it is important to understand how prescriptions are distributed: which students receive them, which doctors prescribe them, and how often.

---

## What Our Database Does

Our database is designed to track prescriptions of study drugs issued to university students. It describes prescription patterns; these records alone cannot establish misuse or whether treatment is clinically appropriate.

The database should be able to answer questions such as:

- Which study drugs are prescribed to students?
- Which producer manufactures each drug?
- Which students have received a prescription, and which have not?
- Which doctor issued a particular prescription?
- What dose and quantity of tablets was prescribed?
- What is the most recent prescription of each student?
- Which drugs are prescribed most frequently?
- Do prescription patterns differ between study programs or study years?

The main goal is to connect information about students, doctors and drugs, so that the use of study drugs can be examined in relation to academic pressure.

---

## Who Is Affected

The problem affects several groups:

- **Students**, who face academic pressure and potential health risks.
- **Professors and university staff**, who are responsible for fair assessment and student wellbeing.
- **Parents and families**, who worry about the health and choices of their children.
- **Doctors and healthcare providers**, who decide when these drugs are prescribed.
- **Employers**, since a culture of performance enhancement may carry over into the workplace.

---

## Data Model Overview

The database consists of the following main entities:

- **Student**: information about students, including study program, study year, name and age.
- **Doctor**: information about the doctors issuing prescriptions, including role and department.
- **StudyDrug**: information about prescription drugs and their producers.
- **Prescription**: records which doctor prescribed which drug to which student, including date, dose and number of tablets.

The main relationships are that **students receive prescriptions**, **doctors issue prescriptions**, and **each prescription refers to exactly one study drug**.

---

## Project Overview

* **Week 1:** [Societal problem and scientific literature report](docs/week1/Week1.pdf)

* **Week 2:** [ERD and normalization report](docs/week2/Week2.pdf)
  Includes the final Crow's foot ERD, scope and assumptions, and before-and-after examples for 1NF, 2NF and 3NF.

* **Week 3:** Relational schema and test queries
  * [Schema](docs/week3/SCHEMA.md) – relational schema and constraints
  * [`sql/01_schema.sql`](sql/01_schema.sql) – table creation and constraints
  * [`sql/02_mock_data.sql`](sql/02_mock_data.sql) – initial small test data
  * [`sql/03_basic_operations.sql`](sql/03_basic_operations.sql) – basic queries (INSERT, UPDATE, DELETE)
  * [`sql/04_advanced_queries.sql`](sql/04_advanced_queries.sql) – advanced queries (JOINs, aggregations, window functions)
    
* **Week 4:** [Stakeholder video presentation](docs/week4/Week4.mp4)

https://github.com/user-attachments/assets/6ab59ed9-3a44-402c-9038-be4cdf5bed6b

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
