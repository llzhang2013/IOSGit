
console.log('**************************', );

class A { 
}
class B extends A  {
}
console.log('object :',  Object.getOwnPropertyNames(A),Object.getOwnPropertyNames(B));//[ 'length', 'name', 'prototype' ]
console.log('A.prototype :', A.prototype);//A {}


console.log(B.__proto__ === A); // true  第1行
console.log(B.prototype.__proto__ === A.prototype); // true 第2行
console.log(A.__proto__ === Function.prototype); // true 第3行
console.log(A.prototype.__proto__ === Object.prototype); // true 第4行

var A1 = function () {};
var B1 ={};
console.log(A1.prototype)
console.log(A1.prototype.constructor)//指向A1 
console.log(B1.prototype)
// A1 {}
//[Function: A1]
// undefined
//对象并不具有prototype属性，只有函数才有prototype属性。这就证明声明2的说法是
console.log('A1.prototype :', Object.getOwnPropertyNames(A1.prototype));// [ 'constructor' ]
console.log('object :', Object.getOwnPropertyDescriptors(A1.prototype));// 
// { constructor: 
// { value: [Function: A1],
//   writable: true,
//   enumerable: false,
//   configurable: true } }



let dic = {}
console.log('dic.__proto__ :', dic.__proto__);//{}

let arr = new Array(3);
console.log('arr.__proto__t :', arr.__proto__,arr.prototype);//arr._photo_ :  [] undefined 只有函数才有prototype
if(!Array.prototype.first) {
    Array.prototype.first = function() {
        console.log(`如果JavaScript本身不提供 first() 方法，
添加一个返回数组的第一个元素的新方法。`);
        return this[0];
    }
    
}
//arr.__proto__===Array.prototype
console.log('arr.__proto__ :', arr.__proto__,arr.prototype)//[ first: [Function] ] undefined

Array.prototype.name = '111';
console.log('arr.name :', arr.name);///111


console.log('Array.prototype :', Array.prototype);//[ first: [Function], name: '111' ]
 let arr1 = [1,2,3];

arr1.__proto__.first2 = ()=>{
    console.log('this :', this);// undefined 该如何使this指向arr1呢??? TODO
   return arr1[1]
}

// Array.prototype.third = ()=>{
//     return this[0];
// }//???TODO 箭头函数不是万能的 此时需要谁调用指向谁 所以得用普通函数

console.log('arr1.first :', arr1.first(),arr.first2());//1 2


console.log('Array.prototype :', Array.prototype);// []
//console.log(' Object.getOwnPropertyDescriptors(Array) :', Object.getOwnPropertyDescriptors(Array));
//可以获取Array所有属性的描述  即实例对象可以调用的方法 
/*{ length: 
    { value: 1,
      writable: false,
      enumerable: false,
      configurable: true },
   name: 
    { value: 'Array',
      writable: false,
      enumerable: false,
      configurable: true },
   arguments: 
    { value: null,
      writable: false,
      enumerable: false,
      configurable: false },
   caller: 
    { value: null,
      writable: false,
      enumerable: false,
      configurable: false },
   prototype:   Array是个类 有这个属性
    { value: [],
      writable: false,
      enumerable: false,
      configurable: false },
      */
let arr = [11,22,33];
//console.log(' Object.getOwnPropertyDescriptors(arr) :', Object.getOwnPropertyDescriptors(arr));
/*{ '0': 
   { value: 11,
     writable: true,
     enumerable: true,
     configurable: true },
  '1': 
   { value: 22,
     writable: true,
     enumerable: true,
     configurable: true },
  '2': 
   { value: 33,
     writable: true,
     enumerable: true,
     configurable: true },
  length: 
   { value: 3,
     writable: true,  这个可以  所以可以认为改变长度  arr.length = 1
     enumerable: false,
     configurable: false } }*/

  //   console.log(' Object.getOwnPropertyDescriptors(Array.prototype) :', Object.getOwnPropertyDescriptors(Array.prototype));
 /*    { length: 
        { value: 0,
          writable: true,
          enumerable: false,
          configurable: false },
       constructor: 
        { value: [Function: Array],//指回原构造函数
          writable: true,
          enumerable: false,
          configurable: true },
       toString: 
        { value: [Function: toString],
          writable: true,
          enumerable: false,
          configurable: true },
       toLocaleString: 
        { value: [Function: toLocaleString],
          writable: true,
          enumerable: false,
          configurable: true },
       join: 
        { value: [Function: join],
          writable: true,
          enumerable: false,
          configurable: true },
       pop: 
        { value: [Function: pop],
          writable: true,
          enumerable: false,
          configurable: true },
       push: 
        { value: [Function: push],
          writable: true,
          enumerable: false,
          configurable: true },
       reverse: 
        { value: [Function: reverse],
          writable: true,
          enumerable: false,
          configurable: true },
       shift: 
        { value: [Function: shift],
          writable: true,
          enumerable: false,
          configurable: true },
       unshift: 
        { value: [Function: unshift],
          writable: true,
          enumerable: false,
          configurable: true },
       slice: 
        { value: [Function: slice],
          writable: true,
          enumerable: false,
          configurable: true },
       splice: 
        { value: [Function: splice],
          writable: true,
          enumerable: false,
          configurable: true },*/

//name 个属性是 实现 interface Function 里的 所以只有function(Array)才有 
//splice是 interface Array<T> 里的 所以实例对象 arr 可以调用
//interface Object {
//    constructor: Function;
//Array.prototype里的  保存着实例共享的方法 
console.log('arr.name :', Array.name,arr.name);//Array undefined???
console.log('arr.__proto__ :', arr.__proto__);//[]
console.log('arr. :', arr.splice(0,1));//[ 11 ] 

//new 过程
// 1. 创建空对象；
// 　　var obj = {};
// 2. 设置新对象的constructor属性为构造函数的名称，设置新对象的__proto__属性指向构造函数的prototype对象；
// 　　obj.__proto__ = ClassA.prototype;
console.log('arr.constructor :', arr.constructor);//function Array() { [native code] }
// 3. 使用新对象调用函数，函数中的this被指向新实例对象：
// 　　ClassA.call(obj);　　//{}.构造函数();          
// 4. 将初始化完毕的新对象地址，保存到等号左边的变量中






