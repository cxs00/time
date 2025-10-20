# 番茄时钟 Web 应用开发大纲

## 项目概述
一个基于Web技术栈的现代化番茄时钟应用，帮助用户提高工作效率和时间管理能力。

## 技术栈
- **HTML5** - 页面结构
- **CSS3** - 样式设计（响应式、动画、渐变）
- **JavaScript (ES6+)** - 核心逻辑
- **LocalStorage** - 数据持久化
- **Notification API** - 浏览器通知
- **Canvas/SVG** - 圆形进度条

## 文件结构
```
pomodoro-timer/
├── index.html          # 主页面
├── css/
│   └── style.css       # 主样式文件
├── js/
│   ├── timer.js        # 计时器核心逻辑
│   ├── storage.js      # 数据存储管理
│   ├── notification.js # 通知功能
│   └── statistics.js   # 统计功能
└── assets/
    ├── sounds/         # 音效文件
    └── icons/          # 图标资源
```

## 核心功能模块

### 1. 计时器核心模块 (timer.js)
**功能：**
- 倒计时功能
- 状态管理（工作/短休息/长休息）
- 番茄计数器
- 自动切换状态

**关键类/函数：**
- `PomodoroTimer` 类
  - `start()` - 开始计时
  - `pause()` - 暂停
  - `reset()` - 重置
  - `tick()` - 每秒更新
  - `switchState()` - 切换状态

**数据结构：**
```javascript
{
  state: 'work' | 'shortBreak' | 'longBreak',
  timeRemaining: 1500, // 秒
  isRunning: false,
  completedPomodoros: 0,
  currentSession: null
}
```

### 2. 用户界面模块 (index.html + style.css)
**主界面元素：**
- 圆形进度条（SVG/Canvas）
- 时间显示（MM:SS格式）
- 状态指示器
- 控制按钮区
  - 开始/暂停按钮
  - 重置按钮
  - 下一阶段按钮
- 番茄计数显示
- 导航菜单（统计、设置）

**视觉设计：**
- 现代扁平化设计
- 渐变色彩方案
- 流畅的动画过渡
- 响应式布局（移动端友好）
- 深色/浅色主题切换

### 3. 数据存储模块 (storage.js)
**功能：**
- 保存番茄时钟记录
- 读取历史数据
- 用户设置持久化

**数据模型：**
```javascript
// 番茄记录
PomodoroSession {
  id: string,
  type: 'work' | 'shortBreak' | 'longBreak',
  duration: number,
  startTime: timestamp,
  endTime: timestamp,
  completed: boolean
}

// 用户设置
Settings {
  workDuration: 25,      // 分钟
  shortBreakDuration: 5,
  longBreakDuration: 15,
  pomodorosUntilLongBreak: 4,
  soundEnabled: true,
  notificationEnabled: true,
  autoStartBreaks: false,
  autoStartPomodoros: false,
  theme: 'light' | 'dark'
}
```

### 4. 通知模块 (notification.js)
**功能：**
- 请求通知权限
- 发送完成提醒
- 播放音效

**通知类型：**
- 工作时间结束
- 休息时间结束
- 长休息提醒

### 5. 统计模块 (statistics.js)
**功能：**
- 今日统计
- 本周统计
- 历史趋势
- 数据可视化

**统计指标：**
- 完成的番茄数
- 总工作时间
- 平均每日番茄数
- 连续工作天数
- 图表展示（柱状图/折线图）

### 6. 设置模块
**可配置项：**
- 时间设置
  - 工作时长
  - 短休息时长
  - 长休息时长
  - 长休息间隔
- 通知设置
- 音效设置
- 主题设置
- 自动开始设置

## 开发步骤

### Phase 1: 基础框架 ✅
1. 创建项目大纲文档
2. 设计文件结构
3. 编写HTML基础结构
4. 编写CSS样式框架

### Phase 2: 核心功能
1. 实现计时器逻辑
2. 实现UI交互
3. 实现进度条动画
4. 状态管理和切换

### Phase 3: 数据持久化
1. LocalStorage集成
2. 数据模型设计
3. 历史记录保存

### Phase 4: 增强功能
1. 通知系统
2. 音效系统
3. 设置页面
4. 统计页面

### Phase 5: 优化和测试
1. 响应式布局优化
2. 性能优化
3. 浏览器兼容性测试
4. 用户体验优化

## UI设计方案

### 配色方案
**工作模式：**
- 主色：#E74C3C (番茄红)
- 辅助色：#C0392B (深红)
- 背景：渐变 #FF6B6B → #E74C3C

**短休息模式：**
- 主色：#3498DB (天蓝)
- 背景：渐变 #5DADE2 → #3498DB

**长休息模式：**
- 主色：#2ECC71 (绿色)
- 背景：渐变 #58D68D → #2ECC71

### 布局结构
```
+----------------------------------+
|         导航栏/Logo              |
+----------------------------------+
|                                  |
|       [圆形进度条显示器]          |
|          25:00                   |
|        工作时间                   |
|                                  |
|    [开始] [暂停] [重置]          |
|                                  |
|    🍅🍅🍅🍅 (4/8)                 |
|                                  |
+----------------------------------+
|   [统计]  [设置]  [关于]         |
+----------------------------------+
```

## 关键技术实现

### 1. 圆形进度条
使用SVG实现，通过修改`stroke-dashoffset`属性实现动画效果

### 2. 计时精度
使用`requestAnimationFrame`或`setInterval`，每秒更新一次

### 3. 后台计时
使用`localStorage`保存开始时间，页面重新打开时计算已过时间

### 4. 通知权限
```javascript
Notification.requestPermission().then(permission => {
  if (permission === 'granted') {
    new Notification('番茄时钟', { body: '工作时间结束！' });
  }
});
```

## 浏览器兼容性
- Chrome 60+
- Firefox 55+
- Safari 11+
- Edge 79+
- 移动端浏览器支持

## 后续扩展功能
- 任务列表集成
- 云同步功能
- 数据导出
- 白噪音播放
- 团队协作功能
- PWA支持（离线使用）
- 桌面应用（Electron）

## 性能优化
- 懒加载
- 代码压缩
- 资源缓存
- 防抖和节流
- 减少DOM操作

## 测试计划
- 单元测试（计时器逻辑）
- 集成测试（数据存储）
- E2E测试（用户流程）
- 性能测试
- 兼容性测试

