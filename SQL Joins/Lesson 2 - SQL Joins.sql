/*
1. Try pulling all the data from the accounts table, and all the data from the 
orders table.

2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, 
and the website and the primary_poc from the accounts table.
*/

SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


SELECT orders.standard_qty, 
    orders.gloss_qty, 
    orders.poster_qty, 
    accounts.website,
    accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;





/*
1. Provide a table for all web_events associated with account name of Walmart. 
There should be three columns. Be sure to include the primary_poc, time of the 
event, and the channel for each event. Additionally, you might choose to add a 
fourth column to assure only Walmart events were chosen. 

2. Provide a table that provides the region for each sales_rep along with their 
associated accounts. Your final table should include three columns: the region name, 
the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) 
according to account name. 

3. Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. Your final table 
should have 3 columns: region name, account name, and unit price. 

*/

SELECT web_events.channel,
    web_events.occurred_at,
    accounts.primary_poc,
    accounts.name
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
WHERE accounts.name ='Walmart';


SELECT sales_reps.name AS sales_rep_name,
    accounts.name account_name,
    region.name region_name
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name;


SELECT orders.total_amt_usd/(orders.total+1e-10) AS unit_price,
    accounts.name account_name,
    region.name region_name
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON sales_reps.id = accounts.sales_rep_id
JOIN region
ON region.id = sales_reps.region_id;





/*
Provide a table that provides the region for each sales_rep along with their associated 
accounts. This time only for the Midwest region. Your final table should include three 
columns: the region name, the sales rep name, and the account name. Sort the accounts 
alphabetically (A-Z) according to account name.
*/

SELECT a.name acoount_name, 
    s.name sales_rep_name, 
    r.name region_name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE r.name = 'Midwest'
ORDER BY a.name ;





/*
Provide a table that provides the region for each sales_rep along with their associated 
accounts. This time only for accounts where the sales rep has a first name starting with 
S and in the Midwest region. Your final table should include three columns: the region 
name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) 
according to account name. 
*/

SELECT a.name acoount_name, 
    s.name sales_rep_name, 
    r.name region_name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE s.name LIKE 'S%' AND r.name = 'Midwest'
ORDER BY a.name ;





/*
Provide a table that provides the region for each sales_rep along with their associated 
accounts. This time only for accounts where the sales rep has a last name starting with 
K and in the Midwest region. Your final table should include three columns: the region 
name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) 
according to account name.
*/

SELECT a.name acoount_name, 
    s.name sales_rep_name, 
    r.name region_name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE s.name LIKE '% K%' AND r.name = 'Midwest'
ORDER BY a.name ;





/*
Provide the name for each region for every order, as well as the account name and the 
unit price they paid (total_amt_usd/total) for the order. However, you should only 
provide the results if the standard order quantity exceeds 100. Your final table should 
have 3 columns: region name, account name, and unit price. In order to avoid a division 
by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/

SELECT a.name acoount_name, 
    o.total_amt_usd/(o.total + 1e-10) unit_price, 
    r.name region_name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 ;





/*
Provide the name for each region for every order, as well as the account name and the 
unit price they paid (total_amt_usd/total) for the order. However, you should only 
provide the results if the standard order quantity exceeds 100 and the poster order 
quantity exceeds 50. Your final table should have 3 columns: region name, account name, 
and unit price. Sort for the smallest unit price first. In order to avoid a division by 
zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). 
*/

SELECT a.name acoount_name, 
    o.total_amt_usd/(o.total + 1e-10) unit_price, 
    r.name region_name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price;





/*
Provide the name for each region for every order, as well as the account name and the 
unit price they paid (total_amt_usd/total) for the order. However, you should only 
provide the results if the standard order quantity exceeds 100 and the poster order 
quantity exceeds 50. Your final table should have 3 columns: region name, account name, 
and unit price. Sort for the largest unit price first. In order to avoid a division by 
zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/

SELECT a.name acoount_name, 
    o.total_amt_usd/(o.total + 1e-10) unit_price, 
    r.name region_name
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC;





/*
What are the different channels used by account id 1001? Your final table should have 
only 2 columns: account name and the different channels. You can try SELECT DISTINCT 
to narrow down the results to only the unique values.
*/

SELECT DISTINCT w.channel,
    a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.id = 1001 ;





/*
What are the different channels used by account id 1001? Your final table should have 
only 2 columns: account name and the different channels. You can try SELECT DISTINCT 
to narrow down the results to only the unique values.
*/

SELECT o.occurred_at,
    a.name,
    o.total,
    o.total_amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01' ;


