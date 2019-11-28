SELECT timeslot, COUNT(week) AS total, (COUNT(week)/52.1429) AS average
FROM (	SELECT EXTRACT(WEEK FROM appointment_timestamp) AS week,
 		CAST(EXTRACT(ISODOW FROM appointment_timestamp) AS TEXT) ||
 		' ' ||
 		SUBSTRING(CAST(appointment_timestamp AS TEXT), 12, 5) AS timeslot
		FROM (	SELECT appointment_timestamp
				FROM createappointment
WHERE appointment_timestamp::timestamp::date > current_date
			 ) as timestamp_during_year
		GROUP BY appointment_timestamp
		ORDER BY week
	 ) as stamp
GROUP BY timeslot
HAVING
COUNT(week) > 1
ORDER BY timeslot;
