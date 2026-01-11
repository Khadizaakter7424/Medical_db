use master 
go 

if exists (select name from sys.databases where name='Medical_DB')
begin 
drop database Medical_db
end 
go
--=======create database ===
Create database Medical_db
On primary (
Name='Medical_data_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Medical_data_1.mdf',
size=25mb,
maxsize=100mb,
Filegrowth =5%
)

log on (
Name='Medical_log_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Log\Medical_data_1.ldf',
size=2mb,
maxsize=50mb,
Filegrowth =1mb
);

		--===use database ==
Use Medical_DB
go 

----Doctors table 
Create table Doctors (DoctorID int primary key ,
DoctorName Varchar (30)
 );


----Department table 
Create table Departments(DepID int primary key ,
DepName varchar(50));

---Schedule table 
Create table Schedule (ScheduleID int primary key , 
Shift Varchar(20) );

---doc_dep relation table 
Create table Doc_dep_relation (relationID int primary key ,
DoctorID int references Doctors (DoctorID),
DepID int references Departments(DepID),
ScheduleID int references Schedule(ScheduleID)
);

--gender table 
Create table Gender (GenID int primary key, 
Type varchar(30));

---Patients table 
Create table Patients (PatientID int primary key , 
PatientName varchar(30),
Phone Varchar(50),
Blood_group varchar(10),
GenID int references Gender(GenID))

----Appointment table 
Create table Appointments (AppointmentID int primary key ,
PatientID int references Patients(PatientID),
DoctorID int references Doctors(DoctorID),
DepId int references departments (DepID),
ScheduleID int references Schedule(ScheduleID),
ConsultaionFee int ,
Appointment_date Date,
Appointment_time Time );


select*From Doctors
select*From Departments
select*From Schedule
select*From Gender
select*From Patients
Select*From Appointments
select*From Doc_dep_relation



----Values for doctor table
Insert into Doctors 
Values (1,'Md.Billal'),
       (2,'Md.Mollah'),
	   (3,'Md.Hisbullah'),
	   (4,'Md.Shifat'),
	   (5,'Md.Rumi'),
	   (6,'Md.Siam'),
	   (7,'Mrs.Shiuli'),
	   (8,'Md.Kased')
	
---Values for dep 
Insert into Departments
Values (1,'Cardiology '),
       (2,'Neurology '),
	   (3,'Pediatrics '),
	   (4,'Orthopedics '),
	   (5,'Dermatology '),
	   (6,'Oncology '),
	   (7,'Psychiatry'),
	   (8,'Hematologist ')

	---Values for schedule 
Insert into Schedule
Values (1,'Morning'),
       (2,'Evening'),
	   (3,'Afternoon')

---Values for  Doc_dep_relation
Insert into Doc_dep_relation
Values (1,1,1,1),
       (2,2,2,2),
      (3,3,3,3),
	  (4,4,4,1),
	  (5,5,5,2),
	  (6,6,6,3),
	  (7,7,7,1),
	  (8,8,8,2)
	 

	--Values for gender 
Insert into gender 
Values (1,'Male'),
      (2,'Female'),
	  (3,'Other')

--Values for Paitents 
Insert into Patients
Values (1,'Daud','019665622','o+',1),
		(2,'saud','019665623','o+',1),
       (3,'maud','019665624','o+',1),
        (4,'Nuha','019665625','o+',2),
		(5,'Maisha','019665626','o+',1),
		(6,'Monshi','019665627','o+',1),
		(7,'Rashed','019665628','o+',1)



----Create sp to see all patient 
Create proc spgetallPatients
as 
select*From Patients
go
Exec spgetallPatients
go 

---create sp to see  doctors and dep 
Create proc spdoc_department  
as 
select  doctorName,consultaionfee,appointment_date 
From Doctors as do join Appointments as ap 
on do.DoctorID=ap.DoctorID
where ScheduleID=1
go 

Exec spdoc_department
go

----create department sp 
Create Proc spDepartment @departmentName Varchar(50)
as 
select DepName, doctorname, consultaionfee,shift 
From Departments as de join Appointments as ap
on de.DepID=ap.DepId
join Doctors as do
on do.DoctorID=ap.DoctorID
join Schedule as s 
on s.ScheduleID=ap.ScheduleID
where depName=@departmentName
go
Exec spDepartment 'Cardiology'
go 

---Create sp to add patient
Create proc sppatients
@PaitentID int ,
@patientName varchar (50),
@Phone varchar (30),
@blood_group varchar(10)

as 
Insert into 
Patients(PatientID,PatientName,Phone,Blood_group)
Values (@PaitentID,@patientName,@Phone,@blood_group)
go 
--drop proc sppatients
Exec sppatients 9,'Miraj','0197787632','o-'
    
	Select*From Patients
	Select*From Appointments

