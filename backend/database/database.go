package database

import (
	"database/sql"
	"embed"
	_ "embed"
	"freshpoint/backend/database/query"
	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/sqlite3"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/golang-migrate/migrate/v4/source/iofs"
	_ "github.com/mattn/go-sqlite3"
	"log"
	"os"
)

//go:embed migrations/*.sql
var migrationFs embed.FS

type Database struct {
	database *sql.DB
}

func NewConnection() *Database {
	dbFile := os.Getenv("STORAGE_PATH") + "/database.db"
	_, err := os.Stat(dbFile)
	if os.IsNotExist(err) {
		log.Println("Database file does not exist. Creating...")
	}

	db, err := sql.Open("sqlite3", dbFile)
	if err != nil {
		log.Fatal("Could not open SQLite database file")
	}
	// defer database.Close()

	fs, err := iofs.New(migrationFs, "migrations") // Get migrations from sql folder
	if err != nil {
		log.Fatal(err)
	}

	m, err := migrate.NewWithSourceInstance("iofs", fs, log.Sprintf("sqlite3://%s", dbFile))
	if err != nil {
		panic(err)
	}

	err = m.Up()
	if err != nil && err != migrate.ErrNoChange {
		panic(err)
	}

	d := &Database{
		database: db,
	}
	return d
}

func (d *Database) ListDevices() []Device {
	rows, err := d.database.Query(query.ListDevices)
	if err != nil {
		panic(err)
	}
	defer rows.Close()

	devices := []Device{}
	for rows.Next() {
		var device Device
		err = rows.Scan(&device.Token, &device.RegisteredAt)
		if err != nil {
			panic(err)
		}
		devices = append(devices, device)
	}

	log.Println(devices)
	return devices
}

func (d *Database) AddDevice(dev Device) {
	stmt, err := d.database.Prepare("INSERT INTO device(token, registered_at) values(?, ?)")
	if err != nil {
		panic(err)
	}
	defer stmt.Close()

	_, err = stmt.Exec(dev.Token, dev.RegisteredAt)
	if err != nil {
		panic(err)
	}
}
