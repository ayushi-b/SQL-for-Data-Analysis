/*
1. Find the total amount of poster_qty paper ordered in the orders table.

2. Find the total amount of standard_qty paper ordered in the orders table.

3. Find the total dollar amount of sales using the total_amt_usd in the 
orders table.
*/

SELECT SUM(poster_qty)
FROM orders;


SELECT SUM(standard_qty)
FROM orders;


SELECT SUM(total_amt_usd)
FROM orders;





/*
1. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper 
for each order in the orders table. This should give a dollar amount for 
each order in the table.

2. Find the standard_amt_usd per unit of standard_qty paper. Your solution should 
use both an aggregation and a mathematical operator.
*/

SELECT standard_amt_usd + gloss_amt_usd total_amount
FROM orders;


SELECT SUM(standard_amt_usd)/SUM(standard_qty) per_unit
FROM orders;




/*
1. When was the earliest order ever placed? You only need to return the date.

2. Try performing the same query as the previous one without using an aggregation function.
*/

SELECT MIN(occurred_at) oldest_order
FROM orders;


SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;





/*
1. When did the most recent (latest) web_event occur?

2. Try to perform the result of the previous query without using an aggregation function.
*/

SELECT MAX(occurred_at) latest_event
FROM web_events;


SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;





/*
Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean 
amount of each paper type purchased per order. Your final answer should have 6 values - 
one for each paper type for the average number of sales, as well as the average amount.
*/

SELECT AVG(standard_qty) standard_qty,
	AVG(gloss_qty) gloss_qty,
    AVG(poster_qty) poster_qty,
    AVG(standard_amt_usd) standard_amt_usd,
    AVG(gloss_amt_usd) gloss_amt_usd,
    AVG(poster_amt_usd) poster_amt_usd
FROM orders;





/*
[Advanced] What is the MEDIAN total_usd spent on all orders?
*/

SELECT *
FROM (
	SELECT total_amt_usd
	FROM orders
	ORDER BY total_amt_usd
	LIMIT (
		SELECT count(total_amt_usd + 1)/2 cnt
		FROM orders
		)
	) data
ORDER BY total_amt_usd DESC
LIMIT 1;





/*
Which account (by name) placed the earliest order? Your solution 
should have the account name and the date of the order.
*/


SELECT o.occurred_at, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

# Alternative Solution 1
SELECT MIN(o.occurred_at) occurred_at, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY occurred_at
LIMIT 1;

# Alternative Solution 2
SELECT o.occurred_at, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at = (
		        SELECT MIN(occurred_at)
		        FROM orders
		      );





/*
Find the total sales in usd for each account. You should include 
two columns - the total sales for each company's orders in usd and 
the company name.
*/

SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;





/*
Via what channel did the most recent (latest) web_event occur, which 
account was associated with this web_event? Your query should return 
only three values - the date, channel, and account name.
*/

SELECT w.channel, w.occurred_at, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;





/*
Find the total number of times each type of channel from the 
web_events was used. Your final table should have two columns - 
the channel and the number of times the channel was used.
*/

SELECT channel, COUNT(channel)
FROM web_events
GROUP BY channel;





/*
Who was the primary contact associated with the earliest web_event? 
*/

SELECT  a.primary_poc, w.channel, w.occurred_at
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;





/*
What was the smallest order placed by each account in terms of total 
usd. Provide only two columns - the account name and the total usd. 
Order from smallest dollar amounts to largest.
*/

SELECT a.name, MIN(o.total_amt_usd) amount
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY amount;





/*
Find the number of sales reps in each region. Your final table should 
have two columns - the region and the number of sales_reps. Order from 
fewest reps to most reps.
*/

SELECT r.name, COUNT(s.id) sales_rep_count
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY sales_rep_count;





/*
For each account, determine the average amount of each type of paper they 
purchased across their orders. Your result should have four columns - one 
for the account name and one for the average quantity purchased for each of 
the paper types for each account.
*/

