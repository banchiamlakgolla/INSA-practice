create database practice;
use practice;

CREATE TABLE teacher(
course_id INT AUTO_INCREMENT PRIMARY KEY,
teacher_name VARCHAR(50),


);

CREATE TABLE student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT AUTO_INCREMENT FOREIGN key,
    first_name VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL, 
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
Q