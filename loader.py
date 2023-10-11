import mysql.connector
from faker import Faker
import random
from datetime import date, timedelta
import os
from dotenv import load_dotenv

load_dotenv()

fake = Faker()

# Name of the new database you want to create
new_db_name = 'college_db'

conn = mysql.connector.connect( 
    user=os.getenv("user"),  
  password=os.getenv("password"), 
  host=os.getenv("host"), 
  port=os.getenv("port")
) 

cursor = conn.cursor() 

try:
    cursor.execute(f"DROP DATABASE {new_db_name};")
except Exception:
    pass

cursor.execute("CREATE DATABASE " + new_db_name)

cursor.execute("USE " + new_db_name)

create_table_department_table = '''
CREATE TABLE DEPARTMENT(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30),
no_faculty INT
);
'''

cursor.execute(create_table_department_table);

# Insert the data into department table
# Department data to insert
departments = [
    (1, "Electrical Engineering", 0),
    (2, "Mathematics", 0),
    (3, "Biology", 0)
]

for department in departments:
    cursor.execute("INSERT INTO DEPARTMENT (id, name, no_faculty) VALUES (%s, %s, %s)", department)

# Commit the transaction
conn.commit()

# Create faculty table
cursor.execute("""
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
""")

# Commit the transaction
conn.commit()

# Insert the data into the faculty table
# Execute the SELECT query
cursor.execute("SELECT id FROM DEPARTMENT")

# Fetch and populate all the results
department_ids = [row[0] for row in cursor.fetchall()]

for _ in range(15):
    # Generate random data for each faculty record
    department_id = random.choice(department_ids)
    first_name = fake.first_name()
    last_name = fake.last_name()
    phone_number = fake.phone_number()[:10]
    email_id = fake.email()
    dob = fake.date_of_birth(minimum_age=25, maximum_age=65)
    street_number = fake.building_number()
    building_number = fake.building_number()
    office_number = fake.building_number()
    salary = random.randint(40000, 90000)  # Assuming a salary range

    # Insert the generated data into the "FACULTY" table
    cursor.execute(
        "INSERT INTO FACULTY (department_id, first_name, last_name, phone_number, email_id, dob, "
        "street_number, building_number, office_number, salary) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (department_id, first_name, last_name, phone_number, email_id, dob, street_number,
            building_number, office_number, salary)
    )

    cursor.execute("UPDATE DEPARTMENT SET no_faculty=no_faculty+1 WHERE id="+str(department_id))

    # Commit the transaction
    conn.commit()

# Create Course table
cursor.execute("""
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
""")

# Insert the data into the course table
for _ in range(15):
    # Generate random data for course records
    course_name = fake.unique.job()[:30]
    course_number = random.randint(100, 999)
    type = random.choice(["lecture", "lab", "seminar"])
    credits = random.randint(1, 5)
    level = random.randint(100, 500)
    timings = fake.time_object(end_datetime=None)
    prereq_id = random.randint(1, 2)

    # Insert the generated data into the "COURSE" table
    cursor.execute(
        "INSERT INTO COURSE (course_name, course_number, type, credits, level, timings) "
        "VALUES (%s, %s, %s, %s, %s, %s)",
        (course_name, course_number, type, credits, level, timings)
    )

# Generate and execute an update query to set random prereq_id values between 1 and 15
update_query = "UPDATE COURSE SET prereq_id = %s WHERE id = %s"
for course_id in range(1, 16):  # Assuming course IDs range from 1 to 15
    random_prereq_id = random.randint(1, 15)
    cursor.execute(update_query, (random_prereq_id, course_id))


# Create Course table
cursor.execute("""
CREATE TABLE STUDENT (
    id INT AUTO_INCREMENT PRIMARY KEY,
    a_number INT UNIQUE,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    dob DATE,
    hawk_id VARCHAR(30) UNIQUE,
    phone_number CHAR(10),
    address VARCHAR(20)
);
""")

# Insert data into the student table
for _ in range(15):
    # Generate random data for student records
    a_number = random.randint(10000000, 99999999)
    first_name = fake.first_name()
    last_name = fake.last_name()
    dob = fake.date_of_birth(minimum_age=18, maximum_age=30)
    hawk_id = fake.unique.user_name()
    phone_number = fake.phone_number()[:10]
    address = fake.address()[:20]  # Truncate to 20 characters

    # Insert the generated data into the "STUDENT" table
    cursor.execute(
        "INSERT INTO STUDENT (a_number, first_name, last_name, dob, hawk_id, phone_number, address) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s)",
        (a_number, first_name, last_name, dob, hawk_id, phone_number, address)
        )

