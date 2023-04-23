package main

import (
	"freshpoint/backend/database"
	"freshpoint/backend/freshpoint"
	"time"
)

var c *cache
var d *database.Database

func main() {
	c = newCache()
	d = database.NewConnection()
	// Run an auto-update goroutine for "my_data"
	go c.SetAutoUpdate("freshpoint", 120*time.Second, func() interface{} {
		println("Updating freshpoint cache")
		return freshpoint.FetchProducts()
	})

	serve()
}
