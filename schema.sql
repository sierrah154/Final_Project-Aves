-- Creating table for eBirds
CREATE TABLE ebirds (
	genus VARCHAR,
	species VARCHAR,
	country_code VARCHAR (10),
	locality VARCHAR,
	state VARCHAR (40),
	occurence_status VARCHAR,
	individual_count BIGINT,
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

SELECT * FROM bird_aqi