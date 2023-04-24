package main

import (
	"freshpoint/backend/database"
	"freshpoint/backend/freshpoint"
	"github.com/sideshow/apns2"
	"time"
)

var c *cache
var d *database.Database
var apns *apns2.Client

func main() {
	c = newCache()
	d = database.NewConnection()
	apns = CreateAPNSClient()

	notify(apns)
	// Run an auto-update goroutine for "my_data"
	go c.SetAutoUpdate("freshpoint", 120*time.Second, func() interface{} {
		println("Updating freshpoint cache")
		curr := freshpoint.FetchProducts()
		old, ok := c.Get("freshpoint")
		if ok {
			newProducts := freshpoint.GetNewProducts(old.(freshpoint.FreshPointCatalog).Products, curr.Products)
			print(newProducts)
		}
		return curr
	})

	serve()
}
