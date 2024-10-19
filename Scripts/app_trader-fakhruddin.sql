SELECT * FROM app_store_apps
WHERE name = 'Temple Run 2';
SELECT * FROM play_store_apps
WHERE name = 'Temple Run 2';

--INTIAL toughts to work on assumptions part a

(
	SELECT	name
		,	rating   --,AS TEST
		,	'apple' AS flag
		,	(COALESCE(NULLIF(price * 1 , 0), 1)) * 10000 ::Money AS purchase_price
	FROM	app_store_apps
)
UNION
(
	SELECT	name
		,	rating
		,	'android'AS flag
		,	(COALESCE(NULLIF(CAST(REPLACE(price, '$','') AS NUMERIC) * 1 , 0), 1)) * 10000 ::Money AS purchase_price
	FROM	play_store_apps)
ORDER BY NAME ASC;


--building further more on the assumtions to add more columns 
--Creating Table as assumtions to review it further
--CREATE TABLE assumptions AS
SELECT DISTINCT ON (name) name
	,	(COALESCE(NULLIF(CAST(REPLACE(price, '$','') AS NUMERIC) * 1 , 0), 1)) * 10000 ::Money AS purchase_price
	,	genres
	,	content_rating
	,	rating
	,	CAST(review_count AS NUMERIC) AS reviews
	,	CAST(REPLACE(price, '$', '') AS NUMERIC) AS price
	--,	'android' AS store
FROM play_store_apps
UNION ALL
SELECT DISTINCT ON (name) name
	,	(COALESCE(NULLIF(price * 1 , 0), 1)) * 10000 ::Money AS purchase_price
	,	primary_genre
	,	content_rating
	,	rating
	,	CAST(review_count AS NUMERIC) AS reviews
	,	price
	--,	'apple' AS store
FROM app_store_apps
ORDER BY name;

SELECT name
FROM assumptions
GROUP BY name
HAVING COUNT(*)>1
ORDER BY name asc
limit 20;


-- testing......
--CREATE TABLE stores AS 
SELECT	DISTINCT ON (name) name
	,	MAX(PRICE) as price
	,	COUNT(name)*5000 AS profit_per_month
	,	COUNT(DISTINCT name)*1000 AS cost_per_month
	,	CAST((ROUND(AVG(rating)*2.0)/2.0)*2 +1 AS DECIMAL(5,2)) AS expected_life
	,	CASE WHEN COUNT(name) > 1 THEN 'Y' ELSE 'N' END AS available_in_both_stores
	,	MAX(genre) AS genre
FROM
(
SELECT	DISTINCT ON (name) name
	,	MAX(CASE WHEN price = '0.00' THEN 10000 else CEILING(price)*10000 END) AS Price
	,	AVG(rating) AS rating
	,	MAX(primary_genre) AS genre
FROM app_store_apps
GROUP BY name
UNION ALL
SELECT	DISTINCT ON (name) name
	,	MAX(CASE WHEN CAST(REPLACE(price, '$', '')AS NUMERIC) = 0 THEN 10000 
			ELSE CEILING(CAST(REPLACE(price, '$','')AS NUMERIC))*10000 END) AS price
	,	AVG(rating)
	,	MAX(genres)
FROM play_store_apps
GROUP BY name)
GROUP BY name;


SELECT *
FROM stores
WHERE available_in_both_stores = 'Y';



SELECT name,
	   price,
	   expected_life
FROM stores
WHERE available_in_both_stores = 'Y'
ORDER BY price, expected_life DESC
LIMIT 20;


