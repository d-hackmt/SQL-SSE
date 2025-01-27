#
#                                         LETS EXPLORE SUB-QUERIES
#---------------------------------------------------------------------------------------------------


#lets say i want to select the movie with highest imdb_rating




















# lets say i want min and max imdb_rating











# similarly  Select all the movies with minimum and maximum release_year. 
















# select all the actors whose age > 70 and < 85















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









# select all the movies whose rating is greater than any of the marvel movies 











# now i want to get all the movies whose rating is more than ALL marvel movies 












#---------------------------------------------------------------------------------------------------|
#
#					LETS Study , Co - related subquery , Performance analysis
#
#---------------------------------------------------------------------------------------------------|


# actor_id , name , movie_cnt  -> meaning how many movie the respecitive actors have acted in 















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











# show all movies that produced / made  more than 500%  profit or more 
# and their rating was less than avg_imdb rating of all movies 

# so this query looks to big and tricky , lets divide and conquer and make 2 queries out of it

#  1) show all movies that made  more than 500%  profit or more 

#  2) movies whose imdb_rating is less than avg_imdb rating of all movies 


# we can get our answer by subqueries and common tables expressions (CTE) both 

# lets do by subquery  1st 











# lets use CTE

















