--Query 1--
/*
List all patients who were admitted to the ICU and whose 
first care unit and last care unit were both “MICU”.
*/

SELECT 
    P.FIRST_NAME, 
    P.LAST_NAME, 
    I.ICUSTAY_ID, 
    I.FIRST_CAREUNIT, 
    I.LAST_CAREUNIT
FROM PATIENTS P
JOIN dbo.ICUSTAYS I
    ON P.SUBJECT_ID = I.SUBJECT_ID
WHERE 
    I.FIRST_CAREUNIT = 'MICU' AND I.LAST_CAREUNIT = 'MICU';

--Query 2--
 /* Find all patients who had more than 3 hospital admissions in total.*/  

 SELECT 
    P.SUBJECT_ID, 
    P.FIRST_NAME, 
    P.LAST_NAME, 
    COUNT(*) AS admission_count
FROM PATIENTS P
INNER JOIN dbo.ADMISSIONS A ON P.SUBJECT_ID = A.SUBJECT_ID
GROUP BY P.SUBJECT_ID, P.FIRST_NAME, P.LAST_NAME
HAVING COUNT(*) > 3;

--Query 3--
/*
Retrieve the names and admission dates of patients who were 
discharged without any procedures.
*/

SELECT
    p.FIRST_NAME, 
    p.LAST_NAME, 
    a.ADMISSION_TYPE, 
    a.ADMITTIME
FROM PATIENTS p INNER JOIN ADMISSIONS a
     ON p.SUBJECT_ID = a.SUBJECT_ID
WHERE EXISTS(
    SELECT 1
    FROM NOTEEVENTS ne_surg
    WHERE ne_surg.HADM_ID = a.HADM_ID
    AND ne_surg.TEXT NOT LIKE '%major surgical or invasive procedure%none%');

--Query 4--
/* List all patients who had both radiology exams 
and surgery during the same admission.
*/
SELECT DISTINCT
    p.FIRST_NAME, p.LAST_NAME
FROM PATIENTS p INNER JOIN ADMISSIONS a
     ON p.SUBJECT_ID = a.SUBJECT_ID
WHERE
    EXISTS (
        SELECT 1
        FROM NOTEEVENTS ne_rad
        WHERE ne_rad.HADM_ID = a.HADM_ID
          AND ne_rad.CATEGORY = 'Radiology'
    )
  AND EXISTS (
    SELECT 1
    FROM NOTEEVENTS ne_surg
    WHERE ne_surg.HADM_ID = a.HADM_ID
      AND ne_surg.TEXT LIKE '%surgery%'
      AND ne_surg.TEXT NOT LIKE '%major surgical or invasive procedure%none%'
);

--Query 5--
/*Find all ICU stays that lasted more than 7 days and the 
associated patient names. */
SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    I.INTIME, 
    I.OUTTIME, 
    DATEDIFF(day, I.INTIME, I.OUTTIME) AS icu_stay_days
FROM dbo.PATIENTS P
JOIN dbo.ICUSTAYS I
    ON P.SUBJECT_ID = I.SUBJECT_ID
WHERE DATEDIFF(day, I.INTIME, I.OUTTIME) > 7;

--Query 6--
/*Count the number of admissions for each patient.*/
SELECT
    SUBJECT_ID,  
    COUNT(HADM_ID) AS admission_count
FROM dbo.ADMISSIONS
GROUP BY SUBJECT_ID;

--Query 7--
/* List all patients who were admitted via the 
emergency department and had at least one ICU stay. */
SELECT DISTINCT
    P.FIRST_NAME, P.LAST_NAME
FROM dbo.PATIENTS P
JOIN dbo.ADMISSIONS A
    ON P.SUBJECT_ID = A.SUBJECT_ID
JOIN dbo.ICUSTAYS I
    ON A.HADM_ID = I.HADM_ID
WHERE A.ADMISSION_TYPE = 'EMERGENCY';

