
//***闭包 */
var person = function(){    
    //变量作用域为函数内部，外部无法访问    
    var name = "default";       
       
    return {    
       getName : function(){    
           return name;    
       },    
       setName : function(newName){    
           name = newName;    
       }    
    }    
}();    
 
//print(person.name);//直接访问，结果为undefined    
console.log(person.getName()); // default  

person.setName("abruzzi");    
console.log(person.getName());  //abruzzi 


 //***闭包 */   

//***  this */
var name = "xiangxiao";

function fun1(){
//默认严格模式 此模式下 this 不用new的话fun1() 指向undefine 
　　this.name  = "dearxiangxiao";

}

let ff1 = new fun1();
console.log('name :', name,ff1.name);//name : xiangxiao dearxiangxiao
//***立即执行函数 创建独立作用域  创建单利
function test(){
    var arr = [];
    for(var i = 0; i < 10; i++){
        console.log('i :', i);
        arr[i] = function(){
            console.log(i);
        }
     }
     return arr;
}
var myArr = test();
for(var j = 0; j < 10; j++){
    myArr[j]();//都是10 
}
//解决办法 立即执行函数
function test1(){
    var arr= [];
    for(var i = 0; i < 10; i++){
        (function(j){//立即执行函数 创建一个独立的作用域。
            arr[j] = function(){
                console.log(j);//立即执行 j为此时传来的 j
             }
          }(i))
    }
      return arr;
    }

    var myArr = test1();
    for(var j = 0; j < 10;j++){
        myArr[j]();
    }


function car() {
    var speed = 0;
    return { //返回的是一个对象
        start:function() {
            speed = 50;
        },
    getspeed:function () {
         return speed;
        }
    }
}
 
var car1 = car();
console.log('car1 :', car1.speed);//undfined 保证了私有 但是可以创建好多个
//解决办法 使用立即执行函数
let carr = (function(){
    var speed = 0;
    return { //返回的是一个对象
        start:function() {
            speed = 50;
        },
    getspeed:function () {
         return speed;
        }
    }
})()
console.log('carr :', carr.getspeed())//0
//*****立即执行函数 创建独立作用于  创建单利



let set = new WeakSet;
let key = {};
set.add(key);
console.log('set.has(key) :', set.has(key))
key = null
console.log('set.has(key) :', set.has(key))

let arr = [11,22,33];
let iterator = arr[Symbol.iterator]();
//let iterator = iterator0()
// console.log('iterator0 :', iterator);
//iterator0 : function values() { [native code] }
console.log('iterator :', iterator.next());
console.log('iterator :', iterator.next());
console.log('iterator :', iterator.next());
console.log('iterator :', iterator.next());
let ii = arr.keys();//返回的是 iterator 打印为{}
console.log('ii :', ii.next(),ii.toString());
console.log('ii :', ii.next());
console.log('ii :', ii.next());
console.log('arrvalues :', arr.values());
for(let key of arr.keys()){
    console.log('key0 :', key);
}

//map的键和值支持不同类型 有 has get delete  而dic只支持键是字符串
let mp = new Map();
mp.set('aa',1);
console.log('mp :', mp);//mp : Map { 'aa' => 1 }

console.log('ffff :', arr.keys());//{} 是空 用of怎么能打印出来呢???

for(let key in arr.keys()){
   
    console.log('key1 :', key);
}



//第一种写法
class myClass{
   static [Symbol.hasInstance](foo){
        console.log('fff',foo)
        return foo instanceof Array
    }
}

console.log([1,2,3] instanceof  myClass)

//第二种写法
class myClass2{
     [Symbol.hasInstance](foo){
         console.log('fff',foo)
         return foo instanceof Array
     }
 }
 
 console.log([1,2,3] instanceof  new myClass2())