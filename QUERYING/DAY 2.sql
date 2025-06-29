# Lets say i have someone who says i want to know the movie which made the highest profit 
#
#
#                                           LETS EXPLORE JOINS
#---------------------------------------------------------------------------------------------------

# lets try a join , INNER JOIN , by default
select m.movie_id ,  title , budget , unit  , currency 
from movies as m 
JOIN financials f 
ON m.movie_id AND f.movie_id;

# lets see another method , USING clause
# NOTE : We use using clause only when we both the joining names are same ,
# else we have to use ON clause

select 
m.movie_id , title , budget , unit  , currency 
from movies m 
JOIN financials f 
USING (movie_id);

# lets see left join
SELECT
m.movie_id , title , budget , unit  , currency 
FROM movies m 
LEFT JOIN financials f 
using (movie_id);

# lets see right join
SELECT
f.movie_id , title , budget , unit  , currency 
FROM movies m 
RIGHT JOIN financials f 
using (movie_id);

# lets see full join ,
# make sure the columns you are retriving should be the same

SELECT 
m.movie_id , title , budget , unit  , currency 
FROM movies m 
LEFT JOIN financials f 
using (movie_id)

UNION

SELECT 
f.movie_id , title , budget , unit  , currency 
FROM movies m 
RIGHT JOIN financials f 
using (movie_id);

#---------------------------------------------------------------------------------------------
#                             FOOD DB DATA SET FOR CROSS JOIN                             
#---------------------------------------------------------------------------------------------

select * from items ;
select * from variants ;

# LETS study cross joins
select * from items 
CROSS JOIN variants;

SELECT *, 
concat(name ," - " , variant_name) as full_name , 
(price + variant_price) as full_prize 
from items 
CROSS JOIN variants;

## finally if you remove *  , menu is ready
SELECT 
concat(name ," - " , variant_name) as full_name , 
(price + variant_price) as full_prize 
from items 
CROSS JOIN variants;


#---------------------------------------------------------------------------------------------
#                    ANALYTICS ON TABLES    , lets go back on movies dataset                   
#---------------------------------------------------------------------------------------------

## NOW i want to get the movie name and the profit earned

SELECT 
m.movie_id , title , budget ,
revenue , currency , unit , (revenue - budget) as profit
FROM movies m JOIN financials f USING (movie_id);


## now i want only bollywood and according to profit 

SELECT 
m.movie_id , title , budget ,
revenue , currency , unit , (revenue - budget) as profit
FROM movies m JOIN financials f USING (movie_id)
WHERE industry = "bollywood"
ORDER BY profit DESC;

## but here we see because of units , we got wrong retrival
# we have to now neutralize the units to millions 

SELECT 
m.movie_id , title , budget ,
revenue , currency , unit ,
CASE 
	WHEN unit = "thousands"  THEN (revenue - budget)/1000
	WHEN unit = "billions"  THEN (revenue - budget)*1000
    ELSE (revenue - budget)
END as profit_mln
FROM movies m JOIN financials f USING (movie_id)
WHERE industry = "bollywood"
ORDER BY profit_mln DESC;

## now we can round this up

SELECT 
m.movie_id , title , budget ,
revenue , currency , unit ,
CASE 
	WHEN unit = "thousands"  THEN ROUND((revenue - budget)/1000 , 1)
	WHEN unit = "billions"  THEN ROUND((revenue - budget)*1000 , 1)
    ELSE ROUND((revenue - budget),1)
END as profit_mln
FROM movies m JOIN financials f USING (movie_id)
WHERE industry = "bollywood"
ORDER BY profit_mln DESC;


#---------------------------------------------------------------------------------------------
#                               JOIN MORE THAN 2 TABLES                
#---------------------------------------------------------------------------------------------


select * from movies;
select * from actors;
select * from movie_actor;

## lets say i want like 
#                           |  movie_id | title | actor name             |
#			    |  101      | kgf   |     yash , sanjay dutt |
#
# WE WILL PERFORM A CROSS JOIN

SELECT m.movie_id , m.title , a.name
FROM movies m
JOIN movie_actor ma using (movie_id)
JOIN actors a using (actor_id) ;
	
# but here we didnt get quite what we were looking for

# lets try something else , can we group something?  GROUP BY ??? YO lets doit

SELECT  m.title , a.name
FROM movies m
JOIN movie_actor ma using (movie_id)
JOIN actors a using (actor_id)
group by m.movie_id ;

# ok  , no error but we didnt  get what we were looking for 
# google karte hai 

# ohhh i found group_concat 
SELECT  m.title , group_concat(a.name SEPARATOR " | ")
FROM movies m
JOIN movie_actor ma using (movie_id)
JOIN actors a using (actor_id)
group by m.movie_id ;

### yeeeee we got it 


## now lets say we want report like reverse

## lets say i want like 
#                           | actor name   |  title                 |
#			    | sanjay dutt  |  kgf , Munna bhai MBBS |
#
# WE WILL PERFORM A CROSS JOIN again 

SELECT a.name , group_Concat(m.title SEPARATOR " | " ) as movies  , 
count(m.title) as movie_cnt 
FROM actors a 
JOIN movie_actor ma USING (actor_id)
JOIN movies m USING (movie_id)
GROUP BY actor_id
ORDER BY movie_cnt DESC;


