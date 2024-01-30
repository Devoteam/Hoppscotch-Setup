# Hoppscotch-Setup

An instruction for deploying self-hosted Hoppscotch service!

## ENV

## Docker-compose file
The docker file needs some changes so Hopscotch will work.

### Changes in the docker file


```
docker-compose -f <file.yaml> up
```
### Migration
```
docker exec -it <container_id> /bin/sh
```
 
```
pnpx prisma migrate deploy
```
