-- Database Creation and Use
CREATE DATABASE MavenMovies;
USE MavenMovies;

-- 1. Create employees table with constraints
CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name TEXT NOT NULL,
    age INT CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL DEFAULT 30000
);

-- 2. Purpose of constraints
-- Constraints ensure data integrity and enforce business rules. 
-- Examples: PRIMARY KEY (ensures uniqueness), NOT NULL (prevents missing values), 
-- UNIQUE (prevents duplicates), CHECK (restricts values), FOREIGN KEY (maintains relationships).

-- 3. NOT NULL and Primary Key
-- NOT NULL prevents missing values. PRIMARY KEY ensures uniqueness and cannot contain NULL.

-- 4. Adding & Removing Constraints
ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary > 25000);
ALTER TABLE employees DROP CONSTRAINT chk_salary;

-- 5. Consequences of Violating Constraints
-- Example: INSERT INTO employees (emp_id, emp_name, age) VALUES (1, 'John', 17); -- ERROR: CHECK constraint failed.

-- 6. Modify Products Table
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE products ALTER COLUMN price SET DEFAULT 50.00;

-- 7. INNER JOIN Students & Classes
SELECT student_name, class_name FROM students INNER JOIN classes ON students.class_id = classes.class_id;

-- 8. Orders, Customers, Products Query
SELECT orders.order_id, customers.customer_name, COALESCE(products.product_name, 'No Product')
FROM orders LEFT JOIN products ON orders.product_id = products.product_id 
INNER JOIN customers ON orders.customer_id = customers.customer_id;

-- 9. Total Sales Per Product
SELECT products.product_name, SUM(orders.amount) AS total_sales FROM orders
INNER JOIN products ON orders.product_id = products.product_id
GROUP BY products.product_name;

-- 10. Orders & Customer Quantity Query
SELECT orders.order_id, customers.customer_name, SUM(order_details.quantity) AS total_quantity 
FROM orders INNER JOIN customers ON orders.customer_id = customers.customer_id 
INNER JOIN order_details ON orders.order_id = order_details.order_id 
GROUP BY orders.order_id, customers.customer_name;

-- SQL Commands for Maven Movies DB
SELECT * FROM actors;
SELECT * FROM customers;
SELECT DISTINCT country FROM addresses;
SELECT * FROM customers WHERE active = 1;
SELECT rental_id FROM rentals WHERE customer_id = 1;
SELECT * FROM films WHERE rental_duration > 5;
SELECT COUNT(*) FROM films WHERE replacement_cost BETWEEN 15 AND 20;
SELECT COUNT(DISTINCT first_name) FROM actors;
SELECT * FROM customers LIMIT 10;
SELECT * FROM customers WHERE first_name LIKE 'b%' LIMIT 3;
SELECT title FROM films WHERE rating = 'G' LIMIT 5;
SELECT * FROM customers WHERE first_name LIKE 'a%';
SELECT * FROM customers WHERE first_name LIKE '%a';
SELECT * FROM cities WHERE city LIKE 'a%a' LIMIT 4;
SELECT * FROM customers WHERE first_name LIKE '%NI%';
SELECT * FROM customers WHERE first_name LIKE '_r%';
SELECT * FROM customers WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;
SELECT * FROM customers WHERE first_name LIKE 'a%' AND first_name LIKE '%o';
SELECT * FROM films WHERE rating IN ('PG', 'PG-13');
SELECT * FROM films WHERE length BETWEEN 50 AND 100;
SELECT * FROM actors LIMIT 50;
SELECT DISTINCT film_id FROM inventory;

-- Aggregate Functions
SELECT COUNT(*) FROM rentals;
SELECT AVG(rental_duration) FROM films;
SELECT UPPER(first_name), UPPER(last_name) FROM customers;
SELECT rental_id, MONTH(rental_date) FROM rentals;

-- GROUP BY Queries
SELECT customer_id, COUNT(*) FROM rentals GROUP BY customer_id;
SELECT store_id, SUM(amount) FROM payments GROUP BY store_id;
SELECT category_name, COUNT(*) FROM film_category
INNER JOIN films ON film_category.film_id = films.film_id
INNER JOIN rentals ON films.film_id = rentals.inventory_id GROUP BY category_name;
SELECT language_id, AVG(rental_rate) FROM films GROUP BY language_id;

-- Joins Queries
SELECT title, first_name, last_name FROM films 
JOIN inventory ON films.film_id = inventory.film_id
JOIN rentals ON inventory.inventory_id = rentals.inventory_id
JOIN customers ON rentals.customer_id = customers.customer_id;

SELECT first_name, last_name FROM actors
JOIN film_actor ON actors.actor_id = film_actor.actor_id
JOIN films ON film_actor.film_id = films.film_id
WHERE films.title = 'Gone with the Wind';

SELECT customers.first_name, customers.last_name, SUM(payments.amount) FROM customers
JOIN payments ON customers.customer_id = payments.customer_id
GROUP BY customers.first_name, customers.last_name;

SELECT title FROM films 
JOIN inventory ON films.film_id = inventory.film_id
JOIN rentals ON inventory.inventory_id = rentals.inventory_id
JOIN customers ON rentals.customer_id = customers.customer_id
JOIN addresses ON customers.address_id = addresses.address_id
JOIN cities ON addresses.city_id = cities.city_id
WHERE cities.city = 'London'
GROUP BY title;

-- Advanced Joins
SELECT title, COUNT(*) FROM films 
JOIN inventory ON films.film_id = inventory.film_id
JOIN rentals ON inventory.inventory_id = rentals.inventory_id
GROUP BY title ORDER BY COUNT(*) DESC LIMIT 5;

-- Windows Functions
SELECT customer_id, RANK() OVER(ORDER BY SUM(amount) DESC) FROM payments GROUP BY customer_id;
SELECT film_id, SUM(amount) OVER(PARTITION BY film_id ORDER BY rental_date) FROM rentals;
SELECT film_id, AVG(rental_duration) OVER(PARTITION BY length) FROM films;
SELECT category_name, title, RANK() OVER(PARTITION BY category_name ORDER BY COUNT(*) DESC) FROM films
JOIN film_category ON films.film_id = film_category.film_id GROUP BY category_name, title;

-- Recursive CTE for Employee Reporting
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT staff_id, first_name, last_name, reports_to FROM staff WHERE reports_to IS NULL
    UNION ALL
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to FROM staff s
    JOIN EmployeeHierarchy eh ON s.reports_to = eh.staff_id
)
SELECT * FROM EmployeeHierarchy;
