package api

import (
	"encoding/json"
	"freshpoint/backend/database"
	"freshpoint/backend/environment"
	"github.com/go-chi/chi/v5"
	"log"
	"net/http"
	"strconv"
	"time"
)

var env *environment.Env

func Serve(e *environment.Env) {
	env = e
	r := chi.NewRouter()
	r.Get("/api/fridges/{fridgeId}", getFridge)
	r.Post("/api/devices", handleDevice)
	r.Get("/api/fridges", getFridgeList)

	srv := &http.Server{
		Addr:    ":8080",
		Handler: r,
	}

	err := srv.ListenAndServe()
	if err != nil {
		log.Fatalf("Could not start listening on port.")
	}
}

func getFridge(w http.ResponseWriter, r *http.Request) {
	// if r.URL.Path != "/" {
	// 	http.NotFound(w, r)
	// 	return
	// }
	// Retrieve the data from cache
	fridgeId, _ := strconv.Atoi(chi.URLParam(r, "fridgeId"))
	catalog := env.Store.Catalog[fridgeId]
	json.NewEncoder(w).Encode(catalog)
}

func getFridgeList(w http.ResponseWriter, r *http.Request) {
	fridges := env.Store.Fridges
	json.NewEncoder(w).Encode(fridges)
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