--Query 8--
/* Retrieve the most common diagnosis (ICD code) in ICU admissions. */
SELECT TOP 1
    D.ICD9_CODE, 
    COUNT(*) AS diagnosis_count
FROM dbo.ICUSTAYS I
JOIN dbo.ADMISSIONS A
    ON I.HADM_ID = A.HADM_ID
JOIN dbo.DIAGNOSES_ICD D
    ON A.HADM_ID = D.HADM_ID
GROUP BY D.ICD9_CODE
ORDER BY diagnosis_count DESC;

--Query 9--
/*Find the average length of stay in the ICU for each ICU type (e.g., MICU, SICU, CCU).*/
SELECT
    FIRST_CAREUNIT AS icu_type, 
    AVG(DATEDIFF(hour, INTIME, OUTTIME) / 24.0) AS avg_icu_stay_days
FROM dbo.ICUSTAYS
WHERE OUTTIME IS NOT NULL
GROUP BY FIRST_CAREUNIT;

--Query 10--
/* List all patients who had surgery before being admitted to the ICU in the same admission. */
SELECT DISTINCT
    p.FIRST_NAME, 
    p.LAST_NAME, 
    a.HADM_ID
FROM PATIENTS p
INNER JOIN ADMISSIONS a
    ON p.SUBJECT_ID = a.SUBJECT_ID
WHERE EXISTS (
    SELECT 1
    FROM NOTEEVENTS ne_surg
    WHERE ne_surg.HADM_ID = a.HADM_ID
      AND ne_surg.TEXT LIKE '%surgery%'
      AND ne_surg.TEXT NOT LIKE '%major surgical or invasive procedure%none%'
      AND EXISTS (
          SELECT 1
          FROM ICUSTAYS i
          WHERE i.HADM_ID = a.HADM_ID
            AND ne_surg.CHARTTIME < i.INTIME
      )
);

--Query 11--
/* Retrieve the names of patients and the number of radiology exams they had during all admissions. */
SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    COUNT(*) AS radiology_exam_count
FROM dbo.PATIENTS P
JOIN dbo.ADMISSIONS A
    ON P.SUBJECT_ID = A.SUBJECT_ID
JOIN dbo.NOTEEVENTS N
    ON A.HADM_ID = N.HADM_ID
WHERE N.CATEGORY = 'Radiology'
GROUP BY P.FIRST_NAME, P.LAST_NAME
ORDER BY radiology_exam_count DESC;

--Query 12--
/* Find patients who had discharge summaries containing the keyword “recovery”. */
SELECT DISTINCT
    P.FIRST_NAME, 
    P.LAST_NAME
FROM dbo.PATIENTS P
JOIN dbo.ADMISSIONS A
    ON P.SUBJECT_ID = A.SUBJECT_ID
JOIN dbo.NOTEEVENTS N
    ON A.HADM_ID = N.HADM_ID
WHERE N.CATEGORY = 'Discharge summary'
  AND N.TEXT LIKE '%recovery%';

--Query 13--
/* List all admissions where the patient had no ICU/CCU stay but had radiology exams performed. */
SELECT DISTINCT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    A.HADM_ID
FROM dbo.ADMISSIONS A
JOIN dbo.PATIENTS P
    ON A.SUBJECT_ID = P.SUBJECT_ID
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.ICUSTAYS I
    WHERE I.HADM_ID = A.HADM_ID
)
AND EXISTS (
    SELECT 1
    FROM dbo.NOTEEVENTS N
    WHERE N.HADM_ID = A.HADM_ID
      AND N.CATEGORY = 'Radiology'
);

--Query 14--
/*Retrieve the patients with the longest hospital stay (admission to discharge).*/
SELECT TOP 10
    P.FIRST_NAME, 
    P.LAST_NAME, 
    A.ADMITTIME, 
    A.DISCHTIME, 
    DATEDIFF(day, A.ADMITTIME, A.DISCHTIME) AS days_at_the_hospital
FROM dbo.ADMISSIONS A
JOIN dbo.PATIENTS P
    ON A.SUBJECT_ID = P.SUBJECT_ID
