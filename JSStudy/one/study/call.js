//用法一 实现继承
//'user strict'
//bb = 3 这个会报错 因为默认是 strict 模式
console.log('this1---------=',this);//strict模式 undefine 否则是window
function Product(name,price){
    console.log('this=',this);
    this.name = name;
    this.price = price;
    if(price<0){
        throw RangeError(this.name+'的价格为负数了');
    }
}

function Food(name,price){
    let args = [].slice.call(arguments, 1);
    console.log('agrs :', args);
    Product.call(this,name,price);//实现集成作用
   //  Product(name,price);//this=undefine
   //new Product(name,price);//this= Product {}  xg-name : undefined
    this.category= 'food';
}

let xg =new  Food('西瓜','2');
console.log('xg-name :', xg.name);

///用法二
var animals = [
    {species: 'Lion', name: 'King'},
    {species: 'Whale', name: 'Fail'}
  ];
  
  for (var i = 0; i < animals.length; i++) {
    (function (i) { 
      this.print = function () { 
        console.log('#' + i  + ' ' + this.species + ': ' + this.name); 
      } 
      this.print();
    }).call(animals[i], i);//使 function (i) 里的this 指向 animals[i]
  }

//   .匿名自执行函数还可以用于在js中模拟创建块级作用域，
//   即如果使用匿名自执行函数将某些代码包裹起来可以实现块级作用域的效果，
//   减少全局变量的数量，在匿名自执行函数执行结束后变量就会被内存释放掉，从而也会节省了内存。


console.log(
    (//小括号能把我们的表达式组合分块，并且每一块，也就是每一对小括号，都有一个返回值
        function(x,y){return x+y;}
    )(2,3)
);// "5"  

//这样实现更简单 为啥要向上面那样实现呢
animals.forEach((value)=>{
    console.log('#' + i  + ' ' + value.species + ': ' + value.name); 
})

//call 用法三 调用函数指定this
function greet() {
    var reply = [this.person, 'Is An Awesome', this.role].join(' ');
    console.log(reply);
  }
  
  var i = {
    person: 'Douglas Crockford', role: 'Javascript Developer'
  };
  
  greet.call(i); // Douglas Crockford Is An Awesome Javascript Developer

 // 严格模式只允许在全局作用域或函数作用域的顶层声明函数。也就是说，不允许在非函数的代码块内声明函数。
 if (true) {
    　　　　function f() { } // 语法错误 并没有抛出异常
    　　}