WITH 
apps AS (SELECT *
		 FROM CreateAppointment AS ca
		 WHERE EXTRACT(YEAR FROM ca.appointment_timestamp::timestamp::date)=2018),
old_min AS (SELECT medical_insurence_number
		FROM PatientAccount AS pa
		WHERE 2018-EXTRACT(YEAR FROM pa.date_of_birth::date)>=50),
young_min AS (SELECT medical_insurence_number 
		 FROM PatientAccount AS pa
		 WHERE 2018-EXTRACT(YEAR FROM pa.date_of_birth::date)<50),
months AS (SELECT DISTINCT EXTRACT(MONTH 
								   FROM apps.appointment_timestamp::timestamp) AS val
		   FROM apps
		   ORDER BY val),
old AS (SELECT apps.medical_insurence_number AS med_n,
		  	   EXTRACT(MONTH FROM apps.appointment_timestamp::timestamp) AS months  
		FROM apps JOIN old_min 
		ON old_min.medical_insurence_number=apps.medical_insurence_number),
young AS (SELECT apps.medical_insurence_number AS med_n,
		  		 EXTRACT(MONTH FROM apps.appointment_timestamp::timestamp) AS months  
		  FROM apps JOIN young_min 
		  ON young_min.medical_insurence_number=apps.medical_insurence_number),
group1 AS (SELECT *
			FROM young
			GROUP BY months, med_n
			HAVING COUNT(med_n) < 3),
total_group1 AS (SELECT SUM(CASE WHEN true 
							THEN 200 ELSE 0 END) AS a
				 FROM group1),
group2 AS (SELECT *
			FROM young
			GROUP BY months, med_n
			HAVING COUNT(med_n) >= 3),
total_group2 AS (SELECT SUM(CASE WHEN true 
							THEN 250 ELSE 0 END) AS b
				 FROM group2),
group3 AS (SELECT *
			FROM old
			GROUP BY months, med_n
			HAVING COUNT(med_n) < 3),
total_group3 AS (SELECT SUM(CASE WHEN true 
							THEN 400 ELSE 0 END) AS c
				 FROM group3),
group4 AS (SELECT *
			FROM old
			GROUP BY months, med_n
			HAVING COUNT(med_n) >= 3),
total_group4 AS (SELECT SUM(CASE WHEN true 
							THEN 500 ELSE 0 END) AS d
				 FROM group4)
SELECT  COALESCE(total_group1.a, 0) + 
		COALESCE(total_group2.b, 0) +
		COALESCE(total_group3.c, 0) + 
		COALESCE(total_group4.d, 0)
		as res
FROM total_group1,total_group2, total_group3, total_group4;