WHERE A.DISCHTIME IS NOT NULL
ORDER BY days_at_the_hospital DESC;

--Query 15--
/* Count the total number of ICU transfers for each patient.*/
SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    I.SUBJECT_ID, 
    COUNT(I.ICUSTAY_ID) AS icu_count
FROM dbo.ICUSTAYS I
JOIN dbo.PATIENTS P
    ON I.SUBJECT_ID = P.SUBJECT_ID
GROUP BY
    P.FIRST_NAME, P.LAST_NAME, I.SUBJECT_ID
ORDER BY icu_count DESC;

--Query 16--
/*List patients who were admitted to multiple ICU types during the same admission.*/
SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    I.SUBJECT_ID, 
    I.HADM_ID, 
    COUNT(DISTINCT I.FIRST_CAREUNIT) AS icu_type_count
FROM dbo.ICUSTAYS I
JOIN dbo.PATIENTS P
    ON I.SUBJECT_ID = P.SUBJECT_ID
GROUP BY
    P.FIRST_NAME, P.LAST_NAME, I.SUBJECT_ID, I.HADM_ID
HAVING COUNT(DISTINCT I.FIRST_CAREUNIT) > 1;

--Query 17--
/* Find all patients who had more than one diagnosis coded during a single admission.*/
SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    D.SUBJECT_ID, 
    D.HADM_ID, 
    COUNT(*) AS diagnosis_count
FROM dbo.DIAGNOSES_ICD D
JOIN dbo.PATIENTS P
    ON D.SUBJECT_ID = P.SUBJECT_ID
GROUP BY
    P.FIRST_NAME, P.LAST_NAME, D.SUBJECT_ID, D.HADM_ID
HAVING COUNT(*) > 1
ORDER BY diagnosis_count DESC;

--Query 18--
/* Retrieve the latest clinical note for each patient.
 */

 SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    N.SUBJECT_ID, 
    N.HADM_ID, 
    N.CHARTTIME, 
    N.CATEGORY, 
    N.TEXT
FROM dbo.NOTEEVENTS N
JOIN dbo.PATIENTS P
    ON N.SUBJECT_ID = P.SUBJECT_ID
WHERE N.CHARTTIME = (
    SELECT MAX(N2.CHARTTIME)
    FROM dbo.NOTEEVENTS N2
    WHERE N2.SUBJECT_ID = N.SUBJECT_ID
);

--Query 19--
/* List all admissions where the patient died during the stay. */
SELECT
    P.FIRST_NAME, 
    P.LAST_NAME, 
    A.HADM_ID, 
    A.SUBJECT_ID, 
    A.ADMITTIME, 
    A.DISCHTIME
FROM dbo.ADMISSIONS A
JOIN dbo.PATIENTS P
    ON A.SUBJECT_ID = P.SUBJECT_ID
WHERE A.HOSPITAL_EXPIRE_FLAG = 1;

--Query 20--
/* Find all patients who had surgery and radiology exams on the same day. */
SELECT DISTINCT
    p.FIRST_NAME, 
    p.LAST_NAME, 
    a.HADM_ID
FROM PATIENTS p
INNER JOIN ADMISSIONS a
    ON p.SUBJECT_ID = a.SUBJECT_ID
WHERE EXISTS (
    SELECT 1
    FROM NOTEEVENTS ne_rad
    WHERE ne_rad.HADM_ID = a.HADM_ID
      AND ne_rad.CATEGORY = 'Radiology'
      AND EXISTS (
          SELECT 1
          FROM NOTEEVENTS ne_surg
          WHERE ne_surg.HADM_ID = a.HADM_ID
            AND ne_surg.TEXT LIKE '%surgery%'
            AND ne_surg.TEXT NOT LIKE '%major surgical or invasive procedure%none%'
            AND CAST(ne_rad.CHARTTIME AS date) = CAST(ne_surg.CHARTTIME AS date)
      )
);