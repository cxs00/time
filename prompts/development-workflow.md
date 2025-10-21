# 开发流程提示词

## 开发环境设置

### 必需工具
- **Cursor IDE**: 主要开发环境
- **Python**: 本地服务器 (python -m http.server 8000)
- **Xcode**: iOS/macOS原生应用开发
- **Git**: 版本控制

### 环境配置
```bash
# 1. 克隆项目
git clone https://github.com/cxs00/time.git
cd time

# 2. 设置环境变量
./scripts/setup-collaborator.sh

# 3. 启动开发服务器
python -m http.server 8000

# 4. 打开Cursor
cursor .
```

## 开发工作流

### 1. 功能开发流程
```bash
# 创建功能分支
git checkout -b feature/new-feature

# 开发功能
# 使用Cursor AI助手实现功能

# 测试功能
# 在浏览器中测试
# 在移动设备上测试

# 提交更改
git add .
git commit -m "添加新功能"
git push origin feature/new-feature
```

### 2. 版本管理流程
```bash
# 查看所有版本
./scripts/version-traveler.sh list

# 跳转到历史版本
./scripts/version-traveler.sh go v1.0.0

# 创建新版本
./scripts/version-traveler.sh create v1.1.0

# 创建备份
./scripts/backup-version.sh v1.1.0
```

### 3. 调试流程
```bash
# 1. 检查控制台错误
# 浏览器开发者工具 -> Console

# 2. 检查网络请求
# 浏览器开发者工具 -> Network

# 3. 检查数据存储
# 浏览器开发者工具 -> Application -> Local Storage

# 4. 使用调试工具
# 设置断点调试JavaScript
# 使用console.log输出调试信息
```

## 代码规范

### JavaScript规范
```javascript
// 使用现代ES6+语法
const timer = new Timer();

// 使用有意义的变量名
const workTimeInMinutes = 25;

// 添加必要的注释
/**
 * 启动计时器
 * @param {number} duration - 计时时长(秒)
 * @param {string} type - 计时类型
 */
function startTimer(duration, type) {
    // 实现逻辑
}

// 使用const/let而不是var
const config = {
    work: 25 * 60,
    shortBreak: 5 * 60
};
```

### CSS规范
```css
/* 使用CSS变量管理主题 */
:root {
    --primary-color: #6366f1;
    --secondary-color: #8b5cf6;
    --background-color: #ffffff;
}

/* 使用语义化的类名 */
.timer-container {
    display: flex;
    flex-direction: column;
    align-items: center;
}

/* 使用响应式设计 */
@media (max-width: 768px) {
    .timer-container {
        padding: 1rem;
    }
}
```

### HTML规范
```html
<!-- 使用语义化标签 -->
<main class="timer-app">
    <section class="timer-display">
        <h1>TIME</h1>
        <div class="timer-circle">
            <span class="timer-text">25:00</span>
        </div>
    </section>
</main>

<!-- 添加必要的属性 -->
<button
    class="start-btn"
    type="button"
    aria-label="开始计时"
    data-action="start"
>
    开始
</button>
```

## 测试策略

### 功能测试
1. **计时器测试**
   - 验证时间计算准确性
   - 测试状态切换
   - 验证音效提醒

2. **数据测试**
   - 验证数据存储
   - 测试统计计算
   - 验证数据导出

3. **UI测试**
   - 测试响应式设计
   - 验证交互效果
   - 测试主题切换

### 性能测试
1. **加载性能**
   - 页面加载时间
   - 资源加载优化
   - 缓存策略

2. **运行性能**
   - 内存使用情况
   - CPU占用率
   - 电池消耗

## 部署流程

### Web版本部署
```bash
# 1. 构建项目
npm run build  # 如果有构建脚本

# 2. 推送到GitHub
git push origin main

# 3. Netlify自动部署
# 配置在netlify.toml中
```

### 原生应用部署
```bash
# 1. 在Xcode中打开项目
open time/time.xcodeproj

# 2. 配置签名和证书
# 在Xcode中设置

# 3. 创建Archive
# Product -> Archive

# 4. 分发应用
# 选择分发方式
```

## 常见问题解决

### 1. 计时器不准确
- 检查时间计算逻辑
- 验证定时器设置
- 测试不同浏览器

### 2. 数据丢失
- 检查LocalStorage权限
- 验证数据序列化
- 测试数据恢复

### 3. 样式问题
- 检查CSS加载
- 验证响应式设计
- 测试主题切换

### 4. 性能问题
- 优化资源加载
- 减少DOM操作
- 使用事件委托
