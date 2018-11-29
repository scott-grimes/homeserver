#!/bin/sh 
kubectl delete deployment pihole
kubectl delete svc pihole
kubectl delete svc pihole-udp
