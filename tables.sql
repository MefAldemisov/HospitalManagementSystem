CREATE TABLE EmployeeAccount (
	password VARCHAR(64) NOT NULL,
	login VARCHAR(64) NOT NULL,
	education VARCHAR(64) NOT NULL,
	date_of_start_of_career VARCHAR(64) NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(64) NOT NULL,
	email VARCHAR(64) NOT NULL,
	CONSTRAINT pk_EmployeeAccount PRIMARY KEY (
		login
	 )
);

CREATE TABLE HeadOfDepartment (
	SSN int NOT NULL,
	CONSTRAINT pk_HeadOfDepartment PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE TaskOfToDoList (
	priority int NOT NULL,
	task_description VARCHAR(64) NOT NULL,
	task_title VARCHAR(64) NOT NULL,
	task_status int NOT NULL,
	login VARCHAR(64) NOT NULL,
	CONSTRAINT pk_TaskOfToDoList PRIMARY KEY (
		task_title
	 ),
	CONSTRAINT fk_TaskOfToDoList_task_title FOREIGN KEY(login)
											REFERENCES EmployeeAccount (login)
);

CREATE TABLE Security (
	SSN int NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE SendMessage (
	message_text VARCHAR(64) NOT NULL,
	title VARCHAR(64) NOT NULL,
	file VARCHAR(64) NOT NULL
);

CREATE TABLE HR (
	SSN int NOT NULL,
	CONSTRAINT pk_HR PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE AddFire (
	request_status int NOT NULL
);

CREATE TABLE Cleaning (
	SSN int NOT NULL,
	CONSTRAINT pk_Cleaning PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Noticeboard (
	season VARCHAR(64) NOT NULL,
	year VARCHAR(64) NOT NULL,
	CONSTRAINT pk_Noticeboard PRIMARY KEY (
		season,year
	 )
);

CREATE TABLE Notice (
	title VARCHAR(64) NOT NULL,
	season VARCHAR(64) NOT NULL,
	year VARCHAR(64) NOT NULL,
	content VARCHAR(64) NOT NULL,
	CONSTRAINT pk_Notice PRIMARY KEY (
		title,season,year
	),
	CONSTRAINT fk_Notice_title FOREIGN KEY(season,year) 
							   REFERENCES Noticeboard (season,year)
);

CREATE TABLE StaffsTimetable (
	month int NOT NULL,
	year int NOT NULL,
	CONSTRAINT pk_StaffsTimetable PRIMARY KEY (
		month,year
	 )
);

-- relationship
CREATE TABLE SendRequest (
	status int NOT NULL,
	purpose VARCHAR(64) NOT NULL,
	timestamp VARCHAR(64) NOT NULL
);

CREATE TABLE WarehouseManager (
	SSN int NOT NULL,
	CONSTRAINT pk_WarehouseManager PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Inventory (
	inventory_code int NOT NULL,
	date_of_purchase VARCHAR(64) NOT NULL,
	price int NOT NULL,
	inventory_name VARCHAR(64) NOT NULL,
	quantity int NOT NULL,
	CONSTRAINT pk_Inventory PRIMARY KEY (
		inventory_code,inventory_name
	 )
);

CREATE TABLE PatientAccount (
	password VARCHAR(64) NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(64) NOT NULL,
	email VARCHAR(64) NOT NULL,
	medical_insurence_number int NOT NULL,
	CONSTRAINT pk_PatientAccount PRIMARY KEY (
		medical_insurence_number
	 )
);

-- weak
CREATE TABLE Feedback (
	title VARCHAR(64) NOT NULL,
	content VARCHAR(64) NOT NULL,
	timestamp VARCHAR(64) NOT NULL,
	medical_insurence_number int NOT NULL,
	CONSTRAINT pk_Feedback PRIMARY KEY (
		timestamp
	 ),
	CONSTRAINT fk_Feedback_timestamp FOREIGN KEY(medical_insurence_number) 
									 REFERENCES PatientAccount (medical_insurence_number)

);

CREATE TABLE Nurse (
	SSN int NOT NULL,
	CONSTRAINT pk_Nurse PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE SendMedicalReport (
	details VARCHAR(64) NOT NULL,
	timestamp VARCHAR(64) NOT NULL,
	complaints VARCHAR(64) NOT NULL,
	conclusion VARCHAR(64) NOT NULL
);

CREATE TABLE ITSpecialist (
	SSN int NOT NULL,
	CONSTRAINT pk_ITSpecialist PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE Contacts (
	timestamp VARCHAR(64) NOT NULL,
	message VARCHAR(64) NOT NULL
);

CREATE TABLE Doctor (
	SSN int NOT NULL,
	is_on_training int NOT NULL,
	date_of_the_last_training VARCHAR(64) NOT NULL,
	CONSTRAINT pk_Doctor PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE CreateRecipe (
	recommendations VARCHAR(64) NOT NULL,
	timestamp VARCHAR(64) NOT NULL,
	CONSTRAINT pk_CreateRecipe PRIMARY KEY (
		timestamp
	 )
);

-- multi attribute
CREATE TABLE Department (
	list_of_rooms VARCHAR(64) NOT NULL,
	department_name VARCHAR(64) NOT NULL,
	CONSTRAINT pk_Department PRIMARY KEY (
		department_name
	 )
);

-- relationship
CREATE TABLE CreateAppointment (
	timestamp VARCHAR(64) NOT NULL,
	room int NOT NULL,
	CONSTRAINT pk_CreateAppointment PRIMARY KEY (
		timestamp
	 )
);

CREATE TABLE PatientTimetable (
	year int NOT NULL,
	month int NOT NULL,
	CONSTRAINT pk_PatientTimetable PRIMARY KEY (
		year,month
	 )
);


CREATE TABLE Pharmacist (
	SSN int NOT NULL,
	CONSTRAINT pk_Pharmacist PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Medicine (
	price int NOT NULL,
	quantity int NOT NULL,
	requires_recipe int NOT NULL,
	medicine_name VARCHAR(64) NOT NULL,
	CONSTRAINT pk_Medicine PRIMARY KEY (
		medicine_name
	 )
);

CREATE TABLE Financial (
	SSN int NOT NULL,
	CONSTRAINT pk_Financial PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Bill (
	quantity int NOT NULL,
	name VARCHAR(64) NOT NULL,
	price int NOT NULL,
	timestamp VARCHAR(64) NOT NULL,
	from_id int NOT NULL,
	to_id int NOT NULL,
	CONSTRAINT pk_Bill PRIMARY KEY (
		from_id,to_id
	 )
);

-- relationship
CREATE TABLE RequestForMeds (
	medical_name VARCHAR(64) NOT NULL,
	status int NOT NULL,
	timestamp VARCHAR(64) NOT NULL
);


-- ALTER TABLE TaskOfToDoList ADD CONSTRAINT fk_TaskOfToDoList_task_title FOREIGN KEY(task_title)
-- REFERENCES EmployeeAccount (login);

