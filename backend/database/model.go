package database

import (
	"time"
)

type Device struct {
	Token        string    `database:"token"`
	RegisteredAt time.Time `database:"registered_at"`
}
