# Student Prescription Database

A university database project exploring prescription patterns in the context of non-medical study-drug use among students. The project combines a normalized prescription model, fictional teaching records, and real FDA product and recall data.

## Purpose and scope

Our societal topic is study-drug use and academic pressure. We are interested in how a database can organize relevant information and answer clear questions for students, university support staff and healthcare providers. The [Week 1 report](docs/week1/Week1.pdf) explains the challenge and supporting literature.

The prescription model can answer:

- Which drugs has a student received, and which doctor prescribed them?
- What dates, doses and tablet quantities are recorded?
- Which drugs appear most often in the sample?
- Which students have no prescription recorded?
- What is each student's latest prescription?

**A prescription does not prove misuse.** The database does not establish medical appropriateness, actual consumption, motivation, or effects on wellbeing and grades. Student prescription results are based entirely on fictional data.

## Project deliverables

| Week | Deliverable |
| --- | --- |
| 1 | [Societal problem and scientific literature](docs/week1/Week1.pdf) |
| 2 | [Crow's foot ERD and normalization report](docs/week2/Week2.pdf), including before-and-after examples for 1NF, 2NF and 3NF |
| 3 | [Relational schema](docs/week3/SCHEMA.md), constraints, mock data, basic operations and four advanced queries in [SQL files 01–04](sql/) |
| 4 | [Stakeholder video](docs/week4/Week4.mp4), explaining questions, limitations and future work in plain language |
| 5 | [Real-world data integration report](docs/week5/Week5.pdf), [real-data import](sql/05_real_world_data.sql) and [four adapted queries](sql/06_real_world_queries.sql) |

## Stakeholder video

The presentation introduces the challenge, demonstrates results from the mock database, and explains the next steps.

https://github.com/user-attachments/assets/6ab59ed9-3a44-402c-9038-be4cdf5bed6b

[Download the video](docs/week4/Week4.mp4).

## Database design

The four core tables are **Student**, **Doctor**, **StudyDrug** and **Prescription**. Each prescription links exactly one student, one doctor and one drug. Each of those can have zero or many prescriptions. A separate prescription ID allows repeated prescriptions for the same student and drug.

The schema uses primary and foreign keys, required fields, unique drug name–producer pairs, and checks on ages, study years, doses and quantities. Reports are calculated through queries. The [Week 2 report](docs/week2/Week2.pdf) explains the normalization choices and assumptions.

Two additional tables, **FDA_Product** and **FDA_Recall**, store real product information and recall events. They remain separate from the fictional prescription records because the sources do not provide verified links to those records.

## Real-world data

| Source | Saved records | Snapshot update date |
| --- | ---: | --- |
| [openFDA NDC Directory](https://open.fda.gov/apis/drug/ndc/) | 100 unique methylphenidate product listings | 7 October 2026 |
| [openFDA drug enforcement records](https://open.fda.gov/apis/drug/enforcement/) | 66 unique methylphenidate recall records | 30 September 2026 |

Both snapshots were accessed on 7 October 2026 and are available under [openFDA's CC0 licence](https://open.fda.gov/license/) without payment or registration. Product listings and recall events describe complementary facts; neither dataset is a subset of the other.

The import converts dates to SQL dates, preserves source names and checks unique identifiers. The Week 5 report documents missing-data checks, constraints, normalization and query results. The adapted queries show product listings, counts by dosage form, recall-classification counts and the latest recall for each exact recalling-firm label.

The catalogue is a 100-record sample. Listing does not establish FDA approval, and recall counts do not measure student use or general clinical risk. Company-name variants remain separate labels. These US datasets provide product context rather than evidence of student misuse.

## Run the database

Use **MySQL 8.0.16 or later**. In your MySQL connection, create and select an empty database:

```sql
CREATE DATABASE student_prescriptions;
USE student_prescriptions;
```

Then run the files in order:

| File | Purpose |
| --- | --- |
| [01_schema.sql](sql/01_schema.sql) | Create the four prescription tables and constraints |
| [02_mock_data.sql](sql/02_mock_data.sql) | Add 8 students, 4 doctors, 4 drugs and 13 fictional prescriptions |
| [03_basic_operations.sql](sql/03_basic_operations.sql) | Demonstrate adding, reading, updating and removing data; changes are rolled back |
| [04_advanced_queries.sql](sql/04_advanced_queries.sql) | Run prescription history, frequency, absence and latest-record queries |
| [05_real_world_data.sql](sql/05_real_world_data.sql) | Create and populate the two FDA tables from the data embedded in the SQL file |
| [06_real_world_queries.sql](sql/06_real_world_queries.sql) | Run four queries on the real FDA records |

After importing the FDA data, rerun files 03 and 04 to check the original operations and queries. File 01 is intended for a fresh database; repeating file 05 refreshes only the FDA tables. No live API connection or additional import program is needed.

**Validation:** tested on MySQL 8.4.0. All 166 imported records matched the selected source fields, repeat imports kept the same counts, and duplicate product keys and invalid recall classifications were rejected. The original queries continued to return the expected mock results.

## Query work distribution
As some of the work was done in collaboration on a single machine by video calls, the commits do not explain who came up with which query. This is a general outline of the work distribution in this aspect (from the most complex queries files 06 and 07):

| User  | Queries |
| --- | --- |
| patrykkolosovski-lab | 6.2, 7.4 |
| szstefanczak | 6.1, 7.3 |
| Mjedlin | 6.3, 6.4 |
| Skindel | 7.1, 7.2 |

## Progress, limitations and future work

In Week 5 we tested more examples and checked the reports, as planned in the video. Query 7.3 in [file 07](sql/07_additional_queries.sql) is a first step to compare changes over time, but only for recalls. We still need to collect feedback from students and staff.

### Limitations

- Our database only has prescriptions, so it does not show pills that students get from friends or online. We also have no data about grades or wellbeing.
- The mock data is small and only covers January to March 2026. Each drug is always prescribed by the same doctor, so we cannot compare drugs and doctors separately.
- Real prescription data is sensitive and the university normally cannot access it. With two students per programme, results could show who the student is - data privacy would need to improve in the future.

### Future work

- Make a bigger mock dataset that covers a full academic year.
- Add an active ingredient to StudyDrug to link it with the FDA data, and import all 262 product listings.
- Save the reports as views, so staff can use them without writing SQL.
- Later: anonymous surveys about motives and outcomes, and real student data only with consent. We would not publish personal data in this repository.
