# 功能实现提示词

## 计时器功能实现

### 核心逻辑
```javascript
// 计时器状态管理
const TimerState = {
  WORK: 'work',
  SHORT_BREAK: 'shortBreak', 
  LONG_BREAK: 'longBreak',
  PAUSED: 'paused'
};

// 时间配置
const TimeConfig = {
  work: 25 * 60,      // 25分钟
  shortBreak: 5 * 60,  // 5分钟
  longBreak: 15 * 60   // 15分钟
};
```

### 实现要点
1. **状态管理**: 使用状态机模式管理计时器状态
2. **时间计算**: 精确的时间倒计时逻辑
3. **音效提醒**: 使用Web Audio API播放提示音
4. **数据持久化**: 使用LocalStorage保存设置和记录

## 数据统计功能

### 数据结构
```javascript
// 统计数据格式
const StatisticsData = {
  daily: {
    date: '2024-10-21',
    workSessions: 8,
    totalWorkTime: 200, // 分钟
    totalBreakTime: 40,
    efficiency: 0.85
  },
  weekly: {
    week: '2024-W43',
    totalSessions: 40,
    averageEfficiency: 0.82
  }
};
```

### 实现要点
1. **数据收集**: 实时记录计时器使用情况
2. **数据计算**: 统计各种指标和趋势
3. **数据可视化**: 使用ECharts创建图表
4. **数据导出**: 支持数据导出和备份

## UI界面设计

### 设计原则
1. **响应式设计**: 适配各种设备尺寸
2. **现代UI**: 简洁美观的界面设计
3. **用户体验**: 直观易用的交互设计
4. **主题支持**: 支持明暗主题切换

### 实现要点
1. **CSS变量**: 使用CSS自定义属性管理主题
2. **Flexbox/Grid**: 使用现代布局技术
3. **动画效果**: 流畅的过渡和动画
4. **移动端优化**: 触摸友好的交互设计

## 数据存储方案

### LocalStorage结构
```javascript
// 存储数据结构
const StorageKeys = {
  SETTINGS: 'timeSettings',
  SESSIONS: 'timeSessions', 
  STATISTICS: 'timeStatistics',
  THEME: 'timeTheme'
};
```

### 实现要点
1. **数据序列化**: JSON格式存储复杂数据
2. **数据验证**: 确保数据完整性和有效性
3. **数据迁移**: 支持数据结构升级
4. **数据清理**: 定期清理过期数据

## 原生应用集成

### WebView集成
```swift
// SwiftUI WebView实现
struct TimeWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // 配置WebView
        return webView
    }
}
```

### 实现要点
1. **资源加载**: 正确加载本地HTML/CSS/JS文件
2. **通信机制**: Web和原生应用之间的数据通信
3. **权限管理**: 处理文件访问权限
4. **性能优化**: 优化WebView性能

## 测试策略

### 功能测试
1. **计时器测试**: 验证时间计算准确性
2. **数据测试**: 验证数据存储和统计
3. **UI测试**: 验证界面响应和交互
4. **兼容性测试**: 验证跨浏览器兼容性

### 性能测试
1. **加载性能**: 页面加载时间优化
2. **运行性能**: 内存使用和CPU占用
3. **数据性能**: 大量数据的处理性能
4. **网络性能**: 资源加载优化
