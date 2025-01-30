use mavenmovies;
/* ============================== SECTION 1: TABLE CREATION AND CONSTRAINTS ============================== */

-- Question 1: Create employees table with constraints
CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name TEXT NOT NULL,
    age INT CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL(10, 2) DEFAULT 30000
);

-- Question 2: Purpose of Constraints
/*
Constraints ensure data integrity by enforcing rules on the data stored in a table.
Examples:
1. NOT NULL: Ensures a column cannot have NULL values.
2. PRIMARY KEY: Uniquely identifies each record in a table.
3. FOREIGN KEY: Ensures referential integrity between tables.
4. CHECK: Validates that values meet a condition.
5. UNIQUE: Ensures all values in a column are distinct.
*/

-- Question 3: Why use NOT NULL? Can a primary key contain NULL?
/*
NOT NULL ensures a column always has a value, preventing incomplete data.
A primary key cannot contain NULL values because it must uniquely identify each record.
*/

-- Question 4: Adding or Removing Constraints
-- Example: Add a CHECK constraint to ensure salary > 20000
ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary > 20000);

-- Example: Remove the CHECK constraint
ALTER TABLE employees DROP CONSTRAINT chk_salary;

-- Question 5: Consequences of Violating Constraints
/*
Attempting to violate constraints results in an error.
Example Error Message:
ERROR: new row for relation "employees" violates check constraint "chk_age"
DETAIL: Failing row contains (1, 'John Doe', 17, 'john@example.com', 30000.00).
*/

-- Question 6: Modify products table to add constraints
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE products ALTER COLUMN price SET DEFAULT 50.00;

-- Question 7: Fetch student_name and class_name using INNER JOIN
-- Assuming tables: students(student_id, student_name, class_id) and classes(class_id, class_name)
SELECT s.student_name, c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.class_id;

-- Question 8: List all order_id, customer_name, and product_name (LEFT JOIN)
-- Assuming tables: orders(order_id, customer_id), customers(customer_id, customer_name), products(product_id, product_name)
SELECT o.order_id, c.customer_name, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
LEFT JOIN customers c ON o.customer_id = c.customer_id;

-- Question 9: Total sales amount for each product
-- Assuming tables: order_details(order_id, product_id, quantity, price), products(product_id, product_name)
SELECT p.product_name, SUM(od.quantity * od.price) AS total_sales
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name;

-- Question 10: Display order_id, customer_name, and quantity of products ordered
-- Assuming tables: orders(order_id, customer_id), customers(customer_id, customer_name), order_details(order_id, product_id, quantity)
SELECT o.order_id, c.customer_name, SUM(od.quantity) AS total_quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, c.customer_name;


/* ============================== SECTION 2: SQL COMMANDS ============================== */

-- Question 1: Identify primary keys and foreign keys in Maven Movies DB
/*
Primary Keys:
- actor.actor_id
- film.film_id
- customer.customer_id

Foreign Keys:
- film_actor.actor_id references actor.actor_id
- film_actor.film_id references film.film_id
- rental.customer_id references customer.customer_id
*/

-- Question 2: List all details of actors
SELECT * FROM actor;

-- Question 3: List all customer information
SELECT * FROM customer;

-- Question 4: List different countries
SELECT DISTINCT country FROM country;

-- Question 5: Display all active customers
SELECT * FROM customer WHERE active = 1;

-- Question 6: List of all rental IDs for customer with ID 1
SELECT rental_id FROM rental WHERE customer_id = 1;

-- Question 7: Films with rental duration > 5
SELECT title FROM film WHERE rental_duration > 5;

-- Question 8: Count of films with replacement cost between $15 and $20
SELECT COUNT(*) AS film_count
FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- Question 9: Count of unique first names of actors
SELECT COUNT(DISTINCT first_name) AS unique_first_names FROM actor;

-- Question 10: First 10 records from customer table
SELECT * FROM customer LIMIT 10;

-- Question 11: First 3 records where first name starts with 'b'
SELECT * FROM customer WHERE first_name LIKE 'B%' LIMIT 3;

-- Question 12: First 5 movies rated as 'G'
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

-- Question 13: Customers whose first name starts with "a"
SELECT * FROM customer WHERE first_name LIKE 'A%';

-- Question 14: Customers whose first name ends with "a"
SELECT * FROM customer WHERE first_name LIKE '%A';

-- Question 15: First 4 cities starting and ending with 'a'
SELECT city FROM city WHERE city LIKE 'A%A' LIMIT 4;

-- Question 16: Customers with "NI" in any position
SELECT * FROM customer WHERE first_name LIKE '%NI%';

-- Question 17: Customers with "r" in the second position
SELECT * FROM customer WHERE first_name LIKE '_R%';

