# --------------------------------------------------------------------------------------------------

#                     Retrieve Data Using Text Query (SELECT, WHERE, DISTINCT, LIKE)

# --------------------------------------------------------------------------------------------------

# select all movies
SELECT * FROM movies;

# lets select a specific column or columns
SELECT studio FROM movies;
SELECT industry , studio FROM movies;
SELECT title, release_year , studio FROM movies;

# select all bollywood movies
SELECT * FROM movies WHERE industry = "Bollywood";

# lets count how many rows 
SELECT count(*) FROM movies;

# lets count how many rows we have in hollywood
SELECT count(*) FROM movies WHERE industry = "Hollywood"; 

# lets get unique studio names or industry names
SELECT DISTINCT studio from movies;
SELECT DISTINCT industry from movies;

# lets find all thor movies
SELECT * FROM movies WHERE title LIKE "%THOR%";  ## wildcard
SELECT * FROM movies WHERE title LIKE "%america%";

# --------------------------------------------------------------------------------------------------

#                     TILL HERE IT WAS TEXT BASED RETRIVAL , LETS EXPLORE NUMERICAL BASED

# --------------------------------------------------------------------------------------------------

#                  Retrieve Data Using Numeric Query (BETWEEN, IN, ORDER BY, LIMIT, OFFSET)

# --------------------------------------------------------------------------------------------------


# lets see blank values
SELECT * FROM movies WHERE studio = "";

# lets find the max rating and min rating
SELECT max(imdb_rating) as max_rating FROM movies;
SELECT min(imdb_rating) as min_rating FROM movies;

# lets see the movies whose rating is more than 9 
SELECT * FROM movies WHERE imdb_rating > 9;

# lets see the movies whose rating is more less than 5 
SELECT * FROM movies WHERE imdb_rating < 7;

# lets use AND operator 
SELECT * FROM movies WHERE imdb_rating >= 6 AND imdb_rating <= 9 ;

# lets use BETWEEN , AND operator , like a range function
# retrieve imdb_rating records 
SELECT * FROM movies WHERE imdb_rating BETWEEN 6 AND 9;
# retrieve release year records 
SELECT * FROM movies WHERE release_year BETWEEN 2019 AND 2022;

# lets use IN operator and retrieve from years 2019 and  2022 
# note that its IN and not BETWEEN
SELECT * FROM movies WHERE release_year IN (2019 , 2022);
SELECT * FROM movies WHERE studio IN ("marvel studios" , "Yash raj Films");
SELECT count(*) FROM movies WHERE studio IN ("marvel studios" , "Yash raj Films");


# lets use NULL and NOT NULL , works only on numerical columns
# Retrieve all null and not null columns from IMDB_rating
SELECT * FROM movies WHERE imdb_rating is NULL;
SELECT * FROM movies WHERE imdb_rating is NOT NULL;

# lets use or operator
SELECT * FROM movies WHERE release_year = 2022 or release_year = 2019 or release_year = 2018 ;

## lets use ORDER BY clause to print  movies  according to imdb_rating
SELECT * FROM movies where industry = "Bollywood" ORDER BY imdb_rating ;

## lets use ORDER BY clause , ASC by default to print  movies  according to imdb_rating
SELECT * FROM movies where industry = "Bollywood" ORDER BY imdb_rating ASC;

## lets use ORDER BY clause , DESC to print  movies  according to imdb_rating 
SELECT * FROM movies where industry = "Bollywood" ORDER BY imdb_rating DESC;

## lets use ORDER BY clause , DESC to print  movies  according to imdb_rating and studio is not empty
SELECT * FROM movies where industry = "Bollywood" AND studio != "" ORDER BY imdb_rating DESC;


# -------------------------------------------------------------------------------------------

#                            FUNCTIONS - eg : HANDS , legs , buttons etc
#                          BASIC Summary Analytics (MIN, MAX, AVG, GROUP BY)

# -------------------------------------------------------------------------------------------

# count function , lets count total unique studio 
select distinct count(studio) FROM movies;

