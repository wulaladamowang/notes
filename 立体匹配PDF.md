WTA: winner takes all
TAD: truncated absolute differences (TAD)
    e(x, y, d) = min{|Ir(x, y)-It(x+d, y)|, T}

## 双目视觉的基础
    视差加三角化
    极线约束
## 立体匹配的难点
    颜色/亮度差异和噪声
    反光区域
    倾斜面
    弱纹理区域
    重复纹理
    透明物体
    遮挡和不连续
    透视变形
## 匹配方法
    局部方法
    全局方法
        图割
        置信度传播
    半全局方法
        SGM
## 直接匹配的问题
    存在冗余计算
## 立体匹配流程
    匹配代价计算
    代价聚合
    视差计算
    视差优化/后处理
## 匹配代价计算
    AD/BT 灰度值相减， BT算法考虑了像素点的采样
    AD+Gradient 增加梯度
    census 进行二值编码，汉明距离
    NCC 向量余弦
    AD+Census 加权
    CNN   