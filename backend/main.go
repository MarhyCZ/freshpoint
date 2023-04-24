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
	notify()
	// Run an auto-update goroutine for "my_data"
	go c.SetAutoUpdate("freshpoint", 120*time.Second, func() interface{} {
		println("Updating freshpoint cache")
		curr := freshpoint.FetchProducts()
		old, ok := c.Get("freshpoint")
		if ok {
			new := freshpoint.GetNewProducts(old.(freshpoint.FreshPointCatalog).Products, curr.Products)
			print(new)
		}
		return curr
	})

	serve()
}
