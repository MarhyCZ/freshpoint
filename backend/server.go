package main

import (
	"encoding/json"
	"fmt"
	"freshpoint/backend/freshpoint"
	"net/http"
)

func serve() {
	mux := http.NewServeMux()
	mux.Handle("/food", AllowedMethodsMiddleware(http.HandlerFunc(index)))

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

func AllowedMethodsMiddleware(next http.Handler) http.Handler {
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
