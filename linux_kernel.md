## 编译linux内核
1. 指定体系架构 #export ARCH=x86 export=arm64 export CROSS\_COMPILE=aarch64-linux-gnu-
2. 指定对应的boardconfig,开发板配置, #make x86\_64\_defconfig make defconfig
3. 配置内核,对第二步的菜单的微调, #make menuconfig
4. 输出image arch/体系架构/boot/image
## 编译文件系统
1. 配置busybox为静态编译,因为编译的内核是没有c库的,编译为静态链库之后不需要额外的动态链接库;make menuconfig-\>busybox Setting ---\> Build Options ---\> Build Busybox as a static binary (no shared libs)
2. make && make install
3. 编译成功在\_\_install目录下
## 补充源码根目录\_\_install
```
# mkdir etc dev mnt //设备和挂载目录
# mkdir -p proc sys tmp //proc sys 虚拟文件系统, tmp 临时文件系统
# mkdir -p etc/init.d/ //系统启动脚本
# vim etc/fstab //挂载文件信息,busybox启动时在该文件读取挂载信息并挂载
proc        /proc           proc         defaults        0        0
tmpfs       /tmp            tmpfs    　　defaults        0        0
sysfs       /sys            sysfs        defaults        0        0
# vim etc/init.d/rcS //busybox启动时执行的代码
echo -e "Welcome to tinyLinux"
/bin/mount -a //挂载etc/fstab下的文件系统
echo -e "Remounting the root filesystem"
mount  -o  remount,rw  / //挂载根文件系统使其可读可写
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts //挂载设备文件系统
echo /sbin/mdev > /proc/sys/kernel/hotplug //处理热插拔
mdev -s
# chmod 755 etc/init.d/rcS
# vim etc/inittab //busybox启动时执行代码, busybox的配置文件,工具在此读取
::sysinit:/etc/init.d/rcS
::respawn:-/bin/sh //sh脚本
::askfirst:-/bin/sh
::ctrlaltdel:/bin/umount -a -r
# chmod 755 etc/inittab
# cd dev //创建设备节点
# mknod console c 5 1 //c 字符设备, 5 主设备号,1 次设备号
# mknod null c 1 3
# mknod tty1 c 4 1
```
## 制作根文件系统镜像文件
1. 制作空镜像文件 dd if=/dev/zero of=./rootfs.ext3 bs=1M count=32
2. 将文件格式化为ext3格式 mkfs.ext3 rootfs.ext3
3. 将镜像文件挂载,将跟文件系统复制挂载到挂载目录 mkdir fs && mount -o loop rootfs.ext3 ./fs && cp -rf ./\_\_install/\* ./fs
4. 卸载镜像文件 umount ./fs
5. 打包成gzip格式 gzip --best -c rootfs.ext3 > rootfs.img.gz
