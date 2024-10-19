--Fixing Charlie's code to see the top 10 so we can compare with my top 10 and group's top 10
--seems like more than half of the apps are matching so we're good as team!!!

SELECT DISTINCT *
FROM app_store_apps

SELECT DISTINCT *
FROM play_store_apps

--Alter datatypes of certain columns
ALTER TABLE play_store_apps
ALTER COLUMN price TYPE money USING (price::money)

ALTER TABLE app_store_apps
ALTER COLUMN price TYPE money USING (price::money)

ALTER TABLE app_store_apps
ALTER COLUMN review_count TYPE integer USING (review_count::integer)
---------------

--Union All the two tables.  Use DISTINCT on both statements to only get duplicates produced by the UNION ALL.  Set this result as its own table with CREATE TABLE.
-- CREATE TABLE stores_union_all
-- AS
SELECT DISTINCT ON (name) name,
	   price,
	   review_count,
	   rating,
	   content_rating,
	   primary_genre,
	   'App Store' AS store
FROM app_store_apps

UNION ALL

SELECT DISTINCT ON (name) name,
	   price,
	   review_count,
	   rating,
	   content_rating,
	   genres,
	   'Play Store' AS store
FROM play_store_apps
ORDER BY name;
-------------------

--This query returns the names of apps that are in both stores
SELECT name
FROM stores_union_all
GROUP BY name
HAVING COUNT(*)>1;
---------

--Also can check this with Intersect
SELECT DISTINCT name
FROM app_store_apps

INTERSECT

SELECT DISTINCT name

FROM play_store_apps
ORDER BY name
-------------

--Use the either of the above queries as a subquery in the WHERE statement below.  This produces a consolidated list of common apps across both stores, with max price (between the tow stores), review sum, and average rating (rounded to the nearest 0.5).  Content rating and genre are removed here to get GROUP BY to work.  Make this as its own table with CREATE TABLE

CREATE TABLE common_app
AS
SELECT name,
	   MAX(price) AS max_price,
	   SUM(review_count) AS sum_reviews,
	   ROUND(AVG(rating)*2,0)/2 AS avg_rating
FROM stores_union_all
WHERE name IN (SELECT DISTINCT name
FROM app_store_apps

INTERSECT

SELECT DISTINCT name

FROM play_store_apps
ORDER BY name)
GROUP BY name
ORDER BY name
--------

--price has to be set to numeric to get the final calculations to work.
ALTER TABLE common_app
ALTER COLUMN max_price TYPE numeric USING (max_price::numeric)


--Final top 10 list.  This is a list of common apps with the lowest purchase prices with the highest ratings and review counts.  These would yield the highest potential return on investment based on the info in the README doc.
SELECT name,
	   max_price,
	   sum_reviews,
	   avg_rating,
	   CASE WHEN max_price>=0.00 AND max_price<=1.00 THEN 10000.00
	   		ELSE max_price*10000.00
			END AS purchase_price,
	   9000.00 AS earnings_per_month
FROM common_app
ORDER BY purchase_price, avg_rating DESC, sum_reviews DESC
LIMIT 10;
----------------

--With content rating and genre
SELECT c.name,
	   c.max_price,
	   c.sum_reviews,
	   c.avg_rating,
	   CASE WHEN max_price>=0.00 AND max_price<=1.00 THEN 10000.00
	   		ELSE max_price*10000.00
			END AS purchase_price,
	   9000.00 AS earnings_per_month,
	   u.primary_genre,
	   u.content_rating
FROM common_app AS c
LEFT JOIN stores_union_all AS u
USING (name)
ORDER BY purchase_price, avg_rating DESC, sum_reviews DESC;

SELECT * FROM stores_union_all;


