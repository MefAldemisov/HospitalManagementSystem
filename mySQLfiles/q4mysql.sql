SELECT  COALESCE(total_group1.a,0)+COALESCE(total_group2.b,0)+COALESCE(total_group3.c,0)+COALESCE(total_group4.d,0)
as res
FROM(SELECT SUM(CASE WHEN true = TRUE 
   THEN 200 ELSE 0 END) AS a
   FROM(SELECT * FROM(SELECT apps.medical_insurence_number AS med_n,
       MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
         FROM(SELECT * FROM CreateAppointment AS ca
            WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019) AS apps JOIN(SELECT medical_insurence_number 
            FROM PatientAccount AS pa
            WHERE CAST(pa.date_of_birth AS DATE) < CURRENT_DATE -interval '50 ' YEAR) AS young_min 
         ON young_min.medical_insurence_number = apps.medical_insurence_number) AS young
      GROUP BY months,med_n
      HAVING COUNT(med_n) < 3) AS group1) AS total_group1, (SELECT SUM(CASE WHEN true = TRUE 
   THEN 250 ELSE 0 END) AS b
   FROM(SELECT * FROM(SELECT apps.medical_insurence_number AS med_n,
       MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
         FROM(SELECT * FROM CreateAppointment AS ca
            WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019) AS apps JOIN(SELECT medical_insurence_number 
            FROM PatientAccount AS pa
            WHERE CAST(pa.date_of_birth AS DATE) < CURRENT_DATE -interval '50 ' YEAR) AS young_min 
         ON young_min.medical_insurence_number = apps.medical_insurence_number) AS young
      GROUP BY months,med_n
      HAVING COUNT(med_n) >= 3) AS group2) AS total_group2, (SELECT SUM(CASE WHEN true = TRUE 
   THEN 400 ELSE 0 END) AS c
   FROM(SELECT * FROM(SELECT apps.medical_insurence_number AS med_n,
        MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
         FROM(SELECT * FROM CreateAppointment AS ca
            WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019) AS apps JOIN(SELECT medical_insurence_number
            FROM PatientAccount AS pa
            WHERE CAST(pa.date_of_birth AS DATE) >= CURRENT_DATE -interval '50 ' YEAR) AS old_min 
         ON old_min.medical_insurence_number = apps.medical_insurence_number) AS old
      GROUP BY months,med_n
      HAVING COUNT(med_n) < 3) AS group3) AS total_group3, (SELECT SUM(CASE WHEN true = TRUE 
   THEN 500 ELSE 0 END) AS d
   FROM(SELECT * FROM(SELECT apps.medical_insurence_number AS med_n,
        MONTH(CAST(apps.appointment_timestamp AS DATETIME)) AS months  
         FROM(SELECT * FROM CreateAppointment AS ca
            WHERE YEAR(CAST(CAST(ca.appointment_timestamp AS DATETIME) AS DATE)) = 2019) AS apps JOIN(SELECT medical_insurence_number
            FROM PatientAccount AS pa
            WHERE CAST(pa.date_of_birth AS DATE) >= CURRENT_DATE -interval '50 ' YEAR) AS old_min 
         ON old_min.medical_insurence_number = apps.medical_insurence_number) AS old
      GROUP BY months,med_n
      HAVING COUNT(med_n) >= 3) AS group4) AS total_group4;