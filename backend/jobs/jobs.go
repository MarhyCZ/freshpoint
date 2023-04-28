package jobs

import (
	"freshpoint/backend/apns"
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
	ticker := time.NewTicker(2 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		println("Updating freshpoint store")
		new := freshpoint.FetchProducts()
		old := env.Store.Catalog
		changes := freshpoint.GetChanges(old.Products, new.Products)
		log.Printf("New products: %d New discounts %d", len(changes.New), len(changes.Discounts))

		devices := env.Database.ListDevices()

		if len(changes.New) > 0 {
			for _, device := range devices {
				apns.NotifyAlert(env.Notification, device.Token, "V automatu jsou nové produkty, jdi to omrknout!")
			}
		}
		if len(changes.Discounts) > 0 {
			for _, device := range devices {
				apns.NotifyAlert(env.Notification, device.Token, "V automatu jsou nové slevy, jdi to omrknout!")
			}
		}
	}
}
