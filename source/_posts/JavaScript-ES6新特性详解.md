---
title: JavaScript ES6新特性详解
date: 2025-08-24 19:24:34
tags: [JavaScript, ES6, 前端开发]
categories: [前端技术, JavaScript]
description: 深入了解ES6的新特性，包括箭头函数、模板字符串、解构赋值等
---

## 概述

ES6（ECMAScript 2015）是JavaScript的一个重要版本，引入了许多新特性，极大地改善了JavaScript的开发体验。本文将详细介绍ES6的主要新特性。

<!-- more -->

## 1. let和const声明

### let声明
```javascript
// 块级作用域
if (true) {
  let x = 1;
  console.log(x); // 1
}
// console.log(x); // ReferenceError

// 没有变量提升
console.log(y); // ReferenceError
let y = 2;
```

### const声明
```javascript
// 声明常量
const PI = 3.14159;
// PI = 3.14; // TypeError

// 对象常量
const person = { name: 'Alice' };
person.name = 'Bob'; // 可以修改对象属性
// person = {}; // TypeError
```

## 2. 箭头函数

```javascript
// 传统函数
function add(a, b) {
  return a + b;
}

// 箭头函数
const add = (a, b) => a + b;

// 复杂箭头函数
const users = [
  { name: 'Alice', age: 25 },
  { name: 'Bob', age: 30 }
];

const names = users.map(user => user.name);
console.log(names); // ['Alice', 'Bob']
```

## 3. 模板字符串

```javascript
const name = 'World';
const message = `Hello, ${name}!`;

// 多行字符串
const html = `
  <div>
    <h1>${name}</h1>
    <p>Welcome to ES6!</p>
  </div>
`;

// 标签模板
function highlight(strings, ...values) {
  return strings.reduce((result, string, i) => {
    return result + string + (values[i] ? `<mark>${values[i]}</mark>` : '');
  }, '');
}

const highlighted = highlight`Hello ${name}, you have ${5} messages.`;
```

## 4. 解构赋值

### 数组解构
```javascript
const [a, b, c] = [1, 2, 3];
console.log(a, b, c); // 1 2 3

// 跳过元素
const [first, , third] = [1, 2, 3];
console.log(first, third); // 1 3

// 默认值
const [x = 10, y = 20] = [1];
console.log(x, y); // 1 20
```

### 对象解构
```javascript
const person = { name: 'Alice', age: 25, city: 'New York' };
const { name, age } = person;
console.log(name, age); // Alice 25

// 重命名
const { name: userName, age: userAge } = person;
console.log(userName, userAge); // Alice 25

// 嵌套解构
const user = {
  profile: {
    name: 'Bob',
    address: { city: 'Shanghai' }
  }
};
const { profile: { name: profileName, address: { city } } } = user;
console.log(profileName, city); // Bob Shanghai
```

## 5. 默认参数

```javascript
function greet(name = 'World', greeting = 'Hello') {
  return `${greeting}, ${name}!`;
}

console.log(greet()); // Hello, World!
console.log(greet('Alice')); // Hello, Alice!
console.log(greet('Bob', 'Hi')); // Hi, Bob!
```

## 6. 扩展运算符

```javascript
// 数组扩展
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const combined = [...arr1, ...arr2];
console.log(combined); // [1, 2, 3, 4, 5, 6]

// 对象扩展
const obj1 = { a: 1, b: 2 };
const obj2 = { c: 3, d: 4 };
const merged = { ...obj1, ...obj2 };
console.log(merged); // { a: 1, b: 2, c: 3, d: 4 }

// 函数参数
function sum(...numbers) {
  return numbers.reduce((total, num) => total + num, 0);
}
console.log(sum(1, 2, 3, 4)); // 10
```

## 7. Promise

```javascript
// 创建Promise
function fetchData() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      const success = Math.random() > 0.5;
      if (success) {
        resolve('Data fetched successfully');
      } else {
        reject(new Error('Failed to fetch data'));
      }
    }, 1000);
  });
}

// 使用Promise
fetchData()
  .then(data => console.log(data))
  .catch(error => console.error(error));

// Promise.all
const promises = [fetchData(), fetchData(), fetchData()];
Promise.all(promises)
  .then(results => console.log('All completed:', results))
  .catch(error => console.error('One failed:', error));
```

## 8. 类

```javascript
class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  greet() {
    return `Hello, I'm ${this.name}`;
  }

  static createAnonymous() {
    return new Person('Anonymous', 0);
  }
}

class Student extends Person {
  constructor(name, age, grade) {
    super(name, age);
    this.grade = grade;
  }

  study() {
    return `${this.name} is studying in grade ${this.grade}`;
  }
}

const student = new Student('Alice', 20, 'A');
console.log(student.greet()); // Hello, I'm Alice
console.log(student.study()); // Alice is studying in grade A
```

## 9. 模块

```javascript
// math.js
export const PI = 3.14159;
export function add(a, b) {
  return a + b;
}
export default function multiply(a, b) {
  return a * b;
}

// main.js
import multiply, { PI, add } from './math.js';
console.log(PI); // 3.14159
console.log(add(2, 3)); // 5
console.log(multiply(4, 5)); // 20

// 全部导入
import * as math from './math.js';
console.log(math.PI); // 3.14159
```

## 10. Map和Set

### Map
```javascript
const map = new Map();
map.set('name', 'Alice');
map.set('age', 25);
map.set(1, 'number key');

console.log(map.get('name')); // Alice
console.log(map.has('age')); // true
console.log(map.size); // 3

// 遍历Map
for (const [key, value] of map) {
  console.log(`${key}: ${value}`);
}
```

### Set
```javascript
const set = new Set([1, 2, 3, 3, 4, 4]);
console.log(set); // Set(4) {1, 2, 3, 4}

set.add(5);
set.delete(1);
console.log(set.has(2)); // true
console.log(set.size); // 4

// 数组去重
const numbers = [1, 2, 2, 3, 3, 4];
const unique = [...new Set(numbers)];
console.log(unique); // [1, 2, 3, 4]
```

## 总结

ES6为JavaScript带来了许多强大的新特性，让代码更加简洁、可读和高效。这些特性已经成为现代JavaScript开发的标准，掌握它们对于前端开发者来说是必不可少的。

在实际开发中，建议：
- 优先使用`let`和`const`代替`var`
- 合理使用箭头函数，注意`this`绑定
- 善用解构赋值简化代码
- 使用Promise处理异步操作
- 采用ES6模块系统组织代码

这些特性不仅提高了开发效率，也使JavaScript代码更加现代化和标准化。
