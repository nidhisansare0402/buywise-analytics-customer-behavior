SELECT * FROM customer LIMIT 20;

--1. Which customer segment generates the most revenue?
--It identifies most valuable customers
SELECT customer_type, SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY customer_type
ORDER BY total_revenue DESC;
--[Loyal customers contribute the highest revenue, indicating strong retention value and opportunity for premium targeting]

--2. Do high-value customers belong to a specific age group?
--Helps target marketing campaigns
SELECT age_group, COUNT(*) AS high_value_count
FROM customer
WHERE high_value = 'TRUE'
GROUP BY age_group
ORDER BY high_value_count DESC;
--[Young customers form the largest segment of high-value purchases, but other age groups also contribute significantly, indicating a balanced distribution across demographics.]

--3. Do discounts actually increase spending?
--Helps decide discount strategy
SELECT discount_applied, ROUND(AVG(purchase_amount),2) AS avg_spend
FROM customer
GROUP BY discount_applied;
--[Customers using discounts show slightly lower average spending, suggesting that discounts may not significantly increase purchase value and should be used strategically]

--4. Which product categories drive repeat customers?
--Identifies loyalty-driving products
SELECT category, ROUND(AVG(previous_purchases),2) AS avg_repeat
FROM customer
GROUP BY category
ORDER BY avg_repeat DESC;
--[Accessories category shows highest repeat purchases, indicating strong customer retention]

--5. Are loyal customers also high spenders?
--Combines loyalty + revenue
SELECT customer_type, ROUND(AVG(purchase_amount),2) AS avg_spend
FROM customer 
GROUP BY customer_type
ORDER BY avg_spend DESC;
--[Regular customers have slightly higher average spending per transaction, while loyal customers contribute more overall revenue due to higher purchase frequency]

--6. Which payment method is preferred by high-value customers?
--Helps optimize payment experience
SELECT payment_method, COUNT(*) AS high_value_count
FROM customer
WHERE high_value = 'TRUE'
GROUP BY payment_method
ORDER BY high_value_count DESC;
--[Credit card is the most preferred payment method among high-value customers, suggesting the importance of seamless digital payment options]

--7. Which age group contributes most to revenue?
--Identifies core customer base
SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
--[Revenue contribution is fairly evenly distributed across age groups, with young customers slightly leading, indicating a broad target audience]

--8. Do subscribed customers generate more revenue?
--Helps evaluate subscription programs
SELECT subscription_status, 
ROUND(SUM(purchase_amount),2) AS total_spend,
ROUND(AVG(purchase_amount),2) AS avg_spend
FROM customer
GROUP BY subscription_status;
--[Non-subscribed customers generate higher total revenue, suggesting that the subscription model may not be effectively driving higher spending and may require reevaluation]

--9. What percentage of total revenue does each category contribute?
SELECT category,
       SUM(purchase_amount) AS revenue,
       ROUND(100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 2) AS percentage
FROM customer
GROUP BY category
ORDER BY percentage DESC;
--[Clothing dominates revenue with nearly 45% contribution, making it the primary revenue driver. Accessories also contribute significantly, while footwear and outerwear have relatively lower impact]

--10. Discount usage by customer type
SELECT customer_type,
       COUNT(CASE WHEN discount_applied = 'Yes' THEN 1 END) AS discount_users,
       COUNT(*) AS total_customers
FROM customer
GROUP BY customer_type;
--[Loyal customers use discounts the most in absolute numbers due to their higher presence. However, discount dependency appears consistent across segments, suggesting discounts are not uniquely driving loyalty]

--11, Which age group and category combination generates the highest revenue?
SELECT age_group, category, SUM(purchase_amount) AS revenue
FROM customer
GROUP BY age_group, category
ORDER BY revenue DESC;
--[Clothing is the top-performing category across all age groups, with young customers contributing the highest revenue. This indicates that Clothing has universal demand, especially among younger demographics]

--12. Which are the top 3 most popular products within each category?
--Top-performing products in each category
SELECT category, item_purchased, purchase_count
FROM (
    SELECT category,
           item_purchased,
           COUNT(*) AS purchase_count,
           RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rank
    FROM customer
    GROUP BY category, item_purchased
) sub
WHERE rank <= 3;
--[Certain products consistently dominate within each category, such as Blouse and Pants in Clothing and Jewelry in Accessories, indicating stable customer preferences and high-demand items]