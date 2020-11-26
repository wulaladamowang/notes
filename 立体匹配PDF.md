WTA: winner takes all
Disparity propagation (PatchMatch)
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
## 代价空间和滑动窗口
    代价窗口可以减小滑动窗口的冗余计算
## 代价聚合
    在视差图上进行滤波
        均值滤波 双边滤波（可以保留边缘特性，窗口可以开的更大， 匹配更加稳定）
        cross-based local stereo matching 自适应阈值窗口
        sgm : 能量函数，考虑视差图的平滑性 动态规划算法加速
## 视差优化
    左右一致性检测
    speckle filter
    亚像素插值