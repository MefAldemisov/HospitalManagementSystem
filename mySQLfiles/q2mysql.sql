SELECT timeslot, COUNT(week) AS total, (COUNT(week)/52.1429) AS average
FROM(SELECT WEEK(appointment_timestamp) AS week,
   CONCAT(CAST(DOW(appointment_timestamp) AS CHAR),' ',SUBSTR(CAST(appointment_timestamp AS CHAR),12,5)) AS timeslot
   FROM(SELECT appointment_timestamp
      FROM createappointment
      WHERE CAST(CAST(appointment_timestamp AS DATETIME) AS DATE) < CURRENT_DATE -interval '1 ' YEAR) as timestamp_during_year
   GROUP BY appointment_timestamp
   ORDER BY week) as stamp
GROUP BY timeslot
HAVING
COUNT(week) > 1
ORDER BY timeslot;