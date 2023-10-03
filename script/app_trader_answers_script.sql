SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

---Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.


WITH app_stats AS (SELECT name, 
p.rating, 
s.rating, 
ROUND(ROUND(((p.rating + s.rating)/2)*4)/4,2) AS avg_rating,
(p.review_count + s.review_count::INT)/2 AS avg_review_count,
MAX(p.price) AS app_store_price, 
MAX(s.price),
p.genres,
s.primary_genre AS app_genre,
(s.price+25000)::money AS app_sale_cost
FROM play_store_apps AS p INNER JOIN app_store_apps AS s USING(name)
WHERE s.price = 0 
GROUP BY name, 
p.rating,
s.rating, 
s.price,
p.genres,
s.primary_genre,
p.review_count,
s.review_count
ORDER BY avg_rating DESC)


SELECT  name, 
app_genre,
app_store_price,
avg_rating,
avg_review_count,
app_sale_cost, 
(avg_rating * 2)+1 AS longevity_in_yrs,
((avg_rating * 2 + 1) *12 *1000)::money AS maintenance_cost, 
((avg_rating * 2 + 1) *12 *5000)::money AS app_revenue,
((avg_rating * 2 + 1) *12 *5000)::money - (((avg_rating * 2 + 1) *12 *1000)+25000)::money AS profit
FROM app_stats
WHERE avg_review_Count >=228522
ORDER BY avg_rating DESC
LIMIT 10;




--Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are 
---thematically appropriate for the upcoming Halloween themed campaign.


WITH Halloween_apps AS (SELECT DISTINCT name, 
ROUND((p.rating+ s.rating)/2,1) AS avg_rating,
s.price AS price,
(s.price+25000)::money AS cost_to_buy_app
FROM play_store_apps AS p INNER JOIN app_store_apps AS s USING(name)
WHERE name ILIKE '%zombie%'
ORDER BY avg_rating DESC)


SELECT name,
avg_rating,
price,
(avg_rating * 2)+1 AS longevity_in_yrs,
((avg_rating * 2 + 1) *12 *1000)::money AS maintenance_cost, 
((avg_rating * 2 + 1) *12 *5000)::money AS app_revenue,
((avg_rating * 2 + 1) *12 *5000)::money - (((avg_rating * 2 + 1) *12 *1000)+25000)::money AS profit
FROM Halloween_apps



