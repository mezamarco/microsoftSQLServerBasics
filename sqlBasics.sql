-- Microsoft SQL Server Basics
	
 -- Create your own database

	CREATE DATABASE CustomerDB;

 -- (Make sure that you select the correct SQL database
 -- By default, we are currently working with the master database)


  
 -- Create Table

	CREATE TABLE Customer(
		firstName VARCHAR(50),
		lastName VARCHAR(50),
		age INT
	);

	
 -- Insert data into a Table

	INSERT INTO Customer(firstName, lastName, age) 
	VALUES ( 'Bob', 'Meza', 20)
			('Marco', 'Meza', 27);
	
			

	
  -- Select (WHERE,WHERE NOT, AND, OR, ORDER BY)

	SELECT * 
	FROM Customer;

	SELECT  firstName, age
	FROM Customer
	WHERE firstName = ‘Marco’;

	SELECT * 
	FROM Customer
	WHERE firstName = ‘Charlie’ 
	OR age = 20;

	SELECT * 
	FROM Customer
	WHERE NOT age = 20;
	
	
	-- ORDER BY: by default it is in ascending order. 
	SELECT * 
	FROM Customer
	ORDER BY age;
	

	
	 -- limit the data that we retrieve: SELECT TOP # fields FROM tableName 
	SELECT TOP 4 * from Customer;

	 -- Offset(Skipping a number of row) the data that we want to retrieve:
	SELECT UserTable
	ORDER BY id
	OFFSET 2 ROWS:

	SELECT *
	FROM UserTable
	ORDER BY zip DESC;
	
	

	 -- LIKE: Searching for a certain keyword, use the wildcard character: % (TRY THIS)

	SELECT * 
	FROM Customer
	WHERE lastName LIKE ‘%za%’;



 	-- UPDATE:  Updating the data of a table

	-- This will update the entire table.

	UPDATE Customer
	SET age = 100

	-- We need to be more specific

	UPDATE Customer
	SET age = 99
	WHERE firstName = ‘Marco’ 
	AND lastname = ‘Meza’;




 	-- DELETE: Deleting all the data in the given table

	DELETE Customer;

	-- You can be more specific
	DELETE Customer
	WHERE age <= 21;


	
	
	 -- DROP: Delete the table
	DROP TABLE Customer; 






 	-- ALTER TABLE: ADD, we are adding a new column to the given table

	-- By default this new column will have all NULL entries
	ALTER TABLE Customer
	ADD city VARCHAR(20);

	 -- PRIMARY KEY ( For auto_incerement  use: identity(start#, incrementBy#) )

	CREATE TABLE Customer(
		id INT PRIMARY KEY INDENTITY(1,1)
		firstName VARCHAR(50),
		lastName VARCHAR(50),
		age INT,
		city VARCHAR(50)
	);


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	-- Lets create a UserTable
	create table UserTable(
		id INT PRIMARY KEY IDENTITY(1,1),
		username varchar(30) not null,
		email varchar(30),
		phone varchar(30),
		zip INT
	);
	
	INSERT INTO UserTable(username, email, phone, zip) 
	VALUES	('Bob', 'bob@yahoo.com', '61934444', 3234),
			('Charlie', 'charlie@yahoo.com', '619555511', 92154),
			('Daniel', 'daniel@yahoo.com', '619321234', 92444),
			('Marco', 'marco@yahoo.com', '6196547', 92154),
			('soccerBoy', 'soccerBoy@yahoo.com', '6197657', 676),
			('Turtle', 'turtle@yahoo.com', '619765', 222),
			('Frog', 'frog@yahoo.com', '6196664444', 444),
			('Monkey', 'monkey@yahoo.com', '61966666', 555),
			('Linden', 'linden@yahoo.com', '6193343', 6543),
			('John', 'john@yahoo.com', '619654', 34),
			('Ninja', 'ninjab@yahoo.com', '61939999', 23432);
	
	
	
	
	 -- We need a Products table and an Orders table 

	CREATE TABLE Products(
		id INT PRIMARY KEY IDENTITY(1,1),
		productName VARCHAR(50),
		price FLOAT
	);


	INSERT INTO Products(productName, price)
	VALUES ('Baseball', 5.95), 
		   ('Bat', 195.99);



	CREATE TABLE Orders(
		orderID INT PRIMARY KEY IDENTITY(1,1),
		orderDate DATETIME,
		userID INT,
		productID int
	);

	
	
	
	 -- Take a look at all the tables before inserting the order data
	 -- We will use this data to do JOIN statements
	SELECT * FROM Orders;
	Select * FROM UserTable;
	Select * FROM Products;


	-- Make the connections usign the following
	-- Charlie bought a Bat
	-- Daniel bought a Bat
	-- Marco bought a Baseball
	-- Marco bought a Bat
	-- Marco boguht a Bat
	INSERT INTO Orders(orderDate, userID, productID)
	VALUES (GETDATE(), 2,2),
		   (GETDATE(), 3,2),
		   (GETDATE(), 4,1);
	
	

	-- Inner join example 
	-- Display the data where equal values in the two tables.
	-- (Note that we use the primary key and the foreign key to join the tables)
	SELECT * 
	FROM Orders
	INNER JOIN Products 
	ON Orders.productID = Products.id;

	
	-- Alias: We can use an alias to simplify the query
	SELECT * 
	FROM Orders AS o
	INNER JOIN Products AS p
	ON o.productID = p.id; 
	
	-- The keyword AS, is optional
	SELECT * 
	FROM Orders o
	INNER JOIN Products p
	ON o.productID = p.id;
	
	-- We can actually select all the fields of a table usign a wildcard character
	
	SELECT o.*, p.*
	FROM Orders o
	INNER JOIN Products p
	ON o.productID = p.id;
	
	
	-- Inner join multiple tables
	SELECT * 
	FROM Orders
	INNER JOIN Products
	ON Orders.productID = Products.id 
	INNER JOIN UserTable
	ON Orders.userID = UserTable.id;

	
	
	-- Get specific data from each each table
	SELECT Orders.orderID, Orders.orderDate, Products.productName, 
			Products.price, UserTable. username
	FROM Orders
	INNER JOIN Products
	ON Orders.productID = Products.id 
	INNER JOIN UserTable
	ON Orders.userID = UserTable.id;
	
	
	
	
	
	-- Total money that was spent (Give the field the name: Total)
	SELECT SUM(Products.price) AS Total
	FROM Orders
	INNER JOIN Products
	ON Orders.productID = Products.id 
	INNER JOIN UserTable
	ON Orders.userID = UserTable.id;
	
	
	-- GROUP BY: For every selected field, we must also group by this field
	-- Total money that was a spent (BY EACH PERSON)
	
	SELECT UserTable.id,UserTable.username, SUM(Products.price) AS Total
	FROM Orders
	INNER JOIN Products
	ON Orders.productID = Products.id 
	INNER JOIN UserTable
	ON Orders.userID = UserTable.id
	GROUP BY UserTable.id, UserTable.username;
	
	/*
		-- The total amount of money that was spent(BY EACH PERSON)
		
		2	Charlie	195.99
		3	Daniel	195.99
		4	Marco	397.93
	*/
	

	
	-- GROUP BY: For every selected field, we must also group by this field
	-- Total money that was a spent (BY EACH PERSON AND BY EACH PRODUCT)

	SELECT UserTable.id,UserTable.username, Products.productName, SUM(Products.price) AS Total
	FROM Orders
	INNER JOIN Products
	ON Orders.productID = Products.id 
	INNER JOIN UserTable
	ON Orders.userID = UserTable.id
	GROUP BY UserTable.id, UserTable.username, Products.productName;

	/*
		-- The total amount of money, according to the product 
	
		4	Marco		Baseball	5.95
		2	Charlie		Bat			195.99
		3	Daniel		Bat			195.99
		4	Marco		Bat			391.98
	*/


	-- The more you group by, the more specific result that we get
	
	
	
	-- GROUP BY: For every selected field, we must also group by this field
	-- Total money that was a spent in a given zip code also the average in a given zip code.  
	SELECT UserTable.zip, SUM(Products.price) AS Total, AVG(Products.price) AS Average
	FROM Orders
	INNER JOIN Products
	ON Orders.productID = Products.id 
	INNER JOIN UserTable
	ON Orders.userID = UserTable.id
	GROUP BY UserTable.zip;

	/*
			Note: 4 puchases were from 92154
				  Therefore  Total/4  equals the average price 
				
				  1 purchase were from 92444
				  Therefore  Total/1  equals the average price 

				  
			zip		Total	Average
			92154	593.92	148.48
			92444	195.99	195.99
	*/
