# -*- coding: utf-8 -*-
"""aves.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1B0dqujGig62wioC2lIlRG8tiUCoWRnCy
"""

# Install Java, Spark, and Findspark
!apt-get update
!apt-get install openjdk-8-jdk-headless -qq > /dev/null
!wget -q http://www-us.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
!tar xf spark-3.0.1-bin-hadoop2.7.tgz
!pip install -q findspark

# Set Environment Variables
import os
os.environ["JAVA_HOME"] = "/usr/lib/jvm/java-8-openjdk-amd64"
os.environ["SPARK_HOME"] = "/content/spark-3.0.1-bin-hadoop2.7"

# Start a SparkSession
import findspark
findspark.init()

!wget https://jdbc.postgresql.org/download/postgresql-42.2.9.jar

# Start Spark Session
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("CloudETL").config("spark.driver.extraClassPath","/content/postgresql-42.2.9.jar").getOrCreate()

# Read in air quality data from S3 Buckets
from pyspark import SparkFiles
url ="https://caznoe-aves.s3.amazonaws.com/aq_dataframe.csv"
spark.sparkContext.addFile(url)
aq_df = spark.read.csv(SparkFiles.get("aq_dataframe.csv"), sep=",", header=True)

# Show DataFrame
aq_df.show()

# Print the schema
aq_df.printSchema()

# Import struct fields that we can use
from pyspark.sql.types import StructField, StringType, IntegerType, StructType

# Creating the list of struct fields
schema = [StructField("state_name", StringType(), True), StructField("county_name", StringType(), False), StructField("state_code", IntegerType(), True), StructField("county_code", IntegerType(), True), StructField("date", StringType(), True), StructField("aqi", IntegerType(), True), StructField("category", StringType(), True), StructField("defining_parameter", StringType(), True)]
schema

# Pass in our AQ fields
aq_final = StructType(fields=schema)
aq_final

# Read in air quality data from S3 Buckets
from pyspark import SparkFiles
url ="https://caznoe-aves.s3.amazonaws.com/aq_dataframe.csv"
spark.sparkContext.addFile(url)
aq_df = spark.read.csv(SparkFiles.get("aq_dataframe.csv"), schema=aq_final, sep=",", header=True)

# Show DataFrame
aq_df.printSchema()

# Create a list of struct fields for Hummingbirds
hb_schema = [StructField("genus", StringType(), True), 
             StructField("species", StringType(), True), 
             StructField("country_code", StringType(), True), 
             StructField("locality", StringType(), True), 
             StructField("state", StringType(), True), 
             StructField("occurence_status", StringType(), True), 
             StructField("individual_count", IntegerType(), True), 
             StructField("latitude", IntegerType(), True),
             StructField("longitude", IntegerType(), True),
             StructField("basis_of_record", StringType(), True),
             StructField("catalog_number", StringType(), True),
             StructField("date", StringType(), True)]

# Pass in our HB fields
hb_final = StructType(fields=hb_schema)
hb_final

# Read in ebirds data from S3 Buckets
from pyspark import SparkFiles
url ="https://caznoe-aves.s3.amazonaws.com/hb_dataframe.csv"
spark.sparkContext.addFile(url)
hb_df = spark.read.csv(SparkFiles.get("hb_dataframe.csv"), schema=hb_final, sep=",", header=True)

# Show DataFrame
hb_df.printSchema()

# Configure settings for RDS
mode = "append"
jdbc_url="jdbc:postgresql://aves.cap6velp6xxz.ap-south-1.rds.amazonaws.com:5432/aves"
config = {"user":"caznoe", 
          "password": "XXXXXXX", 
          "driver":"org.postgresql.Driver"}

# Write DataFrame to air quality table in RDS
aq_df.write.jdbc(url=jdbc_url, table='air_quality', mode=mode, properties=config)

# Write DataFrame to ebirds table in RDS
hb_df.write.jdbc(url=jdbc_url, table='ebirds', mode=mode, properties=config)