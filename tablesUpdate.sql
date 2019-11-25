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
	headOfDepartment_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_HeadOfDepartment PRIMARY KEY (
		headOfDepartment_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);


CREATE TABLE Department (
	department_name VARCHAR(512) NOT NULL,
	CONSTRAINT pk_Department PRIMARY KEY (
		department_name
	 )
);

CREATE TABLE ManageDepartment (
	department_name VARCHAR(512) NOT NULL,
	headOfDepartment_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_ManageDepartment PRIMARY KEY (
		department_name, headOfDepartment_SSN
	),
	CONSTRAINT fk_DepartmentName FOREIGN KEY (department_name) 
								 REFERENCES Department(department_name),
	CONSTRAINT fk_HeadOfDepSSN FOREIGN KEY (headOfDepartment_SSN) 
								 REFERENCES HeadOfDepartment(headOfDepartment_SSN)
);

CREATE TABLE PatientAccount (
	password VARCHAR(16) NOT NULL,
	surname VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	date_of_birth DATE NOT NULL,
	phone VARCHAR(11) NOT NULL,
	email VARCHAR(64) NOT NULL,
	medical_insurence_number BIGINT NOT NULL,
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
		task_title, email
	 ),
	CONSTRAINT fk_TaskOfToDoList_task_title FOREIGN KEY(email)
											REFERENCES EmployeeAccount (email)
);

CREATE TABLE ManageTask (
	manage_task_change_log VARCHAR(256) NOT NULL,
	manage_task_timestamp TIMESTAMP NOT NULL,
	task_title VARCHAR(512) NOT NULL,
	email VARCHAR(16) NOT NULL,
	CONSTRAINT pk_ManageTask PRIMARY KEY (
		task_title, email
	),
	CONSTRAINT fk_task_of_todo_list FOREIGN KEY(task_title, email)
											REFERENCES TaskOfToDoList (task_title, email)
);

