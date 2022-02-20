
# Part 1

# 1) Update the Employees table, so it contains the HireDate values from 2017 till the current (2021) year.

UPDATE
    employees e
SET
    e.HireDate = ADDDATE(HireDate, INTERVAL 27 YEAR); 

#2) Delete records from the Products table which weren`t ordered

DELETE FROM products WHERE ProductID NOT IN (
        SELECT
            od.ProductID
        FROM
            `order details` od
    );

#3) Get the list of data about employees: First Name, Last Name, Title, Hire Date who was hired this year (2021). 

SELECT
    FirstName,
    LastName,
    Title,
    HireDate
FROM
    employees e
WHERE
    YEAR (HireDate) = 2021;

#4) Find quantity of employees in each department. Note: Departments is the same as a title in the Employees table

SELECT
    e2.TerritoryID,
    COUNT(e2.EmployeeID)
FROM
    employeeterritories e2
GROUP BY
    e2.TerritoryID;

#5) Get the list of suppliers, which are located in USA and have a specified region.
SELECT
    *
FROM
    suppliers
WHERE
    suppliers.Country = 'USA'
    AND suppliers.Region IS NOT NULL;

/*6) Get the amount of products that were delivered by each supplier (company), 
which have a discount from the Unit Price more than 10%. 
Where record are represented from the biggest to lowest discount. */

SELECT
    p.ProductID,
    count(*) 'amount_of_products',
    od.Discount
FROM
    `order details` od
INNER JOIN suppliers s
INNER JOIN products p 
ON
    od.ProductID = p.ProductID
    AND od.Discount > 0.1
    AND s.SupplierID = p.SupplierID
GROUP BY
    p.ProductID
ORDER BY
    od.Discount DESC ;

#7)Get the top five product categories with the list of the most buyable products in Germany.
SELECT
    products.CategoryID,
    products.ReorderLevel,
    orders.ShipCountry
FROM
    products 
INNER JOIN orders 
INNER JOIN `order details`  
ON
    products.ProductID = `order details`.ProductID
    AND orders.ShipCountry = 'Germany'
GROUP BY
    products.CategoryID
ORDER BY
    products.ReorderLevel DESC
LIMIT 5;

#8) Get the First Name, Last Name and Title of Managers and their subordinates.
SELECT
	managers.FirstName AS Manager_FirstName,
	 managers.LastName AS Manager_LastName,
	  managers.Title AS Manager_Title,
	   sub.FirstName AS sub_First_name,
	    sub.LastName as Sub_LastName, 
	    sub.Title AS Sub_Title 
FROM employees managers
JOIN employees sub
ON managers.EmployeeID = sub.ReportsTo
ORDER BY managers.EmployeeID

/*9)Get the Firts Name, Lastn Name, Title of Sales who has the least amount of orders. 
(Amount of sold products should be also in the result set).*/
SELECT
    e.FirstName,
    e.LastName,
    e.Title,
    COUNT(o.OrderID) 'amount_of_sales'
FROM
    orders o
INNER JOIN employees e 
ON
    o.EmployeeID = e.EmployeeID
GROUP BY
    e.EmployeeID
ORDER BY
    COUNT(o.OrderID)
LIMIT 1;

# Part 2

#1) Clone data from the Shippers table to the NewShippers table.

CREATE TABLE NewShippers SELECT * FROM shippers;

/*2) Get the list of suppliers which are related to each product name which has price greater than or equal 15$.
  ( Which information about supplier will be present in result set is optional) */

  SELECT suppliers.*, products.ProductName 
  FROM suppliers 
  JOIN products 
  ON suppliers.SupplierID = products.ProductID 
  WHERE products.UnitPrice >=15

/*3) Get the list of total quantities of ordered products which consists of: 
  total quantity ordered in Germany and the total quantity of products ordered in Sweden. */

  