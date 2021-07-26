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
# 2构造/析构/赋值操作
## 条款05：了解c++默默编写并调用哪些函数
### 如果自己没有声明，编译器会声明一个copy构造函数、一个copy assignment操作符和一个析构函数。如果没有声明任何构造函数，编译器会声明一个default构造函数，这些函数都是public且inline函数。
```c++
class Empty {};

class Empty {
public:
    Empty(){...}//default构造函数
    Empty(const Empty& rhs){...}//copy构造函数
    ~Empty() {...}//析构函数

    Empty& operator=(const Empty& rhs){...}//copy assignment操作符
};
```
### 当上述函数被需要时，它们才会被编译器创造出来。
### 编译器产出的析构函数是个non-virtual，除非这个class的base class自身声明有virtual析构函数，这个情况下这个函数的虚属性，主要来自base class
### copy构造函数和copy assignment操作符，编译器创建的版本只是单纯地将来源对象的每一个non-static成员变量拷贝到目标对象。
### 当自己声明了一个构造函数，编译器是不再为它创建default构造函数.
### 没有声明copy构造函数和copy assignment操作符时，编译器会创造这些函数，如果他们被调用的话。
### 面对类中的reference和const成员变量，默认copy assignment无能为力，此时应该自定义copy assignment函数；当base classes将copy assignment对象声明为private时.编译器为derived classes所生的copy assignment操作符想象中可以处理base class成分，但是，它们无法调用derived class无权调用的成员函数，编译器也无能为力。
### 编译器可以暗自为class创建default构造函数、copy构造函数、copy assignment操作符以及析构函数。
## 条款06：若不想使用编译器自动生成的函数，就该明确拒绝。
### 将copy构造函数和copy assignment操作符声明为private可以做到不支持拷贝构造，但是其member函数以及friend函数会可以调用。
### 专门设计函数用于阻止copying动作，将其作为base class。
```c++
class Uncopyable{
protected:
    Uncopyable(){};
    ~Uncopyable(){};
private:
    Uncopyable(const Uncopyable&);
    Uncopyable& operator=(const Uncopyable&);
};
class HomeForSale :private Uncopyable {

};
```
### 任何一个member函数以及friend函数尝试拷贝HomeForSale对象，编译器便尝试着生成一个copy构造函数和copy assignment操作符号.但是，这些编译器生成版会调用base class的对应兄弟，调用会被编译器拒绝，因为其base class的拷贝函数是private。
### 为驳回编译器自动(暗自)提供的机能，可将；相应的成员函数声明为private并且不予实现，使用像Uncopyable这样的base class也是一种做法。
## 条款07：为多态基类声明为virtual析构函数
### 某个函数返回的函数为子类的对象，但是函数返回值为基类类型，在使用delete时，则只有基类部分被释放掉，造成了资源的浪费；解决上述问题的方式为给base class一个virtual析构函数，此时会消除整个对象。
### 任何一个class只要带有virtual函数都几乎确定应该也有一个virtual析构函数。
### 只有当class内含有至少一个virtual函数，才将其声明为virtual析构函数；如果class不含virtual函数，通常表示他并不意图被用作一个base class。
### pure virtual函数导致abstract classes，也就是不能被实体化的class。
```c++
class AWOV {
public:
    virtual ~AWOV() = 0; //声明pure virtual 析构函数
};
AWOV::~AWOV(){};//pure virtual析构函数的定义
```
### polymorphic base classes 应该声明为一个virtual析构函数，如果class带有任何virtual函数，他就应该拥有一个virtual析构函数。
### Classes的设计目的如果不是作为base classes使用，或不是为了具备多态性，就不应声明为virtual析构函数。
## 条款08：别让异常逃离析构函数
### 将析构函数利用try catch进行处理，利用std::abort()函数，此时仍然是异常吞掉。
### 通过设置标志位进行资源的释放。
```c++
class DBConnection{
public:
    static DBConnection create();
    void close();
};
class DBConn{
public:
    void close(){
        db.close();
        closed = true;
    }
    ~DBConn(){
        if (!closed){
            try{
                db.close();
            }
            catch(...){

            }
        }
    }
private:
    DBConnection db;
    bool closed;
};
```
### 析构函数绝对不要吐出异常。如果一个被析构函数调用的函数可能抛出异常，析构函数应该捕捉任何异常，然后吞下它们或结束程序。
### 如果客户需要对某个操作函数运行时期间抛出的异常作出反应，那么class应该提供一个普通函数（而非在析构函数）中执行该操作。
## 条款09：绝不在构造和析构过程中调用virtual函数
### 因为derived classes函数的成员变量可能处于未定义的状态，则在base class构造和析构期间调用的virtual函数不可下降至derived classe。
## 条款10：令operator=返回一个reference to \*this
```c++
class Widget{
public:
    ...
        Widget& operator=(const Widget& rhs){

            return *this;
        }
}
```
## 条款11：在operator=中处理“自我赋值”
```c++
Widget& Widget::operator=(const Widget& rhs){
    if (this == &rhs) return *this;
    delete pb;
    pb = new Bitmap(*rhs.pb);
    return *this;
};

```
### 上述代码在保证异常安全性上有一定的效果，但是当new失败时，这种仍然会产生异常
```c++
Widget& Widget::operator=(const Widget& rhs){
    Bitmap* pOrig = pb;
    pb = new Bitmap(*rhs.pb);
    delete pOrig;
    return *this;
};
```
### 上述代码可以保证在new失败时仍然可以保存原先的数据。
```c++
class Widget{
    ...
        void swap(Widget& rhs);
    
};
Widget& Widget::operator=(const Widget& rhs){
    Widget temp(rhs);
    swap(temp);
    return *this;
};
Widget& Widget::operator=(Widget rhs){
    swap(rhs);
    return *this;
};
```
### 上述使用copy and swap 技术，swap函数用于交换\*this和rhs的数据
### 上述使用某class的copy assignment操作符或者使用by value方式进行接受实参
## 条款12：复制对象时勿忘掉其每一个成分
### copying函数时，其对象中的基类若没被赋值，则会被基类中的构造函数执行缺省的初始化动作；在copy assignment时会对基类中的成员变量保持不变；因此，在派生类中应该注意变量的赋值。o### 不该利用copy assignment操作符调用copy构造函数；两者之间不要直接相会构造，如果两者之间有相似的代码，可以通过建立一个新的成员函数供两者使用。
### Copying 函数应该确保复制“对象内的所有成员变量”及所有base class成分“。
# 3资源管理。
### c++程序中最常使用的资源就是动态分配内存，其他的常见的资源还包括文件描述器、互斥锁、图形界面中的字型和笔刷、数据库连接、以及网络sockets。
### 工厂函数：通过指针返回动态分配的对象，可以通过标识位，将返回值类型为基类，但是动态分配的类型是不同的派生类，注意在分配之后内存的释放。
### 在释放内存的过程中，如果通过函数则函数中途异常则可能导致；资源无法释放。
### 将资源放在对象内，通过析构函数自动调用机制确保资源被释放。
### 标准库的auto\_ptr是个类指针对象,其析构函数自动对其所指对象调用delete。
```c++
void f(){
    std::auto_ptr<Investment> pInv(createInvestment());//调用factory函数
}
```
### 获取资源后立即放进管理对象，资源获得时机便是初始化时机。
### 管理对象运用析构函数确保资源被释放。
### 注意不要让多个auto\_ptr指向同一对象，可能会导致对象被删除多次，从而引发未定义的行为。
### auto\_ptr的性质：若通过copy构造函数或copy assignment操作符复制他们，它们会变成null，而复制所得的指针将取得资源的唯一拥有权。
```c++
std::auto\_ptr<Investment>
pInv1(createInvestment());
std::auto\_ptr<Investment> pInv2(pInv1);//现在pInv2指向对象，pInv1被设为null
pInv1 = pInv2;//pInv2被设为null
```
### auto\_ptr的替代方案是“引用计数型智慧指针”(reference-counting smart pointer:RCSP)
### auto\_ptr和tr1::shared\_ptr两者在其析构函数内做delete而不是delete[]动作，意味着动态分配而得的array身上使用上述两个智能指针是不好的。
### resource acquisition is initialization:RAII
## 条款14：在资源管理类中小心copying行为
### 假设使用c API函数处理类型为Mutex的互斥
```c++
void lock(Mutex* pm);
void unlock(Mutex* pm);
class Lock{
public:
    explicit Lock(Mutex* pm):mutexPtr(pm, unlock){
        lock(mutexPtr.get());
    }
private:
    std::tr1::shared_ptr<Mutex> mutexPtr;
};
```
### 当一个RAII对象被复制时会发生什么事情:禁止复制，对底层资源使用引用计数法，复制底部资源，转移底部资源的拥有权。
## 条款15：在资源管理类中提供对原始资源的访问
### tr1::shared\_ptr和auto\_ptr函数提供get()成员函数，用于执行显式转换，返回智能指针内部的原始指针(的复件)
### 隐式转换函数
```c++
class Font{
public:
    operator FontHandle() const
    {
        return f;
    }
}
```
### APIs往往要求访问原始数据，所以每个RAII class应该提供一个取得其所管理资源的方式
### 对原始资源的访问可能经过显式转换或者隐式转换，一般而言，显式转换比较安全，但是隐式转换对客户比较方便。
## 条款16：成对使用new和delete时要采用相同的形式
### 因为数组中包含数组的大小，因此在new中使用了中括号，则在delete中也要使用中括号，如果没有中括号，则在delete中不应该添加中括号。
## 条款17：以独立语句将newed对象置入智能指针
### 智能指针的转换是显式的，不可以进行隐式转换。
# 4设计与声明
### 所谓软件设计局，是令软件作出你希望它做的事情。
## 条款18：让接口容易被正确使用，不易被误用
```c++
struct Day {
    explicit Day(int d):val(d){};
    int val;
};
struct Month {
    explicit Month(int m):val(m){

    }
    int val;
};
struct Year {
    explicit Year(int y):val(y){};
    int val;
};
class Date{
public:
    Date(const Month& m,const Day& d, const Year& y);
}
```
### 阻止误用的办法包括建立新类型、限制类型上的操作、束缚对象值以及消除客户的资源管理责任。
## 条款19：设计class犹如设计type
## 条款20：宁以pass-by-reference-to-const替换pass-by-value
### 尽量以pass-by-reference-to-const替换pass-by-value。前者通常比较高效，并且可以避免切割问题。
### 以上规则并不适用于内置类型，以及stl的迭代器和函数对象，对他们而言，pass-by-value往往比较妥当。
### 切割问题：当一个derived class对象以by value方式传递并被视为一个base class对象，base class的copy构造函数会被调用，而造成此对象的行为像个derived class对象的那些特化性质会被全切割掉了，仅仅留下一个base class对象。通过pass-by-reference-to-const本质上是指针的操作可以使得解决切割现象。
## 条款21：必须返回对象时，别妄想返回其reference
### 不要返回一个pointer或reference指向一个local stack对象，或者指向一个local static对象，以为有时可能需要多个这样的对象。
## 条款22：将成员变量声明为private
### protected并不比public更具封装性
## 条款23：宁以non-member,no-friend替换member函数
### 越多的东西被封装，越少的人可以看到他，我们就越有较大的弹性去改变他。越多东西被封装，我们改变那些东西的能力也就越大。封装时的能够改变事物只影响有限客户。
### 考虑对象内的数据，越少的代码可以看到数据，越多的数据可以被封装，也就越有自由的改变对象数据。越多函数可以访问他，数据的封装性就越低。
### 有时候non-member non-friend函数比member函数更好，因为他不会改变能够访问class内之private成分的函数数量，就有更大的封装性。
### 使用non-member non-friend函数替换member 函数，可以增加封装性、包裹弹性和机能扩展性。## 条款24：若所有参数皆需要类型转换，请为此采用non-member函数
### 如果你需要为某个函数的所有参数进行类型转换，采用non member函数。
## 条款25：考虑写出一个不抛出异常的swap函数
### c++不支持函数版本的偏特化版本
# 5:实现
## 条款26：尽可能延后变量定义式出现时间


