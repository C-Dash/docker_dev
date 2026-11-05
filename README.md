# CDASH Development Environment Docker set up.

## Omeka S release zip (not tracked in git)
The Dockerfile COPYs an Omeka S release zip (e.g. `omeka-s-4.1.1.zip`) from this
folder. These zips are not committed. Download the version named in the
Dockerfile from https://github.com/omeka/omeka-s/releases and place it here
before building.

## Omeka S 4.2.1 instance (branch omeka-4.2.1)
Runs alongside the 4.1.1 instance with its own data:
* Omeka: http://localhost:8081/   Adminer: http://localhost:8082/
* Persist volume `cdash-persist-421` (a copy of `cdash-persist`); create it once with:

      docker volume create cdash-persist-421
      docker run --rm -v cdash-persist:/from:ro -v cdash-persist-421:/to alpine cp -a /from/. /to/

* `cdash-scans` is shared with 4.1.1.
* Own database, seeded on first start from `db-init/` (see db-init/README.md).
* PHP 8.4. Download `omeka-s-4.2.1.zip` into this folder, then:

      docker compose up -d --build

  If Docker Hub downloads fail and `mysql:9.4` is not local but the same
  build exists as `mysql:latest`: `docker tag mysql:latest mysql:9.4`, then
  `docker compose up -d --pull never`.
* After first start, open /admin and run the database migration.

## Original (older) instructions
Build container for Omeka with C-Dash customizations
WIth command prompt current working directory in cdash-dev-docker run:
:> docker image build -t cdash-omeka-dev-2.0.2 .

Check the docker-compose.yml to make sure that the local path to the cdash-persist folder is correct -- near the bottom of the file.  

Then run the compose command 
:> docker-compose up -d

Check in docker for desktop window that all three services are running.

To stop: 
:> docker-compose down

To connect to Adminer: point browser at  localhost:8080
* system: MySql
* server:  mariadb
* Username: root
* password: blabla
* database: omeka

Set up first user:
* name: firstuser
* email: firstuser@devnull.net
* Display Name: First User
* Password: go#fish

