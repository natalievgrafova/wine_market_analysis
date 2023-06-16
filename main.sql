/*markdown
Part 1. 10 wines to increase sales. 
*/

/*markdown
For this question I assume that ratings_count reflects the popularity of a certain wine among customers. Let'see ... 
*/

SELECT wine_id, ratings_average, ratings_count,  price_euros
FROM vintages 
ORDER BY ratings_count DESC, price_euros DESC
LIMIT 10;


/*markdown
The ratings_count is the highest for the wines in the range between 72 and 460 EURO and the ratings_count is more than 10,000. 
*/

SELECT wine_id, ratings_average, ratings_count,  price_euros
FROM vintages 
ORDER BY  price_euros DESC
LIMIT 10;

/*markdown
The most expensive wines ratings_count is far less than 10,000. 
*/

SELECT MAX(ratings_count),  price_euros
FROM vintages 
WHERE price_euros > 450



/*markdown
460 EURO is the highest price for the most popular wines (more than 10,000 ratings). What we want to do is to find good wines (rated highest) up to this price that are not yet that popular (have less than 10,000 ratings_count)
*/

SELECT wines.id, wines.name, region_id, wines.ratings_average, wines.ratings_count, ROUND(AVG(price_euros)) AS average_price
FROM wines 
INNER JOIN vintages 
ON wines.id = vintages.wine_id
WHERE wines.ratings_count<10000 AND wines.ratings_count>1000
GROUP BY wine_id
HAVING vintages.price_euros < 460
ORDER BY wines.ratings_average DESC

LIMIT 10;

/*markdown
So we get a range of pretty expensive wines, but we should take into account that we get most expensive wines here in the dataset with the average price of around 620EUR and the minimum rating of 4.1. For other categories that can yield more income we should consider a different dataset that includes more wines within the most popular price-range. 
*/

SELECT AVG(price_euros)
FROM vintages 


SELECT MIN(ratings_average), id, name
FROM wines



SELECT ratings_average, name
FROM vintages
WHERE wine_id = 82970

/*markdown
Not quite sure what it means, wonder how the rating is calculated. Anyway, this set is all about good wines. 
*/

/*markdown
Part 2. Top-priority country for marketing campaigns. 
*/

/*markdown
I've updated the countries table with population column like: [UPDATE countries SET population = 2615000 WHERE code = 'md';], to see how many people there are in relation to the number of users. 
*/

SELECT name, (users_count*1000 /population)AS users_perthousandage, users_count,population, wines_count, wineries_count
FROM countries
ORDER BY  users_perthousandage ASC, wines_count DESC
LIMIT 5;

/*markdown
To be more precise, it's a good idea to compare economic situations in the countries of interest, for which I've used external data: https://www.worlddata.info/country-comparison.php?country1=ISR&country2=ZAF. Since we're considering wines that are not that cheap, I would recommend focusing on Israel, where the purchasing power is higher for a larger proportion of people. 
*/

/*markdown
P.S. I couldn't change the type of values hence 'perthousandage', sorry. 
*/

/*markdown
Part 3. Best winery prize. 
*/

/*markdown
To choose the best winery I've considered the average rating and ratings count because the highest rating is usually associated with much fewer ratings. Furthermore, there are really very popular wines with ratings  count of more than 100.000 and a pretty high score. So, I've used average the ratings count for the wineries and have identified two leaders -- Caymus and Tenuta San Guido. 
*/

SELECT winery_id, wineries.name AS winery_name,  AVG(ratings_average) AS avg_rating, AVG(ratings_count)  AS avg_ratings_count
FROM wines
INNER JOIN wineries
ON wineries.id = wines.winery_id
GROUP BY winery_name
HAVING avg_ratings_count>60000
ORDER BY   avg_rating DESC, avg_ratings_count DESC

LIMIT 10

SELECT MAX(ratings_count) AS highest_ratings_count, wines.name AS wine, wineries.name AS winery, ratings_average
FROM wines
INNER JOIN wineries
ON wineries.id = wines.winery_id

