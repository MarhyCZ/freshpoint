package main

import (
	"encoding/json"
	"fmt"
	"freshpoint/backend/freshpoint"
	"freshpoint/backend/user"
	"net/http"
	"time"
)

func serve() {
	mux := http.NewServeMux()
	mux.Handle("/food", allowedMethodsMiddleware(http.HandlerFunc(index)))
	mux.HandleFunc("/api/devices", handleDevice)

	srv := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	srv.ListenAndServe()
}

func index(w http.ResponseWriter, r *http.Request) {
	// if r.URL.Path != "/" {
	// 	http.NotFound(w, r)
	// 	return
	// }
	// Retrieve the data from cache
	products, ok := c.Get("freshpoint")
	json.NewEncoder(w).Encode(products.(freshpoint.FreshPointCatalog))
	if !ok {
		fmt.Println("Could not get data from cache")
	}
}

func allowedMethodsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			next.ServeHTTP(w, r)

		case http.MethodPost:
			next.ServeHTTP(w, r)

		case http.MethodOptions:
			w.Header().Set("Allow", "GET, POST, OPTIONS")
			w.WriteHeader(http.StatusNoContent)

		default:
			w.Header().Set("Allow", "GET, POST, OPTIONS")
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
	})
}

func handleDevice(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodPost:
		decoder := json.NewDecoder(r.Body)
		t := struct {
			Token *string `json:"token"` // pointer so we can test for field absence
		}{}

		err := decoder.Decode(&t)
		if err != nil {
			// bad JSON or unrecognized json field
			print("bad json")
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		d.AddDevice(user.Device{
			Token:        *t.Token,
			RegisteredAt: time.Now(),
		})
	case http.MethodOptions:
		w.Header().Set("Allow", "POST, OPTIONS")
		w.WriteHeader(http.StatusNoContent)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}
