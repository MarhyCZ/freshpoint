package database

import (
	"database/sql"
	_ "embed"
	"fmt"
	_ "github.com/mattn/go-sqlite3"
	"os"
)

//go:embed schema.sql
var schemaBytes []byte

func Init() {
	dbFile := "./database.db"
	_, err := os.Stat(dbFile)
	if os.IsNotExist(err) {
		fmt.Println("Database file does not exist. Creating...")
		db, err := sql.Open("sqlite3", dbFile)
		if err != nil {
			panic(err)
		}
		defer db.Close()

		_, err = db.Exec(string(schemaBytes))
		if err != nil {
			panic(err)
		}
	}

	db, err := sql.Open("sqlite3", dbFile)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	rows, err := db.Query("SELECT * FROM device")
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

	fmt.Println(devices)
}
