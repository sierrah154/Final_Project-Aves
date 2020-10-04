-- Creating table for eBirds
CREATE TABLE ebirds (
	Species_Code VARCHAR (10) NOT NULL,
	Com_Name VARCHAR (40),
	Sci_Name VARCHAR (40),
	Date DATE,
	Time INT,
	Latitude INT,
	Longitude INT,
	Obs_Valid VARCHAR (10),
	PRIMARY KEY (Date)
	);
	
-- Creating table for temperature
CREATE TABLE temperature (
	Latitude INT,
	Longitude INT,
	Date DATE,
	Days_Ext_Low INT,
	Days_Ext_High INT,
	Temp_Ext_Min INT,
	Temp_Ext_Max INT,
	Precipitation INT,
	Temp_Avg INT,
	Temp_Max INT,
	Temp_Min INT,
	FOREIGN KEY (Date) REFERENCES ebirds (Date),
	PRIMARY KEY (Date)
);

-- Creating table for air quality
CREATE TABLE Air_Quality(
	Latitude INT,
	Longitude INT,
	Local_Site_Name VARCHAR (40),
	Date DATE,
	State_Code INT,
	Arithemtic_Mean INT,
	First_Max_Value INT,
	Units_of_Measure VARCHAR (40),
	FOREIGN KEY (Date) REFERENCES ebirds (Date),
	PRIMARY KEY (Date)
);