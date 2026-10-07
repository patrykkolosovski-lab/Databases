-- Week 3 queries remain unchanged and still describe fictional students.
-- Adaptation 1: product history/context replaces fictional prescription history.
SELECT product_ndc, generic_name, labeler_name, dosage_form, marketing_start_date
FROM FDA_Product ORDER BY product_ndc;

-- Adaptation 2: count catalogue entries by dosage form, not prescriptions.
-- Catalogue frequency is not prescribing frequency or student usage.
SELECT dosage_form, COUNT(*) AS product_count
FROM FDA_Product GROUP BY dosage_form
ORDER BY product_count DESC, dosage_form;

-- Adaptation 3: recall classification counts replace the student absence question.
-- These records cannot identify students with or without prescriptions.
SELECT classification, COUNT(*) AS recall_count
FROM FDA_Recall GROUP BY classification ORDER BY classification;

-- Adaptation 4: latest recorded recall per recalling firm, using the Week 3
-- window-function pattern. The recall number gives a deterministic date tie-break.
WITH ranked AS (
    SELECT r.*, ROW_NUMBER() OVER (
        PARTITION BY recalling_firm
        ORDER BY recall_initiation_date DESC, recall_number DESC
    ) AS rn FROM FDA_Recall r
)
SELECT recalling_firm, recall_number, recall_initiation_date, classification
FROM ranked WHERE rn=1 ORDER BY recalling_firm;
