#!/bin/bash

start_docker_compose() {
    echo "Starting Docker Compose..."
    docker-compose up #-d
}

create_kafka_topic() {
    echo "Creating Kafka topic..."
    docker exec -it broker kafka-topics --create --topic game-sales --bootstrap-server broker:29092 --partitions 3
}

create_flink_tables() {
    echo "Creating Flink tables..."
    docker-compose exec -T jobmanager ./bin/sql-client.sh -f /opt/flink/flink-sql/tables_jobs.sql
}

create_postgres_db() {
    echo "Creating PostgreSQL database..."
    docker-compose exec -T postgres psql -U postgres -c "CREATE DATABASE flink;"
    echo "Executing PostgreSQL tables.sql..."
    docker-compose exec -T postgres psql -U postgres -d flink < postgres/tables.sql
}

show_results_pg_top_hit_platforms() {
    echo "Show top hit platforms..."
    docker-compose exec -T postgres psql -U postgres -d flink -c "select * from top_hit_platforms order by 2 desc;"
}

show_results_pg_top_hit_games() {
    echo "Show top hit platforms..."
    docker-compose exec -T postgres psql -U postgres -d flink -c "select * from top_hit_games order by 2 desc;"
}

menu() {
    echo "Select an option:"
    echo "1. Start Docker Compose"
    echo "2. Create Kafka topic"
    echo "3. Create PostgreSQL database and tables"
    echo "4. Create Flink tables"
    echo "5. Show top hit game platforms in Postgres"
    echo "6. Show top hit games in Postgres"
    echo "7. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1) start_docker_compose ;;
        2) create_kafka_topic ;;
        3) create_postgres_db ;;
        4) create_flink_tables ;;
        5) show_results_pg_top_hit_platforms ;;
        6) show_results_pg_top_hit_games ;;
        7) exit ;;
        *) echo "Invalid option";;
    esac
}

menu
