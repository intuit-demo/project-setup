```shell
## create a docker image for cassandra connector
cd scripts/debezium/cassandra
docker build . -t cassandra-connector
```

```shell
## run mosquitto server
docker run  --rm -p 1883:1883 -p 9001:9001 --name mosquitto --rm eclipse-mosquitto mosquitto -c /mosquitto-no-auth.conf
```

```shell
## download the kafka from web
curl -o kafka_2.13-3.5.1.tgz https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz

## run the zookeeper
.\zookeeper-server-start.bat ..\..\config\zookeeper.properties

## run the kafka
.\kafka-server-start.bat ..\..\config\server.properties

```

```shell
## run cassandra server with connector
docker run --network=intuit   --rm  -p 9042:9042 -p 9160:9160  -p 7000:7000  --name cassandra-connector   cassandra-connector
```

``` shell
## login in the container and run the queries
type>> docker exec -it cassandra-connector /bin/bash
type>> cqlsh
type>> select * from intuit.vehicleevents;
```

```shell
## consume the cassandra events
.\kafka-console-consumer.bat --bootstrap-server 192.168.1.4:9092 --topic intuit.intuit.vehicleevents
```
