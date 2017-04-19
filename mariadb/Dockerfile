FROM mariadb
ADD script.sql /docker-entrypoint-initdb.d/script.sql
RUN chmod 755 /docker-entrypoint-initdb.d
ENV MYSQL_ROOT_PASSWORD password
