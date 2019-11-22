CREATE TABLE EmployeeAccount (
	password VARCHAR(16) NOT NULL,
	email VARCHAR(16) NOT NULL,
	education VARCHAR(1024) NOT NULL,
	date_of_start_of_career DATE NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	phone VARCHAR(11) NOT NULL,
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
	date_of_birth DATE NOT NULL,
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
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
	CONSTRAINT fk_task_of_todo_list FOREIGN KEY(task_of_todo_list)
											REFERENCES TaskOfToDoList (task_title),
	CONSTRAINT fk_employee_account_manage_task FOREIGN KEY(employee_account)
											REFERENCES EmployeeAccount (email)
);

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
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
	CONSTRAINT fk_employee_account_send_message FOREIGN KEY(employee_account)
											REFERENCES EmployeeAccount (email)
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
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
	CONSTRAINT fk_employee_account_add_fire FOREIGN KEY(employee_account)
											REFERENCES EmployeeAccount (email),
	CONSTRAINT fk_head_of_department_add_fire FOREIGN KEY(head_of_department)
											REFERENCES HeadOfDepartment (SSN),
	CONSTRAINT fk_hr_add_fire FOREIGN KEY(hr)
											REFERENCES HR (SSN)
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
	noticeboard_season SMALLINT NOT NULL,
	noticeboard_year VARCHAR(4) NOT NULL,
	CONSTRAINT fk_head_of_department_edit_notice FOREIGN KEY(head_of_department)
											REFERENCES HeadOfDepartment (SSN),
	CONSTRAINT fk_noticeboard_edit_notice FOREIGN KEY(noticeboard_season,noticeboard_year)
											REFERENCES Noticeboard (season, year)
);

CREATE TABLE StaffsTimetable (
	month SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_StaffsTimetable PRIMARY KEY (
		year, month
	 ),
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE EditStaffsTimetable (
	edit_staffs_timetable_change_log VARCHAR(256) NOT NULL,
	edit_staffs_timetable_timestamp TIMESTAMP NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	staffs_timetable_year VARCHAR(4) NOT NULL,
	staffs_timetable_month SMALLINT NOT NULL,
	CONSTRAINT fk_head_of_department_edit_staffs_timetable FOREIGN KEY(head_of_department)
											REFERENCES HeadOfDepartment (SSN),
	CONSTRAINT fk_staffs_timetable_edit_staffs_timetable FOREIGN KEY(staffs_timetable_year, staffs_timetable_month)
											REFERENCES StaffsTimetable (year, month)
);

CREATE TABLE SendRequest (
	status BOOLEAN NOT NULL,
	purpose VARCHAR(512) NOT NULL,
	request_timestamp TIMESTAMP NOT NULL,
	employee_account VARCHAR(16) REFERENCES EmployeeAccount(email),
	CONSTRAINT fk_employee_account_send_request FOREIGN KEY(employee_account)
											REFERENCES EmployeeAccount (email)
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
	inventory_code INTEGER NOT NULL,
	inventory_name VARCHAR(256) NOT NULL,
	CONSTRAINT fk_warehouse_manager_manage_inventory FOREIGN KEY(warehouse_manager)
											REFERENCES WarehouseManager (SSN),
	CONSTRAINT fk_inventory_manage_inventory FOREIGN KEY(inventory_code, inventory_name)
											REFERENCES Inventory (inventory_code, inventory_name)
);

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
	CONSTRAINT pk_MedicalReport PRIMARY KEY (
		report_timestamp
	 ),
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
	it_specialist VARCHAR(9) REFERENCES ITSpecialist(SSN),
	CONSTRAINT fk_employee_account_manage_employee_account FOREIGN KEY(employee_account)
											REFERENCES EmployeeAccount (email),
	CONSTRAINT fk_it_specialist_manage_employee_account FOREIGN KEY(it_specialist)
											REFERENCES ITSpecialist (SSN)
);

