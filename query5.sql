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

	-- SELECT DISTINCT EXTRACT(YEAR FROM appointment_timestamp::timestamp) AS years
	-- FROM app;