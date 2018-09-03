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
