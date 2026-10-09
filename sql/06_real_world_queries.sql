-- Adapted from week 3 using real-life data with research/business questions as required in the final submission.

--  product history/context replaces fictional prescription history.
-- Question: Which methylphenidate products are listed, by whom, and in what form?
SELECT product_ndc, generic_name, labeler_name, dosage_form, marketing_start_date
FROM FDA_Product ORDER BY product_ndc;

-- 6.2: count catalogue entries by dosage form, not prescriptions.
-- Question: Which dosage forms (e.g. extended-release tablets) are listed most often?
-- Catalogue frequency is not prescribing frequency or student usage.
SELECT dosage_form, COUNT(*) AS product_count
FROM FDA_Product GROUP BY dosage_form
ORDER BY product_count DESC, dosage_form;

-- 6.3: recall classification counts replace the student absence question.
-- Question: How serious were the recorded recalls? Class I is the most serious.
-- These records cannot identify students with or without prescriptions.
SELECT classification, COUNT(*) AS recall_count
FROM FDA_Recall GROUP BY classification ORDER BY classification;

-- 6.4: latest recorded recall per recalling firm, using the Week 3
-- window-function pattern. The recall number gives a deterministic date tie-break.
-- Question: When did each recalling firm (as named in the data) last issue a recall?
WITH ranked AS (
    SELECT r.*, ROW_NUMBER() OVER (
        PARTITION BY recalling_firm
        ORDER BY recall_initiation_date DESC, recall_number DESC
    ) AS rn FROM FDA_Recall r
)
SELECT recalling_firm, recall_number, recall_initiation_date, classification
FROM ranked WHERE rn=1 ORDER BY recalling_firm;
