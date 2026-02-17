# Winter 2026 Project Phase 1

**Course:** SOEN 363: Data Systems for Software Engineers  
**Instructor:** Hamed Jafarpour  
**Date:** March 8, 2026  
**Contributors:**  
Fouad Elian  
Junior Boni  
Talar Mustafa  
Karina Evangelista   
Nicholas Martoccia  

---

# Task 1 — ER Diagram

## Entities
- Patients
- Admissions
- Hospitals
- Wards
- Physicians
- Clinical_Notes
- Procedures
- Diagnoses
- ICD_Dictionary
- ICU
- Units
- Employees
- Health_Care_Professionals


## Attributes

### Patients
- patient_id (PK)
- first_name
- last_name
- date_of_birth
- gender
- life_status

### Admissions
- admission_id (PK)
- admission_date
- discharge_date
- discharge_time
- demographic_status
- insurance_detail
- time_of_death

### Hospitals
- hospital_id (PK)
- name
- location

### Wards
- physical_location

### Physicians
- physician_id (PK)
- name

### Clinical_Notes
- note_id (PK)
- progress_notes
- radiology_reports
- discharge_summaries
- patient_id (FK)
- healthcareprofessional_id (FK)

### Procedures
- procedure_id (PK)
- description
- procedure_time

### Diagnoses
- diagnosis_id (PK)
- icd_code (FK)

### ICD_Dictionary
- icd_code (PK)

### ICU
- unit_type

### Units
- (no attributes)

### Employees
- (no attributes)

### Health_Care_Professionals
- (no attributes)


## Relationships
- Patients has Admissions
- Admissions has Clinical_Notes
- Admissions belongs to Hospitals
- Admissions assigned to Wards
- Patients receives Diagnoses
- Diagnoses occurs_during Admissions
- Procedures happens_during Admissions
- Diagnoses classified by ICD_Dictionary
- Physicians visits Admissions


## Primary Keys (PK)
- Patients: patient_id
- Admissions: admission_id
- Hospitals: hospital_id
- Physicians: physician_id
- Clinical_Notes: note_id
- Procedures: procedure_id
- Diagnoses: diagnosis_id
- ICD_Dictionary: icd_code


## Foreign Keys (FK)
- Clinical_Notes: patient_id
- Clinical_Notes: healthcareprofessional_id
- Diagnoses: icd_code


## Cardinality
- Patients → Admissions: 1-to-many
- Admissions → Clinical_Notes: 1-to-many
- Hospitals → Admissions: 1-to-many
- Wards → Admissions: 1-to-many
- Patients → Diagnoses: 1-to-many
- Admissions → Diagnoses: 1-to-many
- Admissions → Procedures: 1-to-many
- ICD_Dictionary → Diagnoses: 1-to-many
- Physicians ↔ Admissions: many-to-many

## ER Diagram
![ER Diagram](ER_Model.svg)

---

# Task 2 — Database Creation and Data Import

## Schema Design

---

# Task 3 — SQL Queries

## Query 1
List all patients who were admitted to the ICU and whose first care unit and last care unit were both “MICU”.
```sql
-- SQL code here
```
### Comments

## Query 2
 Find all patients who had more than 3 hospital admissions in total.
```sql
-- SQL code here
```
### Comments

## Query 3
Retrieve the names and admission dates of patients who were discharged without any procedures.
```sql
-- SQL code here
```
### Comments

## Query 4
List all patients who had both radiology exams and surgery during the same admission.
```sql
-- SQL code here
```
### Comments

## Query 5
Find all ICU stays that lasted more than 7 days and the associated patient names.
```sql
-- SQL code here
```
### Comments

## Query 6
Count the number of admissions for each patient.
```sql
-- SQL code here
```
### Comments

## Query 7
List all patients who were admitted via the emergency department and had at least one ICU stay.
```sql
-- SQL code here
```
### Comments

## Query 8
 Retrieve the most common diagnosis (ICD code) in ICU admissions.
```sql
-- SQL code here
```
### Comments

## Query 9
Find the average length of stay in the ICU for each ICU type (e.g., MICU, SICU, CCU).
```sql
-- SQL code here
```
### Comments

## Query 10
. List all patients who had surgery before being admitted to the ICU in the same admission.
```sql
-- SQL code here
```
### Comments

## Query 11
 Retrieve the names of patients and the number of radiology exams they had during all admissions.
```sql
-- SQL code here
```
### Comments

## Query 12
Find patients who had discharge summaries containing the keyword “recovery”.
```sql
-- SQL code here
```
### Comments

## Query 13
List all admissions where the patient had no ICU/CCU stay but had radiology exams performed.
```sql
-- SQL code here
```
### Comments

## Query 14
Retrieve the patients with the longest hospital stay (admission to discharge).
```sql
-- SQL code here
```
### Comments

## Query 15
Count the total number of ICU transfers for each patient.
```sql
-- SQL code here
```
### Comments

## Query 16
List patients who were admitted to multiple ICU types during the same admission.
```sql
-- SQL code here
```
### Comments

## Query 17
Find all patients who had more than one diagnosis coded during a single admission.
```sql
-- SQL code here
```
### Comments

## Query 18
Retrieve the latest clinical note for each patient.
```sql
-- SQL code here
```
### Comments

## Query 19
List all admissions where the patient died during the stay.
```sql
-- SQL code here
```
### Comments

## Query 10
Find all patients who had surgery and radiology exams on the same day.
```sql
-- SQL code here
```
### Comments

