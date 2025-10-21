# 部署指南提示词

## Web版本部署

### 1. Netlify部署 (推荐)
```bash
# 1. 连接GitHub仓库
# 在Netlify中连接GitHub仓库

# 2. 配置构建设置
# Build command: (留空，静态站点)
# Publish directory: . (根目录)

# 3. 环境变量设置
# 在Netlify Dashboard中设置环境变量
NETLIFY_TOKEN=your_token
GITHUB_TOKEN=your_token
```

### 2. GitHub Pages部署
```bash
# 1. 启用GitHub Pages
# Repository Settings -> Pages -> Source: Deploy from a branch

# 2. 选择分支
# Branch: main
# Folder: / (root)

# 3. 访问地址
# https://username.github.io/time
```

### 3. 本地服务器部署
```bash
# 1. 启动本地服务器
python -m http.server 8000

# 2. 访问应用
# http://localhost:8000

# 3. 生产环境部署
# 使用Nginx或Apache配置静态文件服务
```

## 原生应用部署

### 1. iOS应用部署
```bash
# 1. 打开Xcode项目
open time/time.xcodeproj

# 2. 配置签名
# 在Xcode中设置Team和Bundle Identifier

# 3. 创建Archive
# Product -> Archive

# 4. 分发应用
# 选择App Store Connect或Ad Hoc分发
```

### 2. macOS应用部署
```bash
# 1. 配置macOS应用
# 在Xcode中设置macOS目标

# 2. 创建Archive
# Product -> Archive

# 3. 分发应用
# 选择Mac App Store或Direct Distribution
```

## 环境配置

### 1. 开发环境
```bash
# 环境变量配置
DEBUG_MODE=true
LOCAL_PORT=8000
API_BASE_URL=http://localhost:8000
```

### 2. 生产环境
```bash
# 环境变量配置
DEBUG_MODE=false
LOCAL_PORT=80
API_BASE_URL=https://time-2025.netlify.app
```

### 3. 环境切换
```javascript
// 环境检测
const isDevelopment = window.location.hostname === 'localhost';
const isProduction = window.location.hostname === 'time-2025.netlify.app';

// 配置设置
const config = {
    debug: isDevelopment,
    apiUrl: isDevelopment ? 'http://localhost:8000' : 'https://time-2025.netlify.app'
};
```

## 性能优化

### 1. 资源优化
```html
<!-- 压缩CSS和JS -->
<link rel="stylesheet" href="css/style.min.css">
<script src="js/app.min.js"></script>

<!-- 使用CDN -->
<script src="https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js"></script>
```

### 2. 缓存策略
```html
<!-- 设置缓存头 -->
<meta http-equiv="Cache-Control" content="max-age=31536000">
<meta http-equiv="Expires" content="31536000">
```

### 3. 压缩优化
```bash
# 使用工具压缩资源
# CSS压缩: cssnano
# JS压缩: uglify-js
# 图片压缩: imagemin
```

## 监控和分析

### 1. 性能监控
```javascript
// 性能指标收集
const performanceData = {
    loadTime: performance.timing.loadEventEnd - performance.timing.navigationStart,
    domContentLoaded: performance.timing.domContentLoadedEventEnd - performance.timing.navigationStart,
    firstPaint: performance.getEntriesByType('paint')[0].startTime
};

// 发送性能数据
sendAnalytics('performance', performanceData);
```

### 2. 错误监控
```javascript
// 全局错误监控
window.addEventListener('error', function(event) {
    const errorData = {
        message: event.error.message,
        stack: event.error.stack,
        url: event.filename,
        line: event.lineno,
        column: event.colno
    };
    
    // 发送错误报告
    sendAnalytics('error', errorData);
});
```

### 3. 用户行为分析
```javascript
// 用户行为跟踪
function trackUserAction(action, data) {
    const analyticsData = {
        action: action,
        data: data,
        timestamp: Date.now(),
        userAgent: navigator.userAgent,
        url: window.location.href
    };
    
    // 发送分析数据
    sendAnalytics('user_action', analyticsData);
}
```

## 安全配置

### 1. HTTPS配置
```bash
# 在Netlify中启用HTTPS
# 自动SSL证书配置
# 强制HTTPS重定向
```

### 2. 内容安全策略
```html
<!-- 设置CSP头 -->
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; 
               script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; 
               style-src 'self' 'unsafe-inline';">
```

### 3. 数据保护
```javascript
// 数据加密存储
function encryptData(data) {
    // 使用简单的加密算法
    return btoa(JSON.stringify(data));
}

function decryptData(encryptedData) {
    // 解密数据
    return JSON.parse(atob(encryptedData));
}
```

## 持续集成

### 1. GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Netlify

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy to Netlify
      uses: nwtgck/actions-netlify@v1.2
      with:
        publish-dir: '.'
        production-branch: main
        github-token: ${{ secrets.GITHUB_TOKEN }}
        deploy-message: "Deploy from GitHub Actions"
```

### 2. 自动测试
```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '16'
    - name: Install dependencies
      run: npm install
    - name: Run tests
      run: npm test
```

## 部署检查清单

### 部署前检查
- [ ] 代码测试通过
- [ ] 性能优化完成
- [ ] 安全配置正确
- [ ] 环境变量设置
- [ ] 监控配置完成

### 部署后验证
- [ ] 应用正常访问
- [ ] 功能正常工作
- [ ] 性能指标正常
- [ ] 错误监控正常
- [ ] 用户反馈收集

### 回滚计划
- [ ] 备份当前版本
- [ ] 准备回滚脚本
- [ ] 测试回滚流程
- [ ] 通知相关人员
