

CREATE TABLE airbnb (
    id INT,
    name VARCHAR(255),
    host_id DECIMAL(10,2),
    host_name VARCHAR(255),
    neighbourhood_group VARCHAR(255),
    neighbourhood VARCHAR(255),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    room_type VARCHAR(255),
    price DECIMAL(10,2),
    minimum_nights INT,
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month DECIMAL(10,2),
    calculated_host_listings_count INT,
    availability_365 INT
);
Select * from airbnb;

SELECT room_type, AVG(price) AS average_price
FROM airbnb
GROUP BY room_type;

-----------------------------------------------------------------------------
#Calculate the average price of listings in each neighborhood:
SELECT neighbourhood, AVG(price) AS average_price
FROM airbnb
GROUP BY neighbourhood;

----------------------------------------------------------------------------------------------------------------
#Find the neighborhood with the highest average price:
SELECT neighbourhood, AVG(price) AS average_price
FROM airbnb
GROUP BY neighbourhood
ORDER BY average_price DESC
LIMIT 1;
---------------------------------------------------------------------------------------------------------
#Determine the most common room types:
SELECT room_type, COUNT(*) AS count
FROM airbnb
GROUP BY room_type
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------
#Calculate the average number of reviews per month:
SELECT AVG(reviews_per_month) AS average_reviews_per_month
FROM airbnb;

-------------------------------------------------------------------------------------------------------------------
#Identify the hosts with the highest number of listings:

SELECT host_id, host_name, COUNT(*) AS listing_count
FROM airbnb
GROUP BY host_id, host_name
ORDER BY listing_count DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------
#Determine the availability of listings throughout the year:
SELECT availability_365, COUNT(*) AS count
FROM airbnb
GROUP BY availability_365
ORDER BY availability_365;

------------------------------------------------------------------------------------------------------
#Find the neighborhoods with the highest number of listings:
SELECT neighbourhood, COUNT(*) AS listing_count
FROM airbnb
GROUP BY neighbourhood
ORDER BY listing_count DESC;

-----------------------------------------------------------------------------------------------------------
#Calculate the average minimum number of nights for each room type:
SELECT room_type, AVG(minimum_nights) AS average_minimum_nights
FROM airbnb
GROUP BY room_type;

---------------------------------------------------------------------------------------------------------
#Identify the listings with no reviews
SELECT *
FROM airbnb
WHERE number_of_reviews = 0;

---------------------------------------------------------------------------------------------------------
#Determine the percentage of listings belonging to each host:
SELECT host_id, host_name, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM airbnb) AS percentage
FROM airbnb
GROUP BY host_id, host_name
ORDER BY percentage DESC;

---------------------------------------------------------------------------------------------------------
#Find the hosts who have listings in multiple neighborhoods:
SELECT host_id, host_name, COUNT(DISTINCT neighbourhood) AS distinct_neighbourhoods
FROM airbnb
GROUP BY host_id, host_name
HAVING COUNT(DISTINCT neighbourhood) > 1;

---------------------------------------------------------------------------------------------------------
#Calculate the average price for each room type within a specific neighborhood:
SELECT neighbourhood, room_type, AVG(price) AS average_price
FROM airbnb
GROUP BY neighbourhood, room_type;

------------------------------------------------------------------------------------------------------
#Find the hosts with the most recent reviews:
SELECT host_id, host_name, MAX(last_review) AS most_recent_review
FROM airbnb
GROUP BY host_id, host_name
ORDER BY most_recent_review DESC;

------------------------------------------------------------------------------------------------------
#Determine the top 5 neighborhoods with the highest average price per night:
SELECT neighbourhood, AVG(price / minimum_nights) AS average_price_per_night
FROM airbnb
GROUP BY neighbourhood
ORDER BY average_price_per_night DESC
LIMIT 5;

------------------------------------------------------------------------------------------------------
#Calculate the average availability (in days) for each neighborhood:
SELECT neighbourhood, AVG(availability_365) AS average_availability
FROM airbnb
GROUP BY neighbourhood;

------------------------------------------------------------------------------------------------------------
#Determine the percentage of listings belonging to each room type:
SELECT room_type, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM airbnb) AS percentage
FROM airbnb
GROUP BY room_type
ORDER BY percentage DESC;

----------------------------------------------------------------------------------------------------------
#Identify the hosts with the highest average price per night:
SELECT host_id, host_name, AVG(price / minimum_nights) AS average_price_per_night
FROM airbnb
GROUP BY host_id, host_name
ORDER BY average_price_per_night DESC;
