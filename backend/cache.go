package main

import (
	"sync"
	"time"
)

type cachedData struct {
	data       interface{}
	expiration time.Time
	updateFunc func() interface{}
}

type cache struct {
	data map[string]cachedData
	lock sync.Mutex
}

func (c *cache) Get(name string) (interface{}, bool) {
	c.lock.Lock()
	defer c.lock.Unlock()
	cachedData, ok := c.data[name]
	if !ok || cachedData.expiration.Before(time.Now()) {
		return nil, false
	}
	return cachedData.data, true
}

func (c *cache) Set(name string, data interface{}, ttl time.Duration, updateFunc func() interface{}) {
	c.lock.Lock()
	defer c.lock.Unlock()
	expiration := time.Now().Add(ttl)
	c.data[name] = cachedData{data: data, expiration: expiration, updateFunc: updateFunc}
}

func (c *cache) Delete(name string) {
	c.lock.Lock()
	defer c.lock.Unlock()
	delete(c.data, name)
}

func (c *cache) SetAutoUpdate(name string, ttl time.Duration, updateFunc func() interface{}) {
	newData := updateFunc() // Call updateFunc() initially
	c.Set(name, newData, ttl, updateFunc)

	ticker := time.NewTicker(ttl)
	defer ticker.Stop()

	for range ticker.C {
		newData := updateFunc()
		c.Set(name, newData, ttl, updateFunc)
	}
}

func newCache() *cache {
	c := &cache{
		data: make(map[string]cachedData),
	}
	return c
}
