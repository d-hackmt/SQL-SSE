# accessing via json 
SELECT * from items where properties->"$.gluten_free"=1;

SELECT * from items where isnull(properties->"$.gluten_free");

# accessing spatial data_type
SELECT * , ST_astext(location) FROM sakila.address;

