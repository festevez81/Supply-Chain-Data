
-- Step 1: Create a new column named 'Revenue' in the table 'supply_chain_data'.

ALTER TABLE [dbo].[supply_chain_data]
ADD Revenue NUMERIC;

ALTER TABLE [dbo].[supply_chain_data]
ALTER COLUMN Revenue DECIMAL(38,2);

 --Step 2: Populate the 'Revenue' column with the result of multiplying 'Revenue_generated' by 10.

UPDATE [dbo].[supply_chain_data]
SET Revenue = Revenue_generated * 10;

SELECT *
FROM [dbo].[supply_chain_data]


--Revenue:
--1.	Which products generate the highest revenue overall?

SELECT SKU, SUM(Revenue) AS HIGHEST_REV 
FROM [dbo].[supply_chain_data]
GROUP BY SKU
ORDER BY HIGHEST_REV DESC;

--2.	What percentage of total revenue does each product type contribute?

SELECT Product_type, 
    	SUM(Revenue) AS Total_Revenue,
(SUM(Revenue) * 100.0 / (SELECT SUM(Revenue) FROM supply_chain_data)) AS Percentage_Of_Total_Revenue
FROM supply_chain_data
GROUP BY Product_type;


--Shipping Costs:
--1.	What percentage of total revenue is spent on shipping costs?


SELECT SUM(Shipping_costs) * 100 / SUM(Revenue) AS Percentage_spent_on_shipping
FROM [dbo].[supply_chain_data]

--2.	Which products have the highest shipping costs?

SELECT SKU,
		MAX(Shipping_costs) AS Highest_Shipping_Cost
FROM [dbo].[supply_chain_data]
		GROUP BY SKU
		ORDER BY Highest_Shipping_Cost DESC;


--3.	Are shipping costs proportional to product prices or revenue?

--You can calculate and analyze the ratio between shipping costs and product prices or revenue for each product.


SELECT SKU,
    		AVG(price) AS Average_Price,
  		AVG(Shipping_Costs) AS Average_Shipping_Cost,
(AVG(Shipping_Costs) / AVG(price)) AS Shipping_Cost_To_Price_Ratio
FROM supply_chain_data
GROUP BY SKU
ORDER BY Shipping_Cost_To_Price_Ratio DESC;


--4.	Which products have reduced profitability due to high shipping costs?


SELECT	SKU,
    		SUM(Revenue) AS Total_Revenue,
    		SUM(Manufacturing_Costs) AS Total_Manufacturing_Costs,
    		SUM(Shipping_Costs) AS Total_Shipping_Costs,
(SUM(Revenue) - SUM(Manufacturing_Costs) - SUM(Shipping_Costs)) AS Profit,
(SUM(Shipping_Costs) * 100.0 / SUM(Revenue)) AS Shipping_Cost_Percentage
FROM supply_chain_data
GROUP BY SKU
ORDER BY Profit ASC;  -- Sorting by Profit to see products with lower profitability

--Manufacturing Costs:

--1.	What percentage of total revenue is attributed to manufacturing costs?

SELECT (SUM(Manufacturing_costs) / SUM(Revenue)) * 100 AS Manufacturing_cost_percent
FROM supply_chain_data

--2.	Which products have the highest profit margins (Revenue - Manufacturing Cost)?

SELECT 
    SKU AS Product, Revenue, manufacturing_costs, 
    (Revenue - manufacturing_costs) AS Profit_Margin
FROM [dbo].[supply_chain_data]
ORDER BY Profit_Margin DESC;

--3.	Are there any products where manufacturing costs significantly outweigh revenue?

SELECT SKU AS Product, Revenue, manufacturing_costs, 
    manufacturing_costs - Revenue AS Cost_Exceeding_Revenue
FROM [dbo].[supply_chain_data]
WHERE manufacturing_costs > Revenue
ORDER BY Cost_Exceeding_Revenue DESC;

--Profit Margins:
--1.	What is the profit margin for each product? Formula: (Revenue - Shipping Costs - Manufacturing Costs)

SELECT SKU AS Product, Revenue, shipping_costs, manufacturing_costs, 
    (Revenue - shipping_costs - manufacturing_costs) AS Profit_Margin
FROM [dbo].[supply_chain_data]
ORDER BY Profit_Margin DESC;

--2.	Which products have the best and worst profitability margins? 

--TOP 5 BEST 

SELECT TOP 5 SKU AS Product, Revenue, shipping_costs, manufacturing_costs, 
    (Revenue - shipping_costs - manufacturing_costs) AS Profit_Margin
FROM [dbo].[supply_chain_data]
ORDER BY Profit_Margin DESC;

--TOP 5 WORST

SELECT TOP 5 SKU AS Product, Revenue, shipping_costs, manufacturing_costs, 
    (Revenue - shipping_costs - manufacturing_costs) AS Profit_Margin
FROM [dbo].[supply_chain_data]
ORDER BY Profit_Margin ASC;

--3.	What share of total costs comes from shipping versus manufacturing?

SELECT 
    (SUM(shipping_costs) / (SUM(shipping_costs) + SUM(manufacturing_costs)) * 100) AS Shipping_Cost_Percentage,
    (SUM(manufacturing_costs) / (SUM(shipping_costs) + SUM(manufacturing_costs)) * 100) AS Manufacturing_Cost_Percentage
FROM [dbo].[supply_chain_data]

--Comparative Analysis:

--1.	Which products are most cost-efficient (low costs, high profitability)?

SELECT SKU AS Product, Revenue, 
    (manufacturing_costs + shipping_costs) AS Total_Costs, 
    (Revenue - manufacturing_costs - shipping_costs) AS Profit_Margin,
    (Revenue - manufacturing_costs - shipping_costs) / (manufacturing_costs + shipping_costs) AS Efficiency_Ratio
FROM [dbo].[supply_chain_data]
WHERE (manufacturing_costs + shipping_costs) > 0 -- Exclude rows with zero or invalid costs
ORDER BY Efficiency_Ratio DESC; -- Sort by highest efficiency