SELECT a.name,
	AVG(o.standard_qty) standard,
    AVG(o.poster_qty) poster,
    AVG(o.gloss_qty) gloss
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;





/*
For each account, determine the average amount spent per order on each paper 
type. Your result should have four columns - one for the account name and one 
for the average amount spent on each paper type.
*/

SELECT a.name,
	AVG(o.standard_amt_usd) standard,
    AVG(o.poster_amt_usd) poster,
    AVG(o.gloss_amt_usd) gloss
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;





/*
Determine the number of times a particular channel was used in the web_events 
table for each sales rep. Your final table should have three columns - the 
name of the sales rep, the channel, and the number of occurrences. Order your 
table with the highest number of occurrences first.
*/

SELECT s.name,
	COUNT(w.channel) occurences,
    w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY occurences DESC;





/*
Determine the number of times a particular channel was used in the web_events 
table for each region. Your final table should have three columns - the region 
name, the channel, and the number of occurrences. Order your table with the 
highest number of occurrences first.
*/

SELECT r.name,
	COUNT(w.channel) occurences,
    w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY occurences DESC;





/*
Use DISTINCT to test if there are any accounts associated with more than one 
region.
*/

SELECT DISTINCT a.name, s.region_id
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
ORDER BY a.name;





/*
Have any sales reps worked on more than one account?
*/

SELECT DISTINCT a.sales_rep_id, a.name
FROM accounts a
ORDER BY a.sales_rep_id;

# Alternative Solution
SELECT sales_rep_id, COUNT(id) AS num_accounts
FROM accounts
GROUP BY sales_rep_id
ORDER BY num_accounts;

# Solution with sales_rep name
SELECT s.name, a.sales_rep_id, COUNT(a.id) num_accounts
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, a.sales_rep_id
ORDER BY num_accounts;





/*
How many of the sales reps have more than 5 accounts 
that they manage?
*/

SELECT s.name, COUNT(a.id) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.id) > 5
ORDER BY num_accounts;





/*
1. How many accounts have more than 20 orders?

2. Which account has the most orders?
*/

SELECT a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;


SELECT a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY num_orders DESC
LIMIT 1;





/*
1. How many accounts spent more than 30,000 usd total 
across all orders?

2. How many accounts spent less than 1,000 usd total 
across all orders?
*/

SELECT a.name, 
	SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_amt_usd;


SELECT a.name, 
	SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_amt_usd;





/*
1. Which account has spent the most with us?

2. Which account has spent the least with us?
*/

SELECT a.name, 
	SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_amt_usd DESC
LIMIT 1;


SELECT a.name, 
	SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_amt_usd
LIMIT 1;





/*
1. Which accounts used facebook as a channel to 
contact customers more than 6 times?

2. Which account used facebook most as a channel? 
*/

SELECT a.name,
	w.channel,
    COUNT(w.channel) channel_count
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY channel_count;


SELECT a.name,
	w.channel,
    COUNT(w.channel) channel_count
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
ORDER BY channel_count DESC
LIMIT 1;





/*
Which channel was most frequently used by most 
accounts?
*/

SELECT a.name, 
	w.channel,
    COUNT(a.id) account_count
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.name, w.channel
ORDER BY account_count DESC
LIMIT 1;





/*
Find the sales in terms of total dollars for all 
orders in each year, ordered from greatest to 
least. Do you notice any trends in the yearly 
sales totals?
*/

SELECT DATE_TRUNC('year', occurred_at), 
	SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 1;  

# Alternative Solution
SELECT DATE_PART('year', occurred_at), 
	SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 1;





/*
Which month did Parch & Posey have the greatest sales
in terms of total dollars? Are all months evenly 
represented by the dataset?
*/

SELECT DATE_PART('month', occurred_at), 
	SUM(total_amt_usd), COUNT(*)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;





