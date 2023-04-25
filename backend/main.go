package main

import (
	"freshpoint/backend/apns"
	"freshpoint/backend/database"
	"freshpoint/backend/freshpoint"
	"github.com/sideshow/apns2"
	"time"
)

var c *cache
var d *database.Repository
var n *apns2.Client

func main() {
	c = newCache()
	d = database.NewConnection()
	n = apns.CreateAPNSClient()

	// Run an auto-update goroutine for "my_data"
	go c.SetAutoUpdate("freshpoint", 120*time.Second, func() interface{} {
		println("Updating freshpoint cache")
		curr := freshpoint.FetchProducts()
		old, ok := c.Get("freshpoint")
		if ok {
			newProducts := freshpoint.GetNewProducts(old.(freshpoint.FreshPointCatalog).Products, curr.Products)
			print(newProducts)
			devices := d.ListDevices()
			if len(newProducts) > 0 {
				for _, device := range devices {
					apns.NotifyNewItems(n, device.Token)
				}
			}
		}
		return curr
	})

	serve()
}
