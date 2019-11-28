SELECT select2.medical_insurence_number FROM
	(SELECT select1.medical_insurence_number, select1.count, select1.week FROM (SELECT COUNT(medical_insurence_number) as count,medical_insurence_number, date_trunc('week', appointment_timestamp) as week
		FROM createappointment 
		WHERE appointment_timestamp > date_trunc('week', current_date) - interval '3 week' AND appointment_timestamp <= current_date
		GROUP BY week, medical_insurence_number) as select1
		GROUP BY select1.medical_insurence_number, select1.count, select1.week
		HAVING select1.count >=2
	) as select2
GROUP BY select2.medical_insurence_number
HAVING  COUNT(select2.medical_insurence_number) > 3
