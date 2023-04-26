package apns

import (
	"fmt"
	"github.com/sideshow/apns2/token"
	"log"
	"os"

	"github.com/sideshow/apns2"
)

func CreateAPNSClient() *apns2.Client {
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

	// If you want to test push notifications for builds running directly from XCode (Development), use
	// client := apns2.NewClient(cert).Development()
	// For apps published to the app store or installed as an ad-hoc distribution use Production()

	client := apns2.NewTokenClient(token).Production()
	return client
}

func Notify(client *apns2.Client, notification *apns2.Notification) {
	notification.Topic = "com.marstad.freshpoint"

	res, err := client.Push(notification)

	if err != nil {
		log.Fatal("Error:", err)
	}

	fmt.Printf("%v %v %v\n", res.StatusCode, res.ApnsID, res.Reason)

}

func NotifyNewItems(client *apns2.Client, deviceToken string) {
	notification := &apns2.Notification{}
	notification.Payload = []byte(`{"aps":{"alert":"V automatu jsou slevy nebo nové produkty, jdi to omrknout!"}}`)
	notification.DeviceToken = deviceToken
	Notify(client, notification)
}
