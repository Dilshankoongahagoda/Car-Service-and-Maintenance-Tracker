#!/bin/bash
pkill -f 'app.war' 2>/dev/null || true
sleep 1
nohup java -jar /home/ubuntu/app.war --server.port=8095 > /home/ubuntu/app.log 2>&1 &
echo "App started with PID: $!"
sleep 15
tail -30 /home/ubuntu/app.log
