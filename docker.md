启动交互式容器
docker run -i -t IMAGE /bin/bash
    -i --interactive=true | false 默认是false
    -t --tty=true | false 默认是false
docker run -d 采用后台形式进行运行,守护式容器
docker run -p(P) 进行端口映射
docker attach 进入守护式容器


查看容器
docker ps [-a] [-l]
    -a 显示所有的容器
    -l 列出最近的容器
docker inspect name或者序列号

运行已经运行过的dockers
docker start -i 

删除已经停止的容器
docker rm 

查看容器运行日志
docker logs [-f] [-t][--tail] 容器名
查看容器运行情况
docker top

在运行中的容器启动新的进程
docker exec [-d][-t][-i] 容器名 [COMMAND][ARGS]

停止守护式容器
docker stop
docker kill 
