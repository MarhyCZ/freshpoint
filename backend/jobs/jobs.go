package jobs

import (
	"freshpoint/backend/environment"
	"freshpoint/backend/freshpoint"
	"log"
	"time"
)

var env *environment.Env

func Start(e *environment.Env) {
	env = e
	println("Setting up jobs")
	go refreshCatalog()
}
func refreshCatalog() {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		println("Updating freshpoint store")
		new := freshpoint.FetchProducts()
		old := env.Store.Catalog
		changes := freshpoint.GetChanges(old.Products, new.Products)
		log.Printf("New products: %d New discounts %d", len(changes.New), len(changes.Discounts))

		/*devices := env.Database.ListDevices()

		if len(newProducts) > 0 {
			for _, device := range devices {
				apns.NotifyNewItems(env.Notification, device.Token)
			}
		}*/
	}
}
