package query

import (
	_ "embed"
)

var (
	//go:embed scripts/CreateNewDevice.sql
	CreateNewDevice string
	//go:embed scripts/ListDevices.sql
	ListDevices string
)
