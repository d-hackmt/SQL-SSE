#
#                                         LETS EXPLORE SUB-QUERIES
#---------------------------------------------------------------------------------------------------

#lets say i want to select the movie with highest imdb_rating

# one way to do that is

SELECT * from movies order by imdb_rating DESC LIMIT 1;

# the other way to do that is 

SELECT max(imdb_rating) as maxz from movies;

# we have another way

SELECT * from movies where imdb_rating in (9.3);  

                         #or

SELECT * from movies where imdb_rating =9.3;

# lets see this new way 

SELECT * from movies where imdb_Rating  = (SELECT max(imdb_rating) from movies);

# you guys might say , we can do this , but this doesnt work , you will get wrong way of grouping error

SELECT * from movies where imdb_Rating  = max(imdb_rating);

#---------------------------------------------------------------------------------------------------
#
#                              1) so we saw subquery returns a value 
#
#---------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------
#
#                              2)  subquery returns a list of values as well 
#
#---------------------------------------------------------------------------------------------------


# lets say i want min and max imdb_rating

SELECT max(imdb_rating) from movies;
SELECT min(imdb_rating) from movies;

## so one way to do this is 

SELECT * from movies where imdb_Rating in ( 1.9 , 9.3);  # it works

## but i dont know what that it so how to find out 

# lets say  
SELECT * 
FROM movies 
WHERE imdb_rating IN (
    (SELECT MIN(imdb_rating) FROM movies),
    (SELECT MAX(imdb_rating) FROM movies)
);



# similarly  Select all the movies with minimum and maximum release_year. 
SELECt * from movies 
where release_year in
(
(SELECT MIN(release_year) FROM movies),
(SELECT MAX(release_year) FROM movies)
) ;


#---------------------------------------------------------------------------------------------------
#
#                        2) so now we saw subquery returns a list of values as well 
#                AND 
#                        3) Subquery returns a table as well , lets see how
#---------------------------------------------------------------------------------------------------

## lets say my manager tells me , 
# select all the actors whose age > 70 and < 85
# lets get that age

select * from actors;

# so we will have to get the current age first 
# i dont remember , what to do ??????     -------> GOOGLE folks GOOGLE


SELECT 
name , YEAR(curdate())-birth_year as age
from actors;

# now lets apply condition , but where clause  wont work ,because it doesnt work with aggregates

SELECT 
name , YEAR(curdate())-birth_year as age
from actors where age > 70 and  age <85 ;

# but having will work right

SELECT 
name , YEAR(curdate())-birth_year as age
from actors having age > 70 and  age <85 ;

## coool we get it now , lets see how subquery returns a table

# so the query which we wrote returns a table , lets use this table to retrive without using HAVING clause

SELECT * from
(SELECT 
name , YEAR(curdate())-birth_year as age
from actors) as actors_age_table 
where age  > 70 and age < 85;

# and thats how we do it 

#---------------------------------------------------------------------------------------------------|
#                                                                                                   |
#	                                        so now we saw                                           |
#                                                                                                   |
#                        1) Subquery returns a value                                                |
#                                                                                                   |
#                        2) Subquery returns a list of values                                       |
#                                                                                                   |
#                        3) Subquery returns a table                                                |
#---------------------------------------------------------------------------------------------------|

#---------------------------------------------------------------------------------------------------|
#
#									LETS Study , ANY & ALL operators .
#
#---------------------------------------------------------------------------------------------------|


# lets say you want to select all the actors who want to select all actors 
# who has worked in any of the movies (101,110,121)


# one way to do it is using join 


SELECt a.name from actors a 
JOIN movie_actor ma using (actor_id)
where movie_id in (101 ,110,121);

# it works yea but  lets see what another way 

select actor_id from movie_actor where movie_id in (101,110,121);

# so how to get names? stuck ??

# lets use subquery now

SELECT name from actors 
where actor_id IN 
(select actor_id from movie_actor 
where movie_id in (101,110,121));

# this was better , we have another way we can use ANY 
# meaning select ANY movie from this subquery , lets seee

SELECT name from actors 
WHERE actor_id = ANY (
SELECT actor_id from movie_actor 
where movie_id in (101,110,121)
);

## if you dont specify ANy and just say  actor_id = (subquery) 
#you will get an error because = sign is used to get a single value 
# and any is giving us a list of values

