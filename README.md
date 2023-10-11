# LocoNavigator

## architecture

<img title="a title" alt="Alt text" src="/hld/car-events.jpg">


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
.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --create --replication-factor 1 --topic vehicle.events
.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --create --replication-factor 1 --topic overspeed.vehicle.events

.\kafka-topics.bat --bootstrap-server 192.168.1.4:9092 --list
```


#### mongodb setup

```shell
#cd .\scripts\mongodb
docker-compose up

docker-compose exec mongo1 /bin/bash

>> /usr/bin/mongo --eval 'if (rs.status()["ok"] == 0) {rsconf = { _id : "rs0", members: [ { _id : 0, host : "mongo1:27017", priority: 1.0 },{ _id : 1, host : "mongo2:27017", priority: 0.5 }, { _id : 2, host : "mongo3:27017", priority: 0.5 }]};rs.initiate(rsconf);}rs.conf();'

>> mongo
>>  use intuit
>> db.createCollection("vehicles")
>> db.createCollection("vehicle.events")
>> db.createCollection("overspeed.vehicle.events")
>> db. getCollectionNames()
>> db.vehicle.events.topic.remove({})
>> db.intuit.overspeed.vehicleevents.remove({})
>> db.intuit.vehicles.remove({})
>> db.vehicle.events.topic.find().limit(1).pretty()
>> db.intuit.overspeed.vehicleevent.find().limit(1).pretty()
>> db.intuit.vehicles.find().limit(1).pretty()
```

#### kafka connector setup

```shell
## copy the plugins from D:\projects\intuit-demo\project-setup\scripts\kafka\plugins to D:\tools\kafka_2.13-3.5.1\plugins

## run the kafka connect
## sample config file in this path D:\projects\intuit-demo\project-setup\scripts\kafka

.\connect-standalone.bat ..\..\config\connect-standalone.properties  ..\..\config\elasticsearch-sink-config-vehicle.properties ..\..\config\elasticsearch-sink-config-overspeed.properties ..\..\config\mqtt-sink-config-vehicle.properties  
```


## microservices

## vehicle-real-time-data-emitters-simulator

This application simulates the vehicle device emitter.

* Basic Vehicle Simulator 
* Consideration only on road vehicles
* Fuel is full when the vehicle starts
* Vehicle will emit events with the delay of 10 seconds



## vehicle-real-time-data-notification
This application comsumes the vehicle device evetns, calculates the distance. validates whether the 
vehicle is overspeed.

## vehicle-event-service

This application consumes the vehicle device events, and exposes the
services for 3rd part developers

## application URLs

### access camunda url

``` shell
http://localhost:8080/camunda/app/welcome/default/
* username : demo
* password : demo
```

### access camunda url
``` shell
http://localhost:8085/swagger-ui/index.html#/
```

### access kibana url
```shell
http://localhost:5601/login
```