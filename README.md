# CDASH Development Environment Docker set up.

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

