map和noremap 对应的是各种映射命令的递归和非递归版本
set wildmenu 增加命令的提示功能，通过选择tab来进行选择。

<operation> <motion>
d : 剪切
p : 粘贴
y : 复制
c : 改变，删除后并进行插入
f : 寻找直到

w : 单词下一个单词
b : 单词的头部上一个单词

c i "" 在“”中change


ctl+v : 可视块
shift+v : 可视模式选中整行，通过上下键进行其他行的选择
I : 在行首插入
A : 在行尾插入

在可视模式下，通过shift+i 进入插入模式，退出之后会在所选择的可视块中执行相应的命令。

分屏并且改变窗口的大小
split
vertical split
res -5
vertical resize -5

标签页
tabe
tabnext切换标签页