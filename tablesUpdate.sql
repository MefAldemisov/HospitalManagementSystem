CREATE TABLE EmployeeAccount (
	password VARCHAR(16) NOT NULL,
	email VARCHAR(16) NOT NULL,
	education VARCHAR(1024) NOT NULL,
	date_of_start_of_career DATE NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(11) NOT NULL,
	email VARCHAR(64) NOT NULL,
	CONSTRAINT pk_EmployeeAccount PRIMARY KEY (
		email
	 )
);

CREATE TABLE HeadOfDepartment (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_HeadOfDepartment PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
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

CREATE TABLE TaskOfToDoList (
	priority INTEGER NOT NULL,
	task_description VARCHAR(2048) NOT NULL,
	task_title VARCHAR(512) NOT NULL,
	task_status BOOLEAN NOT NULL,
	email VARCHAR(16) NOT NULL,
	CONSTRAINT pk_TaskOfToDoList PRIMARY KEY (
		task_title
	 ),
	CONSTRAINT fk_TaskOfToDoList_task_title FOREIGN KEY(email)
											REFERENCES EmployeeAccount (email)
);

CREATE TABLE ManageTask (
	manage_task_change_log VARCHAR(256) NOT NULL,
	manage_task_timestamp TIMESTAMP NOT NULL,
	task_of_todo_list VARCHAR(512) REFERENCES TaskOfToDoList(task_title),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
)

CREATE TABLE Security (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE SendMessage (
	message_text VARCHAR(2048) NOT NULL,
	title VARCHAR(512) NOT NULL,
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE HR (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_HR PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE AddFire (
	add_fire_flag SMALLINT NOT NULL,
	request_status BOOLEAN NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	hr VARCHAR(9) REFERENCES HR(SSN),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE Cleaning (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Cleaning PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE Noticeboard (
	season SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_Noticeboard PRIMARY KEY (
		season,year
	 )
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

CREATE TABLE EditNotice (
	edit_notice_change_log VARCHAR(256) NOT NULL,
	edit_notice_timestamp TIMESTAMP NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	noticeboard SMALLINT REFERENCES Noticeboard(season)
)

CREATE TABLE StaffsTimetable (
	month SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_StaffsTimetable PRIMARY KEY (
		month,year
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE EditStaffsTimetable (
	edit_staffs_timetable_change_log VARCHAR(256) NOT NULL,
	edit_staffs_timetable_timestamp TIMESTAMP NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	staffs_timetable VARCHAR(4) REFERENCES StaffsTimetable(year)
)

CREATE TABLE SendRequest (
	status BOOLEAN NOT NULL,
	purpose VARCHAR(512) NOT NULL,
	request_timestamp TIMESTAMP NOT NULL,
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE WarehouseManager (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_WarehouseManager PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
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

CREATE TABLE ManageInventory (
	manage_inventory_change_log VARCHAR(256) NOT NULL,
	manage_inventory_timestamp TIMESTAMP NOT NULL,
	warehouse_manager VARCHAR(9) REFERENCES WarehouseManager(SSN),
	inventory INTEGER REFERENCES Inventory(inventory_code)
);

-- weak
CREATE TABLE Feedback (
	title VARCHAR(512) NOT NULL,
	content VARCHAR(2048) NOT NULL,
	feedback_timestamp TIMESTAMP NOT NULL,
	CONSTRAINT pk_Feedback PRIMARY KEY (
		feedback_timestamp
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE Nurse (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Nurse PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE Doctor (
	SSN VARCHAR(9) NOT NULL,
	is_on_training BOOLEAN NOT NULL,
	date_of_the_last_training DATE NOT NULL,
	CONSTRAINT pk_Doctor PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

CREATE TABLE MedicalReport (
	details VARCHAR(2048) NOT NULL,
	report_timestamp TIMESTAMP NOT NULL,
	complaints VARCHAR(2048) NOT NULL,
	conclusion VARCHAR(2048) NOT NULL,
	nurse VARCHAR(9) REFERENCES Nurse(SSN)
);

CREATE TABLE ITSpecialist (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_ITSpecialist PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE ManageEmployeeAccount (
	manage_employee_account_change_log VARCHAR(256) NOT NULL,
	manage_employee_account_timestamp TIMESTAMP NOT NULL,
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
	it_specialist VARCHAR(9) REFERENCES ITSpecialist(SSN)
);

CREATE TABLE Contacts (
	contacts_timestamp TIMESTAMP NOT NULL,
	message VARCHAR(2048) NOT NULL,
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	it_specialist VARCHAR(9) REFERENCES ITSpecialist(SSN)
);

CREATE TABLE CreateRecipe (
	recommendations VARCHAR(2048) NOT NULL,
	recipe_timestamp TIMESTAMP NOT NULL,
	CONSTRAINT pk_CreateRecipe PRIMARY KEY (
		recipe_timestamp
	 ),
	doctor VARCHAR(9) REFERENCES Doctor(SSN),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

-- multi attribute
CREATE TABLE Department (
	list_of_rooms INTEGER[] NOT NULL,
	department_name VARCHAR(512) NOT NULL,
	CONSTRAINT pk_Department PRIMARY KEY (
		department_name
	 ),
	doctor VARCHAR(9) REFERENCES Doctor(SSN),
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

CREATE TABLE Controls (
	department VARCHAR(512) REFERENCES Department(department_name),
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

CREATE TABLE PatientTimetable (
	year VARCHAR(4) NOT NULL,
	month SMALLINT NOT NULL,
	CONSTRAINT pk_PatientTimetable PRIMARY KEY (
		year,month
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN)
);

CREATE TABLE EditPatientTimetable (
	edit_patient_timetable_change_log VARCHAR(256) NOT NULL,
	edit_patient_timetable_timestamp TIMESTAMP NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	patient_timetable VARCHAR(4) REFERENCES PatientTimetable(year)
)

CREATE TABLE CreateAppointment (
	appointment_timestamp TIMESTAMP NOT NULL,
	room SMALLINT NOT NULL,
	CONSTRAINT pk_CreateAppointment PRIMARY KEY (
		appointment_timestamp
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	doctor VARCHAR(9) REFERENCES Doctor(SSN),
	patient_timetable VARCHAR(4) REFERENCES PatientTimetable(year)
);

CREATE TABLE Pharmacist (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Pharmacist PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
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

CREATE TABLE ManageMedicine (
	manage_medicine_change_log VARCHAR(256) NOT NULL,
	manage_medicine_timestamp TIMESTAMP NOT NULL,
	pharmacist VARCHAR(9) REFERENCES Pharmacist(SSN),
	medicine VARCHAR(16) REFERENCES Medicine(medicine_id)
)

CREATE TABLE ChangePrice (
	change_price_change_log VARCHAR(256) NOT NULL,
	change_price_timestamp TIMESTAMP NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	medicine VARCHAR(16) REFERENCES Medicine(medicine_id)
);

CREATE TABLE Financial (
	SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Financial PRIMARY KEY (
		SSN
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE Bill (
	quantity INTEGER NOT NULL,
	bill_name VARCHAR(256) NOT NULL,
	price MONEY NOT NULL,
	bill_timestamp TIMESTAMP NOT NULL,
	from_id INTEGER NOT NULL,
	to_id INTEGER NOT NULL,
	CONSTRAINT pk_Bill PRIMARY KEY (
		from_id,to_id
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE ManageBill (
	manage_bill_change_log VARCHAR(256) NOT NULL,
	manage_bill_timestamp TIMESTAMP NOT NULL,
	financial VARCHAR(9) REFERENCES Financial(SSN),
	bill INTEGER REFERENCES Bill(from_id)
);

CREATE TABLE RequestForMeds (
	medicine_name VARCHAR(256) NOT NULL,
	status BOOLEAN NOT NULL,
	meds_request_timestamp TIMESTAMP NOT NULL,
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	pharmacist VARCHAR(9) REFERENCES Pharmacist(SSN)
);
