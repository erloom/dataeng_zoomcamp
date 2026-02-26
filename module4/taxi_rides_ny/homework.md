# Question 1. dbt Lineage and Execution

If you run dbt run --select int_trips_unioned, what models will be built?

-> int_trips_unioned only, because no "+" before or after the model

# Question 2. dbt Tests

--> dbt will fail the test, returning a non-zero exit code

# Question 3. Counting Records in fct_monthly_zone_revenue

After running your dbt project, query the fct_monthly_zone_revenue model.

What is the count of records in the fct_monthly_zone_revenue model?

select count(*) from {{ ref('fct_monthly_zone_revenue') }};
--> 12,184

# Question 4. Best Performing Zone for Green Taxis (2020)

```sql
select 
    pickup_zone, 
    max(revenue_monthly_total_amount) as max_revenue
 from 
    {{ ref('fct_monthly_zone_revenue')}} 
where
    service_type = 'Green' and year(revenue_month) = 2020
group by 1 order by 2 desc
;
```

--> East Harlem North 

# Question 5 : Green Taxi Trip Counts (October 2019)

```sql
select 
    sum(total_monthly_trips) as total_trips
 from 
    {{ ref('fct_monthly_zone_revenue')}} 
where
    service_type = 'Green' and revenue_month = '2019-10-01'
    ;
```

--> 384,624

# Question 6. Build a Staging Model for FHV Data

Load data using the same script as `ingest_data.py` --> `ingest_data_fhv.py`

Create a stg_fhv_tripdata_sql with the following code :

```sql
with source as (
    select * from {{ source('raw', 'fhv_tripdata') }}
)

select 
    count(*) 
from
    source
where dispatching_base_num IS not NULL;
```
--> 43 244 693
