SELECT *
FROM app_store_apps
ORDER BY name;

SELECT *
FROM play_store_apps
ORDER BY name;

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

---Dibran formula, double checking to see if there are copies (there are) and seeing how drastically different the apps are. recommended to then do avg for rating and review count and MAX function to find the most recent app created
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


---Using MAX, AVG, and ROUND functions to pull the most recent and combine the avgs of apps rating/review count to give good idea about which apps are most popular. Used AS to create aliases. Used inner join and removed CASE because not needed here. Joined on name between both tables, made it so the price had to be 0, and review count had to be above a certain amount to see hightest reviews, also made it so rating was higher than 4. The union and inner join are redundant but review error message by select when its run without it. 

SELECT 
	app_store_apps.name AS name,
	(MAX(app_store_apps.price)::MONEY) AS price,
	ROUND(AVG(app_store_apps.review_count)) AS review_count,
	ROUND(AVG(app_store_apps.rating)) AS rating,
	app_store_apps.price + '10000' AS purchase_price,
	app_store_apps.price + '9000' AS monthly_profit,
	app_store_apps.price + '98000' AS yearly_profit,
	(ROUND(app_store_apps.rating)) * 2.25 AS lifespan
FROM app_store_apps
INNER JOIN play_store_apps
ON app_store_apps.name=play_store_apps.name
WHERE app_store_apps.price = '0' AND app_store_apps.rating  >=4 AND app_store_apps.review_count > 1000000
GROUP BY app_store_apps.name, app_store_apps.price, app_store_apps.rating
UNION
SELECT
	play_store_apps.name AS name,
	(MAX(play_store_apps.price)::MONEY) AS price,
	ROUND(AVG(play_store_apps.review_count)) AS review_count,
	ROUND(AVG(play_store_apps.rating)) AS rating,
	play_store_apps.price + '10000' AS purchase_price,
	play_store_apps.price + '9000' AS monthly_profit,
	play_store_apps.price + '98000' AS yearly_profit,
	(ROUND(play_store_apps.rating)) * 2.25 AS lifespan
FROM play_store_apps
INNER JOIN app_store_apps
ON play_store_apps.name=app_store_apps.name
WHERE play_store_apps.price = '0' AND play_store_apps.rating  >= 4 AND play_store_apps.review_count > 1000000
GROUP BY play_store_apps.name, play_store_apps.price,play_store_apps.rating
ORDER BY review_count DESC
LIMIT 10;




