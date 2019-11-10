CREATE TABLE EmployeeAccount (
	password VARCHAR(8) NOT NULL,
	login VARCHAR(64) NOT NULL,
	education VARCHAR(1024) NOT NULL,
	date_of_start_of_career DATE NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(16) NOT NULL,
	email VARCHAR(64) NOT NULL,
	CONSTRAINT pk_EmployeeAccount PRIMARY KEY (
		login
	 )
);

CREATE TABLE HeadOfDepartment (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_HeadOfDepartment PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE TaskOfToDoList (
	priority INTEGER NOT NULL,
	task_description VARCHAR(2048) NOT NULL,
	task_title VARCHAR(512) NOT NULL,
	task_status BOOLEAN NOT NULL,
	login VARCHAR(64) NOT NULL,
	CONSTRAINT pk_TaskOfToDoList PRIMARY KEY (
		task_title
	 ),
	CONSTRAINT fk_TaskOfToDoList_task_title FOREIGN KEY(login)
											REFERENCES EmployeeAccount (login)
);

CREATE TABLE Security (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE SendMessage (
	message_text VARCHAR(2048) NOT NULL,
	title VARCHAR(512) NOT NULL,
	file BYTEA NOT NULL
);

CREATE TABLE HR (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_HR PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE AddFire (
	request_status BOOLEAN NOT NULL
);

CREATE TABLE Cleaning (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_Cleaning PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Noticeboard (
	season VARCHAR(8) NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_Noticeboard PRIMARY KEY (
		season,year
	 )
);

CREATE TABLE Notice (
	title VARCHAR(512) NOT NULL,
	season VARCHAR(8) NOT NULL,
	year VARCHAR(4) NOT NULL,
	content VARCHAR(2048) NOT NULL,
	CONSTRAINT pk_Notice PRIMARY KEY (
		title,season,year
	),
	CONSTRAINT fk_Notice_title FOREIGN KEY(season,year) 
							   REFERENCES Noticeboard (season,year)
);

CREATE TABLE StaffsTimetable (
	month VARCHAR(8) NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_StaffsTimetable PRIMARY KEY (
		month,year
	 )
);

-- relationship
CREATE TABLE SendRequest (
	status BOOLEAN NOT NULL,
	purpose VARCHAR(512) NOT NULL,
	request_timestamp TIMESTAMP NOT NULL
);

CREATE TABLE WarehouseManager (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_WarehouseManager PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Inventory (
	inventory_code INTEGER NOT NULL,
	date_of_purchase DATE NOT NULL,
	price MONEY NOT NULL,
	inventory_name VARCHAR(256) NOT NULL,
	quantity INTEGER NOT NULL,
	CONSTRAINT pk_Inventory PRIMARY KEY (
		inventory_code,inventory_name
	 )
);

CREATE TABLE PatientAccount (
	password VARCHAR(8) NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(16) NOT NULL,
	email VARCHAR(64) NOT NULL,
	medical_insurence_number INTEGER NOT NULL,
	CONSTRAINT pk_PatientAccount PRIMARY KEY (
		medical_insurence_number
	 )
);

-- weak
CREATE TABLE Feedback (
	title VARCHAR(512) NOT NULL,
	content VARCHAR(2048) NOT NULL,
	feedback_timestamp TIMESTAMP NOT NULL,
	medical_insurence_number INTEGER NOT NULL,
	CONSTRAINT pk_Feedback PRIMARY KEY (
		feedback_timestamp
	 ),
	CONSTRAINT fk_Feedback_timestamp FOREIGN KEY(medical_insurence_number) 
									 REFERENCES PatientAccount (medical_insurence_number)

);

CREATE TABLE Nurse (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_Nurse PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE SendMedicalReport (
	details VARCHAR(2048) NOT NULL,
	report_timestamp TIMESTAMP NOT NULL,
	complaints VARCHAR(2048) NOT NULL,
	conclusion VARCHAR(2048) NOT NULL
);

CREATE TABLE ITSpecialist (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_ITSpecialist PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE Contacts (
	contacts_timestamp TIMESTAMP NOT NULL,
	message VARCHAR(2048) NOT NULL
);

CREATE TABLE Doctor (
	SSN INTEGER NOT NULL,
	is_on_training BOOLEAN NOT NULL,
	date_of_the_last_training DATE NOT NULL,
	CONSTRAINT pk_Doctor PRIMARY KEY (
		SSN
	 )
);

-- relationship
CREATE TABLE CreateRecipe (
	recommendations VARCHAR(2048) NOT NULL,
	recipe_timestamp TIMESTAMP NOT NULL,
	CONSTRAINT pk_CreateRecipe PRIMARY KEY (
		recipe_timestamp
	 )
);

-- multi attribute
CREATE TABLE Department (
	list_of_rooms INTEGER[],
	department_name VARCHAR(512) NOT NULL,
	CONSTRAINT pk_Department PRIMARY KEY (
		department_name
	 )
);

-- relationship
CREATE TABLE CreateAppointment (
	appointment_timestamp TIMESTAMP NOT NULL,
	room SMALLINT NOT NULL,
	CONSTRAINT pk_CreateAppointment PRIMARY KEY (
		appointment_timestamp
	 )
);

CREATE TABLE PatientTimetable (
	year VARCHAR(4) NOT NULL,
	month VARCHAR(8) NOT NULL,
	CONSTRAINT pk_PatientTimetable PRIMARY KEY (
		year,month
	 )
);


CREATE TABLE Pharmacist (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_Pharmacist PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Medicine (
	price MONEY NOT NULL,
	quantity INTEGER NOT NULL,
	requires_recipe BOOLEAN NOT NULL,
	medicine_name VARCHAR(256) NOT NULL,
	CONSTRAINT pk_Medicine PRIMARY KEY (
		medicine_name
	 )
);

CREATE TABLE Financial (
	SSN INTEGER NOT NULL,
	CONSTRAINT pk_Financial PRIMARY KEY (
		SSN
	 )
);

CREATE TABLE Bill (
	quantity INTEGER NOT NULL,
	name VARCHAR(256) NOT NULL,
	price MONEY NOT NULL,
	bill_timestamp TIMESTAMP NOT NULL,
	from_id INTEGER NOT NULL,
	to_id INTEGER NOT NULL,
	CONSTRAINT pk_Bill PRIMARY KEY (
		from_id,to_id
	 )
);

-- relationship
CREATE TABLE RequestForMeds (
	medical_name VARCHAR(256) NOT NULL,
	status BOOLEAN NOT NULL,
	meds_request_timestamp TIMESTAMP NOT NULL
);
