imread(path, flag); 
flag: -1 以文件原格式读入
       0 灰度图读入
       1 彩色图读入

src.convertTo(dst, type, scale, shift)
       缩放并转换到另外一种数据类型：
       dst：目的矩阵；
       type：需要的输出矩阵类型，或者更明确的，是输出矩阵的深度，如果是负值（常用-1）则输出矩阵和输入矩阵类型相同；
       scale:比例因子；
       shift：将输入数组元素按比例缩放后添加的值；
       dst(i)=src(i)xscale+(shift,shift,...)