CREATE TABLE Security (
	security_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Security PRIMARY KEY (
		security_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE SendMessage (
	message_text VARCHAR(2048) NOT NULL,
	title VARCHAR(512) NOT NULL,
	email VARCHAR(16) NOT NULL,
	CONSTRAINT pk_SendMessage PRIMARY KEY (
		message_text, title, email
	),
	CONSTRAINT fk_employee_account_send_message FOREIGN KEY(email)
											REFERENCES EmployeeAccount (email)
);

CREATE TABLE HR (
	hr_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_HR PRIMARY KEY (
		hr_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE AddFire (
	add_fire_flag SMALLINT NOT NULL,
	request_status BOOLEAN NOT NULL,
	headOfDepartment_SSN VARCHAR(9) REFERENCES HeadOfDepartment(headOfDepartment_SSN),
	hr_SSN VARCHAR(9) REFERENCES HR(hr_SSN),
	email VARCHAR(16) REFERENCES EmployeeAccount(email),
	CONSTRAINT pk_AddFire PRIMARY KEY (
		hr_SSN, headOfDepartment_SSN, email, add_fire_flag
	 ),
	CONSTRAINT fk_employee_account_add_fire FOREIGN KEY(email)
											REFERENCES EmployeeAccount (email),
	CONSTRAINT fk_head_of_department_add_fire FOREIGN KEY(headOfDepartment_SSN)
											REFERENCES HeadOfDepartment (headOfDepartment_SSN),
	CONSTRAINT fk_hr_add_fire FOREIGN KEY(hr_SSN)
											REFERENCES HR (hr_SSN)
);

CREATE TABLE Cleaning (
	cleaning_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Cleaning PRIMARY KEY (
		cleaning_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
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
		title, season, year
	),
	CONSTRAINT fk_Notice_title FOREIGN KEY(season,year) 
							   REFERENCES Noticeboard (season,year)
);

CREATE TABLE EditNotice (
	edit_notice_change_log VARCHAR(256) NOT NULL,
	edit_notice_timestamp TIMESTAMP NOT NULL,
	headOfDepartment_SSN VARCHAR(9) NOT NULL,
	season SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_EditNotice PRIMARY KEY (
		headOfDepartment_SSN, season, year, edit_notice_timestamp
	),
	CONSTRAINT fk_head_of_department_edit_notice FOREIGN KEY(headOfDepartment_SSN)
											REFERENCES HeadOfDepartment (headOfDepartment_SSN),
	CONSTRAINT fk_noticeboard_edit_notice FOREIGN KEY(season,year)
											REFERENCES Noticeboard (season, year)
);

CREATE TABLE StaffsTimetable (
	month SMALLINT NOT NULL,
	year VARCHAR(4) NOT NULL,
	CONSTRAINT pk_StaffsTimetable PRIMARY KEY (
		year, month
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE EditStaffsTimetable (
	edit_staffs_timetable_change_log VARCHAR(256) NOT NULL,
	edit_staffs_timetable_timestamp TIMESTAMP NOT NULL,
	headOfDepartment_SSN VARCHAR(9) NOT NULL,
    year VARCHAR(4) NOT NULL,
	month SMALLINT NOT NULL,
	CONSTRAINT pk_EditStaffsTimetable PRIMARY KEY (
		year, month, headOfDepartment_SSN, edit_staffs_timetable_timestamp
	 ),
	CONSTRAINT fk_head_of_department_edit_staffs_timetable FOREIGN KEY(headOfDepartment_SSN)
											REFERENCES HeadOfDepartment (headOfDepartment_SSN),
	CONSTRAINT fk_staffs_timetable_edit_staffs_timetable FOREIGN KEY(year, month)
											REFERENCES StaffsTimetable (year, month)
);

CREATE TABLE SendRequest (
	request_status BOOLEAN NOT NULL,
	purpose VARCHAR(512) NOT NULL,
	request_timestamp TIMESTAMP NOT NULL,
	email VARCHAR(16) REFERENCES EmployeeAccount(email),
	CONSTRAINT pk_SendRequest PRIMARY KEY (
		email, request_timestamp, request_status
	 ),
	CONSTRAINT fk_employee_account_send_request FOREIGN KEY(email)
											REFERENCES EmployeeAccount (email)
);

CREATE TABLE WarehouseManager (
	warehouseManager_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_WarehouseManager PRIMARY KEY (
		warehouseManager_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
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
	warehouseManager_SSN VARCHAR(9) NOT NULL,
	inventory_code INTEGER NOT NULL,
	inventory_name VARCHAR(256) NOT NULL,
	CONSTRAINT pk_ManageInventory PRIMARY KEY (
		inventory_code, inventory_name, warehouseManager_SSN, manage_inventory_timestamp
	 ),
	CONSTRAINT fk_warehouse_manager_manage_inventory FOREIGN KEY(warehouseManager_SSN)
											REFERENCES WarehouseManager (warehouseManager_SSN),
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
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE Nurse (
	nurse_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Nurse PRIMARY KEY (
		nurse_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE Doctor (
	doctor_SSN VARCHAR(9) NOT NULL,
	is_on_training BOOLEAN NOT NULL,
	date_of_the_last_training DATE NOT NULL,
	CONSTRAINT pk_Doctor PRIMARY KEY (
		doctor_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email),
	department_name VARCHAR(512) REFERENCES Department(department_name)
);

CREATE TABLE MedicalReport (
	details VARCHAR(2048) NOT NULL,
	report_timestamp TIMESTAMP NOT NULL,
	complaints VARCHAR(2048) NOT NULL,
	conclusion VARCHAR(2048) NOT NULL,
	CONSTRAINT pk_MedicalReport PRIMARY KEY (
		report_timestamp
	 ),
	nurse_SSN VARCHAR(9) REFERENCES Nurse(nurse_SSN)
);

CREATE TABLE ITSpecialist (
	itSpecialist_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_ITSpecialist PRIMARY KEY (
		itSpecialist_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
);

CREATE TABLE ManageEmployeeAccount (
	manage_employee_account_change_log VARCHAR(256) NOT NULL,
	manage_employee_account_timestamp TIMESTAMP NOT NULL,
	email VARCHAR(16) REFERENCES EmployeeAccount(email),
	itSpecialist_SSN VARCHAR(9) REFERENCES ITSpecialist(itSpecialist_SSN),
	CONSTRAINT pk_ManageEmployeeAccount PRIMARY KEY (
		email, itSpecialist_SSN, manage_employee_account_timestamp
	 ),
	CONSTRAINT fk_employee_account_manage_employee_account FOREIGN KEY(email)
											REFERENCES EmployeeAccount (email),
	CONSTRAINT fk_it_specialist_manage_employee_account FOREIGN KEY(itSpecialist_SSN)
											REFERENCES ITSpecialist (itSpecialist_SSN)
);

CREATE TABLE Contacts (
	contacts_timestamp TIMESTAMP NOT NULL,
	contacts_message VARCHAR(2048) NOT NULL,
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number),
	itSpecialist_SSN VARCHAR(9) REFERENCES ITSpecialist(itSpecialist_SSN),
	CONSTRAINT pk_Contacts PRIMARY KEY (
		medical_insurence_number, itSpecialist_SSN, contacts_timestamp
	 ),
	CONSTRAINT fk_it_specialist_contacts FOREIGN KEY(itSpecialist_SSN)
											REFERENCES ITSpecialist (itSpecialist_SSN),
	CONSTRAINT fk_patient_account_contacts FOREIGN KEY(medical_insurence_number)
											REFERENCES PatientAccount (medical_insurence_number)
);

CREATE TABLE CreateRecipe (
	recommendations VARCHAR(2048) NOT NULL,
	recipe_timestamp TIMESTAMP NOT NULL,
	CONSTRAINT pk_CreateRecipe PRIMARY KEY (
		recipe_timestamp
	 ),
	doctor_SSN VARCHAR(9) REFERENCES Doctor(doctor_SSN),
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE PatientTimetable (
	year VARCHAR(4) NOT NULL,
	month SMALLINT NOT NULL,
	CONSTRAINT pk_PatientTimetable PRIMARY KEY (
		year,month
	 ),
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number),
	headOfDepartment_SSN VARCHAR(9) REFERENCES HeadOfDepartment(headOfDepartment_SSN)
);

CREATE TABLE EditPatientTimetable (
	edit_patient_timetable_change_log VARCHAR(256) NOT NULL,
	edit_patient_timetable_timestamp TIMESTAMP NOT NULL,
	headOfDepartment_SSN VARCHAR(9) REFERENCES HeadOfDepartment(headOfDepartment_SSN),
	year VARCHAR(4) NOT NULL,
	month SMALLINT NOT NULL,
	CONSTRAINT pk_EditPatientTimetable PRIMARY KEY (
		year,month, headOfDepartment_SSN, edit_patient_timetable_timestamp
	 ),
	CONSTRAINT fk_head_of_department_edit_patient_timetable FOREIGN KEY(headOfDepartment_SSN)
											REFERENCES HeadOfDepartment (headOfDepartment_SSN),
	CONSTRAINT fk_patient_timetable_edit_patient_timetable FOREIGN KEY(year, month)
											REFERENCES PatientTimetable (year, month)
);

CREATE TABLE CreateAppointment (
	appointment_timestamp TIMESTAMP NOT NULL,
	room SMALLINT NOT NULL,
	medical_insurence_number BIGINT NOT NULL,
	doctor_SSN VARCHAR(9) NOT NULL,
	year VARCHAR(4) NOT NULL,
	month SMALLINT NOT NULL,
	CONSTRAINT pk_CreateAppointment PRIMARY KEY (
		appointment_timestamp, year, month, medical_insurence_number, doctor_SSN
	 ),
	CONSTRAINT fk_patient_timetable_create_appointment FOREIGN KEY(year, month)
											REFERENCES PatientTimetable (year, month),
	CONSTRAINT fk_doctorSSN FOREIGN KEY(doctor_SSN)
							REFERENCES Doctor(doctor_SSN),
	CONSTRAINT fk_medical_insurence_number FOREIGN KEY(medical_insurence_number) 
							REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE Pharmacist (
	pharmacist_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Pharmacist PRIMARY KEY (
		pharmacist_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email),
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number)
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
	pharmacist_SSN VARCHAR(9) REFERENCES Pharmacist(pharmacist_SSN),
	medicine_id VARCHAR(16) REFERENCES Medicine(medicine_id),
	CONSTRAINT pk_ManageMedicine PRIMARY KEY (
		medicine_id, pharmacist_SSN, manage_medicine_timestamp
	 ),
	CONSTRAINT fk_pharmacist_manage_medicine FOREIGN KEY(pharmacist_SSN)
											REFERENCES Pharmacist (pharmacist_SSN),
	CONSTRAINT fk_medicine_manage_medicine FOREIGN KEY(medicine_id)
											REFERENCES Medicine (medicine_id)
);

CREATE TABLE ChangePrice (
	change_price_change_log VARCHAR(256) NOT NULL,
	change_price_timestamp TIMESTAMP NOT NULL,
	headOfDepartment_SSN VARCHAR(9) REFERENCES HeadOfDepartment(headOfDepartment_SSN),
	medicine_id VARCHAR(16) REFERENCES Medicine(medicine_id),
	CONSTRAINT pk_ChangePrice PRIMARY KEY (
		medicine_id, headOfDepartment_SSN, change_price_timestamp
	 ),
	CONSTRAINT fk_medicine_change_price FOREIGN KEY(medicine_id)
											REFERENCES Medicine (medicine_id),
	CONSTRAINT fk_head_of_department_change_price FOREIGN KEY(headOfDepartment_SSN)
											REFERENCES HeadOfDepartment (headOfDepartment_SSN)
);

CREATE TABLE Financial (
	financial_SSN VARCHAR(9) NOT NULL,
	CONSTRAINT pk_Financial PRIMARY KEY (
		financial_SSN
	 ),
	email VARCHAR(16) REFERENCES EmployeeAccount(email)
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
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number)
);

CREATE TABLE ManageBill (
	manage_bill_change_log VARCHAR(256) NOT NULL,
	manage_bill_timestamp TIMESTAMP NOT NULL,
	financial_SSN VARCHAR(9) REFERENCES Financial(financial_SSN),
	from_id INTEGER NOT NULL,
	to_id INTEGER NOT NULL,
	CONSTRAINT pk_ManageBill PRIMARY KEY (
		from_id, to_id, financial_SSN, manage_bill_timestamp
	 ),
	CONSTRAINT fk_financial_manage_bill FOREIGN KEY(financial_SSN)
											REFERENCES Financial (financial_SSN),
	CONSTRAINT fk_bill_manage_bill FOREIGN KEY(from_id, to_id)
											REFERENCES Bill (from_id, to_id)
);

CREATE TABLE RequestForMeds (
	medicine_name VARCHAR(256) NOT NULL,
	status BOOLEAN NOT NULL,
	meds_request_timestamp TIMESTAMP NOT NULL,
	medical_insurence_number BIGINT REFERENCES PatientAccount(medical_insurence_number),
	pharmacist_SSN VARCHAR(9) REFERENCES Pharmacist(pharmacist_SSN),
	CONSTRAINT pk_RequestForMeds PRIMARY KEY (
		meds_request_timestamp, pharmacist_SSN, medical_insurence_number
	 ),
	CONSTRAINT fk_patient_account_request_for_meds FOREIGN KEY(medical_insurence_number)
											REFERENCES PatientAccount (medical_insurence_number),
	CONSTRAINT fk_pharmacist_request_for_meds FOREIGN KEY(pharmacist_SSN)
											REFERENCES Pharmacist (pharmacist_SSN)
);
