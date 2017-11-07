# dlatk-docker
Docker container for the Differential Language Analysis ToolKit.

## Example usage
Starts a mysql docker container and then builds and runs the DLATK container; linking the two containers together. See https://hub.docker.com/_/mysql/ for more info on the MySQL container.

```bash
docker run --name mysql-8 -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8
docker build -t dlatk-docker .
docker run -it --rm --name dlatk-test --link mysql-8:mysql dlatk-docker bash
```

## Variables
The following variables can be overridden in the DLATK docker container allowing for the user to use a different MySQL instance:
 
* `MYSQL_USER`: Username for the DB.
* `MYSQL_PASSWORD`: Password for the user.
* `MYSQL_HOST`: IP/Host of the server.
* `MYSQL_PORT`: Port of the server (e.g. `3306`).

## Loading the sample datasets
If following [the tutorial](http://dlatk.wwbp.org/tutorials/tut_dla.html) you'll need run the following to load the sample data:

```sql
mysql < $DLATK_DIR/data/dla_tutorial.sql
mysql < $DLATK_DIR/data/permaLexicon.sql
```

## TODO
* Create a `docker-compose.yml`.
* Optionally allow for the IBM Wordcloud jar to be utilized.