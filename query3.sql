SELECT tits2.medical_insurence_number FROM
	(SELECT tits.medical_insurence_number, tits.count, tits.week FROM (SELECT COUNT(medical_insurence_number) as count,medical_insurence_number, date_trunc('week', appointment_timestamp) as week
		FROM createappointment 
		WHERE appointment_timestamp > date_trunc('week', current_date) - interval '3 week' AND appointment_timestamp <= current_date
		GROUP BY week, medical_insurence_number) as tits
		GROUP BY tits.medical_insurence_number, tits.count, tits.week
		HAVING tits.count >=2
	) as tits2
GROUP BY tits2.medical_insurence_number
HAVING  COUNT(tits2.medical_insurence_number) > 3
