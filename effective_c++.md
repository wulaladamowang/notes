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
### 延后定义直到能够给它初值实参为止。
### 如果classes的一个赋值成本小于一组构造加析构成本，那么将变量定义在循环之外更好，否则，将变量定义在循环之内。
## 条款27：尽量少做转型动作
### c++中的四种新式转型方法：const\_cast<T>(expression),dynamic\_cast<T>(expression),reinterpret\_cast<T>(expression),static\_cast<T>(expression);
### const\_cast通常用来将对象的常量性移除。
### dynamic\_cast主要用来执行安全向下转型，也就是用来决定某个对象是否归属继承体系中的某个类型。
### reinterpret\_cast意图执行低级转型，实际动作取决于编译器，其不可移植,例如将一个pointer to int转型为int。
### static\_cast用来强迫隐式转换,例如将non-const对象转换为const对象，int转换为double对象.
### (T)expression 和T(expression)称为旧式转型
### 在注重效率的代码中避免dynamic_casts。
### 使用新式转型方式，而非旧式转型方式，其容易辨识。
## 条款28：避免返回handles指向对象内部成分
### 成员变量的封装性最多只等于返回其reference的函数的访问级别。
### const成员函数传出一个reference，后者所指数据与对象自身有关联，而他又存储在对象之外，那末这个函数的调用者可以修改那笔数据。
### 成员函数返回references、指针、和迭代器统称为handles，返回一个代表对象内部的handle会导致降低对象的封装性，即使是const成员函数也有可能造成对象状态被更改。
### 可以令返回reference为const,但有可能导致dangling handles,空悬。
## 条款29：为“异常安全”而努力是值得的
### 函数调用失败，程序回复到调用函数之前的状态。
### 不要为了表示某件事情发生而改变对象状态，除非那件事情真的发生了。
### copy and swap:为打算修改的对象写一份副本，在副本上作一切必要的修改，若任何修改动作抛出异常，原对象仍可保持未改变状态，待所有改变都成功之后，再将改过的那个副本和原对象在一个不抛出异常的操作中置换。实现上是将原对象放进另一个对象中，然后赋予原对象一个指针，指向那个所谓的实现对象，这种手法通常称为pimpl idiom。
### 异常安全函数即使发生异常也不会泄漏资源或允许任何数据结构遭到破坏，这样的函数区分有三种可能的保证：基本型、强烈型、不抛异常型。
### 强烈保证往往可以通过copy-and-swap实现出来，但强烈保证并非对所有函数都可实现或具备现实意义。
### 函数提供的异常安全保证通常最高只等于其所调用的各个函数的异常安全保证中的最弱者。
### 基本承诺：如果异常被抛出，程序内的任何事物仍然保持在有效状态下，没有数据或对象因此被破坏， 所有对象均处于一种前后一致的状态。
### 强烈保证：如果异常被抛出，程序状态不会被改变，调用这样的函数需要这样的认知，如果函数成功，则就是完全成功，如果函数调用失败，则程序会恢复到调用函数之前的状态。只是提供基本承诺的函数，在出现异常之后，则程序可能出现在任何状态，只要是个合法状态。
### 不抛掷异常保证：承诺绝不抛出异常，因为他们总是能够完成他们承诺的功能。
## 条款30：透彻了解inlining的里里外外
### inline函数背后的整体观念是将对函数的每一个调用都以函数本体进行替换；inline造成的代码膨胀也会可能导致额外的换页行为，降低指令高速缓存装置中的击中率，以及伴随而来的效率损失；如果inline函数的本体很小，其也可能导致代码的减小和效率的提升。
### Inline函数通常被置于头文件内，因为大多数的建置环境在编译过程中进行inlining，而为了将一个函数调用替换为被调用函数的本体，则编译器必须知道那个函数是什么样子。
### 所有对virtual函数的调用（除非是最平淡无奇的）也会使inlining落空；因为虚函数在运行时才会确定调用哪个函数。
### 编译器通常不会对通过函数指针而进行的调用实施inlining。
### inline函数无法随着程序库的升级而升级，如果一旦改变一个inline函数，则进行改变函数时，整个客户端程序需要被重新编译。
### 大部分的调试器对inline函数束手无策。
### 80-20经验法则：平均而言，一个程序将80%的执行时间花费在20%的代码上。作为一个软件开发者，目标是找出可以有效增进程序整体效率的20%的代码上。作为一个软件开发者，目标是找出可以有效增进程序整体效率的20%。
## 条款31：将文件间的编译依存关系降至最低
### 支持编译依存性最小化的一般构想时：相依于声明式，不要依存于定义式。基于此构想的两个手段是:handle classes和Interface class。
# 6继承与面向对象设计
## 条款32：确定你的public继承塑模出is-a关系
### 如果令class D以public形式继承class B，便是告诉c++编译器，每一个类型D对象同时也是一个类型为B的对象。
## 避免遮掩继承而来的名称
### drived classes内的名称会遮掩base classes内的名称，在public继承下从来没有人希望如此。
### 为了使得遮掩的名称重见天日，可以使用using声明式或转交函数。
## 条款34：区分接口继承和实现继承
### 声明一个pure virtual函数的目的是为了让derived classes只是继承函数接口。
### 声明简朴的impure virtual函数的目的，是让derived classes继承该函数的接口和缺省实现。
### 声明non-virtual函数的目的是为了令derived classes继承函数的接口及一份强制性的实现。
## 条款35：考虑virtual函数以外的其他选择
### NVI(non-virtual interface)手法：令客户通过public non-virtual成员函数间接调用private virtual函数。
### 使用NVI手法可以保证在virtual函数真正被调用之前能够设定好适当场景，在结束之后能够清理现场。
### NVI手法允许derived classes重新定义virtual函数，从而赋予他们如何实现机能的控制能力，但是base class保留诉说函数何时被调用的权利。NVI手法对public virtual函数是一个有趣的替代方案。
### 藉由Function Pointer实现Strategy模式
```c++
class GameCharacter;
int defaultHealthCalc(const GameCharacter& gc);//缺省算法
class GameCharacter{
public:
    typedef int (*HealthCalcFunc)(const GameCharacter&);
    explicit GameCharacter(HealthCalcFunc hcf = defaultHealthCalc):healthFunc(hcf){}
    int healthValue() const{return healthFunc(*this);}
private:
    HealthCalcFunc healthFunc;
};
class EvilBadGuy: public GameCharacter{
public:
    explicit EvilBadGuy(HealthCalcFunc hcf = defaultHealthCalc):GameCharacter(hcf){}

};
int loseHealthQuickly(const GameCharacter&);
int loseHealthSlowly(const GameCharacter&);
EvilBadGuy ebg1(loseHealthSlowly);
EvilBadGuy ebg2(loseHealthQuickly);
```
### 通过指针可以在运行时确定调用不同的函数
### 藉由tr1::function完成Strategy模式，形成对象，参数进行隐形转换就可以使用
## 条款36：绝不定义继承而来的non-virtual函数
## 条款37：绝不重新定义继承而来的缺省参数数值
### virtual 函数是动态绑定的，而缺省参数值是静态绑定的。
### 静态类型是目标对象声明的类型，动态类型是目标对象所指的对象。
## 条款38：通过复合塑模出has-a或根据某物实现出
### 复合的意义和public继承完全不同
### 在应用域，复合意味has-a。在实现域，复合意味者根据某物实现出。如通过deque实现stack
## 条款39：明智而谨慎的使用private继承
### private base class继承而来的所有成员，在derived class中会变成private属性，纵使他们在base class中原来是protected或public属性；private意味着implemented-in-terms-of(根据某物实现出)；如果使用class D以private 形式继承B,则用意为采用B内已经具备的某些特性，不是因为BD有任何观念上的关系。
### private继承意味着is-implemented-in-term of,他通常使用情况比复合的级别底，但是当derived class需要访问projected base class的成员，或需要重新定义继承而来的virtual函数时，这么设计是合理的。
### 和复合不同的是，private继承可以造成empty base最优化，这对致力于对象尺寸最小化的程序库开发者而言可能很重要。
## 条款40：明智而审慎地使用多重继承
### 多重继承比单一继承复杂。他可能导致新的歧义性，以及对virtual继承的需要。
### virtual继承会增加大小、速度、初始化复杂度等等成本，如果virtual base classes不带任何数据，将是最具实用价值的情况。
### 多重继承的确有重要的正当用途。其中一个情节及public继承某个interface class，和private 继承某个协助实现的class的两相组合。
# 7模板和泛型编程
## 条款41：了解隐式接口和编译期多态
### 运行期多态和编译期多态之间的差异类似于哪一个重载函数应该被调用和哪一个virtual函数应该被绑定之间的差异。
### 通常显式接口由函数的签名式（也就是函数名称、参数类型、返回类型）构成;隐式接口由有效表达式组成。
## 条款42：了解typename的双重意义
### 声明template参数时，不论使用关键字class或typename意义完全相同。
### template内出现的名称相依于某个template参数，称之为从属名称。如果从属名称在class内呈现嵌套状，则称他为嵌套从属名称；不依赖任何template参数的名称的类型，如int称之为非从属名称。
### 由于嵌套从属名称依赖于template参数，在未确定参数时，无法解析，因此c++默认解析嵌套从属名称不是类型，除非我们告诉他是，通过在嵌套从属名称之前添加typename ，可以说明嵌套从属名称是一个类型。
```c++
template<typename C>
void print2nd(const C& container){
    if (container.size() >= 2){
        typename C::const_iterator iter(container.begin());
    }
}
//上述C::const_iterator iter即为一个嵌套从属名称
template<typename>// 允许使用“typename”或者"class"
void f(const C& container,//不允许使用typename,C并非嵌套于任何取决于template参数的东西内
       typename C::iterator iter);//一定要使用typename
```
### 上述规则的例外是：typename不可以出现在base classes list内的嵌套从属类型名称之前，也不可出现在member initialization list(成员初值列)中作为base class 修饰符。
```c++
template<typename T>
class Derived: public Base<T>::Nested {//base class list中不允许typename
public:
    explicit Derived(int x):Base<T>::Nested(x) // mem init.list中
    {
        typename Base<T>::Nested temp;//嵌套从属类型，既不在base class list中，也不在mem.init.list中，作为base class修饰符需要加上typename
    }
};
template<typename T>
void workWithIterator(T iter){
    typedef typename std::iterator_traits<T>::value_type value_type;
    value_type temp(*iter);
};
```
## 条款43：学习处理模板化基类内的名称
### 可以在derived class templates 内通过this->指涉base class templates内的成员名称，或藉由一个明白写出的base class资格修饰符完成。using  或者知名类名称。
## 条款44：将与参数无关的的代码抽离templates
## 条款45：运用成员函数模板接受所有兼容类型
```c++
// member function
template<typename T>
class SmartPtr {
public:
    template<typename U>
        SmartPtr(const SmartPtr<U>& other);
};
template<typename T>
class SmartPtr{
public:
    template<typename U>
        SmartPtr(const SmartPtr<U>& other): heldPtr(other.get()) {...};
    T* get() const {return heldPtr;};
private:
    T* heldPtr;
};
//以类型为U*的指针初始化，只有当存在一个隐式转换时才会通过编译
```
### 在声明member templates用于泛化copy构造或泛化assignment操作，还是需要声明正常的copy 构造函数和copy assignment操作符。
## 条款46：需要类型转换时请为模板定义非成员函数
### template在进行实参推导过程中不会将隐式转换转换考虑在内。template中功能是通过参数确定是否有函数，而不可通过函数去推导参数。
### class templates不依赖template实参推导，因为参数在调用过程中已经传递进去。
```c++
template<typename T>
class Retional {
public:
    friend const Rational operator*(const Rational& lhs, const Rational& rhs){};
}
//声明为友元函数之后可以进行隐式转化,声明式不够，需要定义在模板类中。
```
### 在一个class template内，template名称可以被用来作为template和其参数的简略表达方式。
## 条款47：请使用traits classes表现类型信息
## 认识template元编程
# 8定制new和delete
## 条款49：了解new-handler的行为
## 条款50：了解new和delete的合理替换时机
## 条款51：编写new和delete时需要固守常规
## 条款52: 写了placement new 也要写placement delete
