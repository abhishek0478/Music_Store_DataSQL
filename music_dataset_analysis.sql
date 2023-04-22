Q.1 Who is the senior most employee ?

Select * from employee
Order by levels desc
limit 1

Q.2 Which countries have the most invoices ?
 Select count(*) as c,billing_country
 from invoice
 group by billing_country
 Order by c desc
 
Q.3 What are top 3 values of total invoice ?

Select * from invoice
order by total desc
limit 3

Q.4 Which city has best customer? We would like to throw music festival in the city we made most 
money. Write a query that returns one city that has highest sum of invoice total. return both the 
city name and sum of all invoice totals.

Select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc
limit 1

--Q.5 Who is best customer? the person who spent most money will be declared as best customer. write
--the query that returns the person who has spent most money.

Select customer.customer_id, customer.first_name,customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc 
limit 1

-- SeT_2( Moderate questions)

--Q.1 Write a query to first name , last name, email, genre of all music listners. Return your list 
--ordered alphabetically by email starting with A.

SELECT DISTINCT email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
Where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	Where genre.name Like 'Rock'
 )
order by email;


--Q.2 Lets invite the artist who have written the most rock music in our dataset. write a query 
--that return the artist name and total track count of the top 10 rock bands.

Select artist.artist_id, artist.name, Count( artist.artist_id) as number_of_songs
From track
join album on album.album_id=track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id  = track.genre_id
where genre.name like'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10 ;


--Q.3 Return all the track names that have a song lenght longer than the average song lenght. 
-- Return  the name and milliseconds for each track . Order by the song lenght with the longest
--songs listed first.

Select name,milliseconds
from track
where milliseconds>(
	select avg(milliseconds) as avg_track_lenght
	from track)
order by milliseconds desc;


--SET 3 ( Advance question)

--Q.1 Find how much amount spent by each customer on artists? Write a query to return customer 
--name, artist name and total spent.
 With best_selling_artist AS(
	 select artist.artist_id AS artist_id, artist.name As artist_name,
	 sum(invoice_line.unit_price*invoice_line.quantity) As total_sales
	 from invoice_line
	 join track on track.track_id = invoice_line.track_id
	 join album on album.album_id = track.album_id
	 join artist on artist.artist_id = album.artist_id
	 group by 1
	 order by 3 desc
	 limit 1 
 )
select c.customer_id, c.first_name,c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i 
join customer c on c.customer_id = i.customer_id
join invoice_line il ON il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb ON alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id =  alb.artist_id
group by 1,2,3,4
order by 5 desc;

--Q.2 We want to find out the most popular music genre for each country.
--we determine the 

With popular_genre as(
	select count(invoice_line.quantity) As purchases , customer.country, genre.name, genre.genre_id,
    row_number()over(partition by customer.country order by count(invoice_line.quantity)DESC)AS RowNo
	from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc, 1 desc
)
select *from popular_genre where RowNo<=1

--Q.3 Write a query that determines the customer that has spent the most on music for each country
-- write a query that returns the most on music for each country . write a query that returns the
--country along with the top customer and how much they spent .For countries where the top amount 
-- spent is shared, provide all customers who spent this amount.

with customer_with_country AS(
	select customer.customer_id, first_name, last_name, billing_country, sum(total) AS total_spending,
	row_number() over(partition by billing_country order by sum(total) desc) as RowNo
	from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 4 asc, 5 desc
)
Select * from customer_with_country where RowNo<= 1 





