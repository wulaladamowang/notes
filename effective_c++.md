# 0序言
## 每个函数的声明揭示其签名式，也就是参数和返回类型。一个函数的签名等同于该函数的类型；c++对签名的定义并不包括函数的返回类型，《effective c++》将返回值作为签名的一部分。
## 定义式的任务为提供编译器一些声明式所遗漏的细节。对对象而言，定义式是编译器为此对象拨发内存的地点，对function或function template而言，定义式提供了代码本体；对class或者class template而言,定义式列出他们的成员。
## exlicit：用来阻止执行隐式的类型转换。
## copy构造和copy赋值：如果一个新的对象被定义，一定会有个构造函数被调用。
### copy构造:Widget w3 = w2
# 1让自己习惯c++
## 条款01：视C++为一个语言联邦
### 四个次语言：c, Object-Oriented C++,Template c++,stl
### c++高校编程守则视情况而变化，取决于使用c++的哪一个部分
## 条款02：尽量以const,enum,inline替换#define(宁可以编译器替换预处理)
### #define 发生在预处理过程，其并未进入记号表
### 定义常量指针，若头文件中定义一个常量char\*based字符串，const须写两次,const char\* const authorName = "ABC",同时，string对象比char\* based合宜。const std::string autorName("ABC")
### class专属常量,为了将常量的作用域限制在class内,使它成为class的一个成员,为了确保只有一份实体,让他成为一个static成员。
'''
class GamePlayer{
private:
    static const int NumTurns = 5; //常量声明式
    int scores[NumTurns]; //使用该常量
}
'''
### 如果class专属常量是static且为整数类型，则需特殊处理，只要不取他们的地址，可以声明并使用他们而无须提供定义式。如果取某个class专属常量的地址，或者不取地址，但编译器却坚持看定义式，则需提供定义式如下：const int GamePlayer::NumTurns;// 定义。将该文件应该放在实现文件而非头文件，由于class常量已经在声明时获得初值，则定义时不可以再设初值。
'''
class GamePlayer{
private:
    enum { NumTurns = 5 };//
    int scores[NumTurns];
}
'''
### the enum hack:一个属于枚举类型的数值可权充int被使用。enum和#define一样不会导致非必要的内存分配
'''
\\#define CALL_WITH_MAX(a, b) f((a)>(b) ? (a):(b))
  int a = 5, b = 0;
  CALL_WITH_MAX(++a, b);
  CALL_WITH_MAX(++a, b+10);
'''
### 在上述代码中，每次调用a会被增加两次。
'''
template<typename T>
inline void callWithMax(const T& a, const T& b){
    f(a > b ? a:b);
}
'''
### 对于单纯常量，最好以const对象或者enums替换#define
### 对于形似函数的宏(macros)，最好改用inline函数替换#defines。
## 尽可能使用const


