--Top rated category Education: 42, Lifestyle: 29, Medical: 28, Entertainment: 19, Business: 18
(SELECT genres, COUNT(rating) AS cnt
FROM play_store_apps
WHERE rating = 5
GROUP BY genres
--ORDER BY cnt DESC)

UNION

--Top rated category Games: 277, Photo & Video: 30, Entertainment: 26, Education: 24, Health & Fitness: 24
(SELECT primary_genre, COUNT(rating) AS cnt
FROM app_store_apps
WHERE rating = 5
GROUP BY primary_genre
--ORDER BY cnt DESC)

ORDER BY cnt DESC
-------------------------------------
(SELECT genres
FROM play_store_apps
WHERE rating = 5
GROUP BY genres)

INTERSECT

(SELECT primary_genre
FROM app_store_apps
WHERE rating = 5
GROUP BY primary_genre)
--

(SELECT name, genres, price
FROM play_store_apps
WHERE price BETWEEN '0' AND '1'
AND review_count > 500
AND install_count >'500,000'
AND rating > 4.5
--AND content_rating ILIKE 'Everyone'
--AND genres ILIKE 'Games'
)

UNION

(SELECT name, primary_genre, price
FROM app_store_apps
WHERE price BETWEEN '0' AND '1'
AND review_count > '500'
AND rating > 4.5)

--
(SELECT name, price::money, genres
FROM play_store_apps
WHERE price <= '1'
AND review_count >= 500
AND rating >= 4)

INTERSECT

(SELECT name, price::money, primary_genre
FROM app_store_apps
WHERE price <= 1
AND review_count >= '500'
AND rating >= 4)



SELECT *
--FROM app_store_apps
FROM play_store_apps