# so you either use ANY or IN

# lets see this new query

# select all the movies whose rating is greater than any of the marvel movies 

# so how do you get all marvel_movie rating?

SELECT imdb_rating from movies 
where studio = "marvel studios" ;

# now lets use ANY 

SELECT * from movies 
where imdb_rating > ANY (
SELECT imdb_rating from movies 
where studio = "marvel studios"
);

# do we have another way to write it ? , if we dont want to use ANY , yes we do 

SELECT * from movies 
where imdb_rating > 
(SELECT min(imdb_rating) 
from movies where studio like "%marvel%"
);

# so we see we get the same thing 

# so instead of ANY we can write SOME as well here , and it will work the same

SELECT * from movies 
where imdb_rating > SOME (
SELECT imdb_rating from movies 
where studio = "marvel studios"
);

# now i want to get all the movies whose rating is more than ALL marvel movies 

# lets see whats the max imdb_rating
SELECT max(imdb_rating) 
from movies where studio like "%marvel%";

# so we have to check if this query gives us more than 8.4 

SELECT * from movies
where imdb_rating > ALL(
SELECT imdb_rating from movies 
where studio like "%marvel%"
);

# we still have another way to write it , and see we get the same thing

SELECT * from movies
where imdb_rating > (
SELECT max(imdb_rating) from movies 
where studio like "%marvel%"
);


#---------------------------------------------------------------------------------------------------|



#---------------------------------------------------------------------------------------------------|
#
#					LETS Study , Co - related subquery , Performance analysis
#
#---------------------------------------------------------------------------------------------------|


# lets say you want 
# actor_id , name , movie_cnt  -> meaning how many movie the respecitive actors have acted in 

# so we can do it simply by

SELECT actor_id , count(movie_id) as movie_cnt
from movie_actor
group by actor_id 
order by movie_cnt DESC;

# but here name is missing ?

# okay sure we can  get that with simple JOIN

SELECT name , count(movie_id) as movie_cnt
FROM actors a
JOIN movie_actor ma
USING (actor_id) 
GROUP BY actor_id
ORDER BY movie_cnt DESC;

# see we got it 


# lets see if we have another way of doing that

select * from movie_actor;

# okay lets fetch the count for one id

SELECT count(*) from movie_actor where actor_id = 51; 

# ok so now we get the count of this id 51 actor is 2 ,
# this is only for 1 , i want  a for loop sort of thing 

# lets write our subquery

SELECT actor_id , name ,
(SELECT count(*) from movie_actor 
where actor_id = actors.actor_id) as movie_cnt
from actors
order by movie_cnt DESC;

## okay fine , so we got it , this is called co-related subquery  .
# because we refered actors table in our subquery which is a outer table , so  CO-related sub_query 
# because its execution depend on outer table 


# you will go row by row in your outer table 

# lets say you pick the first_id = 50 , for that you will get a count from movie_actor table

# now which one is better group by or this ??

# well depends what suits you and whos performance is faster 

# if we write explain analyze before a query we will get a log of the execution

EXPLAIN ANALYZE
SELECT actor_id , name ,
(SELECT count(*) from movie_actor 
where actor_id = actors.actor_id) as movie_cnt
from actors
order by movie_cnt DESC;

#  (actual time=0.435..0.439 rows=67 loops=1)


# this means it tool 0.435secs for one row and 
# 0.439secs for all rows

# lets check for group by query  

EXPLAIN ANALYZE
SELECT name , count(movie_id) as movie_cnt
FROM actors a
JOIN movie_actor ma
USING (actor_id) 
GROUP BY movie_id
ORDER BY movie_cnt DESC;


# (actual time=0.379..0.381 rows=39 loops=1)

-- see this took less time , compared to our subquery , so we will go with this 



#---------------------------------------------------------------------------------------------------|
#
#					         LETS Study an exotic topic ,
#		                                    Common table expressions (CTE)
#				       		
#---------------------------------------------------------------------------------------------------|

# remember subqueries also return a table and we did this query where 

# select all the actors whose age > 70 and < 85

SELECT * 
from (SELECt name , 
YEAR(curdate()) - birth_year as age 
from actors) as actors_age
where age > 70 and age < 80;

