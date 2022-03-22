package main

import (
	"net/http"
	"testing"
)

func TestHandles(t *testing.T) {
	resp, _ := http.Get("http://localhost:8080/")
	if resp.StatusCode != 200 {
		t.Errorf("HandleBase; StatusCode not correct")
	}

	resp, _ = http.Get("http://localhost:8080/search")
	if resp.StatusCode != 200 {
		t.Errorf("HandleBase; StatusCode not correct")
	}

	resp, _ = http.Get("http://localhost:8080/badserch")
	if resp.StatusCode != 200 {
		t.Errorf("HandleBase; StatusCode not correct")
	}
}

func TestSearch(t *testing.T) {
	list := map[string]int{"1-st-test": 200, "b563feb7b2b84b6": 200,
		"c234dfg5gsdf4e": 200, "4-thtest": 200, "5": 200, "": 200}
	for key, value := range list {
		resp, _ := http.Get("http://localhost:8080/json?id=" + key)
		if resp.StatusCode != value {
			t.Errorf("HandlerJson with id = %s; statusCode not correct", key)
		}
	}
}
