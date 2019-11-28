SELECT group1.doctor_SSN
FROM(SELECT doctor_SSN
   FROM(SELECT doctor_SSN, YEAR(CAST(appointment_timestamp AS DATETIME)) AS years, COUNT(app.medical_insurence_number) AS counter
      FROM(SELECT * FROM CreateAppointment 
         WHERE (CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) >= CURRENT_DATE -interval '10 ' YEAR)) AS app
      GROUP BY doctor_SSN,years
      HAVING COUNT(app.medical_insurence_number) >= 5
      ORDER BY doctor_SSN,years) AS gr 
   GROUP BY doctor_SSN
   HAVING COUNT(years) >= 10) AS group1 INNER JOIN(SELECT doctor_SSN
   FROM(SELECT * FROM CreateAppointment 
      WHERE (CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) >= CURRENT_DATE -interval '10 ' YEAR)) AS app
   GROUP BY doctor_SSN
   HAVING COUNT(app.medical_insurence_number) >= 100) AS group2 ON group1.doctor_SSN = group2.doctor_SSN;

 -- SELECT DISTINCT EXTRACT(YEAR FROM appointment_timestamp::timestamp) AS years
 -- FROM app;