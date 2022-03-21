package main

import (
	"Client/model"
	"encoding/json"
	"fmt"
	"github.com/nats-io/stan.go"
	"log"
)

const (
	clusterName    = "test-cluster"
	clientName     = "test-client"
	subscriberName = "subscremba"
)

func ConnectNatsStream() (stan.Conn, error) {
	sc, err := stan.Connect(clusterName, clientName,
		stan.NatsURL(stan.DefaultNatsURL),
		stan.Pings(2, 5),
		stan.SetConnectionLostHandler(func(con stan.Conn, err error) {
			log.Printf("Connection nats lost: %s", err)
		}))
	if err != nil {
		return sc, err
	}
	return sc, nil
}

func MsgProcessing(sc stan.Conn, cache *model.Cashe) error {
	handler := func(msg *stan.Msg) {
		var newItem model.Order
		if err := msg.Ack(); err != nil {
			log.Printf("error ack msg:%v", err)
		}
		//
		err := json.Unmarshal(msg.Data, &newItem)
		if err != nil {
			log.Println(fmt.Errorf("Bad nats message %s", err))
			return
		}
		err = SetDataToDB(newItem)
		if err != nil {
			fmt.Println("error with wriring to DB", err)
		}
		cache.Lock()
		cache.Memory[newItem.OrderUid] = newItem
		cache.Unlock()
		//fmt.Println("Message: ", msg)
	}

	_, err := sc.Subscribe("foo", handler, stan.DurableName(subscriberName), stan.SetManualAckMode())
	if err != nil {
		return fmt.Errorf("error subcribe: %s", err)
	}
	return nil

}
