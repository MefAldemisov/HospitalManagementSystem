# Hospital Management System

## TODO

- [ ] Fix bug with PRIMARY - PARTIAL keys (`tablesUpdated.sql`)
- [ ] Solve the problem of 1! doctor in department (`tablesUpdated.sql`)
- [ ] Create interface
- [ ] Convert to MySQL

## Requirments for `tablesUpdated.sql` file (to be parsed by generator script)

1. Each  `REFERENCES` relation should connect columns with the same names

Example:

Correct:
```sql
CREATE TABLE Security (
	security_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		security_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);
```

INCORRECT:

```sql
CREATE TABLE Security (
	security_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		security_SSN
	 ),
	acc VARCHAR(16) REFERENCES EmployeeAccount(email)
);
```

2. Creation of each simple entry should be generated with statement that finishs on `NOT NULL` (look at the `security_SSN` at the example above)

3. `SSN` for each type of employee should be named in format `job_SSN` started with **lowercase letter**
