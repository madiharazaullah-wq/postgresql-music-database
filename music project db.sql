-- Qno 1: who is  senior most employee based on job title?
select *  from employee order by levels desc  limit 1;
-- Qno 2: which country  have the most invoices?
select  billing_country,count(total) from invoice group by billing_country  order by count (total)desc limit 1;
-- Qno 3: what  are top 3 values of total invoice?
select  * from invoice order by total desc  limit 3;
-- Qno 4:Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals?.
select billing_city,sum(total) from invoice group by billing_city order by sum(total) desc limit 1 ;
-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer.
-- Write a query that returns the person who has spent the most money ?.
select customer.customer_id,customer.first_name,customer.last_name ,sum(total) as total  from  customer join invoice on customer.customer_id=invoice.customer_id  group by customer.customer_id order by sum(total) desc limit 1 ;
select * from genre;
select * from customer;
-- Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email, starting with A ?.
select  distinct email,first_name,last_name from customer  join invoice on customer.customer_id=invoice.customer_id join invoice_line on invoice.invoice_id=invoice_line.invoice_id  where track_id in(select track_id from track join genre on track.genre_id=genre.genre_id 
where genre.name='Rock'
) order by email;
-- Q7: Let's invite the artists who have written the most rock music in our dataset.
-- Write a query that returns the Artist name and total track count of the top 10 rock bands?.
select artist.artist_id,artist.name,count(artist.artist_id) AS number_of_songs  from track JOIN album ON album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;
-- Q8: Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first?.
select  name ,milliseconds  from  track where milliseconds>
(select avg(milliseconds)  from track)
order by milliseconds   desc ;
 -- Q9:Find how much amount spent by each customer on artists
 -- Write a query to return customer name, artist name and total spent?.
SELECT 
    artist.name AS artist_name,
    customer.customer_id,
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS total_amount
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON track.album_id = album.album_id
JOIN invoice_line ON track.track_id = invoice_line.track_id
JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, artist.name
ORDER BY total_amount DESC;
-- Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases.
-- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared, return all Genres?.
 WITH ranked_genres AS (
 select  invoice.billing_Country, count(*) as total_purchase ,dense_rank () over ( partition by billing_country order by count(*) desc) AS genre_rank, genre.name from invoice join invoice_line on invoice.invoice_id= invoice_line.invoice_id  join track on  track.track_id=invoice_line.track_id 
 join genre on  genre.genre_id= track.genre_id  group by  invoice.billing_Country, genre.name ) 
 select * from ranked_genres where   genre_rank=1;
 -- Q11: Write a query that determines the customer that has spent the most on music for each country. 
 -- Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount?.
 WITH total AS (
    SELECT 
        customer.first_name,
        customer.last_name, 
        invoice.billing_country,  
        SUM(invoice_line.quantity * invoice_line.unit_price) AS total_spend,
        DENSE_RANK() OVER (
            PARTITION BY invoice.billing_country  
            ORDER BY SUM(invoice_line.quantity * invoice_line.unit_price) DESC
        ) AS rnk
    FROM customer  
    JOIN invoice ON customer.customer_id = invoice.customer_id  
    JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id 
    GROUP BY invoice.billing_country, customer.first_name, customer.last_name
)
SELECT * 
FROM total 
WHERE rnk = 1;