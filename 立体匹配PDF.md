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

## 端到端视差计算网络
    Disp-Net(2016)
    GC-Net(2017)
    iRestNet(2018)
    PSM-Net(2018)
    Stereo-Net(2018)
    GA-Net(2019)
    EdgejStereo(2020)


# 全局匹配算法
## 动态规划算法（dp）
    全局能量函数： E(d) = E(data) + E(smooth)
    E(data) = m(p, d) = sum(C(p,d)) 左像素与视差为d的右像素之间的匹配代价函数
    E(smooth) = sum(s(dp, dq))p,q 属于N
    N表示相邻像素对的集合，dp,dq分别代表两个相邻像素点的视差，s代表平滑项约束
    忽略了扫描线之间的视差约束，视差图有明显的条纹现象

    通过像素点间的相互约束的领域范围，产生几种树结构的DP算法
    基于控制点的双向动态规划匹配，通过事先确定的正确匹配点作为匹配控制点，在动态规划的过程中对寻优路径进行指导，降低复杂度，减少条纹瑕疵。
![](pictures/动态规划全局平滑项.png)
![](pictures/树结构DP算法图.png)