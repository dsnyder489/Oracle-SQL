-- script to empty NORTHWOODS database tables

DROP TABLE enrollment CASCADE CONSTRAINTS;
DROP TABLE course_section CASCADE CONSTRAINTS;
DROP TABLE term CASCADE CONSTRAINTS;
DROP TABLE course CASCADE CONSTRAINTS;
DROP TABLE student CASCADE CONSTRAINTS;
DROP TABLE faculty CASCADE CONSTRAINTS;
DROP TABLE location CASCADE CONSTRAINTS;

CREATE TABLE LOCATION
(loc_id NUMBER(6),
bldg_code VARCHAR2(10),
room VARCHAR2(6),
capacity NUMBER(5),
CONSTRAINT location_loc_id_pk PRIMARY KEY (loc_id));

CREATE TABLE faculty
(f_id NUMBER(6),
f_last VARCHAR2(30),
f_first VARCHAR2(30),
f_mi CHAR(1),
loc_id NUMBER(5),
f_phone VARCHAR2(10),
f_rank VARCHAR2(9),
f_super NUMBER(6),
f_pin NUMBER(4),
f_image BLOB,
CONSTRAINT faculty_f_id_pk PRIMARY KEY(f_id),
CONSTRAINT faculty_loc_id_fk FOREIGN KEY (loc_id) REFERENCES location(loc_id));

CREATE TABLE student
(s_id VARCHAR2(6),
s_last VARCHAR2(30),
s_first VARCHAR2(30),
s_mi CHAR(1),
s_address VARCHAR2(25),
s_city VARCHAR2(20),
s_state CHAR(2),
s_zip VARCHAR2(10),
s_phone VARCHAR2(10),
s_class CHAR(2),
s_dob DATE,
s_pin NUMBER(4),
f_id NUMBER(6),
time_enrolled INTERVAL YEAR TO MONTH,
CONSTRAINT student_s_id_pk PRIMARY KEY (s_id),
CONSTRAINT student_f_id_fk FOREIGN KEY (f_id) REFERENCES faculty(f_id));

CREATE TABLE TERM
(term_id NUMBER(6),
term_desc VARCHAR2(20),
status VARCHAR2(20),
start_date DATE,
CONSTRAINT term_term_id_pk PRIMARY KEY (term_id),
CONSTRAINT term_status_cc CHECK ((status = 'OPEN') OR (status = 'CLOSED')));

CREATE TABLE COURSE
(course_no VARCHAR2(7),
course_name VARCHAR2(25),
credits NUMBER(2),
CONSTRAINT course_course_id_pk PRIMARY KEY(course_no));

CREATE TABLE COURSE_SECTION
(c_sec_id NUMBER(6),
course_no VARCHAR2(7) CONSTRAINT course_section_courseid_nn NOT NULL,
term_id NUMBER(6) CONSTRAINT course_section_termid_nn NOT NULL,
sec_num NUMBER(2) CONSTRAINT course_section_secnum_nn NOT NULL,
f_id NUMBER(6),
c_sec_day VARCHAR2(10),
c_sec_time DATE,
c_sec_duration INTERVAL DAY TO SECOND,
loc_id NUMBER(6),
max_enrl NUMBER(4) CONSTRAINT course_section_maxenrl_nn NOT NULL,
CONSTRAINT course_section_csec_id_pk PRIMARY KEY (c_sec_id),
CONSTRAINT course_section_cid_fk FOREIGN KEY (course_no) REFERENCES course(course_no),
CONSTRAINT course_section_loc_id_fk FOREIGN KEY (loc_id) REFERENCES location(loc_id),
CONSTRAINT course_section_termid_fk FOREIGN KEY (term_id) REFERENCES term(term_id),
CONSTRAINT course_section_fid_fk FOREIGN KEY (f_id) REFERENCES faculty(f_id));

CREATE TABLE ENROLLMENT
(s_id VARCHAR2(6),
c_sec_id NUMBER(6),
grade CHAR(1),
CONSTRAINT enrollment_pk PRIMARY KEY (s_id, c_sec_id),
CONSTRAINT enrollment_sid_fk FOREIGN KEY (s_id) REFERENCES student(s_id),
CONSTRAINT enrollment_csecid_fk FOREIGN KEY (c_sec_id) REFERENCES course_section (c_sec_id));
