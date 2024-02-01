This repo is a playgroud to setup/test and interaction with a Flink, Kafka, and PostgreSQL environment using Docker Compose. Follow the steps below to utilize the project and the included script.

# Apache Flink Playground Game Sales

Welcome to the Apache Flink Playground, a project designed for testing the seamless integration of Apache Flink with Kafka and Postgres and a simple Go producer. The primary goal of this playground is to provide a hands-on environment for exploring real-time data processing, event streaming, and database interaction within the Apache Flink ecosystem.

## Prerequisites

Before getting started, make sure Docker and Docker Compose are installed on your system.

## Step 1: Clone the Repository
```
git clone https://github.com/lucasviecelli/apache-flink-agg-game-sales.git
cd apache-flink-agg-game-sales
```

## Step 2: Menu Options

Once Docker Compose is up, a menu will appear with the following options:

1. Start Docker Compose: Start the Docker Compose environment.
2. Create Kafka Topic: Create a Kafka topic named "game-sales."
3. Create PostgreSQL Database and Tables: Initialize a PostgreSQL database named "flink" and execute required tables.
4. Create Flink Tables: Create Flink tables using the provided SQL script.
5. Show Top Hit Game Platforms in PostgreSQL: Display results from the "top_hit_platforms" table in PostgreSQL.
6. Show Top Hit Games in PostgreSQL: Display results from the "top_hit_games" table in PostgreSQL.
7. Exit: Stop the script and exit.


## Step 3: Creating things

Perform menu steps 1 to 4. After that, it's time to create fake data in the Kafka topic by running Producer.go, the number of fake events is customized and the idea is that it runs as many times as you want.

```
$ go run producer.go --num 1000000
1000000 messages published to Kafka successfully
```

## Step 3: Show data and explore

If everything is working fine, it's time to show the data and you can see the data in Apache-flink or the summary in Postgres, if you want to see it in postgres there are two options 5 and 6 in the menu to use for this, choose an option by entering the corresponding number. The script will perform the selected action. Example of use:

```
$ ./setup.sh 

Select an option:
1. Start Docker Compose
2. Create Kafka topic
3. Create PostgreSQL database and tables
4. Create Flink tables
5. Show top hit game platforms in Postgres
6. Show top hit games in Postgres
7. Exit
Enter your choice: 6

Show top hit platforms...
         game_name         | platform_name | game_count 
---------------------------+---------------+------------
 GTA 5                     | Xbox Series X |      83483
 Battlefield 2042          | Xbox Series X |      83595
 Minecraft                 | Xbox Series X |      83365
 FC 24                     | Xbox Series X |      82949
 Assassin's Creed Valhalla | Xbox Series X |      82999
 Pokemon Arceus            | Xbox Series X |      82935
 Cyberpunk 2077            | Xbox Series X |      83014
 Call of Duty: Warzone     | Xbox Series X |      83483
 Battlefield 2042          | PS5           |      82502
 Call of Duty: Warzone     | PS5           |      84007
 FC 24                     | PS5           |      83090
 Pokemon Arceus            | PS5           |      83690
 GTA 5                     | PS5           |      83279
 Assassin's Creed Valhalla | PS5           |      83689
 Minecraft                 | PS5           |      83611
 Cyberpunk 2077            | PS5           |      82798
 GTA 5                     | PC            |      83423
 Call of Duty: Warzone     | PC            |      83395
 Cyberpunk 2077            | PC            |      83256
 Assassin's Creed Valhalla | PC            |      83805
 FC 24                     | PC            |      83427
 Minecraft                 | PC            |      83175
 Pokemon Arceus            | PC            |      83359
 Battlefield 2042          | PC            |      83671

```

Select the desired option from the menu by entering the corresponding number. Follow the on-screen instructions to interact with the environment and view the results.
Feel free to explore and modify the script according to your needs. Enjoy using the project!

## References

- [Apache Flink Documentation](https://ci.apache.org/projects/flink/flink-docs-release-1.14/)
- [Building Streaming Application with Flink SQL](https://flink.apache.org/2020/07/28/flink-sql-demo-building-an-end-to-end-streaming-application/)