# min and max functions , imdb_rating
SELECT max(imdb_rating) as max_rating FROM movies;
SELECT min(imdb_rating) as min_rating FROM movies;

# average function ,avg imdb_rating
SELECT avg(imdb_rating) FROM movies;
# round up 
SELECT ROUND(avg(imdb_rating) , 2) as avgg FROM movies;

# select count of hollywood movies 
SELECT count(*) from movies where industry = "Bollywood";

#### NOW I WANT table like this
##                                        HOLLYWOOD = 18
##                                        BOLLYWOOD = 16
##                                        TOLLYWOOD = 10 

select industry ,count(*) as ind_countt FROM movies GROUP BY industry; 

## same for studio
select studio ,count(*) as std_countt FROM movies WHERE studio != "" GROUP BY studio order by std_countt DESC LIMIT 5 ;

 ## now i want 
##   INDUSTRY   , MOVIE COUNT , avg rating

SELECT industry , count(industry) as movie_cnt , avg(imdb_rating) as avg_rating FROM movies GROUP BY industry; 

# same for studio
SELECT 
studio , 
count(studio) as studio_cnt , 
ROUND(avg(imdb_rating) , 2) as avg_rating 
FROM movies 
WHERE studio != "" 
GROUP BY studio 
ORDER BY studio_cnt DESC ;


# -------------------------------------------------------------------------------------------
#                                                NEW 
#                                           HAVING CLAUSE 
# -------------------------------------------------------------------------------------------


 #                          RELEASE YEAR | CNT of movies|
 #                              2022     |        5     |
 #                              2021     |        3     |
 #
## select all the years where more than 2 movies were released
SELECT release_year , count(*) as cnt FROM movies GROUP BY release_year ORDER BY cnt DESC ; 

#### now most part is done , we only want to filter out more than 2 but if we us this query we will get error

SELECT release_year , count(*) as cnt FROM movies where cnt>2 GROUP BY release_year ORDER BY cnt DESC ;

## USING HAVING CLAUSE , there you go 
SELECT release_year , count(*) as cnt FROM movies GROUP BY release_year HAVING cnt > 2 ORDER BY cnt DESC ;

# -------------------------------------------------------------------------------------------
### key point , where does not has to be in SELECT 

SELECT title FROM movies WHERE release_year = 2022;

## see this one willl give you error
SELECT title FROM movies HAVING release_year = 2022;

# but if you this one
SELECT title , studio FROM movies HAVING studio like "%marvel%";

# -------------------------------------------------------------------------------------------
#                                   FLOW OF QUERYING
#                                                                                  
#            SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY                                                                         
#                                                                                       
# -------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------

#                      Calculated Columns (IF, CASE, YEAR, CURYEAR)

# -------------------------------------------------------------------------------------------

## lets say we have to calculate a few things
# like what is the average age of an actor in action movies
# who is the youngest actor in bollywood

## so to get current age ====>> Current date(year) - Birthdate(year)

SELECT * FROM actors;

## let do that , see we got the age

SELECT * , YEAR(curdate()) - birth_year as age FROM actors;


## lets move to financials

SELECT * FROM financials;

# profit = revenue - budget , lets do that

SELECT * , (revenue - budget) as profit FROM financials;


# Now say we want to print the revenue in single currency because we have INR and USD
# units also we have million , billion , thousands

# USD ---> INR = 80 ratio , new column we will have revenue INR

SELECT * , 
IF(currency = 'USD' , revenue * 80 , revenue) as revenue_inr 
FROM financials;


# now lets convert all the units into MILLIONS
# 1 BILLION = 1000 MILLION   <--conversion--> n*1000
# 1 MILLION = 1000 THOUSANDS <--conversion--> n/1000

# lets select unique units first
SELECT 
DISTINCT unit 
FROM financials;


# now lets finally convert all the units into MILLIONS
SELECT *, 
       CASE
           WHEN unit = 'thousands' THEN revenue / 1000  
           WHEN unit = 'billions'   THEN revenue * 1000 
           WHEN unit = 'millions'   THEN revenue 
       END AS revenue_mln
FROM financials;
