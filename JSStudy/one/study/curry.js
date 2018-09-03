
var curry = function(func){
   // var args = [].slice.call(arguments,1); //与下面等价
    let arr = Array.from(arguments);
    let args = arr.slice(1);
    console.log('arguments :', arguments);
    //arguments : { '0': [Function: add], '1': 1, '2': 2 }

    return function(){
        console.log('arguments :', arguments);//arguments : {}
      //  var newArgs = args.concat([].slice.call(arguments));
       // newArgs,arr,args : [ 1, 2 ] [ [Function: add], 1, 2 ] [ 1, 2 ]

       
        let arr2 = Array.from(arguments);
         let newArgs = args.concat(arr2);


        console.log('newArgs,arr,args :', newArgs,arr,args);
       // [ 1, 2, [Function: add], 1, 2 ] [ [Function: add], 1, 2 ] [ 1, 2 ]


        return func.apply(this,newArgs);
    }
}

function add(a, b) {
    console.log('a,b :', a,b);
    return a + b;
}

var addCurry = curry(add,1,2);
let result = addCurry(); //3
console.log('result :', result);

//或者
var addCurry = curry(add,1);
addCurry(2); //3

//或者
var addCurry = curry(add);
addCurry(1, 2) // 3
//缺点 addCurry只能调用一次  改进版

var curry = function(func,args){
    var length = func.length;
     args = args||[];//保留上次传的值

    return function(){
      let  newArgs = args.concat([].slice.call(arguments));//连接每次传入的参数
      console.log('newArgs,arguments :', newArgs,arguments);//[ 1, 2 ] { '0': 1, '1': 2 }
        if(newArgs.length < length){
           // return curry.call(this,func,newArgs);
           return curry(func,newArgs);
        }else{
            //return func.apply(this,newArgs);
            //newArgs = [ 1, 2 ] 所以用apply 或是 ...
            return func(...newArgs);
        }
    }

}

var addCurry = curry(add);
let aa1 =addCurry(1,2) //3
let aa2 = addCurry(1)(2) //3 调用(1)使得args=[1] 
console.log('aa1,aa2---------------------- :', aa1,aa2);//aa1,aa2 : 1,2undefined 1,2undefined

//其实这里的需求是我们在柯里化的过程中既能返回一个函数继续接受剩下的参数，又能就此输出当前的一个结果。
function add(){
    var args = [].slice.call(arguments);
    var fn = function(){
        console.log('fn调用 :', fn,arguments);
        var newArgs = args.concat([].slice.call(arguments));
        return add.apply(null,newArgs);
    } 
    console.log('fn.toString :', fn.toString);
    fn.toString = function(){
        return args.reduce(function(a, b) {
            return a + b;
        })
    }//不写这个 返回的就是 fn的定义的 function(){
    //     var newArgs = args.concat([].slice.call(arguments));
    //     return add.apply(null,newArgs);
    // }   写这个 返回的是个计算结果值 
    console.log('fn.toString :', fn.toString);
    console.log('fn :', fn);
    return fn ;//只是返回的是个数值 但是fn其实是个函数 可调用
}
// 当我们返回函数的时候，会调用函数的toString来完成隐式转换，
// 这样输出的就不是函数的字符串形式而是我们定义的toString返回的值。
// 这样就既可以保持返回一个函数，又能够得到一个特定的值。

let aa3 = add(1) //6 此时返回的是fn 这个函数 但是并没有调用
console.log('aa3 :', aa3);
let aa4 = aa3(2)//调用了fn(2)
//let aa4 =add(1)(2)(3)(4)(5) //15
console.log('aa4 :', aa4);