/*
Which year did Parch & Posey have the greatest sales in 
terms of total number of orders? Are all years evenly 
represented by the dataset?
*/

SELECT DATE_PART('year', occurred_at), 
	COUNT(*)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;





/*
Which month did Parch & Posey have the greatest sales in 
terms of total number of orders? Are all months evenly 
represented by the dataset?
*/

SELECT DATE_PART('month', occurred_at), 
	COUNT(*)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;





/*
In which month of which year did Walmart spend the most on 
gloss paper in terms of dollars?
*/

SELECT a.name, DATE_TRUNC('month', o.occurred_at), 
	SUM(o. gloss_amt_usd)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 2, 1
ORDER BY 3 DESC
LIMIT 1;





/*
We would like to understand 3 different levels of customers 
based on the amount associated with their purchases. The 
top branch includes anyone with a Lifetime Value (total 
sales of all orders) greater than 200,000 usd. The second 
branch is between 200,000 and 100,000 usd. The lowest 
branch is anyone under 100,000 usd. Provide a table that 
includes the level associated with each account. You should 
provide the account name, the total sales of all orders for 
the customer, and the level. Order with the top spending 
customers listed first.
*/

SELECT a.name,
	SUM(total_amt_usd) total_spent,
	CASE 
		WHEN SUM(total_amt_usd) > 200000 
			THEN 'top'
    	WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 
    		THEN 'middle'
    	ELSE 'lowest' END 
	AS level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;





/*
We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only 
in 2016 and 2017. Keep the same levels as in the previous 
question. Order with the top spending customers listed first.
*/

SELECT a.name, 
	SUM(total_amt_usd) total_spent,
	CASE 
		WHEN SUM(total_amt_usd) > 200000 
		THEN 'top'
    	WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 
    	THEN 'middle'
    	ELSE 'lowest' 
	END AS level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE DATE_PART('year', o.occurred_at) = 2016
	OR DATE_PART('year', o.occurred_at) = 2017
GROUP BY 1
ORDER BY 2 DESC;

# Alternate Solution
SELECT a.name, SUM(total_amt_usd) total_spent,
	CASE 
		WHEN SUM(total_amt_usd) > 200000 
		THEN 'top'
    	WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 
    	THEN 'middle'
    	ELSE 'lowest' 
	END AS level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY 1
ORDER BY 2 DESC;





/*
We would like to identify top performing sales reps, which are 
sales reps associated with more than 200 orders. Create a table 
with the sales rep name, the total number of orders, and a 
column with top or not depending on if they have more than 200 
orders. Place the top sales people first in your final table.
*/

SELECT s.name, 
	COUNT(o.id) total_orders,
	CASE 
		WHEN COUNT(o.id) > 200 
		THEN 'top'
    	ELSE 'not' 
	END AS top_or_not
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;





/*
The previous one didn't account for the middle, nor the dollar amount 
associated with the sales. Management decides they want to see 
these characteristics represented as well. We would like to identify 
top performing sales reps, which are sales reps associated with more 
than 200 orders or more than 750000 in total sales. The middle group 
has any rep with more than 150 orders or 500000 in sales. Create a 
table with the sales rep name, the total number of orders, total 
sales across all orders, and a column with top, middle, or low 
depending on this criteria. Place the top sales people based on 
dollar amount of sales first in your final table. You might see a 
few upset sales people by this criteria!
*/

SELECT s.name, 
	COUNT(o.id) total_orders,
    SUM(o.total_amt_usd) sales_value,
	CASE 
    	WHEN COUNT(o.id) > 200 
        	OR SUM(o.total_amt_usd) > 750000 
        THEN 'top'
    	WHEN COUNT(o.id) BETWEEN 150 AND 200 
        	OR SUM(o.total_amt_usd) BETWEEN 500000 AND 750000 
        THEN 'middle'
    	ELSE 'low' 
	END AS top_or_not
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3 DESC;
