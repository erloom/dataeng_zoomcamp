1/ Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

--> check on gcp storage after doing kestra workflow
--> 134.5

2/ What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

--> check on kestra worklow
file: "{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv"
--> check all inputs
answer : "greentripdata_2020-04.csv"

3/ How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

--> need to backfill all data from 2020, yellow and green
then go to Bigquery and do the count

```sql
SELECT
 sum(row_count) as row_count
FROM
  `dtc-de-course-485615.zoomcamp.__TABLES__`
WHERE
  table_id IN (
    'yellow_tripdata_2020_01','yellow_tripdata_2020_02','yellow_tripdata_2020_03','yellow_tripdata_2020_04',
    'yellow_tripdata_2020_05','yellow_tripdata_2020_06','yellow_tripdata_2020_07','yellow_tripdata_2020_08',
    'yellow_tripdata_2020_09','yellow_tripdata_2020_10','yellow_tripdata_2020_11','yellow_tripdata_2020_12'
  
  ); -- 24_648_499
```
4/ How many rows are there for the Green Taxi data for all CSV files in the year 2020?

Same method as question 3 : 
- do a backfill with all green data from 2020
- look at bigquerry number of rows with the the same sql command
->  1_734_051

5/ How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

- adapt the 08 script by adding 2021 in the year id
- retrieve the table
- on GCP, SELECT count(*) FROM `dtc-de-course-485615.zoomcamp.yellow_tripdata_2021_03`; -> 1_925_152

6/ How would you configure the timezone to New York in a Schedule trigger?

Check in the kestra documentation of cron, there is a 'timezone' option
Check the New York timezone : 'America/New_York' (source : https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)
Answer : Add a timezone property set to America/New_York in the Schedule trigger configuration

