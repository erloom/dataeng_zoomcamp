# Création du network docker

Déjà configuré dans docker-compose.yaml. Il suffit juste de lancerl a commande suivante :

```bash
docker compose up
```

Ca va crée les 2 containers associées (postreg + pgadmin), les 2 dans le même network car c'est géré automatiquement par docker-compose. On ajout toutefois dans la section `networks` le nom du réseau pour pouvoir s'y connecter par la suite avec un autre container (celui python pour l'ingestion des données).

# Ingestion des données

Première étape : uv init sur le projet pour démarrer l'environnement virtuel.
Attention : pour travailler cet environnement, il faut toujours ajouter `uv run` avant la commande.

-> création du programme d'ingestion `/pipeline/ingest_data.py`

On pourrait directement envoyer ces données via uv sur le network docker. Cependant, on va le faire de manière propre en utilisant un autre container docker qu'on va connecter aux containers existants.

Pour ce faire :
1/ build le container avec les infos contenues dans `Dockerfile`. A noter qu'on charge uv directement dans le Dockerfile puis uv se charge de tout le reste.
2/ On créé le container qui va utiliser le script ingest_data.py

```
docker build -t taxi_ingest:v001 .
```

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



Note : network = data_engineer_course_default si aucun nom donné par défaut.
Pour module2 : module2_default (check docker network ls pour voir lequel est utilisé). Pro

Voir https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/01-docker-terraform/docker-sql pour les codes.