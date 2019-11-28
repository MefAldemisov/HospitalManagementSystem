-- first
CREATE VIEW query1_acc AS SELECT email
FROM EmployeeAccount
WHERE (NOT name REGEXP '[ML].*' AND surname REGEXP '[ML].*') OR 
        (name REGEXP '[ML].*' AND NOT surname REGEXP '[ML].*');
CREATE VIEW query1_app AS SELECT *  -- find all appointments by the date
    FROM CreateAppointment
WHERE CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) =(SELECT MAX(CAST(CAST(appointment_timestamp AS DATETIME) AS DATE))
   FROM CreateAppointment
   WHERE medical_insurence_number = 3124645379976567)
AND medical_insurence_number = 3124645379976567;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query1  AS 

SELECT app.room
FROM Doctor JOIN query1_acc AS acc ON Doctor.email = acc.email 
JOIN query1_app AS app ON Doctor.doctor_ssn = app.doctor_ssn;
-- second
CREATE VIEW query2_stamp_timestamp_during_year AS SELECT appointment_timestamp
FROM createappointment
WHERE CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) < CURRENT_DATE -interval '1 ' YEAR;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query2_stamp(week, timeslot) AS SELECT WEEK(appointment_timestamp) AS week,
   CONCAT(CAST(DOW(appointment_timestamp) AS CHAR),' ',SUBSTR(CAST(appointment_timestamp AS CHAR),12,5)) AS timeslot
FROM query2_stamp_timestamp_during_year as timestamp_during_year
GROUP BY appointment_timestamp
ORDER BY week;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query2  AS 
SELECT timeslot, COUNT(week) AS total, (COUNT(week)/52.1429) AS average
FROM query2_stamp as stamp
GROUP BY timeslot
HAVING
COUNT(week) > 1
ORDER BY timeslot;

-- third
CREATE VIEW query3_select2_select1(`count`, medical_insurence_number, week) AS SELECT COUNT(medical_insurence_number) as count,medical_insurence_number, date_trunc('week',appointment_timestamp) as week
FROM createappointment 
WHERE appointment_timestamp > date_trunc('week',CURRENT_DATE) -interval '21' DAY AND appointment_timestamp <= CURRENT_DATE
GROUP BY week,medical_insurence_number;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query3_select2 AS SELECT select1.medical_insurence_number, select1.`count`, select1.week 
FROM query3_select2_select1 as select1
GROUP BY select1.medical_insurence_number,select1.`count`,select1.week
HAVING select1.`count` >= 2;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query3  AS
SELECT select2.medical_insurence_number FROM
query3_select2 as select2
GROUP BY select2.medical_insurence_number
HAVING COUNT(select2.medical_insurence_number) > 3;

-- fourth
CREATE VIEW query4_total_group1_group1_young_apps AS SELECT * FROM CreateAppointment AS ca
WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019;
CREATE VIEW query4_total_group1_group1_young_young_min AS SELECT medical_insurence_number 
FROM PatientAccount AS pa
WHERE CAST(pa.date_of_birth AS DATE) < CURRENT_DATE -interval '50 ' YEAR;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group1_group1_young(med_n, months) AS SELECT apps.medical_insurence_number AS med_n,
       MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
FROM query4_total_group1_group1_young_apps AS apps JOIN query4_total_group1_group1_young_young_min AS young_min 
ON young_min.medical_insurence_number = apps.medical_insurence_number;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group1_group1 AS SELECT * FROM query4_total_group1_group1_young AS young
GROUP BY months,med_n
HAVING COUNT(med_n) < 3;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group1(a) AS SELECT SUM(CASE WHEN true = TRUE 
THEN 200 ELSE 0 END) AS a
FROM query4_total_group1_group1 AS group1;
CREATE VIEW query4_total_group2_group2_young_apps AS SELECT * FROM CreateAppointment AS ca
WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS
DATE)) = 2019;
CREATE VIEW query4_total_group2_group2_young_young_min AS SELECT medical_insurence_number 
FROM PatientAccount AS pa
WHERE CAST(pa.date_of_birth AS DATE) < CURRENT_DATE -interval '50 ' YEAR;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group2_group2_young(med_n, months) AS SELECT apps.medical_insurence_number AS med_n,
       MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
