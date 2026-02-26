

-- Question 3
select count(*) from {{ ref('fct_monthly_zone_revenue') }};

-- Question 4
select 
    pickup_zone, 
    max(revenue_monthly_total_amount) as max_revenue
 from 
    {{ ref('fct_monthly_zone_revenue')}} 
where
    service_type = 'Green' and year(revenue_month) = 2020
group by 1 order by 2 desc
;
--> East Harlem North 

-- Question 5

select 
    sum(total_monthly_trips) as total_trips
 from 
    {{ ref('fct_monthly_zone_revenue')}} 
where
    service_type = 'Green' and revenue_month = '2019-10-01'
    ;
