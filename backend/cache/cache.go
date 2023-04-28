package cache

import (
	"sync"
	"time"
)

type cachedData struct {
	data       interface{}
	expiration time.Time
	updateFunc func() interface{}
}

type Cache struct {
	data map[string]cachedData
	lock sync.Mutex
}

func (c *Cache) Get(name string) (interface{}, bool) {
	c.lock.Lock()
	defer c.lock.Unlock()
	cachedData, ok := c.data[name]
	if !ok || cachedData.expiration.Before(time.Now()) {
		return nil, false
	}
	return cachedData.data, true
}

func (c *Cache) Set(name string, data interface{}, ttl time.Duration, updateFunc func() interface{}) {
	c.lock.Lock()
	defer c.lock.Unlock()
	expiration := time.Now().Add(ttl)
	c.data[name] = cachedData{data: data, expiration: expiration, updateFunc: updateFunc}
}

func (c *Cache) Delete(name string) {
	c.lock.Lock()
	defer c.lock.Unlock()
	delete(c.data, name)
}

func (c *Cache) SetAutoUpdate(name string, ttl time.Duration, updateFunc func() interface{}) {
	newData := updateFunc()
	c.Set(name, newData, ttl, updateFunc)

	ticker := time.NewTicker(ttl)
	defer ticker.Stop()

	for range ticker.C {
		newData := updateFunc()
		c.Set(name, newData, ttl, updateFunc)
	}
}

func NewCache() *Cache {
	c := &Cache{
		data: make(map[string]cachedData),
	}
	return c
}
