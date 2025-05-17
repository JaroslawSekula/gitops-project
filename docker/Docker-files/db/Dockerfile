FROM mysql:8.0.33

ENV MYSQL_ROOT_PASSWORD="vprodbpass"
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin123
ENV MYSQL_DATABASE="accounts"

ADD db_backup.sql docker-entrypoint-initdb.d/db_backup.sql