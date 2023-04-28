package environment

import (
	"freshpoint/backend/cache"
	"freshpoint/backend/user"
	"github.com/sideshow/apns2"
)

type Env struct {
	Users        *user.UserModel
	Cache        *cache.Cache
	Notification *apns2.Client
}
