
create database if not EXISTS college_db;

use college_db;

select
    'CREATING TABLES...' AS '';

/* Create other tables (COURSE, STUDENT, STUDENT_ACCOUNTING, JOB, EMPLOYEE, COURSE_WORK, STUDENT_SUBMISSION, STUDENT_COURSE, COURSE_FACULTY) */
CREATE TABLE DEPARTMENT(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30),
no_faculty INT
);

CREATE TABLE FACULTY (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    phone_number CHAR(10) NOT NULL,
    email_id VARCHAR(30) NOT NULL UNIQUE,
    dob DATE NOT NULL,
    street_number INT NOT NULL,
    building_number CHAR(10) NOT NULL,
    office_number INT NOT NULL,
    salary INT NOT NULL,
    CONSTRAINT fk_department_id FOREIGN KEY (department_id) REFERENCES DEPARTMENT(id) ON DELETE CASCADE
);

CREATE TABLE COURSE(
id INT AUTO_INCREMENT PRIMARY KEY,
course_name VARCHAR(30),
course_number INT,
type VARCHAR(10),
credits INT,
level INT,
timings TIME,
prereq_id INT NULL,
CONSTRAINT fk_course_id FOREIGN KEY (prereq_id) REFERENCES COURSE(id) ON DELETE SET NULL
);

CREATE TABLE STUDENT (
    id INT AUTO_INCREMENT PRIMARY KEY,
    a_number INT UNIQUE,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    dob DATE,
    hawk_id VARCHAR(30),
    phone_number CHAR(10),
    address VARCHAR(20)
);

CREATE TABLE STUDENT_ACCOUNTING (
    id INT AUTO_INCREMENT PRIMARY KEY,
    total INT,
    method VARCHAR(15),
    is_paid BOOLEAN,
    transaction_id INT UNIQUE,
    scholarship INT NULL,
    student_id INT,
    CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE
);

CREATE TABLE JOB (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    pay_per_hour INT NOT NULL,
    job_description TEXT NOT NULL,
    vacancy INT,
    faculty_id INT NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES FACULTY(id) ON DELETE CASCADE
);

