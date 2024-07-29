# df-initdb


## Pull

```sh
git clone --depth=1 https://github.com/aphage/df-initdb.git
```

## Update Db Connect

At `z-update_db_connect.sql` you need to update the `MYSQL_SECURITY_PASSWORD`.

`MYSQL_SECURITY_PASSWORD` is the password encrypted using `df-crypto`.

```sh
sudo docker pull registry.hub.docker.com/aphage/df-server:0.0.1

sudo docker run --rm -it df-crypto:0.0.1 \
df-crypto enc 123456
```

## Initialize Database

```sh
mkdir mysql

sudo docker pull registry.hub.docker.com/aphage/mysql:5.0.96

sudo docker run --rm -it \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_USER=game \
-e MYSQL_PASSWORD=123456 \
-e MYSQL_USER_GRANTS_ALL=true \
--user="$(id -u)":"$(id -g)" \
--mount type=bind,source="$(pwd)"/df-initdb.d,target=/docker-entrypoint-initdb.d \
--mount type=bind,src="$(pwd)"/mysql,target=/var/lib/mysql \
--name df-mysql \
mysql:5.0.96
```

## With my.cnf

```sh
sudo docker run --rm -it \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_USER=game \
-e MYSQL_PASSWORD=123456 \
-e MYSQL_USER_GRANTS_ALL=true \
--user="$(id -u)":"$(id -g)" \
--mount type=bind,source="$(pwd)"/docker-entrypoint-initdb.d,target=/docker-entrypoint-initdb.d \
--mount type=bind,src="$(pwd)"/mysql,target=/var/lib/mysql \
--name df-mysql \
mysql:5.0.96
```
