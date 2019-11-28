-- first
CREATE VIEW query1 AS 
WITH 
app AS (SELECT * -- find all appointments by the date
		FROM CreateAppointment
		WHERE appointment_timestamp::timestamp::date=
			(SELECT MAX(appointment_timestamp::timestamp::date)
			 FROM CreateAppointment
			 WHERE medical_insurence_number=2576561477010630)
			 AND medical_insurence_number=2576561477010630),
acc AS (SELECT email
		FROM EmployeeAccount
		WHERE (NOT name SIMILAR TO '(M|L)%' AND surname SIMILAR TO '(M|L)%') OR 
			  (name SIMILAR TO '(M|L)%' AND NOT surname SIMILAR TO '(M|L)%'))
SELECT app.room
FROM Doctor JOIN acc ON Doctor.email=acc.email 
			JOIN app ON Doctor.doctor_ssn=app.doctor_ssn;
-- second
CREATE VIEW query2 AS 
SELECT timeslot, COUNT(week) AS total, (COUNT(week)/52.1429) AS average
FROM (	SELECT EXTRACT(WEEK FROM appointment_timestamp) AS week,
 		CAST(EXTRACT(ISODOW FROM appointment_timestamp) AS TEXT) ||
 		' ' ||
 		SUBSTRING(CAST(appointment_timestamp AS TEXT), 12, 5) AS timeslot
		FROM (	SELECT appointment_timestamp
				FROM createappointment
WHERE appointment_timestamp > '2018-11-28 00:00:00'
			 ) as timestamp_during_year
		GROUP BY appointment_timestamp
		ORDER BY week
	 ) as stamp
GROUP BY timeslot
HAVING
COUNT(week) > 1
ORDER BY timeslot;

-- third
CREATE VIEW query3 
SELECT select2.medical_insurence_number FROM
	(SELECT select1.medical_insurence_number, select1.count, select1.week 
		FROM (SELECT COUNT(medical_insurence_number) as count,medical_insurence_number, date_trunc('week', appointment_timestamp) as week
			FROM createappointment 
			WHERE appointment_timestamp > date_trunc('week', current_date) - interval '3 week' AND appointment_timestamp <= current_date
			GROUP BY week, medical_insurence_number) as select1
		GROUP BY select1.medical_insurence_number, select1.count, select1.week
		HAVING select1.count >=2
	) as select2
GROUP BY select2.medical_insurence_number
HAVING COUNT(select2.medical_insurence_number) > 3;

-- fourth
CREATE VIEW query4
WITH 
apps AS (SELECT *
		 FROM CreateAppointment AS ca
		 WHERE EXTRACT(YEAR FROM ca.appointment_timestamp::timestamp::date)=2019),
old_min AS (SELECT medical_insurence_number
		FROM PatientAccount AS pa
		WHERE pa.date_of_birth::date >= current_date - interval '50 years'),
young_min AS (SELECT medical_insurence_number 
		 FROM PatientAccount AS pa
		 WHERE pa.date_of_birth::date < current_date - interval '50 years'),
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

-- fifth
CREATE VIEW query5 
WITH
app AS 
	(SELECT * 
	FROM CreateAppointment 
	WHERE (appointment_timestamp::timestamp::date >= current_date - interval '10 years')),

gr AS (SELECT doctor_SSN, EXTRACT(YEAR FROM appointment_timestamp::timestamp) AS years, COUNT(app.medical_insurence_number) AS counter
 	FROM app
 	GROUP BY doctor_SSN, years
 	HAVING COUNT(app.medical_insurence_number)>=5
 	ORDER BY doctor_SSN, years),

group1 AS (SELECT doctor_SSN
			FROM gr 
			GROUP BY doctor_SSN
			HAVING COUNT(years)>=10),
group2 AS
	(SELECT doctor_SSN
	FROM app
	GROUP BY doctor_SSN
	HAVING COUNT(app.medical_insurence_number) >= 100)

SELECT group1.doctor_SSN
FROM group1 INNER JOIN group2 ON group1.doctor_SSN = group2.doctor_SSN;