FROM query4_total_group2_group2_young_apps AS apps JOIN query4_total_group2_group2_young_young_min AS young_min 
ON young_min.medical_insurence_number = apps.medical_insurence_number;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group2_group2 AS SELECT * FROM query4_total_group2_group2_young AS young
GROUP BY months,med_n
HAVING COUNT(med_n) >= 3;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group2(b) AS SELECT SUM(CASE WHEN true = TRUE 
THEN 250 ELSE 0 END) AS b
FROM query4_total_group2_group2 AS group2;
CREATE VIEW query4_total_group3_group3_old_apps AS SELECT * FROM CreateAppointment AS ca
WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019;
CREATE VIEW query4_total_group3_group3_old_old_min AS SELECT medical_insurence_number
FROM PatientAccount AS pa
WHERE CAST(pa.date_of_birth AS DATE) >= CURRENT_DATE -interval '50 ' YEAR;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group3_group3_old(med_n, months) AS SELECT apps.medical_insurence_number AS med_n,
        MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
FROM query4_total_group3_group3_old_apps AS apps JOIN query4_total_group3_group3_old_old_min AS old_min 
ON old_min.medical_insurence_number = apps.medical_insurence_number;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group3_group3 AS SELECT * FROM query4_total_group3_group3_old AS old
GROUP BY months,med_n
HAVING COUNT(med_n) < 3;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group3(c) AS SELECT SUM(CASE WHEN true = TRUE 
THEN 400 ELSE 0 END) AS c
FROM query4_total_group3_group3 AS group3;
CREATE VIEW query4_total_group4_group4_old_apps AS SELECT * FROM CreateAppointment AS ca
WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019;
CREATE VIEW query4_total_group4_group4_old_old_min AS SELECT medical_insurence_number
FROM PatientAccount AS pa
WHERE CAST(pa.date_of_birth AS DATE) >= CURRENT_DATE -interval '50 ' YEAR;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group4_group4_old(med_n, months) AS SELECT apps.medical_insurence_number AS med_n,
        MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
FROM query4_total_group4_group4_old_apps AS apps JOIN query4_total_group4_group4_old_old_min AS old_min 
ON old_min.medical_insurence_number = apps.medical_insurence_number;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group4_group4 AS SELECT * FROM query4_total_group4_group4_old AS old
GROUP BY months,med_n
HAVING COUNT(med_n) >= 3;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4_total_group4(d) AS SELECT SUM(CASE WHEN true = TRUE 
THEN 500 ELSE 0 END) AS d
FROM query4_total_group4_group4 AS group4;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query4  AS

SELECT  COALESCE(total_group1.a,0)+COALESCE(total_group2.b,0)+COALESCE(total_group3.c,0)+COALESCE(total_group4.d,0)
as res
FROM query4_total_group1 AS total_group1, query4_total_group2 AS total_group2, query4_total_group3 AS total_group3, query4_total_group4 AS total_group4;

-- fifth
CREATE VIEW query5_group1_gr_app AS SELECT * FROM CreateAppointment 
WHERE (CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) >= CURRENT_DATE -interval '10 ' YEAR);
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query5_group1_gr(doctor_SSN, years, counter) AS SELECT doctor_SSN, YEAR(CAST(appointment_timestamp AS DATETIME)) AS years, COUNT(app.medical_insurence_number) AS counter
FROM query5_group1_gr_app AS app
GROUP BY doctor_SSN,years
HAVING COUNT(app.medical_insurence_number) >= 5
ORDER BY doctor_SSN,years;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query5_group1 AS SELECT doctor_SSN
FROM query5_group1_gr AS gr 
GROUP BY doctor_SSN
HAVING COUNT(years) >= 10;
CREATE VIEW query5_group2_app AS SELECT * FROM CreateAppointment 
WHERE (CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) >= CURRENT_DATE -interval '10 ' YEAR);
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query5_group2 AS SELECT doctor_SSN
FROM query5_group2_app AS app
GROUP BY doctor_SSN
HAVING COUNT(app.medical_insurence_number) >= 100;
/* -- Creating additional view since a subquery in the FROM clause not supported*/
CREATE VIEW query5  AS


SELECT group1.doctor_SSN
FROM query5_group1 AS group1 INNER JOIN query5_group2 AS group2 ON group1.doctor_SSN = group2.doctor_SSN;