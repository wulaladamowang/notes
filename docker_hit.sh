xhost +

docker start easyconnect
echo "wait docker start"
var=$(docker ps | grep easyconnect | wc -l)
while [ $var -le 0 ]
do
  var=$(docker ps | grep easyconnect | wc -l)
  sleep 1
done

echo "wait tun0"
var1=$(docker exec easyconnect ls /sys/class/net | grep tun0 | wc -l)
while [ $var1 -le 0 ]
do 
  var1=$(docker exec easyconnect ls /sys/class/net | grep tun0 | wc -l)
  sleep 1
done


docker exec -it easyconnect /bin/bash

var=$(docker ps | grep easyconnect | wc -l)
echo "wait docker stop"
while [ $var -ge 1 ]
do
  docker stop easyconnect
  var=$(docker ps | grep easyconnect | wc -l)
  sleep 1
done

xhost -
