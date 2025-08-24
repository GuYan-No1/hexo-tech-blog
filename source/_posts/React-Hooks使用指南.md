---
title: React Hooks使用指南
date: 2025-08-24 19:24:40
tags: [React, Hooks, 前端开发]
categories: [前端技术, React]
description: 全面介绍React Hooks的使用方法，包括useState、useEffect等常用Hook
---

## 概述

React Hooks是React 16.8引入的新特性，允许在函数组件中使用state和其他React特性。Hooks让我们能够在不编写class的情况下使用state以及其他的React特性。

<!-- more -->

## 1. useState Hook

`useState`是最常用的Hook，用于在函数组件中添加state。

```javascript
import React, { useState } from 'react';

function Counter() {
  // 声明一个state变量
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>你点击了 {count} 次</p>
      <button onClick={() => setCount(count + 1)}>
        点击我
      </button>
    </div>
  );
}
```
