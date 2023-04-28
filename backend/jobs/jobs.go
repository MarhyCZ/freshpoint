package jobs

import (
	"freshpoint/backend/apns"
	"freshpoint/backend/environment"
	"freshpoint/backend/freshpoint"
	"time"
)

var env *environment.Env

func Start(env *environment.Env) {
	refreshCatalog()
}
func refreshCatalog() {
	ticker := time.NewTicker(10 * time.Second)
	// defer ticker.Stop()

	for range ticker.C {
		println("Updating freshpoint store")
		new := freshpoint.FetchProducts()
		old := env.Store.Catalog
		newProducts := freshpoint.GetNewProducts(old.Products, new.Products)
		print(newProducts)

		devices := env.Database.ListDevices()

		if len(newProducts) > 0 {
			for _, device := range devices {
				apns.NotifyNewItems(env.Notification, device.Token)
			}
		}
	}
}