# here we made a temporary  table and in outer query
# used age as critria to retrive something

# imagine we have some table instead of this inner query 


SELECT * from (sometable) 
where age > 75 and age < 80;


# so lets write that , using CTE

with actors_age as (SELECt name , 
YEAR(curdate()) - birth_year as age 
from actors)

SELECT * from actors_age
where age > 75 and age < 85;


# look at the beauty of this query its looks so 
# simple and readible compared to subquery

# lets go to mysql doc and see this CTE

##  https://dev.mysql.com/doc/refman/8.4/en/with.html

# okay we can see we have multiple CTE's as welll

# okay we can have different col name as well , 
# so inner columns name can be different and we can have new names as well

with actors_age (a_name , a_age) as (SELECt name as x , 
YEAR(curdate()) - birth_year as y 
from actors)

SELECT * from actors_age
where a_age > 75 and a_age < 85;

## niceee---------------------------

# lets take an example of something bit more complex

# show all movies that produced / made  more than 500%  profit or more 
# and their rating was less than avg_imdb rating of all movies 


# so this query looks to big and tricky , lets divide and conquer and make 2 queries out of it

#  1) show all movies that made  more than 500%  profit or more 

# we have financials table , lets see 

SELECt * , (revenue - budget)* 100 / budget as profit_pct from financials 
where profit_pct > 500;

# this above query wont work becasue we cant use aggregates / calc with where , we can use having

SELECt * , (revenue - budget)* 100 / budget as profit_pct from financials 
having profit_pct > 500;

# or we can use this also , same thing 

SELECt * , (revenue - budget)* 100 / budget as profit_pct from financials 
where (revenue - budget)* 100 / budget > 500;

# so this is done -------------------------------------------------------


#  2) movies whose imdb_rating is less than avg_imdb rating of all movies 

# we can get avg rating like this 
SELECt round(avg(imdb_rating) , 2) as avggg from movies;

# we can also get like this with subquery
 
select * from movies where imdb_rating < (SELECt round(avg(imdb_rating) , 2) from movies);


-- okay so now we have both tables and let combine them to get our answers 

# 1st table gives you pct prcnt ---lets call it --> x table
# 2nd table give you all the less than avg movies ---lets call it --> y table

# one thing if you see in common is , they have movie_id in common

# lets join them ? 

# we can get our answer by subqueries and common tables expressions (CTE) both 

# lets do by subquery  1st 


SELECT * from 
(SELECt * , (revenue - budget)* 100 / budget as profit_pct 
from financials) as x
JOIN 
(select * from movies where imdb_rating < 
(SELECt round(avg(imdb_rating) , 2) from movies)) as y
using(movie_id)
where profit_pct  > 500;

# i dont want every col , lets filter

SELECT movie_id , title , profit_pct , imdb_rating from 
(SELECt * , (revenue - budget)* 100 / budget as profit_pct 
from financials) as x
JOIN 
(select * from movies where imdb_rating < 
(SELECt round(avg(imdb_rating) , 2) from movies)) as y
using(movie_id)
where profit_pct  > 500;


# so we did get it but isnt it very messy 

# lets use CTE
# can we have soemthing like

-- ------------------------------------------------------------------------------ 
with x as () , 
	 y as ()

SELECt movie_id  , profit_pct ,
title , imdb_rating
from x
JOIN y USING (movie_id)
where profit_pct>500;

-- ------------------------------------------------------------------------------ 

-- okay lets do it


with x as (SELECt * , (revenue - budget)* 100 / budget as profit_pct 
from financials) , 
	 y as (select * from movies where imdb_rating < 
(SELECt round(avg(imdb_rating) , 2) from movies))

SELECt movie_id  , profit_pct ,
title , imdb_rating
from x
JOIN y USING (movie_id)
where profit_pct>500;



#---------------------------------------------------------------------------------------------------
# BENEFITS OF CTES
# 
# 1) SIMPLE QUERIES - as queires evolve , people keep on adding more and more where clauses etc and when there is issue in the 
#    system no one dares to touch that query because it will affect the whole system
# 2) SAME RESULT set can be referenced multiple times -  query reusablity
# 3) If you see some table used always , we can convert it into views , gives potential candidates for views
#---------------------------------------------------------------------------------------------------