# Create STUDENT ACCOUNT TABLE table
cursor.execute("""
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
""")

# Insert the data into the student account

for _ in range(15):
    # Generate random data for student accounting records
    total = random.randint(1000, 5000)
    method = random.choice(["Credit Card", "Cash", "Bank Transfer"])
    is_paid = random.choice([True, False])
    transaction_id = random.randint(10000, 99999)
    scholarship = random.randint(0, 1000)
    student_id = random.randint(1, 15)  # Assuming student IDs range from 1 to 15

    # Insert the generated data into the "STUDENT_ACCOUNTING" table
    cursor.execute(
        "INSERT INTO STUDENT_ACCOUNTING (total, method, is_paid, transaction_id, scholarship, student_id) "
        "VALUES (%s, %s, %s, %s, %s, %s)",
        (total, method, is_paid, transaction_id, scholarship, student_id)
    )

# Create STUDENT ACCOUNT TABLE table
cursor.execute("""
CREATE TABLE JOB (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    pay_per_hour INT NOT NULL,
    job_description TEXT NOT NULL,
    vacancy INT,
    faculty_id INT NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES FACULTY(id) ON DELETE CASCADE
);
""")

for _ in range(15):
    # Generate random data for job records
    pay_per_hour = random.randint(10, 50)
    job_description = fake.job()
    vacancy = random.randint(1, 5)
    faculty_id = random.randint(1, 15)  # Assuming faculty IDs range from 1 to 15

    # Insert the generated data into the "JOB" table
    cursor.execute(
        "INSERT INTO JOB (pay_per_hour, job_description, vacancy, faculty_id) "
        "VALUES (%s, %s, %s, %s)",
        (pay_per_hour, job_description, vacancy, faculty_id)
    )

cursor.execute("""
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
""")

# Create a set to keep track of unique combinations of student_id and job_id
unique_combinations = set()

while len(unique_combinations) < 15:
    # Generate random data for employee records
    no_hours = random.randint(10, 40)
    remarks = fake.text(max_nb_chars=40)
    start_date = fake.date_between(start_date='-1y', end_date='today')
    end_date = start_date + timedelta(days=random.randint(30, 365))
    job_id = random.randint(1, 15)  # Assuming job IDs range from 1 to 15
    student_id = random.randint(1, 15)  # Assuming student IDs range from 1 to 15

    # Check if the combination of student_id and job_id is unique
    if (student_id, job_id) not in unique_combinations:
        # Insert the generated data into the "EMPLOYEE" table
        cursor.execute(
            "INSERT INTO EMPLOYEE (no_hours, remarks, start_date, end_date, job_id, student_id) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (no_hours, remarks, start_date, end_date, job_id, student_id)
        )

        # Add the combination to the set of unique combinations
        unique_combinations.add((student_id, job_id))

cursor.execute("""
CREATE TABLE COURSE_WORK (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employee_id INT,
    course_id INT,
    work_type VARCHAR(20) NOT NULL,
    title VARCHAR(20) NOT NULL,
    description VARCHAR(30),
    deadline DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE
);
""")

# Create a set to keep track of unique combinations of employee_id and course_id
unique_combinations = set()

while len(unique_combinations) < 15:
    # Generate random data for course work records
    employee_id = random.randint(1, 15)  # Assuming employee IDs range from 1 to 15
    course_id = random.randint(1, 15)  # Assuming course IDs range from 1 to 15
    work_type = random.choice(["Assignment", "Quiz", "Project"])
    title = fake.word()
    description = fake.text(max_nb_chars=30)
    deadline = fake.date_between(start_date='today', end_date='+30d')

    # Check if the combination of employee_id and course_id is unique
    if (employee_id, course_id) not in unique_combinations:
        # Insert the generated data into the "COURSE_WORK" table
        cursor.execute(
            "INSERT INTO COURSE_WORK (employee_id, course_id, work_type, title, description, deadline) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (employee_id, course_id, work_type, title, description, deadline)
        )

        # Add the combination to the set of unique combinations
        unique_combinations.add((employee_id, course_id))

cursor.execute("""
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
""")

for _ in range(15):
    # Generate random data for student submission records
    student_id = random.randint(1, 15)  # Assuming student IDs range from 1 to 15
    course_work_id = random.randint(1, 15)  # Assuming course work IDs range from 1 to 15
    submission_link = fake.url()
    remarks = fake.text(max_nb_chars=50)
    submission_date = fake.date_between(start_date='-30d', end_date='today')
    grade = random.choice(['A', 'B', 'C', 'D', 'F'])

    # Insert the generated data into the "STUDENT_SUBMISSION" table
    cursor.execute(
        "INSERT INTO STUDENT_SUBMISSION (student_id, course_work_id, submission_link, remarks, submission_date, grade) "
        "VALUES (%s, %s, %s, %s, %s, %s)",
        (student_id, course_work_id, submission_link, remarks, submission_date, grade)
    )

