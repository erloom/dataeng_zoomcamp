# Setup du module 2

Lancement du docker

```bash
docker compose up -d
```

Ingestion des données issues du script python. On repart du script précédent à la racine du projet

```bash
docker build -t taxi_ingest:v001 .
```

network a comme nom par défaut le nom du dossier + "_default". Check `docker compose ls` pour voir lequel utilisé.
Utiliser `docker network prune` pour nettoyer.

```bash
docker run -it \
  --network=module2_default \
  taxi_ingest:v001 \
    --pg-user=root \
    --pg-password=root \
    --pg-host=pgdatabase \
    --pg-port=5432 \
    --pg-db=ny_taxi \
    --target-table=yellow_taxi_trips
```

```