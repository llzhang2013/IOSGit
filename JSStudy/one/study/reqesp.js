var pattern = new RegExp('Box','i');
var str = 'box';
console.log(pattern.test(str)); //true
var pattern = /Box/i;
var str = 'box';
console.log(pattern.test(str)); //true
var pattern = /Box/i;
var str = 'This is a box';
console.log(pattern.test(str)); //true
var pattern = /Box/i;
var str = 'box';
console.log(pattern.exec(str)); box
//返回的是数组，有就返回数组的值，没有匹配到就返回null
var str ='ss';
//console.log(pattern.exec(str)); 没有匹配到返回null
