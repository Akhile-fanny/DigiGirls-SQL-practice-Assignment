--Q1
/* QUESTION 1.
Display the customer names that share the same address. (E.g husband and wife)  */

SELECT cus1.first_name, cus1.last_name, cus2.first_name, cus2.last_name
FROM customer AS cus1
INNER JOIN customer AS cus2 ON 
								cus1.customer_id != cus2.customer_id 
							AND cus1.address_id = cus2.address_id;
							
							
--Q2
/*QUESTION 2.
What is the name of the customer who made the highest total payments */

SELECT concat(cus.first_name,' ', cus.last_name) AS customer_name, SUM(pay.amount) AS total_amount
FROM customer cus
INNER JOIN payment pay ON cus.customer_id = pay.customer_id
GROUP BY first_name, last_name
ORDER BY total_amount DESC
LIMIT 1;

--Q3
/* QUESTION 3.
What is the movie(s) that was rented the most.*/

SELECT film_id, COUNT(film_id) AS rental_count FROM rental ren INNER JOIN inventory inv
				ON ren.inventory_id = inv.inventory_id
GROUP BY film_id
ORDER BY rental_count DESC;

-- Since the 34 was the most time the film was rented,the 
--following query resulted the name of the movie that was rented 34 times.

SELECT title  FROM film
WHERE film_id = 103;

--Q4
/*  QUESTION 4.
Which movies have been rented so far. */

SELECT COUNT(title)AS number_of_rented_movies  FROM film WHERE film_id IN (SELECT film_id 
										FROM rental ren INNER JOIN inventory inv ON
										ren.inventory_id = inv.inventory_id);


--Q5
/*  QUESTION 5.
Which movies have not been rented so far.*/

SELECT COUNT(title)AS number_of_not_rented_movies  FROM film WHERE film_id NOT IN (SELECT film_id 
										FROM rental ren INNER JOIN inventory inv ON
										ren.inventory_id = inv.inventory_id);


--Q6
/*  QUESTION 6.
 Which customers have not rented any movies so far.*/
 
SELECT concat(cus.first_name,' ', cus.last_name) AS customer_name  
FROM customer cus
WHERE customer_id NOT IN (SELECT DISTINCT(customer_id) 
										FROM rental);
										
--Q7
/*  QUESTION 7.
 Display each movie and the number of times it got rented. */
 
SELECT fil.title, COUNT(inv.film_id) AS times_rented 
FROM film fil INNER JOIN inventory inv ON fil.film_id = inv.film_id 
						INNER JOIN rental AS ren ON inv.inventory_id = ren.inventory_id
GROUP BY title
ORDER BY times_rented DESC;

--Q8
/*  QUESTION 8.
Show the first name and the last name and the number of movies each actor acted in */

SELECT first_name, last_name, COUNT (film_id) AS times_acted FROM actor act
								INNER JOIN film_actor filact ON act.actor_id = filact.actor_id
GROUP BY first_name,last_name
ORDER BY times_acted DESC;

--Q9
/*  QUESTION 9.
Display the names of the actors that acted in more than 20 movies */

-- Appraoch 1
/*I created a temporary table to store the query that resulted all actors and how many times they acted. */

 CREATE TEMPORARY TABLE times_acted AS
(SELECT first_name, last_name, COUNT (film_id) AS times_acted FROM actor act
						INNER JOIN film_actor filact ON act.actor_id = filact.actor_id
GROUP BY first_name,last_name
ORDER BY times_acted DESC);

-- I queryed the temporary table to show actors that acted in more than 20 films
SELECT * FROM times_acted
WHERE times_acted > 20;

-- Appraoch 2 to question 9.
SELECT first_name, last_name, COUNT (film_id) AS times_acted FROM actor act
						INNER JOIN film_actor filact ON act.actor_id = filact.actor_id
GROUP BY first_name,last_name
HAVING COUNT (film_id) >20
ORDER BY times_acted DESC;


--Q10
/*  QUESTION 10.
For all the movies rated “PG” show me the movie and the number of times it got rented */

SELECT fil.title, COUNT(inv.film_id) AS times_rented 
FROM film fil INNER JOIN inventory inv ON fil.film_id = inv.film_id 
								INNER JOIN rental AS ren ON inv.inventory_id = ren.inventory_id
								
WHERE rating = 'PG'
GROUP BY title
ORDER BY times_rented DESC;

--Q11
/*  QUESTION 11.
Display the movies offered for rent in store_id 1 and not offered in store_id 2. */

SELECT fil.title
FROM film fil 
			INNER JOIN inventory inv ON fil.film_id = inv.film_id
WHERE inv.store_id = 1 AND fil.title NOT IN
					(SELECT fil.title FROM film fil WHERE store_id = 2);
									
--Q12
/*  QUESTION 12.
Display the movies offered for rent in any of the two stores 1 and 2. */

SELECT fil.title
FROM film fil 
			INNER JOIN inventory inv ON fil.film_id = inv.film_id
WHERE inv.store_id = 1
UNION 
SELECT fil.title
FROM film fil 
			INNER JOIN inventory inv ON fil.film_id = inv.film_id
WHERE inv.store_id =  2 ;

--Q13
/*  QUESTION 13.
Display the movie titles of those movies offered in both stores at the same time. */

SELECT title
FROM film 
WHERE film_id IN 
		(SELECT film_id FROM inventory WHERE store_id = 1) AND film_id IN
		(SELECT film_id FROM inventory WHERE store_id = 2);

--Q14
/*  QUESTION 14.
Display the movie title for the most rented movie in the store with store_id 1*/

SELECT fil.title, COUNT (ren.rental_id) AS rented_times
FROM film fil
			INNER JOIN inventory inv ON inv.film_id = fil.film_id
			INNER JOIN rental ren ON ren.inventory_id = inv.inventory_id
WHERE inv.store_id = 1
GROUP BY title
ORDER BY rented_times DESC
LIMIT 1;

--Q15
/*  QUESTION 15.
How many movies are not offered for rent in the stores yet. There are two stores only 1 and 2.*/

SELECT COUNT(DISTINCT(film_id)) films_not_offered_for_rent FROM film
WHERE film_id NOT IN (SELECT film_id FROM inventory)

--Q16
/*  QUESTION 16.
Show the number of rented movies under each rating */

SELECT fil.rating, COUNT(ren.rental_id) AS No_of_rented_movies
FROM film fil 
			INNER JOIN inventory inv ON fil.film_id = inv.film_id
			INNER JOIN rental ren ON inv.inventory_id = ren.inventory_id
GROUP BY fil.rating
ORDER BY No_of_rented_movies DESC;

--Q17
/* QUESTION 17.
Show the profit of each of the stores 1 and 2 */

SELECT inv.store_id, SUM(pay.amount) AS profit
FROM payment pay 
		INNER JOIN rental ren ON pay.rental_id = ren.rental_id
		INNER JOIN inventory inv ON inv.inventory_id = ren.inventory_id
GROUP BY inv.store_id
ORDER BY profit DESC;