CREATE TABLE Contacts (
	contacts_timestamp TIMESTAMP NOT NULL,
	message VARCHAR(2048) NOT NULL,
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	it_specialist VARCHAR(9) REFERENCES ITSpecialist(SSN),
	CONSTRAINT fk_it_specialist_contacts FOREIGN KEY(it_specialist)
											REFERENCES ITSpecialist (SSN),
	CONSTRAINT fk_patient_account_contacts FOREIGN KEY(patient_account)
											REFERENCES PatientAccount (medical_insurence_number)
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

CREATE TABLE Department (
	list_of_rooms INTEGER[] NOT NULL,
	department_name VARCHAR(512) NOT NULL,
	CONSTRAINT pk_Department PRIMARY KEY (
		department_name
	 ),
	doctor VARCHAR(9) REFERENCES Doctor(SSN),
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
	patient_timetable_year VARCHAR(4) NOT NULL,
	patient_timetable_month SMALLINT NOT NULL,
	CONSTRAINT fk_head_of_department_edit_patient_timetable FOREIGN KEY(head_of_department)
											REFERENCES HeadOfDepartment (SSN),
	CONSTRAINT fk_patient_timetable_edit_patient_timetable FOREIGN KEY(patient_timetable_year, patient_timetable_month)
											REFERENCES PatientTimetable (year, month)
);

CREATE TABLE CreateAppointment (
	appointment_timestamp TIMESTAMP NOT NULL,
	room SMALLINT NOT NULL,
	CONSTRAINT pk_CreateAppointment PRIMARY KEY (
		appointment_timestamp
	 ),
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	doctor VARCHAR(9) REFERENCES Doctor(SSN),
	patient_timetable_year VARCHAR(4) NOT NULL,
	patient_timetable_month SMALLINT NOT NULL,
	CONSTRAINT fk_patient_timetable_create_appointment FOREIGN KEY(patient_timetable_year, patient_timetable_month)
											REFERENCES PatientTimetable (year, month)
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
	medicine VARCHAR(16) REFERENCES Medicine(medicine_id),
	CONSTRAINT fk_pharmacist_manage_medicine FOREIGN KEY(pharmacist)
											REFERENCES Pharmacist (SSN),
	CONSTRAINT fk_medicine_manage_medicine FOREIGN KEY(medicine)
											REFERENCES Medicine (medicine_id)
);

CREATE TABLE ChangePrice (
	change_price_change_log VARCHAR(256) NOT NULL,
	change_price_timestamp TIMESTAMP NOT NULL,
	head_of_department VARCHAR(9) REFERENCES HeadOfDepartment(SSN),
	medicine VARCHAR(16) REFERENCES Medicine(medicine_id),
	CONSTRAINT fk_medicine_change_price FOREIGN KEY(medicine)
											REFERENCES Medicine (medicine_id),
	CONSTRAINT fk_head_of_department_change_price FOREIGN KEY(head_of_department)
											REFERENCES HeadOfDepartment (SSN)
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
	bill_from_id INTEGER NOT NULL,
	bill_to_id INTEGER NOT NULL,
	CONSTRAINT fk_financial_manage_bill FOREIGN KEY(financial)
											REFERENCES Financial (SSN),
	CONSTRAINT fk_bill_manage_bill FOREIGN KEY(bill_from_id, bill_to_id)
											REFERENCES Bill (from_id, to_id)
);

CREATE TABLE RequestForMeds (
	medicine_name VARCHAR(256) NOT NULL,
	status BOOLEAN NOT NULL,
	meds_request_timestamp TIMESTAMP NOT NULL,
	patient_account INTEGER REFERENCES PatientAccount(medical_insurence_number),
	pharmacist VARCHAR(9) REFERENCES Pharmacist(SSN),
	CONSTRAINT fk_patient_account_request_for_meds FOREIGN KEY(patient_account)
											REFERENCES PatientAccount (medical_insurence_number),
	CONSTRAINT fk_pharmacist_request_for_meds FOREIGN KEY(pharmacist)
											REFERENCES Pharmacist (SSN)
);