CREATE TABLE EMPLOYEE (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    no_hours INT NOT NULL,
    remarks VARCHAR(40),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    job_id INT NOT NULL,
    student_id INT NOT NULL,
    CONSTRAINT unique_student_job UNIQUE (student_id, job_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES JOB(id) ON DELETE CASCADE
);

CREATE TABLE COURSE_WORK (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employee_id INT,
    course_id INT,
    work_type VARCHAR(20) NOT NULL,
    title VARCHAR(20) NOT NULL,
    description VARCHAR(30),
    deadline DATE NOT NULL,
    CONSTRAINT unique_employee_course UNIQUE (employee_id, course_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE
);

CREATE TABLE STUDENT_SUBMISSION (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    student_id INT NOT NULL,
    course_work_id INT NOT NULL,
    submission_link TEXT NOT NULL,
    remarks VARCHAR(50),
    submission_date DATE NOT NULL,
    grade CHAR(1) NOT NULL,
    CONSTRAINT fk_course_work_student_id FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_work_id FOREIGN KEY (course_work_id) REFERENCES COURSE_WORK(id) ON DELETE CASCADE
);

CREATE TABLE STUDENT_COURSE (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    total_grade CHAR(1) NOT NULL,
    CONSTRAINT unique_student_course UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE
);

CREATE TABLE COURSE_FACULTY (
    course_id INT NOT NULL,
    faculty_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES FACULTY(id) ON DELETE CASCADE,
    CONSTRAINT unique_course_faculty UNIQUE (course_id, faculty_id)
);

select  'LOADING DATA...' AS '';




/* Load data into the tables */

INSERT INTO DEPARTMENT (id, name, no_faculty) VALUES (1, 'Electrical Engineering', 75);
INSERT INTO DEPARTMENT (id, name, no_faculty) VALUES (2, 'Mathematics', 50);
INSERT INTO DEPARTMENT (id, name, no_faculty) VALUES (3, 'Biology', 120);

/* faculty Table */

INSERT INTO FACULTY (department_id, first_name, last_name, phone_number, email_id, dob,street_number, building_number, office_number, salary) VALUES
(3, 'Jerry', 'Wilkinson', '684-837-88', 'jeanettemoss@example.org', '1998-03-26', 2933, '7834', 1936, 77618),
(3, 'Miranda', 'Gomez', '581.906.31', 'pcarter@example.net', '1993-04-27', 48037, '83811', 84640, 68449),
(2, 'Randy', 'Daugherty', '001-626-93', 'megan59@example.org', '1963-05-09', 79010, '464', 540, 67600),
(3, 'Rachael', 'Yates', '980-567-44', 'alvarezjonathan@example.org', '1983-11-22', 43434, '69753', 141, 74621),
(2, 'Cameron', 'Cannon', '+1-990-374', 'davidpena@example.net', '1981-12-02', 2242, '0167', 6160, 66726),
(1, 'William', 'Johns', '472.711.14', 'ppeters@example.org', '1977-06-07', 0620, '56806', 451, 62992),
(3, 'Joseph', 'Gonzalez', '6126195437', 'jeremy52@example.org', '1970-09-20', 551, '7479', 006, 62017),
(1, 'Anthony', 'Sandoval', '001-819-45', 'connor58@example.org', '1987-09-30', 534, '5094', 3218, 71266),
(2, 'Timothy', 'Wade', '218-727-70', 'gloverjordan@example.com', '1961-01-12', 45244, '02546', 93166, 55383),
(2, 'Timothy', 'Wilson', '(875)248-8', 'kcole@example.org', '1966-08-13', 527, '50909', 78522, 75156),
(3, 'Amanda', 'Hudson', '001-410-98', 'anthonykayla@example.com', '1982-06-17', 7028, '29742', 9946, 50060),
(2, 'Kathleen', 'Ruiz', '+1-656-600', 'fmendez@example.net', '1976-09-27', 421, '64739', 74021, 79732),
(3, 'Robert', 'Maxwell', '+1-484-355', 'iowens@example.org', '1971-10-24', 24905, '395', 13138, 86477),
(3, 'Virginia', 'Bell', '+1-744-666', 'deniseberry@example.org', '1987-06-01', 100, '5577', 41564, 75673),
(1, 'Raymond', 'Davis', '813.679.93', 'allisonhawkins@example.net', '1972-11-21', 48116, '9812', 5174, 71753);

/* course Table */
INSERT INTO COURSE (course_name, course_number, type, credits, level, timings) VALUES
('Accountant, chartered manageme', 755, 'seminar', 1, 317, '21:38:08'),
('Metallurgist', 464, 'lab', 2, 106, '19:40:07'),
('Radio broadcast assistant', 486, 'seminar', 4, 325, '20:39:05'),
('Therapist, art', 949, 'seminar', 4, 305, '14:12:32'),
('Electrical engineer', 404, 'seminar', 1, 495, '12:01:12'),
('Tour manager', 566, 'lecture', 4, 299, '12:06:56'),
('Horticulturist, commercial', 274, 'seminar', 3, 166, '23:15:46'),
('Wellsite geologist', 833, 'seminar', 1, 183, '00:56:35'),
('Human resources officer', 737, 'seminar', 1, 112, '06:04:54'),
('Animal technologist', 831, 'seminar', 3, 425, '05:42:05'),
('Cytogeneticist', 541, 'seminar', 4, 252, '15:05:14'),
('Travel agency manager', 672, 'seminar', 2, 296, '06:32:32'),
('Company secretary', 656, 'lab', 2, 122, '12:56:47'),
('Licensed conveyancer', 430, 'seminar', 4, 295, '08:08:39'),
('Cartographer', 200, 'lecture', 1, 481, '15:32:03');

UPDATE COURSE SET prereq_id = 11 WHERE id = 1;
UPDATE COURSE SET prereq_id = 2 WHERE id = 2;
UPDATE COURSE SET prereq_id = 1 WHERE id = 3;
UPDATE COURSE SET prereq_id = 5 WHERE id = 4;
UPDATE COURSE SET prereq_id = 6 WHERE id = 5;
UPDATE COURSE SET prereq_id = 7 WHERE id = 6;
UPDATE COURSE SET prereq_id = 8 WHERE id = 7;
UPDATE COURSE SET prereq_id = 10 WHERE id = 8;
UPDATE COURSE SET prereq_id = 10 WHERE id = 9;
UPDATE COURSE SET prereq_id = 2 WHERE id = 10;
UPDATE COURSE SET prereq_id = 14 WHERE id = 11;
UPDATE COURSE SET prereq_id = 8 WHERE id = 12;
UPDATE COURSE SET prereq_id = 9 WHERE id = 13;
UPDATE COURSE SET prereq_id = 1 WHERE id = 14;
UPDATE COURSE SET prereq_id = 8 WHERE id = 15;


/* student table */


INSERT INTO STUDENT (a_number, first_name, last_name, dob, hawk_id, phone_number, address) VALUES 
(77344514, 'Luis', 'Thomas', '2004-04-25', 'andersonclaire', '001-488-36', '430 Harmon Canyon Su'),
(47938052, 'Charles', 'Long', '1994-04-29', 'hernandezkenneth', '(503)905-4', 'USCGC GriffithFPO A'),
(24179146, 'Teresa', 'Miranda', '2001-02-28', 'annetterobbins', '001-788-56', '520 Jennifer RunBel'),
(34962559, 'Phillip', 'Ferguson', '2001-03-09', 'ncurtis', '584.285.01', '3697 Jennifer Points'),
(42571762, 'Alexa', 'Crawford', '1998-02-16', 'jonescalvin', '550.225.25', '570 Crystal HollowR'),
(97639818, 'Audrey', 'Murphy', '2002-09-26', 'elizabethsmith', '001-630-74', '74366 Chad Summit Ap'),
(36945488, 'Joseph', 'Martinez', '1999-03-30', 'maynardamanda', '001-889-56', '75782 Booth VillePo'),
(33330833, 'Jennifer', 'Bowman', '2001-11-13', 'marioalvarez', '465.911.31', '336 Gallegos Key Sui'),
(32036271, 'Jeremy', 'Sellers', '1992-11-09', 'daniel28', '001-312-48', '2113 Owens PointsWe'),
(15898980, 'Tommy', 'Stewart', '2004-04-11', 'marshallselena', '6948950312', '32650 Jones Falls Su'),
(85743930, 'Scott', 'Nguyen', '2005-02-12', 'paul95', '(669)544-9', '317 Lee MountainsRo'),
(86052351, 'Corey', 'Walker', '1998-10-30', 'cindymcgee', '857-623-12', '84568 Darren Mills S'),
(81024296, 'Melissa', 'Reynolds', '1996-04-29', 'danderson', '355-665-76', '9972 Jeffrey Forge S'),
(99029999, 'Lawrence', 'Allen', '1994-12-30', 'pramirez', '825.390.39', 'Unit 7382 Box 1856D'),
(98476204, 'Whitney', 'Hull', '2003-12-17', 'maria79', '+1-749-322', '30878 Ashley Locks A');


/* student_accounting table */

INSERT INTO STUDENT_ACCOUNTING (total, method, is_paid, transaction_id, scholarship, student_id) VALUES
(1521, 'Credit Card', True, 68930, 357, 7),
(4839, 'Credit Card', False, 40898, 36, 11),
(4993, 'Credit Card', False, 51823, 359, 8),
(3588, 'Bank Transfer', False, 69698, 198, 11),
(2868, 'Bank Transfer', True, 96487, 615, 14),
(3133, 'Cash', True, 10415, 239, 10),
(2862, 'Credit Card', False, 68722, 657, 9),
(1931, 'Bank Transfer', True, 72316, 506, 1),
(3115, 'Cash', False, 67654, 842, 15),
(2073, 'Cash', False, 43817, 904, 13),
(1930, 'Bank Transfer', False, 81531, 224, 15),
(2928, 'Cash', False, 92446, 462, 4),
(4728, 'Cash', True, 56003, 624, 2),
(2123, 'Credit Card', True, 42460, 304, 9),
(4212, 'Bank Transfer', False, 15346, 29, 13);

/* job table */

INSERT INTO JOB (pay_per_hour, job_description, vacancy, faculty_id) VALUES
(35, 'Programmer, applications', 3, 11),
(29, 'Therapeutic radiographer', 3, 8),
(28, 'Scientist, water quality', 1, 1),
(15, 'Teacher, English as a foreign language', 3, 15),
(36, 'Surveyor, building control', 2, 7),
(42, 'Writer', 4, 6),
(38, 'Merchant navy officer', 1, 6),
(14, 'Ceramics designer', 1, 3),
(20, 'Psychologist, sport and exercise', 5, 15),
(19, 'Retail manager', 4, 12),
(15, 'Licensed conveyancer', 2, 3),
(39, 'Administrator, sports', 2, 13),
(28, 'Civil Service administrator', 5, 13),
(42, 'Scientist, research (medical)', 1, 6),
(42, 'Communications engineer', 2, 1);



INSERT INTO EMPLOYEE (no_hours, remarks, start_date, end_date, job_id, student_id) VALUES 
(35, 'Effort since relate easy country the.', '2023-09-11', '2024-04-15', 2, 11),
(23, 'Office site close TV little as clear.', '2023-03-18', '2024-02-07', 4, 15),
(17, 'Begin the get fall.', '2022-10-11', '2023-01-25', 9, 9),
(16, 'Trouble popular each few toward listen.', '2022-12-12', '2023-06-07', 2, 13),
(31, 'Wide nor challenge.', '2022-10-30', '2023-03-25', 3, 11),
(21, 'Statement yes attorney person.', '2023-01-01', '2023-03-06', 13, 1),
(28, 'Speak respond grow word.', '2022-12-07', '2023-05-03', 14, 14),
(34, 'Newspaper sing book short on year.', '2022-11-29', '2023-11-18', 6, 1),
(14, 'Blood step test through organization.', '2022-12-04', '2023-03-06', 10, 15),
(25, 'Wish number black between.', '2022-11-27', '2023-09-16', 3, 13),
(21, 'Safe low such response feel miss.', '2023-01-14', '2023-10-16', 8, 3),
(25, 'At budget alone region.', '2022-11-29', '2023-10-02', 7, 6),
(10, 'All unit cell have others old building.', '2023-05-14', '2024-01-09', 14, 5),
(22, 'Away land need draw.', '2022-11-25', '2023-11-02', 15, 7),
(16, 'Ok fine pass sea as enough could.', '2022-12-29', '2023-05-08', 10, 12);


INSERT INTO COURSE_WORK (employee_id, course_id, work_type, title, description, deadline) VALUES
(13, 5, 'Assignment', 'moment', 'Person any soldier statement.', '2023-10-22'),
(13, 8, 'Quiz', 'father', 'Difference add front.', '2023-10-20'),
(8, 5, 'Assignment', 'family', 'Member arrive garden.', '2023-11-03'),
(9, 4, 'Assignment', 'when', 'Everybody coach interview.', '2023-10-11'),
(1, 4, 'Quiz', 'wish', 'Local dinner might yeah.', '2023-10-31'),
(13, 14, 'Quiz', 'result', 'Worker above garden.', '2023-10-24'),
(12, 4, 'Quiz', 'new', 'Piece pretty son simple.', '2023-10-16'),
(13, 9, 'Quiz', 'officer', 'Write fly everyone top note.', '2023-11-01'),
(8, 9, 'Assignment', 'fish', 'Both about hour growth.', '2023-11-05'),
(2, 9, 'Quiz', 'discussion', 'Hit church guy I.', '2023-10-17'),
(13, 6, 'Assignment', 'fly', 'Event treat hand.', '2023-11-05'),
(7, 8, 'Assignment', 'professor', 'Arm month could easy.', '2023-10-12'),
(7, 14, 'Project', 'pay', 'Follow game deal energy.', '2023-10-14'),
(12, 2, 'Quiz', 'garden', 'Economic available article.', '2023-10-08'),
(13, 13, 'Assignment', 'card', 'Nor job month argue senior.', '2023-10-22');




INSERT INTO STUDENT_SUBMISSION (student_id, course_work_id, submission_link, remarks, submission_date, grade) VALUES 
(1, 2, 'http://www.burch-henson.com/', 'May leave owner air fact service.', '2023-09-19', 'C'),
(10, 4, 'http://price.org/', 'Area kind protect listen popular near.', '2023-09-23', 'A'),
(8, 9, 'https://www.willis.com/', 'Tree build head miss need. Mind radio join.', '2023-09-15', 'C'),
(13, 14, 'https://www.randall.info/', 'Work bill black hold investment manage.', '2023-09-29', 'C'),
(10, 4, 'https://www.taylor.com/', 'Democratic wrong outside place perhaps boy.', '2023-09-22', 'B'),
(1, 3, 'http://www.johnson.com/', 'Young by remember executive own western.', '2023-09-24', 'B'),
(10, 9, 'https://www.cox.biz/', 'On help argue. Foot price age add service after.', '2023-09-17', 'B'),
(6, 4, 'http://www.wood-hanna.biz/', 'Vote truth media account size.', '2023-09-09', 'C'),
(2, 6, 'https://quinn-white.info/', 'Congress area agency laugh meeting hit cell.', '2023-09-15', 'C'),
(5, 11, 'https://cook.org/', 'Country fish compare surface imagine get.', '2023-09-25', 'C'),
(15, 3, 'https://www.cunningham-johnson.com/', 'Miss report listen up heart.', '2023-09-09', 'B'),
(10, 9, 'http://www.fisher-parks.com/', 'Particular nearly meet protect.', '2023-09-30', 'F'),
(11, 5, 'http://willis.com/', 'President idea eat top information sell.', '2023-09-20', 'C'),
(1, 12, 'https://dixon-hodges.info/', 'Reflect everything north should.', '2023-09-26', 'C'),
(9, 4, 'https://www.lane.com/', 'Dark mind could floor court nation recent day.', '2023-10-05', 'C');



INSERT INTO STUDENT_COURSE (student_id, course_id, total_grade) VALUES 
(11, 5, 'C'),
(14, 7, 'F'),
(15, 3, 'B'),
(1, 4, 'F'),
(13, 15, 'D'),
(4, 6, 'B'),
(11, 4, 'C'),
(6, 5, 'D'),
(10, 7, 'C'),
(5, 5, 'B'),
(15, 15, 'B'),
(4, 11, 'A'),
(11, 7, 'C'),
(11, 6, 'C'),
(14, 14, 'D');

INSERT INTO COURSE_FACULTY (course_id, faculty_id) VALUES
(13, 5),
(1, 12),
(5, 9),
(7, 2),
(13, 15),
(12, 7),
(1, 6),
(9, 6),
(5, 7),
(6, 10),
(11, 8),
(7, 5),
(3, 15),
(8, 3),
(12, 12);



/* Create an index for name column in the department table by name department_name_index */
create index department_name on DEPARTMENT(name);

/* Create an index for course_name and course_number together by name course_name_number_index */
create INDEX course_name_number_index on COURSE(course_name, course_number);

/* Create a view for viewing the basic faculty information */
create view student_faculty_view as select id, first_name, last_name, phone_number, email_id from faculty;

/* Create a view for viewing the basic course information */
    CREATE VIEW course_information AS
    SELECT
        department.id AS Department_id,
        name AS course_name,
        faculty.id AS faculty_id,
        concat(
            first_name, " ", last_name) AS faculty_name,
        phone_number,
        email_id
    FROM
        department
        INNER JOIN faculty ON department.id = faculty.department_id
        INNER JOIN course_faculty ON faculty.id = course_faculty.faculty_id
    ORDER BY
        department.id;

delimiter //
/* Procedure to update the faculty count in the department table */

CREATE PROCEDURE update_no_faculty_in_department_when_update_delete_in_faculty()
BEGIN
update department set no_faculty = (select count(*) from faculty where department_id = department.id );
END;

//
/*Procedure to update the faculty count in the department table */

CREATE PROCEDURE update_no_faculty_in_department_when_insert_in_faculty ( IN depart_id INT)
BEGIN
 update department set no_faculty = (select count(*) from faculty where department_id = depart_id ) where department.id = depart_id;
END;

/*Trigger to update the faculty count in department when the faculty row is deleted */

Create TRIGGER delete_faculty_count after DELETE on faculty
for each row 
BEGIN
 call update_no_faculty_in_department_when_update_delete_in_faculty();
END;

/* Trigger to update the faculty count in department when the faculty row is updated */

create TRIGGER update_faculty_count after update on faculty
for each row 
BEGIN
 call update_no_faculty_in_department();
END;


/* Trigger to update the faculty count in department when the faculty row is inserted */
create TRIGGER insert_faculty_count AFTER INSERT on faculty
FOR EACH ROW
BEGIN
    call update_no_faculty_in_department_when_insert_in_faculty(NEW.department_id);
END;

/* calculating grade for student in course */
CREATE FUNCTION CalculateTotalStudentGrade (student_id INT, course_work_id INT)
RETURNS DECIMAL(2,1)
READS SQL DATA
BEGIN 
    DECLARE avg_mapped_value DECIMAL(2, 1);
    DECLARE distinct_course_id INT;

    CREATE TEMPORARY TABLE temp_table (
        student_id INT,
        course_id INT,
        grade CHAR(1)
    );

    INSERT INTO temp_table (course_id, grade, student_id)
    SELECT
        COURSE_WORK.course_id AS course_id,
        STUDENT_SUBMISSION.grade AS grade,
        STUDENT_SUBMISSION.student_id AS student_id
    FROM
        STUDENT_SUBMISSION
    INNER JOIN COURSE_WORK ON COURSE_WORK.id = STUDENT_SUBMISSION.course_work_id
    WHERE
        STUDENT_SUBMISSION.student_id = student_id
        AND COURSE_WORK.course_id IN (
            SELECT
                COURSE_WORK.course_id
            FROM
                STUDENT_SUBMISSION
            INNER JOIN COURSE_WORK ON COURSE_WORK.id = STUDENT_SUBMISSION.course_work_id
            WHERE
                STUDENT_SUBMISSION.student_id = student_id
                AND COURSE_WORK.id = course_work_id
        );

    SELECT DISTINCT course_id INTO distinct_course_id FROM temp_table;

    SET avg_mapped_value = (
        SELECT AVG(
            CASE
                WHEN grade = 'A' THEN 5
                WHEN grade = 'B' THEN 4
                WHEN grade = 'C' THEN 3
                WHEN grade = 'D' THEN 2
                WHEN grade = 'E' THEN 1
            END
        ) AS avg_mapped_value
        FROM temp_table
    );

    UPDATE STUDENT_COURSE
    SET total_grade = avg_mapped_value
    WHERE student_id = student_id AND course_id = distinct_course_id;

    DROP TEMPORARY TABLE temp_table;

	RETURN avg_mapped_value;
END;

CREATE TRIGGER update_total_grade_trigger_at_insert AFTER INSERT on STUDENT_SUBMISSION
FOR EACH ROW
BEGIN
	DECLARE count DECIMAL(2,1);
	
    SET count = CalculateTotalStudentGrade(NEW.student_id, NEW.course_work_id);
END;

//
delimiter ;