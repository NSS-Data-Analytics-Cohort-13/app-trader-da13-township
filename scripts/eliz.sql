SELECT *
FROM app_store_apps
ORDER BY name;

SELECT *
FROM play_store_apps
ORDER BY name;

---Formula (self join) that Dibran shared. Here we are seeing the different copies of each app in the play store first, then the apple store. The next move will be to use the MAX and maybe the AVG of the apps to find the most recent and to find the average of the ratings. 
select * 
from play_store_apps
where name in (

select distinct a.name
from play_store_apps a
inner join play_store_apps b
	on a.name = b.name
where a.review_count != b.review_count

)
order by name, review_count desc

---Formula (self join) for apple store
select * 
from app_store_apps
where name in (

select distinct a.name
from app_store_apps a
inner join app_store_apps b
	on a.name = b.name
where a.review_count != b.review_count

)
order by name, review_count desc



--Using Union function to pull apps that are in both columns. Using case statement to structure store column to output apple store or play store in relation to rows pulled. 

SELECT name,
	   price,
	   review_count,
	   rating,
	   content_rating,
	   primary_genre AS genre,
	   CASE 
	   		WHEN 'app_store' IS NOT NULL THEN 'Apple Store'
			ELSE 'Play Store'
		END AS store
FROM app_store_apps

UNION 

SELECT  name,
	   price,
	   review_count,
	   rating,
	   content_rating,
	   genres AS genre,
	   CASE 
	   		WHEN 'play_store' IS NOT NULL THEN 'Play Store'
			ELSE 'Apple Store'
		END AS store
FROM play_store_apps
ORDER BY name;


---Using DISTINCT to find only 1 copy of each app in both stores, MAX, AVG, and ROUND functions to pull the most recent and combine the avgs of apps rating/review count to give good idea about which apps are most popular. Used AS to create aliases. Used inner join. Joined on name between both tables, made it so the price had to be 0, and review count had to be above a certain amount to see hightest reviews, also made it so rating was higher than 4. The union and inner join are redundant but review error message by select when its run without it. 

SELECT 
	DISTINCT app_store_apps.name AS name, --finding single copy of app of name in app store
	CAST(MAX(app_store_apps.price) AS MONEY) AS price, ---casting integer price as money
	ROUND(MAX(app_store_apps.review_count)) AS review_count,
	 MAX(ROUND(app_store_apps.rating *2.0)/ 2.0) AS rating,     -----round funnction for the rating to round to the highest .5
	CASE	
		WHEN app_store_apps.price = CAST(0 AS MONEY) THEN CAST (1000 AS MONEY)     ---better way to change integer to money but this also works
		END AS app_cost,
	CAST((ROUND(AVG(play_store_apps.rating)*2.0)/2.0)*2 +1 AS DECIMAL (5,2)) AS lifespan ----round rating again--dean did this formula still a little confused on it 
FROM app_store_apps
INNER JOIN play_store_apps
ON app_store_apps.name=play_store_apps.name
WHERE app_store_apps.price = CAST(0 AS MONEY) AND app_store_apps.rating  >=4 AND app_store_apps.review_count > 1000000 ---rating equal to or higher than 4, review count higher than 1 million
GROUP BY app_store_apps.name, app_store_apps.price, app_store_apps.rating
----repeat all for play store
UNION

SELECT
	DISTINCT play_store_apps.name AS name,
	CAST(MAX(play_store_apps.price) AS MONEY) AS price,
	ROUND(MAX(play_store_apps.review_count)) AS review_count,
	MAX(ROUND(play_store_apps.rating *2.0)/ 2.0) AS rating,
	CASE	
		WHEN play_store_apps.price = CAST(0 AS MONEY) THEN CAST (1000 AS MONEY)
		END AS app_cost,
	CAST((ROUND(AVG(play_store_apps.rating)*2.0)/2.0)*2 +1 AS DECIMAL (5,2)) AS lifespan
FROM play_store_apps
INNER JOIN app_store_apps
ON play_store_apps.name=app_store_apps.name
WHERE play_store_apps.price = CAST(0 AS MONEY) AND play_store_apps.rating  >= 4 AND play_store_apps.review_count > 1000000

GROUP BY play_store_apps.name, play_store_apps.price,play_store_apps.rating
ORDER BY review_count DESC ----desc for highest review
LIMIT 10; --top ten