-- Question 18: Customers whose first name starts with "a" and is at least 5 characters long
SELECT * FROM customer WHERE first_name LIKE 'A____%';

-- Question 19: Customers whose first name starts with "a" and ends with "o"
SELECT * FROM customer WHERE first_name LIKE 'A%O';

-- Question 20: Films with PG and PG-13 ratings
SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

-- Question 21: Films with length between 50 and 100
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- Question 22: Top 50 actors
SELECT * FROM actor LIMIT 50;

-- Question 23: Distinct film IDs from inventory table
SELECT DISTINCT film_id FROM inventory;


/* ============================== SECTION 3: FUNCTIONS ============================== */

-- Question 1: Total number of rentals
SELECT COUNT(*) AS total_rentals FROM rental;

-- Question 2: Average rental duration
SELECT AVG(rental_duration) AS avg_rental_duration FROM film;

-- Question 3: Customer names in uppercase
SELECT UPPER(first_name) AS first_name, UPPER(last_name) AS last_name FROM customer;

-- Question 4: Extract month from rental date
SELECT rental_id, MONTH(rental_date) AS rental_month FROM rental;

-- Question 5: Count of rentals per customer
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Question 6: Total revenue per store
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- Question 7: Rentals per category
SELECT c.name AS category, COUNT(*) AS rental_count
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- Question 8: Average rental rate per language
SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

/* ============================== SECTION 4: JOINS ============================== */

-- Question 9: Display the title of the movie, customer's first name, and last name who rented it
-- Assuming tables: film(film_id, title), inventory(film_id, inventory_id), rental(rental_id, inventory_id, customer_id), customer(customer_id, first_name, last_name)
SELECT f.title AS movie_title, c.first_name, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Question 10: Retrieve the names of all actors who have appeared in the film "Gone with the Wind"
-- Assuming tables: film(film_id, title), film_actor(actor_id, film_id), actor(actor_id, first_name, last_name)
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- Question 11: Retrieve the customer names along with the total amount they've spent on rentals
-- Assuming tables: customer(customer_id, first_name, last_name), payment(customer_id, amount)
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Question 12: List the titles of movies rented by each customer in a particular city (e.g., 'London')
-- Assuming tables: customer(customer_id, first_name, last_name, address_id), address(address_id, city_id), city(city_id, city), rental(rental_id, customer_id, inventory_id), inventory(inventory_id, film_id), film(film_id, title)
SELECT c.first_name, c.last_name, f.title AS movie_title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ct.city = 'London';

/* ============================== Advanced Joins and GROUP BY ============================== */

-- Question 13: Display the top 5 rented movies along with the number of times they've been rented.
SELECT 
    f.title AS film_title,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

-- Question 14: Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
WITH CustomerStoreRentals AS (
    SELECT 
        c.customer_id,
        i.store_id
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    GROUP BY c.customer_id, i.store_id
)
SELECT 
    csr1.customer_id
FROM CustomerStoreRentals csr1
JOIN CustomerStoreRentals csr2 
    ON csr1.customer_id = csr2.customer_id AND csr1.store_id <> csr2.store_id
GROUP BY csr1.customer_id;

/* ============================== SECTION 5: Window Functions ============================== */

-- Question 1: Rank the customers based on the total amount they've spent on rentals.
SELECT 
    customer_id,
    first_name,
    last_name,
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer_id, first_name, last_name;

-- Question 2: Calculate the cumulative revenue generated by each film over time.
SELECT 
    f.title AS film_title,
    p.payment_date,
    p.amount,
    SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
ORDER BY f.title, p.payment_date;

-- Question 3: Determine the average rental duration for each film, considering films with similar lengths.
SELECT 
    title,
    length,
    rental_duration,
    AVG(rental_duration) OVER (PARTITION BY length) AS avg_rental_duration_for_length
FROM film
ORDER BY length, title;

-- Question 4: Identify the top 3 films in each category based on their rental counts.
WITH FilmRentalCounts AS (
    SELECT 
        c.name AS category,
        f.film_id,
        f.title,
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.film_id, f.title
),
RankedFilms AS (
    SELECT 
        category,
        film_id,
        title,
        rental_count,
        RANK() OVER (PARTITION BY category ORDER BY rental_count DESC) AS rank_within_category
    FROM FilmRentalCounts
)
SELECT 
    category,
    title,
    rental_count,
    rank_within_category
FROM RankedFilms
WHERE rank_within_category <= 3
ORDER BY category, rank_within_category;

-- Question 5: Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.
WITH CustomerRentalCounts AS (
    SELECT 
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY customer_id
),
AverageRentalCount AS (
    SELECT 
        AVG(rental_count) AS avg_rental_count
    FROM CustomerRentalCounts
)
SELECT 
    crc.customer_id,
    crc.rental_count,
    arc.avg_rental_count,
    (crc.rental_count - arc.avg_rental_count) AS difference_from_average
