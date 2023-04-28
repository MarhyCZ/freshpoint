package user

import (
	"time"
)

type Device struct {
	Token        string    `user:"token"`
	RegisteredAt time.Time `user:"registered_at"`
}
