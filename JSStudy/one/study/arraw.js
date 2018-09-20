
  function foo() {
    setTimeout(() => {
      console.log('id:', this.id);
    }, 100);
  }
  
  var id = 21;
  
  foo.call({ id: 42 });
  // id: 42

  function Timer() {
    this.s1 = 0;
    this.s2 = 0;
    // 箭头函数
    setTimeout(() => this.s1++, 1000);
    // 普通函数
    setTimeout(function () {
        console.log('this :', this);//Timeout {
      this.s2++;
    }, 1000);
  }
  
  var timer = new Timer();
  
  setTimeout(() => console.log('s1: ', timer.s1), 3100);//3
  setTimeout(() => console.log('s2: ', timer.s2), 3100);//0


/**
 * 1.箭头函数中this值在函数周期内是不会改变的 指向的是外围最近的不是箭头的函数 没有普通函数包裹则只需全局
 * 2.没有contructor 所以不能用new 没有protype属性 没有super
 * 3.没有arguments
 */
let jfun1 =()=>{
    console.log('箭头函数里的this :', this);//undefined 指向全局 严格模式  非严格模式是 window
}
jfun1();


 