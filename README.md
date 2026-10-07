
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
  * [Report](docs/week5/Week5.tex), [source data](data/week5), [import](sql/05_real_world_data.sql) and [adapted queries](sql/06_real_world_queries.sql)

---

## Week 5: Real-world data integration

Two openFDA snapshots provide **100 methylphenidate product listings** and **66 recall records**, accessed on 7 October 2026 under CC0. The catalogue snapshot was updated on 7 October 2026 and the recall snapshot on 30 September 2026. They cover product information and recall events, not student prescriptions.

- [Product source snapshot](data/week5/ndc.json) and [recall source snapshot](data/week5/recalls.json).
- [Week 5 report](docs/week5/Week5.tex): sources, cleaning, schema changes, normalization, verified query results and limitations.
- [Import SQL](sql/05_real_world_data.sql) and [adapted queries](sql/06_real_world_queries.sql).
- [FDA licence](https://open.fda.gov/license/), [product documentation](https://open.fda.gov/apis/drug/ndc/) and [recall documentation](https://open.fda.gov/apis/drug/enforcement/).

After the Week 3 files, run `05_real_world_data.sql`, rerun the Week 3 queries, then run `06_real_world_queries.sql`. Use MySQL 8.0.16 or later. The import adds two FDA tables and preserves the fictional students, doctors and prescriptions. Repeating the import refreshes only the FDA tables. Verified on MySQL 8.4.0: 100 product rows and 66 recall rows match the source snapshots, repeat counts are unchanged, and the original queries still work.

The product export is a 100-record sample, not the full catalogue. Source company labels are preserved, including spelling and punctuation variants. Product listing does not establish FDA approval, and neither dataset identifies student misuse. See the report for the exact source queries and limitations.
