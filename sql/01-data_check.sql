USE marketing_analysis;
GO

-- Count total rows
SELECT 
    COUNT(*) AS total_rows
FROM marketing_data_clean;


-- Preview first 10 rows
SELECT TOP 10 *
FROM marketing_data_clean;


-- Check minimum, maximum and average age
SELECT 
    MIN(Age) AS min_age, 
    MAX(Age) AS max_age, 
    ROUND(AVG(CAST(Age AS FLOAT)), 2) AS avg_age
FROM marketing_data_clean;


-- Count customers by complaint status
SELECT 
    Complain, 
    COUNT(*) AS customers
FROM marketing_data_clean
GROUP BY Complain
ORDER BY Complain;


-- Count customers by child status
SELECT 
    Child,
    COUNT(*) AS customers
FROM marketing_data_clean
GROUP BY Child
ORDER BY customers DESC;


-- Count customers by accepted campaign
SELECT 
    Accepted_campaign,
    COUNT(*) AS customers
FROM marketing_data_clean
GROUP BY Accepted_campaign
ORDER BY customers DESC;
