package api

import (
	"encoding/json"
	"freshpoint/backend/database"
	"freshpoint/backend/environment"
	"log"
	"net/http"
	"time"
)

var env *environment.Env

func Serve(e *environment.Env) {
	env = e
	mux := http.NewServeMux()
	mux.Handle("/food", allowedMethodsMiddleware(http.HandlerFunc(index)))
	mux.HandleFunc("/api/devices", handleDevice)

	srv := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	err := srv.ListenAndServe()
	if err != nil {
		log.Fatalf("Could not start listening on port.")
	}
}

func index(w http.ResponseWriter, r *http.Request) {
	// if r.URL.Path != "/" {
	// 	http.NotFound(w, r)
	// 	return
	// }
	// Retrieve the data from cache
	catalog := env.Store.Catalog
	print(catalog)
	json.NewEncoder(w).Encode(catalog)
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
		env.Database.AddDevice(database.Device{
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
