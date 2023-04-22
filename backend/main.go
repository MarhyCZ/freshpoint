package main

import (
	"freshpoint/backend/database"
	"freshpoint/backend/freshpoint"
	"time"
)

var c *cache

func main() {
	c = newCache()

	// Run an auto-update goroutine for "my_data"
	go c.SetAutoUpdate("freshpoint", 120*time.Second, func() interface{} {
		println("Updating freshpoint cache")
		return freshpoint.FetchProducts()
	})

	database.Init()
	serve()
}
