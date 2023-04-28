package main

import (
	"freshpoint/backend/api"
	"freshpoint/backend/apns"
	"freshpoint/backend/database"
	"freshpoint/backend/environment"
	"freshpoint/backend/jobs"
)

func main() {
	env := &environment.Env{
		Database:     database.NewConnection(),
		Store:        environment.NewStore(),
		Notification: apns.CreateAPNSClient(),
	}
	api.Serve(env)
	jobs.Start(env)
}
