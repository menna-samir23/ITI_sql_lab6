create rule r1 as @x in ('NY','DS','KW')
create default def as 'NY'
sp_addtype loc3 ,'nchar(2)'
sp_bindrule r1,loc3
sp_bindefault def ,loc3

create table department 
(
deptno char(3) primary key ,
deptname varchar(20),
location loc3
)

insert into department 
values ('d1','Research','NY'),('d2','Acoounting','DS'),('d3','Marketing','KW')

select * from department
---test the rule 
insert into department (DeptNo)
values ('d4')
select * from department
--So it is done بحمد الله
----------------------
create table employee (
empNo int primary key ,
fname varchar(50) not null ,
lname varchar(50) not null ,
salary int ,
deptno char(3)
constraint c1 foreign key (deptno) references department (Deptno)
on delete set null on update cascade ,
constraint c2 unique (salary)
) 
create rule r2 as @x <6000
sp_bindrule r2 , 'employee.salary'
-------------------
create table prject 
(
ProjectNo char(3) primary key ,
projectname varchar(50) not null ,
Budget int 
)
-------------
--1 
insert into works_on(empNO)
values (11111)
---Cannot insert the value NULL into column 'projectNO', table 'SD32-Company.dbo.works_on'; column does not allow nulls. INSERT fails
--2
insert into works_on(empNO,ProjectNo) 
values(11111, 'p1') -- this is after we ad this empno in tha parent table 
update Works_on set EmpNo =11111 where EmpNo=10102  

--3
update employee set empNo=22222 where empNo=10102 --after edit the properties of the relation in the diagram
--4
delete from employee where empNo=10102
---------------
--1
alter table employee add tele_no int 
--2 
alter table employee drop column tele_no
---------------
create schema company 
alter schema company transfer department  
alter schema company transfer prject 
--
create schema HR
alter schema Hr transfer employee
---
--3 Write query to display the constraints for the Employee table.
select * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='Employee'
--4 
create synonym emp for Hr.employee
--a -b 
Select * from Hr.Employee
--c-d 
Select * from Emp
--the comments 
--a.Select * from Employee ( the default is dbo , so we must but (hr.) )
--b.Select * from [Human Resource].Employee (correct)
--c.Select * from Emp ()
--d.Select * from [Human Resource].Emp (it is a synonym refer to hr.employee)

--5 Increase the budget of the project where the manager number is 10102 by 10%.
update company.prject set budget =(0.1*budget)
from company.prject c , works_on w 
where  c.projectNO=w.projectno and empno=10102
--6 Change the name of the department for which 
--the employee named James works.The new department name is Sales.
update company.department set deptname='Sales'
from company.department d, HR.employee e
where d.deptno=e.deptno and fname='james'
--7 Change the enter date for the projects for those employees who work in project p1 
--and belong to department ‘Sales’. The new date is 12.12.2007.
update works_on  set enter_date='12.12.2007'
from works_on w, company.department d,HR.employee e
where e.deptno=d.deptno and e.empno=w.empNO and projectNO='p1' and deptname='sales'

--8 Delete the information in the works_on table for all employees 
--who work for the department located in KW.
delete works_on
from works_on w,HR.employee e , company.department d
where e.deptno=d.deptno and e.empno=w.empNO and location ='KW'
--9 Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB 
--then allow him to select and insert data into tables 
--and deny Delete and update
create schema ITI1
alter schema ITI1 transfer dbo.student 
alter schema ITI1 transfer course