---Create sp to add appointment 
Create proc spappointment 
@appointmentID int ,
@PatientID int ,
@DoctorID int ,
@ScheduleID int ,
@DepID int ,
@consultaionFee int ,
@appointment_Date date ,
@appointment_time time

as 
begin 
insert into appointments (AppointmentID,PatientID,DoctorID,DepID,ScheduleID,ConsultaionFee,Appointment_date,Appointment_time)
Values (@AppointmentID,@PatientID,@DoctorID,@DepID,@ScheduleID ,@ConsultaionFee,@Appointment_date,@appointment_time)
end 
go

Drop proc spappointment
exec spappointment 1,1,1,1,1,1000,'2025-10-09','9:00'
exec spappointment 2,1,2,2,2,700,'2025-10-10','12:30'
exec spappointment 3,2,2,2,2,1000,'2025-10-11','9:30'
exec spappointment 4,3,3,3,3,900,'2025-11-12','11:00'
exec spappointment 5,3,3,3,1,1000,'2025-11-10','11:00'
select*from appointments 

--Drop table Appointments

---Insert a new appointment with scope identity 
Create proc spAppointment1
@appointmentID int ,
@PatientID int ,
@DoctorID int ,
@DepID int ,
@consultaionFee int ,
@appointment_Date date 

as 
begin
Insert into Appointments (AppointmentID,PatientID,DoctorID,DepID,ConsultaionFee,Appointment_date)
Values (@AppointmentID,@PatientID,@DoctorID,@DepID,@ConsultaionFee,@Appointment_date)
Return Scope_identity ()
end; 
go 

declare @NewPatientID int
Exec @NewPatientID=spAppointment1
6,2,7,7,1000,'2026-02-02'
Print 'New paitent appointment has been recorded:' + Cast(@NewPatientID as varchar(50))
go

Select*From Appointments 

---Create update for Appointments  
Create proc SpAppointmentse2 
@appointmentID int ,
@PatientID int ,
@DoctorID int ,
@DepID int ,
@ScheduleID int ,
@consultaionFee int ,
@appointment_Date date 

as
Update Appointments 
Set ScheduleID =@ScheduleID 
Where AppointmentID=@AppointmentID
Go 

Exec SpAppointmentse2 5,2,7,7,1,1000,'2026-03-02'

Select*From Appointments  

---create sp for delete doctorid 
create proc spdelete
@doctorID int 
as 
delete from doctors where doctorID=@doctorID 

exec spdelete 1;
select*from doctors 
--Alter sp for delete appointment 
Alter proc spdelete
@doctorID int 
as 
begin 
delete from Doc_dep_relation  where doctorID=@doctorID
delete from Appointments where doctorID=@doctorID 
delete from doctors where doctorID=@doctorID 
end ;

----Create function 
create function scalarfunction ()
Returns int 
as 
begin 
declare @max int 
select @max =Max(Consultaionfee) from appointments 
return @max 
end
go 

select dbo.scalarfunction() as 'Fees'

---Create table function 
Create function fu_tableappointment (@consultaionFee int)
Returns Table 
as
Return (Select doctorID  ,depID  ,scheduleID , appointment_date
from Appointments where AppointmentID=1)
go 

select*From fu_tableappointment(1000)
----===
select*From Appointments
---===

--Create multitable function 
Create function mul_table (@consultaionfee int)
Returns @Table Table (do_doctorID int, de_depId int, s_scheduleID int, c_consultaionfee int )
as 
begin 
insert into @Table
select doctorID,depID,scheduleID,consultaionfee from Appointments where ConsultaionFee=@consultaionfee
return 
end 
go 

--test 
select*From dbo.mul_table(1000)

----Create trigger 
Create Trigger trgendertable 
ON Gender 
For insert 
as 
begin
    print 'Trigger fired : New gender vlaue insertion is not allowed';
    Rollback Transaction ;
end
go 

---Drop trigger trgendertable

 INSERT INTO Gender VALUES (4,'Others');
---
select*from Gender

--delete trigger 
CREATE TRIGGER trig_appointment
    ON appointments
    FOR DELETE
    AS
    BEGIN
    PRINT 'Trigger fired : You are not allowed to make any changes in this table';
    Rollback Transaction ;
    END
	GO

	delete from Appointments
	where AppointmentID=1

	---drop trigger trig_appointment

	---create view 
Create view nnview 
with encryption, schemabinding
AS 
Select do.doctorName ,de.depName, s.shift,ap.consultaionFee
from dbo.Doctors as do
join dbo.appointments as ap
on do.DoctorID=ap.DoctorID
join dbo.Departments as de
on de.DepID=ap.DepId
join dbo.Schedule as s 
on s.ScheduleID=ap.ScheduleID
where ConsultaionFee=1000
go 

select*From nnview
------
select*From Departments
------