USE marketing_analysis;
GO

SELECT TOP 1 *
FROM marketing_data_clean;

-- Question 1:
-- What is the average spending by child status?

SELECT 
    Child,
    COUNT(*) AS customers,
    ROUND(AVG(CAST(total_spent AS FLOAT)), 2) AS avg_total_spent,
    ROUND(AVG(CAST(MntWines AS FLOAT)), 2) AS avg_wines,
    ROUND(AVG(CAST(MntFruits AS FLOAT)), 2) AS avg_fruits,
    ROUND(AVG(CAST(MntMeatProducts AS FLOAT)), 2) AS avg_meat,
    ROUND(AVG(CAST(MntFishProducts AS FLOAT)), 2) AS avg_fish,
    ROUND(AVG(CAST(MntSweetProducts AS FLOAT)), 2) AS avg_sweets,
    ROUND(AVG(CAST(MntGoldProds AS FLOAT)), 2) AS avg_gold
FROM marketing_data_clean
GROUP BY Child
ORDER BY avg_total_spent DESC;

-- Question 2:
-- How does purchase channel usage change by child status?

SELECT 
    Child,
    COUNT(*) AS customers,
    ROUND(AVG(CAST(total_purchased AS FLOAT)), 2) AS total_purchases,
    ROUND(AVG(CAST(NumWebPurchases AS FLOAT)), 2) AS web_purchases,
    ROUND(AVG(CAST(NumCatalogPurchases AS FLOAT)), 2) AS catalog_purchases,
    ROUND(AVG(CAST(NumStorePurchases AS FLOAT)), 2) AS store_purchases,
    ROUND(AVG(CAST(NumDealsPurchases AS FLOAT)), 2) AS deals_purchases
FROM marketing_data_clean
GROUP BY child
ORDER BY total_purchases DESC;

-- Question 3:
-- How does purchase channel usage change by age group?

;WITH customer_age_groups AS (
    SELECT *,
        CASE
            WHEN Age BETWEEN 18 AND 50 THEN 'Young (18-50)'
            WHEN Age BETWEEN 51 AND 64 THEN 'Senior (51-64)'
            ELSE 'Elder (65+)'
        END AS Age_group
    FROM marketing_data_clean
)

SELECT 
    Age_group,
    COUNT(*) AS customers,
    ROUND(AVG(CAST(total_purchased AS FLOAT)), 2) AS avg_total_purchases,
    ROUND(AVG(CAST(NumWebPurchases AS FLOAT)), 2) AS avg_web_purchases,
    ROUND(AVG(CAST(NumCatalogPurchases AS FLOAT)), 2) AS avg_catalog_purchases,
    ROUND(AVG(CAST(NumStorePurchases AS FLOAT)), 2) AS avg_store_purchases,
    ROUND(AVG(CAST(NumDealsPurchases AS FLOAT)), 2) AS avg_deals_purchases
FROM customer_age_groups
GROUP BY Age_group
ORDER BY avg_total_purchases DESC;

-- Question 4:
-- Which customer segment has the highest average spending?

;WITH customers_age_group AS(
    SELECT *,
        CASE 
            WHEN Age BETWEEN 18 AND 50 THEN 'Young (18-50)'
            WHEN Age BETWEEN 51 AND 64 THEN 'Senior (51-64)'
            ELSE 'Elder (65+)'
        END AS age_group
    FROM marketing_data_clean)
SELECT age_group, Child,
    COUNT (*) as customers,
    ROUND(AVG(CAST(total_spent AS FLOAT)), 2) AS avg_total_spent,
    ROUND(AVG(CAST(MntWines AS FLOAT)), 2) AS avg_wines,
    ROUND(AVG(CAST(MntFruits AS FLOAT)), 2) AS avg_fruits,
    ROUND(AVG(CAST(MntMeatProducts AS FLOAT)), 2) AS avg_meat,
    ROUND(AVG(CAST(MntFishProducts AS FLOAT)), 2) AS avg_fish,
    ROUND(AVG(CAST(MntSweetProducts AS FLOAT)), 2) AS avg_sweets,
    ROUND(AVG(CAST(MntGoldProds AS FLOAT)), 2) AS avg_gold
FROM customers_age_group
GROUP BY age_group, Child
ORDER BY avg_total_spent DESC;

-- Question 5:
-- What is the campaign acceptance distribution?

SELECT 
    Accepted_campaign,
    COUNT(*) AS customers,
    CAST(ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM marketing_data_clean),
        2) AS DECIMAL (5,2)) AS percentage
FROM marketing_data_clean
GROUP BY Accepted_campaign
ORDER BY customers DESC;

-- Question 6:
-- Which customer segments have the highest campaign acceptance rate?

;WITH customers_age_group AS(
    SELECT *,
        CASE 
            WHEN Age BETWEEN 18 AND 50 THEN 'Young (18-50)'
            WHEN Age BETWEEN 51 AND 64 THEN 'Senior (51-64)'
            ELSE 'Elder (65+)'
        END AS age_group
    FROM marketing_data_clean)
SELECT Child, age_group,
    COUNT (*) AS customers,
    SUM(CASE WHEN Accepted_campaign <> 'no campaign' THEN 1 ELSE 0 END) AS accepted_customers,
    CAST(ROUND(SUM(CASE WHEN Accepted_campaign <> 'no campaign' THEN 1 ELSE 0 END)*100.0/ COUNT (*),2) AS DECIMAL (5,2)) AS acceptance_rate,
    ROUND(AVG(CAST(total_spent AS FLOAT)),2) AS avg_total_spent
FROM customers_age_group
GROUP BY child, age_group
ORDER BY acceptance_rate DESC;

-- Question 7:
-- How does product spending change by age group?
;WITH customers_age_group AS(
    SELECT *,
        CASE 
            WHEN Age BETWEEN 18 AND 50 THEN 'Young (18-50)'
            WHEN Age BETWEEN 51 AND 64 THEN 'Senior (51-64)'
            ELSE 'Elder (65+)'
        END AS age_group
    FROM marketing_data_clean)
SELECT age_group,
    COUNT (*) as customers,
    ROUND(AVG(CAST(total_spent AS FLOAT)), 2) AS avg_total_spent,
    ROUND(AVG(CAST(MntWines AS FLOAT)), 2) AS avg_wines,
    ROUND(AVG(CAST(MntFruits AS FLOAT)), 2) AS avg_fruits,
    ROUND(AVG(CAST(MntMeatProducts AS FLOAT)), 2) AS avg_meat,
    ROUND(AVG(CAST(MntFishProducts AS FLOAT)), 2) AS avg_fish,
    ROUND(AVG(CAST(MntSweetProducts AS FLOAT)), 2) AS avg_sweets,
    ROUND(AVG(CAST(MntGoldProds AS FLOAT)), 2) AS avg_gold
FROM customers_age_group
GROUP BY age_group
ORDER BY avg_total_spent DESC;

-- Question 8:
-- Do customers who complain spend less?

SELECT Complain,
    COUNT(*) as customers,
    ROUND(AVG(CAST(total_spent AS FLOAT)),2) AS avg_total_spent,
    ROUND(AVG(CAST(total_purchased AS FLOAT)),2) AS avg_total_purchased,
    ROUND(AVG(CAST(Recency AS FLOAT)),2) AS avg_recency
FROM marketing_data_clean
GROUP BY Complain
ORDER BY avg_total_spent DESC;