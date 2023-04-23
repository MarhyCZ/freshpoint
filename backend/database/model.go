package database

import (
	"time"
)

type Device struct {
	Token        string    `db:"token"`
	RegisteredAt time.Time `db:"registered_at"`
}
