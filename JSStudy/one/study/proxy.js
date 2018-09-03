
//promise
function timeout(mm){
    return new Promise((resolve,reject)=>{
        setTimeout(() => {
            resolve('哈哈');
        }, mm);

    } );
}
timeout(1*1000).then((ss)=>{
    console.log('timeou :', ss);
})
//proxy
let person = {
    name:'zll'
}
let proxy = new Proxy(person, {
    get(taget,pro){//get:function 的简写
        if(pro in taget){
            return taget[pro]
        }else{
            throw new ReferenceError('哈哈 没有这个属性')
        }
    }
})

console.log(person.name)
console.log(person.age)

console.log(proxy.name)
//console.log(proxy.age) 抛出异常

//Reflect
console.log('assign' in Object);
console.log(Reflect.has(Object,'assign'));

//Generator
 function *helloGen(){
     yield 'hello';
     yield 'world';
     return 'ending';
 }

 let aa = helloGen();
 console.log('helloGen1', aa.next());
 console.log('helloGen2', aa.next());
 console.log('helloGen3', aa.next());
 console.log('helloGen4', aa.next());

//  console.log('yield= :'+(yield 123));

/*
zll
undefined
zll
true
true
helloGen1 { value: 'hello', done: false }
helloGen2 { value: 'world', done: false }
helloGen3 { value: 'ending', done: true }
helloGen4 { value: undefined, done: true }
timeou : 哈哈
*/






