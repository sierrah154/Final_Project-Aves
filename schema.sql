-- Creating table for eBirds
CREATE TABLE ebirds (
	genus VARCHAR,
	species VARCHAR,
	country_code VARCHAR (10),
	locality VARCHAR,
	state VARCHAR (40),
	occurence_status VARCHAR,
	individual_count VARCHAR (10),
	latitude VARCHAR,
	longitude VARCHAR,
	basis_of_record VARCHAR (40),
	catalog_number VARCHAR (40),
	date VARCHAR (15) NOT NULL
);
	
-- Creating table for air quality
CREATE TABLE air_quality(
	state_name VARCHAR (40),
	county_name VARCHAR (40),
	state_code VARCHAR (10),
	county_code VARCHAR (10),
	date VARCHAR (10),
	aqi VARCHAR (10),
	category VARCHAR (40),
	defining_parameter VARCHAR (40)
);

-- Creating table for counties
CREATE TABLE counties(
	latitude INT,
	longitude INT,
	county VARCHAR (40),
	PRIMARY KEY (county)
);

SELECT * FROM air_quality