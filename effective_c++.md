# 0序言
### 每个函数的声明揭示其签名式，也就是参数和返回类型。一个函数的签名等同于该函数的类型；c++对签名的定义并不包括函数的返回类型，《effective c++》将返回值作为签名的一部分。
## 定义式的任务为提供编译器一些声明式所遗漏的细节。对对象而言，定义式是编译器为此对象拨发内存的地点，对function或function template而言，定义式提供了代码本体；对class或者class template而言,定义式列出他们的成员。
### exlicit：用来阻止执行隐式的类型转换。
### copy构造和copy赋值：如果一个新的对象被定义，一定会有个构造函数被调用。
### copy构造:Widget w3 = w2
# 1让自己习惯c++
## 条款01：视C++为一个语言联邦
### 四个次语言：c, Object-Oriented C++,Template c++,stl
### c++高校编程守则视情况而变化，取决于使用c++的哪一个部分
## 条款02：尽量以const,enum,inline替换#define(宁可以编译器替换预处理)
### #define 发生在预处理过程，其并未进入记号表
### 定义常量指针，若头文件中定义一个常量char\*based字符串，const须写两次,const char\* const authorName = "ABC",同时，string对象比char\* based合宜。const std::string autorName("ABC")
### class专属常量,为了将常量的作用域限制在class内,使它成为class的一个成员,为了确保只有一份实体,让他成为一个static成员。
```c++
class GamePlayer{
private:
    static const int NumTurns = 5; //常量声明式
    int scores[NumTurns]; //使用该常量
}

```
### 如果class专属常量是static且为整数类型，则需特殊处理，只要不取他们的地址，可以声明并使用他们而无须提供定义式。如果取某个class专属常量的地址，或者不取地址，但编译器却坚持看定义式，则需提供定义式如下：const int GamePlayer::NumTurns;// 定义。将该文件应该放在实现文件而非头文件，由于class常量已经在声明时获得初值，则定义时不可以再设初值。
```c++
class GamePlayer{
private:
    enum { NumTurns = 5 };//
    int scores[NumTurns];
}
```
### the enum hack:一个属于枚举类型的数值可权充int被使用。enum和#define一样不会导致非必要的内存分配
```c++
#define CALL_WITH_MAX(a, b) f((a)>(b) ? (a):(b))
int a = 5, b = 0;
CALL_WITH_MAX(++a, b);
CALL_WITH_MAX(++a, b+10);
```
### 在上述代码中，每次调用a会被增加两次。
```c++
template<typename T>
inline void callWithMax(const T& a, const T& b){
    f(a > b ? a:b);
}
```
### 对于单纯常量，最好以const对象或者enums替换#define
### 对于形似函数的宏(macros)，最好改用inline函数替换#defines。
## 条款03：尽可能使用const
### const出现在星号左边，表示被指物是常量；如果出现在星号右侧，则表示指针自身是常量；如果出现在星号两边，表示被指物和指针两者都是常量.
```c++
std::vector<int> vec;
const std::vector<int>::iterator iter = vec.begin();// iter的作用像个T* const
*iter = 10;  //没问题，改变iter所指物
++iter; // 错误！iter是个const
std::vector<int>::const_iterator cIter = vec.begin(); // cIter的作用像个const T*
*cIter = 10; //错误！*cIter是const
++cIter; //没问题，改变cIter
```
### const在成员函数中的位置不同则含义不同
```c++
/*
 * FunctionConst.h
 */

#ifndef FUNCTIONCONST_H_
#define FUNCTIONCONST_H_

class FunctionConst {
public:
    int value;
    FunctionConst();
    virtual ~FunctionConst();
    const int getValue();
    int getValue2() const;
};
#endif 
/*
 * FunctionConst.cpp 
  */

#include "FunctionConst.h"

FunctionConst::FunctionConst():value(100) {
     // TODO Auto-generated constructor stub
}

FunctionConst::~FunctionConst() {
        // TODO Auto-generated destructor stub
}

const int FunctionConst::getValue(){
        return value;//返回值是 const, 使用指针时很有用.
}

int FunctionConst::getValue2() const{
        //此函数不能修改class FunctionConst的成员函数 value
        value = 15;//错误的, 因为函数后面加 const
            return value;
}
```
### 位于函数之后的const表示该函数不会修改类的成员值，及该类表明为const的，不可修改的
### 使用mutable放在成员变量的前边，可以进行更改相应的变量。
### 将某些东西声明为const可帮助编译器侦测出错误用法。const可被施加于任何作用域内的对象、函数参数、函数返回类型、成员函数本体。
### 编译器强制实施bitwise constness,但你编写程序时应该使用“概念上的常量性”
### 当const 和non-const成员函数有着实质等价的实现时，令non-const版本可避免代码重复。
```c++
class TextBlock {
public:
    const char& operator[](std::size_t position) const{
        return text[position];
    }
    char& operator[](std::size_t position){
        return const_cast<char& >(
                                  static_cast<const TextBlocks&>(*this)[position];
                                 );
    }
};

```
### 对上述代码理解：static_cast<const TextBlock&>(\*this)将对象变为const，这样符合函数之后的const，上述函数调用第一个函数返回值为常量，因此通过const_cast<char&>将const去除，与返回值相匹配。
## 条款04：确定对象被使用前已被初始化
### c part of c++初始化可能招致运行期成本，那么就不保证发生初始化，一旦进入到non-c part of c++,规则就有些变化。可用于解释array不保证其内容被初始化，vector保证被初始化
### 永远在使用对象之前将它初始化，确保每一个构造函数都将对象的每一个成员初始化。
### c++规定，对象的成员变量的初始化动作发生在进入构造函数本体之前，之后的应该称为赋值，内置类型则不一定。
### 内置类型的初始化与赋值成本相同。
### 如果成员变量是const或references，那么他就一定需要初值，而不能被赋值。
### c++的成员初始化次序，base classes早于derived classes，class的成员变量总是以其声明次序被初始化。
### c++对定义于不同编译单元内的non-local static对象的初始化次序并无明确定义;编译单元是指产出单一目标文件的那些源码，基本上是单一源码文件加上其所含入的头文件;non-local static对象是global或位于namespace作用域内，亦或在class内或file作用域内被声明为static。
### 解决初始化次序问题的方法：将每个non-local static对象搬到自己的专属函数内（该对象在此函数内被声明为static），这些函数返回一个reference指向它所含的对象，然后用户调用这些函数。这是Singleton模式的一个常见实现方法。优势：在未调用该non-local static对象时，构造函数和析构函数就不会发生。
```c++
class FileSystem{...};
FileSystem& tfs(){
    static FileSystem fs;
    return fs;
}
class Directory{...};
Directory::Directory(params){
    size_t disks = tfs().numDisks();
}
Directory& temDir(){
    static Directory td;
    return td;
}
```
### 上述函数在多线程环境下会有麻烦，解决方法是：在程序的单线程启动阶段就手工调用所有的reference-returning函数。但要记住上述过程中的依赖关系。
### 为了避免在对象初始化之前过早的使用他们，第一：要手工初始化内置类型的non-member对象。第二：使用成员初值列对付成员的所有成分。第三：在初始化次序不确定性氛围下加强你的设计。
### 对内置类型对象进行手工初始化，因为c++不保证会初始化他们。
### 构造函数最好使用成员初值列，避免在构造函数本体内使用赋值操作；初值列出的成员变量的排列次序尽量和他们在class中的声明次序相同。
### 为免除跨编译单元之初始化次序问题，请以local staic对象替换non-local static对象。
