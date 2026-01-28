# 1/ Run docker with the python:3.13 image. Use an entrypoint bash to interact with the container.
# What's the version of pip in the image?

# Réponse = lancer un docker avec python 3.13 et connaitre la version de pip

```bash
docker run -it \
    --rm \
    --entrypoint=bash \
    python:3.13
```

puis `pip -V` --> 25.3

2/ Problème sur les ports :

La structure du port est la suivante : HOST:CONTAINER
Ne sachant pas exactement quel est lequel (en principe je dirais le host car le container est local dans docker), je vais essayer manuellement avec postreg

```
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql \
  -p 5433:5432 \
  postgres:18
```
Puis on va essayer de connecter uv dessus

uv run pgcli -h localhost -p 5433 -u root -d ny_taxi
-> marche bien avec 5433 qui est le port du host
-> réponse = db / 5433

3/ besoin d'ingérer des données

-> ajout des données dans ingest_data.py
-> docker compose up
-> build docker puis run docker (docker co)


# SQL

Tout est lancé sur pgadmin

```sql
-- demande 1 : nombre de trips en novembre avec distance parcourue < 1 mile
select count(*)
from 
	green_taxi_trips
where
	lpep_pickup_datetime between '2025-11-01' and '2025-11-01'
	and trip_distance <= 1
; -- 8007

-- demande 2 : jour avec la distance la plus longue <= 100 miles
select 
	cast(lpep_pickup_datetime as date), 
	max(trip_distance) as distance_max
from 
	green_taxi_trips
where
	lpep_pickup_datetime between '2025-11-01' and '2025-12-01'
	and trip_distance <= 100
group by 1
order by 2 desc
; -- 2025-11-14

-- demande 3 : pickup zone avec le montant le plus élevé le 18 novembre 2025

select  l."Zone", sum(total_amount) as total_amount
from
	green_taxi_trips as t
inner join taxi_zones as l
	on t."PULocationID" = l."LocationID"
where 
	t.lpep_pickup_datetime::date = '2025-11-18'
group by "Zone" order by total_amount desc

; -- "East Harlem North"

-- demande 4 : For the passengers picked up in the zone named "East Harlem North" in November 2025, 
-- which was the drop off zone that had the largest tip?
select zone_arrivee, sum(coalesce(tip_amount, 0)) as tip_amount
from
	green_taxi_trips as t
inner join (select "LocationID", "Zone" as zone_debut from taxi_zones) as l
	on t."PULocationID" = l."LocationID"
inner join (select "LocationID", "Zone" as zone_arrivee from taxi_zones) as l2
	on t."DOLocationID" = l2."LocationID"
where 
	t.lpep_pickup_datetime between '2025-11-01' and '2025-11-30'
	and l.zone_debut = 'East Harlem North'
	and l2.zone_arrivee in ('JFK Airport','Yorkville West','East Harlem North','LaGuardia Airport')
group by zone_arrivee order by 2 desc
; -- "Yorkville West"
```

