package main

import (
	"freshpoint/backend/apns"
	"freshpoint/backend/freshpoint"
	"freshpoint/backend/user"
	"github.com/sideshow/apns2"
	"time"
)

var c *cache
var d *user.UserModel
var n *apns2.Client

func main() {
	c = newCache()
	d = user.NewConnection()
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
