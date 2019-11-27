WITH
app AS 
	(SELECT * 
	FROM CreateAppointment 
	WHERE (appointment_timestamp::timestamp::date >= current_date - interval '10 years')),
group1 as
	(SELECT doctor_SSN, EXTRACT(YEAR FROM appointment_timestamp::timestamp) AS years
	 	FROM app
	 	GROUP BY doctor_SSN, years
	 	HAVING COUNT(app.medical_insurence_number) >= 5),
group2 as
	(SELECT doctor_SSN
	FROM app
	GROUP BY doctor_SSN
	HAVING COUNT(app.medical_insurence_number) >= 100)
SELECT *
	FROM group1 INNER JOIN group2 ON group1.doctor_SSN = group2.doctor_SSN;