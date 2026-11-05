# db-init

On the **first** start of the stack (when the `mysql-data` volume is empty),
MySQL loads every `*.sql` file in this folder into the `omeka` database.
Dumps are not committed (see `.gitignore`).

To seed this instance from the running 4.1.1 dev instance:

    docker exec cdash-dev-docker-db-1 sh -c 'mysqldump -uroot -pblabla --single-transaction --routines --triggers --no-tablespaces omeka' > db-init/omeka-from-4.1.1.sql

To re-seed later, remove the db volume (`docker compose down` then
`docker volume rm cdash-dev-421_mysql-data`) and start again.
