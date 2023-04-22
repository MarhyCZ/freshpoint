package database

type Device struct {
	Token        string `db:"token"`
	RegisteredAt string `db:"registered_at"`
}
