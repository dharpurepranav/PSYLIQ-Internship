-- 1. Retrieve the Patient_id and ages of all patients.
SELECT Patient_id, age FROM patient;

-- 2. Select all female patients who are older than 40.
SELECT EmployeeName, Patient_id, gender, age
FROM patient
WHERE gender = 'Female' AND age > 40;

-- 3. Calculate the average BMI of patients.
SELECT AVG(bmi) FROM patient;

-- 4. List patients in descending order of blood glucose levels.
SELECT EmployeeName, Patient_id, blood_glucose_level
FROM patient
ORDER BY blood_glucose_level DESC;

-- 5. Find patients who have hypertension and diabetes.
SELECT EmployeeName, Patient_id, hypertension, diabetes
FROM patient
WHERE hypertension = 1 AND diabetes = 1;

-- 6. Determine the number of patients with heart disease.
SELECT COUNT(Patient_id) AS No_of_heart_patients
FROM patient
WHERE heart_disease = 1;

-- 7. Group patients by smoking history and count how many smokers and non-smokers there are.
SELECT
  CASE
    WHEN smoking_history IN ('current', 'former', 'ever') THEN 'Smoker'
    WHEN smoking_history = 'never' THEN 'Non-smoker'
    ELSE 'Unknown'
  END AS smoking_status,
  COUNT(*) AS patient_count
FROM patient
WHERE smoking_history IN ('never', 'No Info', 'current', 'former', 'ever', 'not current')
GROUP BY smoking_status;

-- 8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.
SELECT Patient_id, bmi
FROM patient
WHERE bmi > (SELECT AVG(bmi) FROM patient);

-- 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel
SELECT EmployeeName, Patient_id, HbA1c_level
FROM patient
WHERE HbA1c_level = (SELECT MAX(HbA1c_level) FROM patient)

UNION ALL

SELECT EmployeeName, Patient_id, HbA1c_level
FROM patient
WHERE HbA1c_level = (SELECT MIN(HbA1c_level) FROM patient);

-- 10. Calculate the age of patients in years (assuming the current date as of now).
SELECT
  Patient_id,
  EmployeeName,
  Age AS Approximate_Age,
  FLOOR(YEAR(CURDATE()) - Age) AS BirthYear,
  CURDATE() AS CurrentDate,
  FLOOR(DATEDIFF(CURDATE(), STR_TO_DATE(CONCAT(YEAR(CURDATE()) - Age, '-01-01'), '%Y-%m-%d')) / 365) AS Age_In_Years
FROM patient;

-- 11. Rank patients by blood glucose level within each gender group.
SELECT
  Patient_id,
  EmployeeName,
  gender,
  blood_glucose_level,
  RANK() OVER (PARTITION BY Gender ORDER BY blood_glucose_level) AS Glucose_Rank_Within_Gender
FROM patient;

-- 12. Update the smoking history of patients who are older than 50 to "Ex-smoker."
UPDATE patient
SET smoking_history = 'Ex-smoker'
WHERE age > 50;

-- 13. Insert a new patient into the database with sample data.
INSERT INTO patient (Patient_id, EmployeeName, gender, age, smoking_history, blood_glucose_level)
VALUES
  (1, 'John Doe', 'Male', 35, 'Non-smoker', 120),
  (2, 'Jane Smith', 'Female', 45, 'Current smoker', 140),
  -- Add more sample data as needed
  (3, 'Sam Johnson', 'Male', 55, 'Former smoker', 130);

-- 14. Delete all patients with heart disease from the database.
DELETE FROM patient
WHERE heart_disease = 1;

-- 15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
SELECT EmployeeName, Patient_id, hypertension, diabetes
FROM patient
WHERE Hypertension = 1
AND NOT EXISTS (
  SELECT 1
  FROM patient AS p2
  WHERE p2.Patient_id = patient.Patient_id AND p2.diabetes = 1
);

-- 16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
ALTER TABLE patient
ADD CONSTRAINT unique_Patient_id UNIQUE (Patient_id);

-- 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
CREATE VIEW patient_info_view AS
SELECT
  Patient_id,
  age,
  bmi
FROM
  patient;
  
SELECT * FROM patient_info_view;




