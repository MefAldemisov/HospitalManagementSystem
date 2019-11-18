CREATE TABLE EmployeeAccount (
	password VARCHAR(16) NOT NULL,
	login VARCHAR(16) NOT NULL,
	education VARCHAR(1024) NOT NULL,
	date_of_start_of_career DATE NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(11) NOT NULL,
	email VARCHAR(64) NOT NULL,
	CONSTRAINT pk_EmployeeAccount PRIMARY KEY (
		login
	 )
);

CREATE TABLE HeadOfDepartment (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_HeadOfDepartment PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE TaskOfToDoList (
	priority INTEGER NOT NULL,
	task_description VARCHAR(2048) NOT NULL,
	task_title VARCHAR(512) NOT NULL,
	task_status BOOLEAN NOT NULL,
	login VARCHAR(16) NOT NULL,
	CONSTRAINT pk_TaskOfToDoList PRIMARY KEY (
		task_title
	 ),
	CONSTRAINT fk_TaskOfToDoList_task_title FOREIGN KEY(login)
											REFERENCES EmployeeAccount (login)
);

CREATE TABLE Security (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

-- relationship
CREATE TABLE SendMessage (
	message_text VARCHAR(2048) NOT NULL,
	title VARCHAR(512) NOT NULL,
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE HR (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_HR PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

-- relationship
CREATE TABLE AddFire (
	request_status BOOLEAN NOT NULL,
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	hr VARCHAR(9) REFERENCES HR(SSN),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE Cleaning (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Cleaning PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE Noticeboard (
	season SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_Noticeboard PRIMARY KEY (
		season,year
	 ),
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

CREATE TABLE Notice (
	title VARCHAR(512) NOT NULL,
	season SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	content VARCHAR(2048) NOT NULL,
	CONSTRAINT pk_Notice PRIMARY KEY (
		title,season,year
	),
	CONSTRAINT fk_Notice_title FOREIGN KEY(season,year) 
							   REFERENCES Noticeboard (season,year)
);

CREATE TABLE StaffsTimetable (
	month SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_StaffsTimetable PRIMARY KEY (
		month,year
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login),
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

-- relationship
CREATE TABLE SendRequest (
	status BOOLEAN NOT NULL,
	purpose VARCHAR(512) NOT NULL,
	request_timestamp VARCHAR(10) NOT NULL,
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE WarehouseManager (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_WarehouseManager PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
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

CREATE TABLE ManagesWarehouseInventory (
	warehouse_manager VARCHAR(9) REFERENCES WarehouseManager(SSN),
	inventory INTEGER REFERENCES Inventory(inventory_code)
);

CREATE TABLE PatientAccount (
	password VARCHAR(16) NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(11) NOT NULL,
	email VARCHAR(64) NOT NULL,
	medical_insurence_number INTEGER NOT NULL,
	CONSTRAINT pk_PatientAccount PRIMARY KEY (
		medical_insurence_number
	 )
);

CREATE TABLE SeeFeedback (
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	feedback VARCHAR(10) REFERENCES Feedback(feedback_timestamp)
)

-- weak
CREATE TABLE Feedback (
	title VARCHAR(512) NOT NULL,
	content VARCHAR(2048) NOT NULL,
	feedback_timestamp VARCHAR(10) NOT NULL,
	medical_insurence_number INTEGER NOT NULL,
	CONSTRAINT pk_Feedback PRIMARY KEY (
		feedback_timestamp
	 ),
	CONSTRAINT fk_Feedback_timestamp FOREIGN KEY(medical_insurence_number) 
									 REFERENCES PatientAccount (medical_insurence_number),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE Nurse (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Nurse PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

-- relationship
CREATE TABLE SendMedicalReport (
	details VARCHAR(2048) NOT NULL,
	report_timestamp VARCHAR(10) NOT NULL,
	complaints VARCHAR(2048) NOT NULL,
	conclusion VARCHAR(2048) NOT NULL,
	nurse VARCHAR(9) REFERENCES Nurse(SSN),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	doctor VARCHAR(9) REFERENCES Doctor(SSN)
);

CREATE TABLE ITSpecialist (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_ITSpecialist PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE ManagesITEmployee (
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login),
	it_specialist VARCHAR(9) REFERENCES ITSpecialist(SSN)
);

-- relationship
CREATE TABLE Contacts (
	contacts_timestamp VARCHAR(10) NOT NULL,
	message VARCHAR(2048) NOT NULL,
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	it_specialist VARCHAR(9) REFERENCES ITSpecialist(SSN)
);

CREATE TABLE Doctor (
	SSN VARCHAR(9) NOT NULL,
	is_on_training BOOLEAN NOT NULL,
	date_of_the_last_training DATE NOT NULL,
	CONSTRAINT pk_Doctor PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login),
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

-- relationship
CREATE TABLE CreateRecipe (
	recommendations VARCHAR(2048) NOT NULL,
	recipe_timestamp VARCHAR(10) NOT NULL,
	CONSTRAINT pk_CreateRecipe PRIMARY KEY (
		recipe_timestamp
	 ),
	doctor VARCHAR(9) REFERENCES Doctor(SSN),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

-- multi attribute
CREATE TABLE Department (
	list_of_rooms INTEGER[],
	department_name VARCHAR(512) NOT NULL,
	CONSTRAINT pk_Department PRIMARY KEY (
		department_name
	 ),
	doctor VARCHAR(9) REFERENCES Doctor(SSN)
);

CREATE TABLE Controls (
	department VARCHAR(512) REFERENCES Department(department_name),
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

-- relationship
CREATE TABLE CreateAppointment (
	appointment_timestamp VARCHAR(10) NOT NULL,
	room SMALLINT NOT NULL,
	CONSTRAINT pk_CreateAppointment PRIMARY KEY (
		appointment_timestamp
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	doctor VARCHAR(9) REFERENCES Doctor(SSN)
);

CREATE TABLE PatientTimetable (
	year VARCHAR(4) NOT NULL,
	month SMALLINT NOT NULL,
	CONSTRAINT pk_PatientTimetable PRIMARY KEY (
		year,month
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	create_appointment VARCHAR(10) REFERENCES CreateAppointment(appointment_timestamp)
);


CREATE TABLE Pharmacist (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Pharmacist PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE Medicine (
	price MONEY NOT NULL,
	quantity INTEGER NOT NULL,
	requires_recipe BOOLEAN NOT NULL,
	medicine_name VARCHAR(256) NOT NULL,
	medicine_id VARCHAR(16) NOT NULL,
	CONSTRAINT pk_Medicine PRIMARY KEY (
		medicine_id
	 )
);

CREATE TABLE ChangePrice (
	head_of_deaprtment VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	medicine VARCHAR(16) REFERENCES Medicine(medicine_id)
);


CREATE TABLE ManagesPharmacistMedicine (
	pharmacist VARCHAR(9) REFERENCES Pharmacist(SSN),
	medicine VARCHAR(16) REFERENCES Medicine(medicine_id)
);

CREATE TABLE Financial (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Financial PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(login)
);

CREATE TABLE Bill (
	quantity INTEGER NOT NULL,
	bill_name VARCHAR(256) NOT NULL,
	price MONEY NOT NULL,
	bill_timestamp VARCHAR(10) NOT NULL,
	from_id INTEGER NOT NULL,
	to_id INTEGER NOT NULL,
	CONSTRAINT pk_Bill PRIMARY KEY (
		from_id,to_id
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE ManagesBillFinancial (
	financial VARCHAR(9) REFERENCES Financial(SSN),
	bill INTEGER REFERENCES Bill(from_id)
);

-- relationship
CREATE TABLE RequestForMeds (
	medicine_name VARCHAR(256) NOT NULL,
	status BOOLEAN NOT NULL,
	meds_request_timestamp VARCHAR(10) NOT NULL,
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	pharmacist VARCHAR(9) REFERENCES Pharmacist(SSN)
);
