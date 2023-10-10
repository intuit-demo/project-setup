# LocoNavigator

## prerequists

### tools and frameworks
* java 17
* postgres
* elastic search
* mongodb
* kafka
* mqtt
* camunda
* kibana
* elastic search kafka connector
* docker
* intelliJ idea
* maven build

### presetup

#### network for docker

```shell
 docker network create intuit 
 # server address = 192.168.1.4 (find the local address in your system)
```

####  mqtt setup
```shell
## run mosquitto server
docker run  --network=intuit --rm -p 1883:1883 -p 9001:9001 --name mosquitto --rm eclipse-mosquitto mosquitto -c /mosquitto-no-auth.conf
```

#### elastic search and kibana setup
```shell

## cd ./scripts/elk/
docker-compose up

docker exec -it elasticsearch /bin/bash
# http://localhost:5601/app/kibana#/home
# username : elastic
# password : elastic```

```

### mongodb setup
```shell
#cd .\scripts\mongodb
docker-compose up

docker-compose exec mongo1 /bin/bash

>> /usr/bin/mongo --eval 'if (rs.status()["ok"] == 0) {rsconf = { _id : "rs0", members: [ { _id : 0, host : "mongo1:27017", priority: 1.0 },{ _id : 1, host : "mongo2:27017", priority: 0.5 }, { _id : 2, host : "mongo3:27017", priority: 0.5 }]};rs.initiate(rsconf);}rs.conf();'

>> mongo
>>  use intuit
>> db.createCollection("vehicle.events.topic")
>> db.createCollection("intuit.overspeed.vehicleevents")
>> db. getCollectionNames()
>> db.vehicle.events.topic.remove({})
>> db.intuit.overspeed.vehicleevents.remove({})
>> db.intuit.vehicles.remove({})
>> db.vehicle.events.topic.find().limit(1).pretty()
>> db.intuit.overspeed.vehicleevent.find().limit(1).pretty()
>> db.intuit.vehicles.find().limit(1).pretty()
```



```shell
http://localhost:8080/camunda/app/welcome/default/
```

#### kafka setup

```shell
## download the kafka from web
curl -o kafka_2.13-3.5.1.tgz https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz

## cd D:\tools\kafka_2.13-3.5.1\bin\windows
## run the zookeeper
.\zookeeper-server-start.bat ..\..\config\zookeeper.properties

## run the kafka
.\kafka-server-start.bat ..\..\config\server.properties

## create topics
.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --create --replication-factor 1 --topic intuit.intuit.vehicleevents

.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --create --replication-factor 1 --topic vehicle.events.topic

.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --create --replication-factor 1 --topic intuit.overspeed.vehicleevents

.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --list

## copy the plugins from D:\projects\intuit-demo\project-setup\scripts\kafka\plugins to D:\tools\kafka_2.13-3.5.1\plugins

## run the kafka connect
## sample config file in this path D:\projects\intuit-demo\project-setup\scripts\kafka

.\connect-standalone.bat ..\..\config\connect-standalone.properties  ..\..\config\elasticsearch-sink-config-vehicle.properties ..\..\config\elasticsearch-sink-config-overspeed.properties ..\..\config\mqtt-sink-config-vehicle.properties  ..\..\config\mongo-sink-config-vehicle.properties

```


# vehicle-real-time-data-emitters-simulator
* Basic Vehicle Simulator 
* Consideration only on road vehicles
* Fuel is full when the vehicle starts
* vechile will emit events with the delay of 5 seconds

# vehicle-real-time-data-receiver

# vehicle-real-time-data-notification


access camunda url
```
http://localhost:8080/camunda/app/welcome/default/
* username : demo
* password : demo
```

http://localhost:8085/swagger-ui/index.html#/






docker run -it --rm --name mongodb-connector -e MONGO_INITDB_ROOT_USERNAME=mongodb -e MONGO_INITDB_ROOT_PASSWORD=mongodb -p 27017:27017  debezium/example-mongodb


# reporting
## setup







```shell
## create a docker image for cassandra connector
cd scripts/debezium/cassandra
docker build . -t cassandra-connector
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

```shell
docker run -it --rm --network=intuit --name kibana --link elasticsearch -e ELASTICSEARCH_HOSTS= ['https://elasticsearch:9200'] -p 5601:5601 kibana:8.10.2

## /usr/share/kibana/config/kibana.yml

docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -c http-kibana.crt -k http-kibana.key -s kibana


 # http://192.168.1.4:5601/?code=087031

```