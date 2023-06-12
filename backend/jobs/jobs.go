package jobs

import (
	"fmt"
	"freshpoint/backend/environment"
	"freshpoint/backend/freshpoint"
	"log"
	"time"
)

var env *environment.Env

func Start(e *environment.Env) {
	env = e
	println("Setting up jobs")
	go refreshFridges()
	go refreshCatalog()
}
func refreshCatalog() {
	ticker := time.NewTicker(5 * time.Minute)
	defer ticker.Stop()

	for _, fridge := range env.Store.Fridges {
		refreshFridge(fridge)
		time.Sleep(2 * time.Second)
	}
}

func refreshFridge(fridge freshpoint.Fridge) {
	fmt.Printf("Updating freshpoint store for fridge %s", fridge.Location.Name)
	new := freshpoint.FetchProducts(fridge)
	old := env.Store.Catalog[fridge.Prop.Id]
	changes := freshpoint.GetChanges(old.Products, new.Products)
	log.Printf("New products: %d New discounts %d", len(changes.New), len(changes.Discounts))

	/*
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

	*/

	env.Store.Catalog[fridge.Prop.Id] = new
}

func refreshFridges() {
	ticker := time.NewTicker(60 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		println("Updating fridges list")
		new := freshpoint.FetchFridges()
		env.Store.Fridges = new
	}
}
