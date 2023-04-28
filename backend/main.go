package main

import (
	"freshpoint/backend/apns"
	"freshpoint/backend/cache"
	"freshpoint/backend/environment"
	"freshpoint/backend/freshpoint"
	"freshpoint/backend/server"
	"freshpoint/backend/user"
	"time"
)

var env *environment.Env

func main() {
	env = &environment.Env{
		Users:        user.NewConnection(),
		Cache:        cache.NewCache(),
		Notification: apns.CreateAPNSClient(),
	}

	// Run an auto-update goroutine for "my_data"
	go env.Cache.SetAutoUpdate("freshpoint", 120*time.Second, func() interface{} {
		println("Updating freshpoint cache")
		curr := freshpoint.FetchProducts()
		old, ok := env.Cache.Get("freshpoint")
		if ok {
			newProducts := freshpoint.GetNewProducts(old.(freshpoint.FreshPointCatalog).Products, curr.Products)
			print(newProducts)
			devices := env.Users.ListDevices()
			if len(newProducts) > 0 {
				for _, device := range devices {
					apns.NotifyNewItems(env.Notification, device.Token)
				}
			}
		}
		return curr
	})

	server.Serve(env)
}
