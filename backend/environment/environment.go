package environment

import (
	"freshpoint/backend/database"
	"freshpoint/backend/freshpoint"
	"github.com/sideshow/apns2"
)

type Env struct {
	Database     *database.Database
	Notification *apns2.Client
	Store        *Store
}

type Store struct {
	Catalog freshpoint.FridgeCatalog
	Fridges []freshpoint.Fridge
}

func NewStore() *Store {
	catalog := freshpoint.FetchProducts()
	fridges := freshpoint.FetchFridges()

	return &Store{
		catalog,
		fridges,
	}
}
