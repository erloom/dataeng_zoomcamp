1/ load data using load.py

2/ create external table in bigquerry to access data

```sql
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-485615.zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dtc_course_bootcamp_gdr/yellow_tripdata_2024-*.parquet']
);
```

For the materialized table :
```sql
CREATE OR REPLACE TABLE dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned AS
SELECT * FROM dtc-de-course-485615.zoomcamp.external_yellow_tripdata;
```


1/What is count of records for the 2024 Yellow Taxi Data?

```sql
select count(*) from `dtc-de-course-485615.zoomcamp.external_yellow_tripdata`; 
```

20_332_093

2/ What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

query : 
select count(distinct `PULocationID`) from dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned;  --(155MB)
select count(distinct `PULocationID`) from dtc-de-course-485615.zoomcamp.external_yellow_tripdata; -- (0B)

3/ Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.

select `PULocationID` from dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned; -- 155 MB
select `PULocationID`, `DOLocationID` from dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned; 310 MB

Answer : 
BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

4 / How many records have a fare_amount of 0?

select count(*) from dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned where fare_amount = 0; -- 8_333

5/ What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

--> Partition by tpep_dropoff_datetime and Cluster on VendorID

```sql
CREATE OR REPLACE TABLE dtc-de-course-485615.zoomcamp.yellow_tripdata_partitioned
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned;
```

6/ Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

```sql
select distinct VendorID from
dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'; -- 310
select distinct VendorID from
dtc-de-course-485615.zoomcamp.yellow_tripdata_partitioned
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'; -- 26.84
```

7/ Where is the data stored in the External Table you created?

--> GCP Bucket
Bigquerry gets data directly from the bucket

8/ It is best practice in Big Query to always cluster your data:
--> False, for instance for small tables or highly skewed variables

9/ No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
select count(*) from `dtc-de-course-485615.zoomcamp.yellow_tripdata_non_partitioned`; -- 0B
-> maybe because the count is retrieved from the metadata
