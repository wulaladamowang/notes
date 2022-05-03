## 编译linux内核
1. 指定体系架构 #export ARCH=x86 export=arm64 export CROSS\_COMPILE=aarch64-linux-gnu-
2. 指定对应的boardconfig,开发板配置, #make x86\_64\_defconfig make defconfig
3. 配置内核,对第二步的菜单的微调, #make menuconfig
4. 输出image arch/体系架构/boot/image
## 编译文件系统
1. 配置busybox为静态编译,因为编译的内核是没有c库的,编译为静态链库之后不需要额外的动态链接库;make menuconfig-\>busybox Setting ---\> Build Options ---\> Build Busybox as a static binary (no shared libs)
2. 生成arm版本配置的.config, make\_ARCH=arm64 CROSS\_COMPILE=aarch64-linux-gnu- defconfig
3. make && make install
4. 编译成功在\_\_install目录下
5. 通过在\_install/bin/目录下查看file busybox 可以查看busybox编译的版本
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
## qemu启动
1. x86启动
```
nitrd ./busybox-1.30.0/rootfs.img.gz   \
  -append "root=/dev/ram init=/linuxrc"  \# qemu-system-x86_64 \
    -kernel ./linux-4.9.229/arch/x86_64/boot/bzImage  \\指定kernel
  -initrd ./busybox-1.30.0/rootfs.img.gz   \\指定根文件系统
  -append "root=/dev/ram init=/linuxrc"  \\init=内核在启动之后转交给文件系统的地一个程序, 一般是init,busybox是linuxrc
  -serial file:output.txt //输出日志
```
2. arm64启动
```
qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -m 2048 -smp 2 -kernel arch/arm64/boot/Image -initrd ./busybox-arm64/rootfs.img.gz --append "root=/dev/ram init=/linuxrc console=ttyAMA0"

-smp 核数目
-m 物理内存大小
-kernel 内核压缩镜像位置
-initrd rootfs位置
-nographic 不使用图形界面，不加可能会因为无法启动图形界面而失败
-append cmdline启动参数
-S 在入口处阻塞CPU
-gdb tcp::xxxx 指定通信通道为 本地tcp通道(因为是在同一个机器上)，端口号为xxxx，如果不需要指定端口号可以用-s 代替
```
3. gdb调试
- 安装gdb-multiarch
- 在一个命令行执行上述启动命令, -S -gdb
- 在另一个终端链接编译内核路径下的vmlinux文件, 执行gdb-multiarch /linux/vmlinux
- 执行下列命令进行调试
```
target romote :9000
break start_kernel
continue
step
```

