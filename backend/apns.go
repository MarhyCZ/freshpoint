package main

import (
	"fmt"
	"github.com/sideshow/apns2/token"
	"log"
	"os"

	"github.com/sideshow/apns2"
)

func notify() {
	authKey, err := token.AuthKeyFromFile(os.Getenv("STORAGE_PATH") + "/authkey.p8")
	if err != nil {
		log.Fatal("token error:", err)
	}

	token := &token.Token{
		AuthKey: authKey,
		// KeyID from developer account (Certificates, Identifiers & Profiles -> Keys)
		KeyID: "72MVDUVLV3",
		// TeamID from developer account (View Account -> Membership)
		TeamID: "FBWNLT2RLU",
	}

	notification := &apns2.Notification{}
	notification.DeviceToken = "e04914e1d28e58f01c8af573d46a5c2a492f52b453e5fa71b2e1b7ebde5f9c62"
	notification.Topic = "com.marstad.freshpoint"
	notification.Payload = []byte(`{"aps":{"alert":"Ahooj️ ☀️"}}`) // See Payload section below

	// If you want to test push notifications for builds running directly from XCode (Development), use
	// client := apns2.NewClient(cert).Development()
	// For apps published to the app store or installed as an ad-hoc distribution use Production()

	client := apns2.NewTokenClient(token).Development()
	res, err := client.Push(notification)

	if err != nil {
		log.Fatal("Error:", err)
	}

	fmt.Printf("%v %v %v\n", res.StatusCode, res.ApnsID, res.Reason)
}
