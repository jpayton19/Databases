/* John Payton SQLite3 Homework
	Dr.Ball
	Database Systems */

/*Question a*/

SELECT pizzeria
FROM Person, Frequents
WHERE age < 18;
/*This question gets you a list of all the pizzerias that are frequented by people under the age of 18*/

/*Question b*/

SELECT name
FROM Person natural join Eats
WHERE gender= ‘female’ and (pizza= ‘mushroom’ or pizza = 'pepperoni’);
/*This question gets you a list of all the females who eat mushroom or pepperoni pizza*/

/*Question c*/

SELECT name
FROM Person natural join Eats
WHERE gender = ‘female’ and pizza = ‘mushroom’
INTERSECT
SELECT name
FROM Person natural join Eats
WHERE gender = ‘female’ and pizza = ‘pepperoni’;
/*This question gets you a list of all the females who have eaten mushroom pizza but not pepperoni, and pepperoni but not mushroom*/

/*Question d*/

SELECT pizzeria
FROM Eats, Serves
WHERE name = ‘Amy’ and price < 10;
/*This question gets you all the places Amy has visited that charged her under $10*/

/*Question e*/

SELECT*FROM
(SELECT pizzeria
FROM Person, Frequents
WHERE gender = ‘female’
EXCEPT
SELECT pizzeria
FROM Person, Frequents
WHERE gender = ‘male’)
UNION
SELECT*FROM
(SELECT pizzeria
FROM Person, Frequents
WHERE gender = ‘male’
EXCEPT
SELECT pizzeria
FROM Person, Frequents
WHERE gender = ‘female’);
/*This question gets you pizzerias that only the females frequent and the pizzerias that only the men frequent*/

/*Question f*/

SELECT *
FROM Eats
EXCEPT
SELECT name, pizza
FROM Frequents, Serves;
/*This question gets you the pizzas that people eat that are not served at the places they frequent*/

/*Question g*/

SELECT name
FROM Person
EXCEPT
SELECT name
FROM 
(SELECT *
 FROM Frequents
EXCEPT
SELECT name, pizzeria
FROM Eats, Serves);
/*This question gets you the people who only eat from pizzerias that serve the pizzas they eat*/

/*Question h*/

SELECT name
FROM Person
EXCEPT
SELECT name
FROM
(SELECT name, pizzeria
FROM Eats, Serves
EXCEPT
SELECT *
FROM Frequents);
/*This question gets you people who only eat pizzas at the places they don't frequent*/

/*Question 9*/

SELECT Avg(age)
FROM Person;
/*The Average age of the people in the table should be 24.55556*/

/*Question 10*/

SELECT count(name)
FROM Eats
GROUP BY name;
/*2
  2
  1
  5
  2
  1
  3
  2
  2*/