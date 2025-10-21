# 调试指南提示词

## 调试工具和方法

### 浏览器调试工具
```javascript
// 1. 控制台调试
console.log('调试信息:', data);
console.error('错误信息:', error);
console.warn('警告信息:', warning);

// 2. 断点调试
debugger; // 在代码中设置断点

// 3. 性能调试
console.time('计时器名称');
// 执行代码
console.timeEnd('计时器名称');
```

### 数据调试
```javascript
// 检查LocalStorage数据
console.log('存储的数据:', localStorage.getItem('timeData'));

// 检查计时器状态
console.log('当前状态:', timer.getState());

// 检查统计数据
console.log('统计数据:', statistics.getData());
```

### 网络调试
```javascript
// 检查资源加载
fetch('/api/data')
    .then(response => {
        console.log('响应状态:', response.status);
        return response.json();
    })
    .then(data => console.log('数据:', data))
    .catch(error => console.error('错误:', error));
```

## 常见问题诊断

### 1. 计时器问题
```javascript
// 问题：计时器不准确
// 诊断方法：
console.log('当前时间:', Date.now());
console.log('计时器状态:', timer.isRunning);
console.log('剩余时间:', timer.getRemainingTime());

// 解决方案：
// 1. 检查定时器设置
// 2. 验证时间计算逻辑
// 3. 测试不同浏览器
```

### 2. 数据存储问题
```javascript
// 问题：数据丢失
// 诊断方法：
console.log('LocalStorage支持:', typeof Storage !== 'undefined');
console.log('存储的数据:', localStorage.getItem('timeData'));
console.log('存储大小:', JSON.stringify(localStorage).length);

// 解决方案：
// 1. 检查浏览器支持
// 2. 验证数据格式
// 3. 处理存储限制
```

### 3. 样式问题
```css
/* 问题：样式不生效 */
/* 诊断方法： */
/* 1. 检查CSS选择器 */
/* 2. 验证样式优先级 */
/* 3. 测试响应式设计 */

/* 解决方案： */
/* 1. 使用浏览器开发者工具 */
/* 2. 检查CSS加载 */
/* 3. 验证媒体查询 */
```

### 4. 性能问题
```javascript
// 问题：应用运行缓慢
// 诊断方法：
console.log('内存使用:', performance.memory);
console.log('页面加载时间:', performance.timing.loadEventEnd - performance.timing.navigationStart);

// 解决方案：
// 1. 优化DOM操作
// 2. 减少重绘重排
// 3. 使用事件委托
```

## 调试技巧

### 1. 使用调试模式
```javascript
// 启用调试模式
const DEBUG = true;

if (DEBUG) {
    console.log('调试信息:', data);
    // 显示调试面板
    document.getElementById('debug-panel').style.display = 'block';
}
```

### 2. 错误处理
```javascript
// 全局错误处理
window.addEventListener('error', function(event) {
    console.error('全局错误:', event.error);
    // 发送错误报告
    sendErrorReport(event.error);
});

// Promise错误处理
Promise.reject(new Error('测试错误'))
    .catch(error => {
        console.error('Promise错误:', error);
    });
```

### 3. 性能监控
```javascript
// 性能监控
const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
        console.log('性能指标:', entry.name, entry.duration);
    }
});

observer.observe({entryTypes: ['measure', 'navigation']});
```

## 测试方法

### 1. 单元测试
```javascript
// 测试计时器功能
function testTimer() {
    const timer = new Timer();

    // 测试开始计时
    timer.start(25 * 60);
    assert(timer.isRunning === true);

    // 测试暂停
    timer.pause();
    assert(timer.isRunning === false);

    // 测试重置
    timer.reset();
    assert(timer.getRemainingTime() === 25 * 60);
}
```

### 2. 集成测试
```javascript
// 测试完整流程
function testCompleteFlow() {
    // 1. 开始计时
    startTimer();

    // 2. 等待一段时间
    setTimeout(() => {
        // 3. 检查状态
        assert(timer.getState() === 'work');

        // 4. 完成计时
        completeTimer();

        // 5. 检查数据
        assert(statistics.getTodaySessions() > 0);
    }, 1000);
}
```

### 3. 用户界面测试
```javascript
// 测试UI交互
function testUIInteraction() {
    // 点击开始按钮
    document.getElementById('start-btn').click();

    // 检查UI状态
    assert(document.getElementById('start-btn').textContent === '暂停');

    // 点击暂停按钮
    document.getElementById('start-btn').click();

    // 检查UI状态
    assert(document.getElementById('start-btn').textContent === '开始');
}
```

## 调试工具推荐

### 1. 浏览器开发者工具
- **Console**: 控制台调试
- **Network**: 网络请求调试
- **Application**: 应用数据调试
- **Performance**: 性能分析

### 2. 第三方工具
- **Lighthouse**: 性能分析
- **WebPageTest**: 页面性能测试
- **Chrome DevTools**: 高级调试功能

### 3. 移动端调试
- **Safari Web Inspector**: iOS调试
- **Chrome Remote Debugging**: Android调试
- **Weinre**: 远程调试工具

## 问题报告模板

### 错误报告格式
```markdown
## 问题描述
简要描述遇到的问题

## 重现步骤
1. 打开应用
2. 执行操作
3. 观察结果

## 预期结果
描述预期的正确行为

## 实际结果
描述实际发生的情况

## 环境信息
- 浏览器: Chrome 91.0
- 操作系统: macOS 11.0
- 设备: iPhone 12

## 调试信息
- 控制台错误: [错误信息]
- 网络请求: [请求状态]
- 数据状态: [数据内容]
```
