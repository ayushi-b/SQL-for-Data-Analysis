/*
In the accounts table, there is a column holding the website for each 
company. The last three digits specify what type of web address they 
are using. Pull these extensions and provide how many of each website 
type exist in the accounts table.
*/

SELECT RIGHT(website, 3),
	COUNT(*)
FROM accounts
GROUP BY 1;





/*
Use the accounts table to pull the first letter of each company name 
to see the distribution of company names that begin with each letter 
(or number). 
*/

SELECT LEFT(name, 1),
	COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;





/*
Use the accounts table and a CASE statement to create two groups: one 
group of company names that start with a number and a second group of 
those company names that start with a letter. What proportion of 
company names start with a letter?
*/

SELECT CASE WHEN LEFT(name, 1) IN ('0','1','2','3','4','5','6','7','8','9')
		    THEN 'number'
		    ELSE 'letter'
			END
		AS type,
		COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;





/*
Consider vowels as a, e, i, o, and u. What proportion of company names 
start with a vowel, and what percent start with anything else?
*/

SELECT CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
		    THEN 'vowel'
		    ELSE 'else'
			END
		AS type,
		COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;





/*
Use the accounts table to create first and last name columns that hold the 
first and last names for the primary_poc. 
*/

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) AS firstname,
	RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lastname
FROM accounts;





/*
Now see if you can do the same thing for every rep name in the sales_reps 
table. Again provide first and last name columns.
*/

SELECT LEFT(name, STRPOS(name, ' ')-1) AS firstname,
RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS lname
FROM sales_reps;





/*
Each company in the accounts table wants to create an email address for each 
primary_poc. The email address should be the first name of the primary_poc . 
last name primary_poc @ company name .com.
*/

SELECT primary_poc, name,
	LOWER(
		LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) || 
		'.' || 
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) || 
		'@' || 
		name || 
		'.com') 
	AS email
FROM accounts;







/*
You may have noticed that in the previous solution some of the company names 
include spaces, which will certainly not work in an email address. See if 
you can create an email address that will work by removing all of the spaces 
in the account name, but otherwise your solution should be just as in 
question above.
*/

SELECT primary_poc, name,
	LOWER(
		LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) || 
		'.' || 
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) || 
		'@' || 
		TRANSLATE(name, ' ', '') || 
		'.com') 
	AS email
FROM accounts;





/*
We would also like to create an initial password, which they will change after 
their first log in. The first password will be the first letter of the 
primary_poc's first name (lowercase), then the last letter of their first name 
(lowercase), the first letter of their last name (lowercase), the last letter of 
their last name (lowercase), the number of letters in their first name, the number 
of letters in their last name, and then the name of the company they are working 
with, all capitalized with no spaces.
*/

WITH sub AS (
  	SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) AS firstname,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lastname,
		id
	FROM accounts)
          
SELECT LEFT(LOWER(sub.firstname), 1) ||
       RIGHT(LOWER(sub.firstname), 1) ||
       LEFT(LOWER(sub.lastname), 1) ||
       RIGHT(LOWER(sub.lastname), 1) ||
       LENGTH(sub.firstname) ||
       LENGTH(sub.lastname) ||
       TRANSLATE(UPPER(a.name), ' ', '')
       AS pwd, 
       a.primary_poc,
	   a.name
FROM accounts a
JOIN sub
ON sub.id = a.id;


