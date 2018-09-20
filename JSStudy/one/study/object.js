console.log('**************************', );

let o2 = Object.create({}, {
    p: {
      value: 42, 
      writable: true,
      enumerable: true,
      configurable: true 
    } 
  });

  console.log('o2 :', o2);//o2 : { p: 42 }


/***代理和反射 */
let colors = [1,2,3];
colors.length = 2;
console.log('colors :', colors);//[1,2]
Object.defineProperties(colors,{
    a:{
        value:5,
        enumerable: true,
    }
})
let bb = Object.getOwnPropertyNames(colors);//[ '0', '1', 'length' ]

colors.b = 6;//这样定义的属性 描述符都是默认值
console.log('colors.b :', colors.b);//6

console.log('colors.getOwnPropertyDescriptor() :',Object.getOwnPropertyDescriptors(colors) );
// { '0': { value: 1, writable: true, enumerable: true, configurable: true },
//   '1': { value: 2, writable: true, enumerable: true, configurable: true },
//   length: 
//    { value: 2,
//      writable: true,
//      enumerable: false,
//      configurable: false } }
// a: 
// { value: 5,
//   writable: false,
//   enumerable: false,
//   configurable: false }
//b: { value: 6, writable: true, enumerable: true, configurable: true } }
console.log('colors :', colors);//colors : [ 1, 2, a: 5 ]



/***Object */


const obj = {
	foo: 123,
    get bar() { return 'abc' },
    bar2:()=>'abc2'
};
let mm = Object.getOwnPropertyDescriptors(obj)//注意后面有 s
console.log('mm :', mm);
//console.log('obj.bar :', obj.bar,obj.bar2,obj.bar2());//abc 奇怪  obj.bar()会报错
// mm : { foo: 
//     { value: 123,
//       writable: true,
//       enumerable: true,
//       configurable: true },
//    bar: 
//     { get: [Function: get bar],
//       set: undefined,
//       enumerable: true,
//       configurable: true } }
// bar2: 
// { value: [Function: bar2],
//   writable: true,
//   enumerable: true,
//   configurable: true } }


let receive = {},
    gg = {
        get name(){
            return 'bbb'
        }
    }
   Object.assign(receive,gg);
   console.log('receive :', receive); //{ name: 'bbb' }
   let des = Object.getOwnPropertyDescriptor(receive,'name');
   console.log('des.value :', des);
   //返回指定对象所有自身属性（非继承属性）的描述对象
//    { value: 'bbb',
//   writable: true,
//   enumerable: true,
//   configurable: true }
   console.log('des.get :', des.get);//undefined

   /***set get */
var age = 18;
var testsg = {
    get age (){
        return age;
    },
    set age (value){
        if(value > 100) age= new Date().getFullYear() - value;
        else age = value;
    }
};
testsg.age = 1994;
console.log(testsg.age);//24

function Person() {
    var age = new Date().getFullYear() - 18;
    var name = 'zll'
    this.name2 = 'zll2'
    Object.defineProperty(this, "age", {
        get: function () { console.log("内部存储数据为:" + age); return new Date().getFullYear() - age; },
        set: function (value) { age = value; }
    });
    Object.defineProperty(this, "age2", {
        get: function () { console.log("内部存储数据为:" + age); return new Date().getFullYear() - age; },
        set: function (value) { age = value; }
    });
}

var p = new Person();
p.age = 1994;
console.log("外部获取到的数据为:" + p.age);

//console.log('Object.getOwnPropertyDescriptor() :', Person.getOwnPropertyDescriptor(p));
console.log('Object.getOwnPropertyNames() :', Object.getOwnPropertyNames(p));//[ 'name2', 'age', 'age2' ]
let arr0 = Object.getOwnPropertyNames(Person).forEach((val, idx, array)=>{
    let dis = Object.getOwnPropertyDescriptor(Person,val);
    console.log('dis :', val,dis.value);
// dis : length 0
// dis : name Person
// dis : prototype Person {}
})




