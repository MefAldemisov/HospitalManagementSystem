WITH 
app AS (SELECT * -- find all appointments by the date
		FROM CreateAppointment
		WHERE appointment_timestamp::timestamp::date=
			(SELECT MAX(appointment_timestamp::timestamp::date)
			 FROM CreateAppointment
			 WHERE medical_insurence_number=6087649573088168)
			 AND medical_insurence_number=6087649573088168),
acc AS (SELECT email
		FROM EmployeeAccount
		WHERE (NOT name SIMILAR TO '(M|L)%' AND surname SIMILAR TO '(M|L)%') OR 
			  (name SIMILAR TO '(M|L)%' AND NOT surname SIMILAR TO '(M|L)%'))
SELECT app.room
FROM Doctor JOIN acc ON Doctor.email=acc.email 
			JOIN app ON Doctor.doctor_ssn=app.doctor_ssn
			;
-- SELECT *
-- FROM PatientAccount
-- WHERE medical_insurence_number=6087649573088168; --Gordy Betty, she is a woman