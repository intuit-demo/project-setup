-- Create a keyspace
CREATE KEYSPACE IF NOT EXISTS intuit WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

-- Create a table
CREATE TABLE IF NOT EXISTS intuit.vehicleevents (
    id text PRIMARY KEY,
    registration_number text ,
    uuid text,
    status text,
    latitude double,
    longitude double,
    speed double,
    distance double,
    fuel double,
    event_ts text,
    update_ts timestamp
)  WITH cdc=true;