/*markdown
Part 4. Wines with  coffee, toast, green apple, cream, citrus combination.



*/

SELECT wine_id, keyword_id,name AS flavour, group_name AS flavour_group
FROM keywords_wine
LEFT JOIN keywords
ON keywords.id = keywords_wine.keyword_id
WHERE count>10 AND name IN ('coffee','toast','green apple', 'cream', 'citrus') AND keyword_type = 'primary'


GROUP BY flavour_group
LIMIT 10

CREATE TABLE wine_flavours_primary AS
SELECT wine_id, wines.name AS wine_name, keyword_id, keywords.name AS flavour, group_name AS flavour_group
FROM keywords_wine
LEFT JOIN keywords
ON keywords.id = keywords_wine.keyword_id
INNER JOIN wines
ON keywords_wine.wine_id =  wines.id 
WHERE count>10 AND keywords.name IN ('coffee',  'toast', 'green apple', 'cream','citrus') AND keyword_type = 'primary'


ORDER BY wine_name 



SELECT wine_id, wine_name, COUNT(DISTINCT flavour) AS flavours_count
FROM wine_flavours_primary
GROUP BY wine_id 
HAVING flavours_count>4

/*markdown
Part 5. Three most common grapes and five best-rated wines for each grape. 
*/

/*markdown
Most common grapes:
*/

SELECT grape_id, COUNT(country_code) AS country_count, wines_count, grapes.name AS grape_name
FROM most_used_grapes_per_country AS m
INNER JOIN grapes
ON grapes.id = m.grape_id
GROUP BY grape_id
ORDER BY country_count DESC
LIMIT 3;

/*markdown
Five best-rated Cabernet Sauvignon wines:
*/

SELECT  wine_id, name AS wine_name,ratings_average, ratings_count, price_euros
FROM vintages 
WHERE name LIKE '%Cabernet%'  AND name LIKE '%Sauvignon%'
ORDER BY ratings_average DESC, ratings_count DESC
LIMIT 5;

/*markdown
Five best-rated Merlot wines:
*/

SELECT  wine_id, name AS wine_name,ratings_average, ratings_count, price_euros
FROM vintages 
WHERE name LIKE '%Merlot%'
ORDER BY ratings_average DESC, ratings_count DESC
LIMIT 5;


/*markdown
Five best-rated Chardonnay wines
*/

SELECT  wine_id, name AS wine_name,ratings_average, ratings_count, price_euros
FROM vintages 
WHERE name LIKE '%Chardonnay%'
ORDER BY ratings_average DESC, ratings_count DESC
LIMIT 5;


/*markdown
Part 6. Countries leaderboard. 
*/

/*markdown
These countries' wines are ranked the highest. 
*/

SELECT c.name AS country_name, ROUND(AVG(ratings_average),4) AS countries_wine_ratings
FROM wines AS w
JOIN regions AS r 
ON r.id = w.region_id 
JOIN countries AS c 
ON r.country_code = c.code
GROUP BY c.name
ORDER BY countries_wine_ratings DESC
LIMIT 3;

/*markdown
Part 7. Wines recommendations.
*/

/*markdown
The suggestions are based on either the highest score for the most expensive and highly rated wines or ratings count with a persistent high rating.
*/

SELECT  wine_id, name,  ratings_average, price_euros,ratings_count
FROM vintages
WHERE name LIKE '%Cabernet%' AND name LIKE '%Sauvignon%' AND (ratings_count>1000 OR ratings_average>4.6)
ORDER BY ratings_average DESC
LIMIT 5;

/*markdown
Suggestions for me. 
*/

SELECT  wine_id, name,  ratings_average, price_euros
FROM vintages
WHERE name LIKE '%Pinot%'  AND name LIKE '%Noir%' AND price_euros <200
ORDER BY ratings_average DESC
LIMIT 5;