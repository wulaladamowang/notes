xhost +

var=$(docker ps| grep easyconnect | wc -l)
echo "wait docker stop"
while [ $var -ge 1 ]
do
  docker stop easyconnect
  var=$(docker ps | grep easyconnect | wc -l)
  sleep 1
done

var=$(docker ps -a| grep easyconnect | wc -l)
while [ $var -ge 1 ]
do
  docker rm easyconnect
  var=$(docker ps -a| grep easyconnect | wc -l)
  sleep 1
done


docker run --device /dev/net/tun --name easyconnect --cap-add NET_ADMIN -d -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority -e EXIT=1 -e DISPLAY=$DISPLAY -e URLWIN=1 -e TYPE=x11 -p 127.0.0.1:1080:1080 wulala97/easyconnect_hit /usr/local/bin/start.sh

echo "wait docker build 1 "
var=$(docker ps| grep easyconnect | wc -l)
while [ $var -le 0 ]
do
  var=$(docker ps | grep easyconnect | wc -l)
  sleep 1
done

var1=$(docker exec easyconnect ls /sys/class/net | grep tun0 | wc -l)
echo "wait docker build 2 "
while [ $var1 -le 0 ]
do 
  var1=$(docker exec easyconnect ls /sys/class/net | grep tun0 | wc -l)
  sleep 1
done

echo "wait docker build 3 "
docker stop easyconnect

echo "Finish"

xhost -