FROM CustomerRentalCounts crc
CROSS JOIN AverageRentalCount arc;

-- Question 6: Find the monthly revenue trend for the entire rental store over time.
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS revenue_month,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY revenue_month;

-- Question 7: Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH CustomerSpending AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spent,
        NTILE(5) OVER (ORDER BY SUM(amount) DESC) AS spending_percentile
    FROM payment
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spent
FROM CustomerSpending
WHERE spending_percentile = 1; -- Top 20% corresponds to the first NTILE group

-- Question 8: Calculate the running total of rentals per category, ordered by rental count.
WITH CategoryRentalCounts AS (
    SELECT 
        c.name AS category,
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name
)
SELECT 
    category,
    rental_count,
    SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total_rentals
FROM CategoryRentalCounts;

-- Question 9: Find the films that have been rented less than the average rental count for their respective categories.
WITH FilmRentalCounts AS (
    SELECT 
        c.name AS category,
        f.film_id,
        f.title,
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.film_id, f.title
),
CategoryAverages AS (
    SELECT 
        category,
        AVG(rental_count) AS avg_rental_count
    FROM FilmRentalCounts
    GROUP BY category
)
SELECT 
    frc.category,
    frc.title,
    frc.rental_count,
    ca.avg_rental_count
FROM FilmRentalCounts frc
JOIN CategoryAverages ca ON frc.category = ca.category
WHERE frc.rental_count < ca.avg_rental_count;

-- Question 10: Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS revenue_month,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY total_revenue DESC
LIMIT 5;


/* ============================== SECTION 6: NORMALIZATION & CTE ============================== */

-- Question 1: Normalize a table to 1NF
/*
Example: A table storing multiple phone numbers in a single column violates 1NF.
Solution: Split the phone numbers into separate rows.
*/

-- Question 2: Normalize a table to 2NF
/*
Example: A table with composite primary key (film_id, actor_id) and non-key attributes violates 2NF.
Solution: Split into separate tables for film and actor relationships.
*/

-- Question 3: Normalize a table to 3NF
/*
Example: A table with transitive dependency (e.g., customer -> city -> country) violates 3NF.
Solution: Create separate tables for city and country.
*/

-- Question 4: Normalize a table from unnormalized form to 2NF
/*
Example: Start with a table storing customer, order, and product details.
Step 1: Split into customer, order, and product tables.
Step 2: Ensure each table has a primary key and no partial dependencies.
*/

-- Question 5: CTE for actor names and film count
WITH ActorFilmCount AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor a
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT * FROM ActorFilmCount;

-- Question 6: CTE for film title, language, and rental rate
WITH FilmLanguageDetails AS (
    SELECT f.title, l.name AS language, f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM FilmLanguageDetails;

-- Question 7: CTE for total revenue per customer
WITH CustomerRevenue AS (
    SELECT c.customer_id, SUM(p.amount) AS total_revenue
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
)
SELECT * FROM CustomerRevenue;

-- Question 8: Recursive CTE for employees reporting to a manager
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT staff_id, first_name, last_name, reports_to
    FROM staff
    WHERE reports_to IS NULL
    UNION ALL
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
    FROM staff s
    INNER JOIN EmployeeHierarchy eh ON s.reports_to = eh.staff_id
)
SELECT * FROM EmployeeHierarchy;

/* ============================== Normalization & CTE Section ============================== */

-- 9a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.
WITH CustomersWithMoreThanTwoRentals AS (
    SELECT 
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ctr.rental_count
FROM customer c
JOIN CustomersWithMoreThanTwoRentals ctr ON c.customer_id = ctr.customer_id;

-- 10a. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table.
WITH MonthlyRentalCounts AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
)
SELECT 
    rental_month,
    total_rentals
FROM MonthlyRentalCounts
ORDER BY rental_month;

-- 11a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.
WITH ActorPairs AS (
    SELECT 
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id,
        f.title AS film_title
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
    JOIN film f ON fa1.film_id = f.film_id
)
SELECT 
    a1.first_name AS actor1_first_name,
    a1.last_name AS actor1_last_name,
    a2.first_name AS actor2_first_name,
    a2.last_name AS actor2_last_name,
    ap.film_title
FROM ActorPairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id;

-- 12a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column.
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT 
        staff_id,
        first_name,
        last_name,
        reports_to
    FROM staff
    WHERE staff_id = 1 -- Replace '1' with the desired manager's staff_id
    UNION ALL
    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        s.reports_to
    FROM staff s
    INNER JOIN EmployeeHierarchy eh ON s.reports_to = eh.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name,
    reports_to
FROM EmployeeHierarchy;