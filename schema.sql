-- Creating table for eBirds
CREATE TABLE ebirds (
	genus VARCHAR,
	species VARCHAR,
	country_code VARCHAR (10),
	locality VARCHAR,
	state VARCHAR (40),
	occurence_status VARCHAR,
	individual_count VARCHAR,
	latitude FLOAT,
	longitude FLOAT,
	basis_of_record VARCHAR (40),
	catalog_number VARCHAR (40),
	date VARCHAR (15) NOT NULL
);

-- Creating table for air quality
CREATE TABLE air_quality(
	county_name VARCHAR (40),
	county_code INT,
	date VARCHAR (10),
	aqi INT,
	category VARCHAR (40),
	defining_parameter VARCHAR (40)
);

-- Creating table for counties
CREATE TABLE counties(
	latitude FLOAT,
	longitude FLOAT,
	county_name VARCHAR (40)
);

-- Creating table for weather
CREATE TABLE weather(
	county VARCHAR,
	date VARCHAR,
	heavy_rain INT,
	high_wind INT
);

-- Creating table for county population
CREATE TABLE county_pop(
	county VARCHAR (15),
	year VARCHAR(10),
	population VARCHAR (15)
);	

CREATE TABLE obs_date_year(
	county_name VARCHAR, 
	date VARCHAR,
	year VARCHAR
);
	
SELECT * FROM ebirds
SELECT * FROM counties
SELECT * FROM air_quality

SELECT
	c.county_name,
	b.species,
	b.latitude,
	b.longitude,
	b. date
INTO bird_county
FROM ebirds b
INNER JOIN counties c
ON c.latitude = b.latitude AND c.longitude = b.longitude

-- INNER JOIN bird data and air quality
SELECT
	bc.county_name,
	bc.species,
	bc.date,
	a.aqi,
	a.category
INTO bird_aqi 
FROM bird_county bc
INNER JOIN air_quality a
ON a.county_name = bc.county_name AND a.date = bc.date

-- Update weather table date format
ALTER TABLE weather ALTER COLUMN date TYPE VARCHAR
using to_date(date, 'MM-DD-YY');

-- Create a table using left join to add in weather events to the bird observations and air quality
SELECT
	ba.county_name,
	ba.species,
	ba.date,
	ba.aqi,
	ba.category,
	ba.defining_parameter,
	w.heavy_rain,
	w.high_wind,
INTO bird_aqi_weather
FROM bird_aqi ba
LEFT JOIN weather w
ON ba.county_name = w.county AND ba.date = w.date



SELECT * FROM bird_aqi_weather

-- Copy date into new year column
UPDATE bird_aqi_weather SET year = date;

-- Show list of years
ALTER TABLE bird_aqi_weather ADD COLUMN (
SELECT *, split_part(year, '-', 1) AS year_2
FROM bird_aqi_weather);

-- Split column to have a column of just year for join
ALTER TABLE bird_aqi_weather ADD COLUMN (year_1 TYPE VARCHAR,
SELECT *, split_part(year, '-', 1) AS year_1
FROM bird_aqi_weather
);										

-- Join obs_date_year to birds table for future join.
SELECT
	b.county_name,
	b.species,
	b.date,
	b.aqi,
	b.category,
	b.defining_parameter,
	b.heavy_rain,
	b.high_wind,
	o.year
INTO bird_aqi_weather_2
FROM bird_aqi_weather b
LEFT JOIN obs_date_year o
ON b.date = o.date

SELECT * FROM bird_aqi_weather_2

-- Create a table using left join to add in population to the bird observations and air quality
SELECT
	b.county_name,
	b.species,
	b.date,
	b.aqi,
	b.category,
	b.defining_parameter,
	b.heavy_rain,
	b.high_wind,
	b.year,
	cp.population
INTO bird_a_w_p 
FROM bird_aqi_weather_2 b
LEFT JOIN county_pop cp
ON b.county_name = cp.county AND b.year = cp.year

SELECT * FROM bird_a_w_p
