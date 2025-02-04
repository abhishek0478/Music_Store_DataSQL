
--Create tables
Drop table if exists Books;
Create TABLE Books(
	Book_id Serial Primary key,
	Title varchar(100),
	Author Varchar(100),
	Genre Varchar(50),
	Published_year INT,
	Price Numeric(10,2),
	Stock INT
);

Drop table if exists Customers;
Create TABLE Customers(
	Customer_ID Serial Primary Key,
	Name Varchar(100),
	Email Varchar(100),
	Phone Varchar(100),
	City Varchar(50),
	Country Varchar(150)
);

Drop Table If exists orders;
Create table orders(
	Order_id Serial Primary Key,
	Customer_id Int references Customers(Customer_ID),
	Book_id Int references Books(Book_id),
	Order_date Date,
	Quantity INT,
	Total_amount Numeric(10,2)
);


Select * from Books
Select * from Customers
Select * from Orders

-- 1) Retrieve all books in the "Fiction" genre:
Select * from Books
where Genre = 'Fiction'

-- 2) Find books published after the year 1950:
Select * from Books
where published_year >1950

-- 3) List all customers from the Canada:
Select * from Customers
where Country = 'Canada'

-- 4) Show orders placed in November 2023:
Select * from Orders
where Order_Date >= '01-11-2023' and Order_Date <= '30-11-2023'

-- 5) Retrieve the total stock of books available:
Select Sum(Stock) as Total_stock
from Books

-- 6) Find the details of the most expensive book:
Select * from Books
where price = (select max(price) from Books);

SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
Select * from orders
where quantity >1

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
Select B.Genre, sum(o.Quantity) as books_sold
from Books B
join orders o on B.book_id = o.book_id
group by genre
order by books_sold desc

-- 2) Find the average price of books in the "Fantasy" genre:
Select Round(Avg(price),2) as avg_price
from Books
where Genre = 'Fantasy'

-- 3) List customers who have placed at least 2 orders:
Select c.customer_id ,c.name, count(o.order_id)
from Customers c
join orders o on c.Customer_id = o.Customer_id
Group by  c.Customer_id ,c.name
Having count(o.order_id)>=2
order by  c.Customer_id ;

-- 4) Find the most frequently ordered book:
Select b.book_id,b.Title, Count(o.order_id) as frequently_ordered
from Books b
join orders o on b.book_id = o.book_id
group by b.book_id,b.Title
order by Count(o.Book_ID) desc
Limit 1

--NOTE: Above query does not provide exact number of books with same order frequency, but query mentioned below will
--assign row number to each order count with same number, it helps to fetch all frequently ordered book with same rank.
SELECT Book_id, title, ORDER_COUNT
FROM (
    SELECT 
        o.Book_id, 
        b.title, 
        COUNT(o.order_id) AS ORDER_COUNT, 
        RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rnk
    FROM orders o
    JOIN books b ON o.book_id = b.book_id
    GROUP BY o.book_id, b.title
) ranked_books
WHERE rnk = 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
Select * from Books
where Genre = 'Fantasy'
order by price desc
limit 3

-- 6) Retrieve the total quantity of books sold by each author:
Select b.author, sum(o.Quantity) as total_quantity
from books b 
join orders o on b.book_id = o.book_id
group by b.author
order by  sum(o.quantity) desc

-- 7) List the cities where customers who spent over $30 are located:
Select Distinct c.city, total_amount 
from orders o 
join customers c on o.customer_id=c.customer_id
where total_amount>30

-- 8) Find the customer who spent the most on orders:
Select c.customer_id, c.Name, Sum(o.Total_amount) as total_spent
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.Name
order by Sum(o.Total_amount) desc
limit 1

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;























