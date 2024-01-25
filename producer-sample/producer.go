package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"math/rand"
	"time"

	"github.com/google/uuid"
	"github.com/segmentio/kafka-go"
)

type Game struct {
	ID        string  `json:"id"`
	GameName  string  `json:"game_name"`
	Platform  string  `json:"platform"`
	DateSale  string  `json:"date_sale"`
	Country   string  `json:"country"`
	Genre     string  `json:"genre"`
	Publisher string  `json:"publisher"`
	Price     float64 `json:"price"`
}

var validGameNames = []string{
	"Assassin's Creed Valhalla",
	"Call of Duty: Warzone",
	"Cyberpunk 2077",
	"Battlefield 2042",
	"FC 24",
	"Minecraft",
	"Pokemon Arceus",
	"GTA 5",
}

func generateRandomID() string {
	return uuid.New().String()
}

func generateRandomDate() string {
	return time.Now().Add(time.Duration(rand.Intn(365*24*60*60)) * time.Second).Format("2006-01-02 15:04:05")
}

func generateRandomGame() Game {
	return Game{
		ID:        generateRandomID(),
		GameName:  getRandomGameName(),
		Platform:  []string{"PS5", "Xbox Series X", "PC"}[rand.Intn(3)],
		DateSale:  generateRandomDate(),
		Country:   []string{"Brazil", "United States", "Germany"}[rand.Intn(3)],
		Genre:     []string{"Action", "FPS", "RPG"}[rand.Intn(3)],
		Publisher: []string{"Ubisoft", "Activision", "EA Sports", "Nintendo"}[rand.Intn(4)],
		Price:     float64(rand.Intn(100)) + 0.99,
	}
}

func getRandomGameName() string {
	return validGameNames[rand.Intn(len(validGameNames))]
}

func main() {
	numGames := flag.Int("num", 3, "Number of messages to produce")
	flag.Parse()

	rand.Seed(time.Now().UnixNano())

	var messages []kafka.Message

	for i := 0; i < *numGames; i++ {
		game := generateRandomGame()

		// Convert to JSON
		jsonData, err := json.Marshal(game)
		if err != nil {
			log.Fatal("Error marshalling JSON:", err)
		}

		message := kafka.Message{
			Key:   []byte(game.ID),
			Value: jsonData,
		}

		messages = append(messages, message)
	}

	brokerAddress := "localhost:9092"
	topic := "game-sales"

	config := kafka.WriterConfig{
		Brokers:  []string{brokerAddress},
		Topic:    topic,
		Balancer: &kafka.LeastBytes{},
	}

	writer := kafka.NewWriter(config)
	err := writer.WriteMessages(context.Background(), messages...)

	if err != nil {
		log.Fatal("Error publishing to Kafka:", err)
	}

	fmt.Printf("%d messages published to Kafka successfully\n", *numGames)
	writer.Close()
}
