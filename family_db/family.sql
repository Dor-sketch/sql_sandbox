create table person
(id int,
first_name varchar(20),
original_surname varchar(20),
new_surname varchar(20),
birth_date DATE,
primary key (id));

create table marriage
(m_id int,
w_id int,
date DATE,
primary key (m_id,w_id));

create table child_of
(child_id int,
father_id int,
mother_id int,
primary key (child_id));

insert into person values 
(1,'Adam','Smith','Smith','1970-01-01'),
(2,'Eve','Doe','Smith','1970-01-01'),
(3,'Lev','Ayzen','Ayzen','1970-01-01'),
(4,'Shir','Blah','Ayzen','1970-01-01'),
(5,'Son of Lev','Ayzen','Ayzen','1995-01-01'),
(6,'Doughter of Lev','Ayzen','Smith','1999-01-01'),
(7,'Old Feminist Mom','Same','Same','1970-01-01'),
(8,'Son of Feminist','Same','Same','2000-01-01');



insert into marriage values
(1,2,'1985-01-01'),
(3,4,'1997-01-01'),
(1,6,'2010-01-01');

insert into child_of values
(1,1,2),
(2,1,2),
(5,3,4),
(6,3,4),
(8,1,7);
