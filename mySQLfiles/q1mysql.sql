SELECT app.room
FROM Doctor JOIN(SELECT email
   FROM EmployeeAccount
   WHERE (NOT name REGEXP '[ML].*' AND surname REGEXP '[ML].*') OR 
        (name REGEXP '[ML].*' AND NOT surname REGEXP '[ML].*')) AS acc ON Doctor.email = acc.email 
JOIN(SELECT *  -- find all appointments by the date
    FROM CreateAppointment
   WHERE CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) =(SELECT MAX(CAST(CAST(appointment_timestamp AS DATETIME) AS DATE))
      FROM CreateAppointment
      WHERE medical_insurence_number = 3124645379976567)
   AND medical_insurence_number = 3124645379976567) AS app ON Doctor.doctor_ssn = app.doctor_ssn;