//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

print ("Hello, world")

//常量
let π = 3.1415926

//变量
var sleepTime = 9
sleepTime = 8
print(sleepTime)

var 商品价格 : Double = 3.50101

//元组（Tuple）

var (x,y,z) = (5,2,3)
x

var 课程 = (day:3,unit:"天")
课程.day

//可选类型
var addr : String?
addr = "上海市普陀区"
var what : String? = "这是什么"

addr?.isEmpty


let words = "你说是"
//字符串插入
var insertW = "\(words) 插入 \(商品价格)"
//字符串追加
var w = words
w.append("append")

for word in words {
    print(word)
}

var welcome = "welcome to shanghai"
welcome.remove(at: welcome.index(after: welcome.startIndex))
welcome.insert(contentsOf: " there ", at: welcome.index(before: welcome.endIndex))
print("+++++\(welcome)")

//集合类型:数组 set 字典

var arr : [Int]
arr = [Int](repeatElement(5, count: 3))
arr.append(1)
arr[arr.count - 1]

let arr2 = Array(1...10)
arr += arr2
arr.insert(66, at: 8)

//set 无序 且唯一
let s : Set = [1,2,3,4,1]

var a : Dictionary<String,String>
a = ["hhh":"4","ssss":"2"]

for (key,value) in a {
    print(key,value)
}

var i = 0

while i <= 100 {
    i += 1
}

//包含参数和返回类型的简写
func addNumber(x:Int , y:Int) -> Int{
    return x + y
}
addNumber(x: 1, y: 2)

func haveMethod(x : Int,y : Int ,method:(Int,Int) -> Int) -> Int{
    return method(x,y)
}
haveMethod(x: 4, y: 4, method: addNumber(x:y:))

//枚举
enum Weather{
    case snow
    case wind
    case rainy
}
Weather.snow //结合switch使用

//类
class person1{
    var id : String
    var money : String
    init(id : String,money : String) {
        self.id = id
        self.money = money
    }
}

let p = person1(id :"person" , money : "1000")
p.id
p.money

//-------错误处理 对函数加 throws
func addq() throws{
    print("错误处理")
}
//调用加 try
try addq()


//---------------------协议***************
//协议组合 &...&
protocol FileAccessPriotory {
    var  gName : String { get }
    var  pName : String { get }
}
//结构体遵从协议
struct Astruct : FileAccessPriotory {
    var gName: String
    var pName: String
}

var as1 = Astruct(gName:"王",pName:"22")
as1.gName
as1.pName
print(as1.pName)

/*------------------扩展协议-----------------------*/
let ai = 1

protocol ShowHint{
    func hint() -> String
}

extension Int: ShowHint{
    func hint() -> String {
        return "整数：\(self)"
    }
}
ai.hint()
(-34).hint()

//where即限定条件 遵守CustomStringConvertible
extension ShowHint where Self : CustomStringConvertible{
    func hint2() -> String {
        return "能显示字符串的类型：" + self.description
    }
}
3.hint2()

//collection也是一种协议 iterator.element 指其中元素
let arrC = [1,2,3,4]

extension Collection where Iterator.Element : CustomStringConvertible{
    func newDes() -> String {
        //依次转化为字符串
        let itemAsText = self.map{ $0.description }
        
        return "集合元素数目是\(self.count)," + itemAsText.joined(separator: ",")
    }
}

arrC.newDes()

//协议可多继承 class不可
//打印在控制条和playground
protocol MyPrint : CustomStringConvertible,CustomPlaygroundQuickLookable{
    
}

//类专用协议 ---只能类遵循此协议
protocol pForClass : class{
    
}

//不需要写break
let vegetable = "red pepper"
switch vegetable {
case "celerty":
    print("add some raisins_")
case "cucumber","water":
    print("water")
case let x where x.hasSuffix("pepper"):
    print("have pepper")
default:
    print("everything tastes good in soup")
}



let assumdStr : String? = "可选类型"
let forcedStr : String = assumdStr!
if assumdStr != nil {
    print("不为空")
}


let age = 3
//使用断言调试
assert(age >= 0,"age 不能小于0")













