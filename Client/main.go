package main

import (
	"Client/model"
	"fmt"
	"log"
	"net/http"
)

func main() {

	mem := model.New()
	err := GetDataFromDB(mem)
	if err != nil {
		log.Fatalf("Init cache error", err)
	}
	sc, err := ConnectNatsStream()
	if err != nil {
		log.Fatal(err)
	}
	defer sc.Close()

	err = SubscribeMsg(sc, mem)
	if err != nil {
		log.Fatal(err)
	}
	Start(mem)
	err = http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Errorf(err.Error())
	}

}
