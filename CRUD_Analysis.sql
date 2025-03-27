SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM members;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;

--CRUD OPERATIONS (Create, Read, Update and Delete)

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

UPDATE members
SET member_address='125 Main St'
WHERE member_id='C101';

DELETE FROM issued_status
WHERE issued_id='IS121';

SELECT * FROM issued_status 
WHERE issued_emp_id='E104';

--Select employees who have issued more than 1 book

SELECT issued_emp_id
	--COUNT(issued_id) AS total_books_issued 
FROM issued_status
GROUP BY 1
HAVING COUNT(issued_id)>1;

--CTAS (Create Table as Select)

--Creating Summary Table using CTAS based on books and the total number of tims they have been issued

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issued_cnt LIMIT 5;

--DATA ANAlYSIS 

--Retrieve all books in a specific category
SELECT * FROM books WHERE category='Classic';

--Find total rental income by category
SELECT b.category, SUM(b.rental_price), COUNT(*)
FROM books as b 
JOIN issued_status as ist
ON ist.issued_book_isbn=b.isbn
GROUP BY 1;

--Members who registered in the last 180 days

SELECT CURRENT_DATE; --Gives current Date

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

--List Employees with their branch manager names and branch details

SELECT
	e1.*, e2.emp_name as manager, b.branch_id
FROM employees as e1
JOIN branch as b
ON e1.branch_id = b.branch_id
JOIN 
employees as e2
ON b.manager_id = e2.emp_id;

--Create a table of books with rental price above 7 

CREATE TABLE books_price_above_7 AS
SELECT * FROM books
WHERE rental_price > 7;

SELECT * FROM books_price_above_7;

--Retrieve List of Books not yet returned

SELECT DISTINCT(issued_status.issued_book_name)
FROM issued_status
LEFT JOIN return_status
ON issued_status.issued_id=return_status.issued_id
WHERE return_status.return_id IS NULL;