cursor.execute("""
CREATE TABLE STUDENT_COURSE (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    total_grade DECIMAL(2,1) NOT NULL,
    CONSTRAINT unique_student_course UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE
);
""")

unique_combinations = set()

while len(unique_combinations) < 15:
    # Generate random student_id and course_id
    student_id = random.randint(1, 15)  # Assuming student IDs range from 1 to 15
    course_id = random.randint(1, 15)  # Assuming course IDs range from 1 to 15
    total_grade = round(random.uniform(0, 10), 1)

    # Check if the combination of student_id and course_id is unique
    if (student_id, course_id) not in unique_combinations:
        # Insert the generated data into the "STUDENT_COURSE" table
        cursor.execute(
            "INSERT INTO STUDENT_COURSE (student_id, course_id, total_grade) "
            "VALUES (%s, %s, %s)",
            (student_id, course_id, total_grade)
        )

        # Add the combination to the set of unique combinations
        unique_combinations.add((student_id, course_id))

cursor.execute("""
CREATE TABLE COURSE_FACULTY (
    course_id INT NOT NULL,
    faculty_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES FACULTY(id) ON DELETE CASCADE,
    CONSTRAINT unique_course_faculty UNIQUE (course_id, faculty_id)
);
""")

# Create a set to keep track of unique combinations of course_id and faculty_id
unique_combinations = set()

while len(unique_combinations) < 15:
    # Generate random course_id and faculty_id
    course_id = random.randint(1, 15)  # Assuming course IDs range from 1 to 15
    faculty_id = random.randint(1, 15)  # Assuming faculty IDs range from 1 to 15

    # Check if the combination of course_id and faculty_id is unique
    if (course_id, faculty_id) not in unique_combinations:
        # Insert the generated data into the "COURSE_FACULTY" table
        cursor.execute(
            "INSERT INTO COURSE_FACULTY (course_id, faculty_id) "
            "VALUES (%s, %s)",
            (course_id, faculty_id)
        )

        # Add the combination to the set of unique combinations
        unique_combinations.add((course_id, faculty_id))

conn.commit()

# Create an index for name column in the department table by name department_name_index
cursor.execute("create index department_name on DEPARTMENT(name);")

# Create an index for course_name and course_number together by name course_name_number_index
cursor.execute("create INDEX course_name_number_index on COURSE(course_name, course_number);")

# Create a view for viewing the basic faculty information
cursor.execute("""
    create view student_faculty_view as select id, first_name, last_name, phone_number, email_id from faculty;
""")

cursor.execute("""
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
        department.id
""")

# Procedure to update the faculty count in the department table
cursor.execute("""
CREATE PROCEDURE update_no_faculty_in_department_when_update_delete_in_faculty()
BEGIN
update department set no_faculty = (select count(*) from faculty where department_id = department.id );
END;
""")

# Procedure to update the faculty count in the department table
cursor.execute("""
CREATE PROCEDURE update_no_faculty_in_department_when_insert_in_faculty ( IN depart_id INT)
BEGIN
 update department set no_faculty = (select count(*) from faculty where department_id = depart_id ) where department.id = depart_id;
END;
""")

# Trigger to update the faculty count in department when the faculty row is deleted
cursor.execute("""
Create TRIGGER delete_faculty_count after DELETE on faculty
for each row 
BEGIN
 call update_no_faculty_in_department_when_update_delete_in_faculty();
END
""")

# Trigger to update the faculty count in department when the faculty row is updated
cursor.execute("""
create TRIGGER update_faculty_count after update on faculty
for each row 
BEGIN
 call update_no_faculty_in_department();
END
""")

# Trigger to update the faculty count in department when the faculty row is inserted
cursor.execute("""
create TRIGGER insert_faculty_count AFTER INSERT on faculty
FOR EACH ROW
BEGIN
    call update_no_faculty_in_department_when_insert_in_faculty(NEW.department_id);
END;
""")

# Trigger to update the total_grade of the student in STUDENT_COURSE
cursor.execute("""
CREATE TRIGGER update_total_grade_trigger_at_insert AFTER INSERT on STUDENT_SUBMISSION
FOR EACH ROW
BEGIN
	DECLARE count DECIMAL(2,1);
	
    SET count = CalculateTotalStudentGrade(NEW.student_id, NEW.course_work_id);
END;
""")

# Function to calculate the total grade of a student
cursor.execute("""
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
""")
# Commit the transaction

conn.close() 