package main

import (
	"Client/model"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"reflect"
	"testing"
)

func TestJson(t *testing.T) {

	var test model.Order
	file, err := os.Open("test.json")
	if err != nil {
		t.Error("File opening error")
	}
	defer file.Close()
	data, err := ioutil.ReadAll(file)
	if err != nil {
		t.Error("File reading error")
	}
	err = json.Unmarshal(data, &test)
	if err != nil {
		t.Error("Bad data to model.Order")
	}
	fmt.Println("used type:", reflect.TypeOf(test))

	return
}
