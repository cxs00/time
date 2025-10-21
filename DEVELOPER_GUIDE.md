# TIME项目开发者指南

## 🎯 项目概述

TIME是一个跨平台的时间管理应用，支持：
- 🌐 Web版本 (HTML/CSS/JavaScript)
- 📱 iOS原生应用 (SwiftUI)
- 💻 macOS原生应用 (SwiftUI)

## 🚀 快速开始

### 1. 克隆项目
```bash
git clone https://github.com/cxs00/time.git
cd time
```

### 2. 使用Cursor打开项目
```bash
# 在项目根目录运行
cursor .
```

### 3. 版本管理
```bash
# 查看所有版本
./scripts/version-traveler.sh list

# 跳转到特定版本
./scripts/version-traveler.sh go v1.0.0

# 创建新版本
./scripts/version-traveler.sh create v1.1.0
```

## 🛠️ 开发环境设置

### Web开发
```bash
# 直接打开index.html或使用本地服务器
python -m http.server 8000
# 访问: http://localhost:8000
```

### iOS/macOS开发
```bash
# 打开Xcode项目
open time/time.xcodeproj

# 或使用命令行
xcodebuild -project time/time.xcodeproj -scheme time
```

## 📁 项目结构

```
TIME/
├── index.html              # Web版本入口
├── css/style.css           # 样式文件
├── js/                     # JavaScript文件
│   ├── app.js             # 主应用逻辑
│   ├── timer.js           # 计时器功能
│   ├── statistics.js      # 统计功能
│   ├── analytics.js       # 数据分析
│   └── storage.js         # 数据存储
├── time/                   # iOS/macOS项目
│   └── time.xcodeproj     # Xcode项目文件
└── docs/                   # 项目文档
```

## 🔧 开发工作流

### 1. 功能开发
```bash
# 创建功能分支
git checkout -b feature/new-feature

# 开发完成后
git add .
git commit -m "添加新功能"
git push origin feature/new-feature
```

### 2. 版本发布
```bash
# 创建新版本
./scripts/version-traveler.sh create v1.1.0

# 创建备份
./scripts/backup-version.sh v1.1.0
```

### 3. 版本回溯
```bash
# 查看所有版本
./scripts/version-traveler.sh list

# 跳转到历史版本
./scripts/version-traveler.sh go v1.0.0

# 从备份恢复
cd /path/to/project
tar -xzf /path/to/backup/time-v1.0.0-*.tar.gz
```

## 🎨 技术栈

### 前端技术
- **HTML5**: 语义化结构
- **CSS3**: 响应式设计，CSS变量
- **JavaScript ES6+**: 现代JavaScript
- **ECharts**: 数据可视化
- **LocalStorage**: 客户端数据存储

### 原生应用
- **SwiftUI**: iOS/macOS界面框架
- **WebKit**: 嵌入Web内容
- **Xcode**: 开发环境

## 📊 数据管理

### 本地存储
```javascript
// 数据存储在localStorage中
localStorage.setItem('timerData', JSON.stringify(data));
localStorage.getItem('timerData');
```

### 数据结构
```javascript
// 计时器数据
{
  workTime: 25,
  shortBreak: 5,
  longBreak: 15,
  sessions: [],
  statistics: {}
}
```

## 🚀 部署

### Web版本
- **Netlify**: 自动部署 (已配置)
- **GitHub Pages**: 静态托管
- **本地服务器**: 开发测试

### 原生应用
- **Xcode Archive**: 创建发布版本
- **App Store**: iOS应用分发
- **Mac App Store**: macOS应用分发

## 🔍 调试指南

### Web版本调试
```bash
# 浏览器开发者工具
F12 -> Console/Network/Application

# 本地服务器调试
python -m http.server 8000
```

### 原生应用调试
```bash
# Xcode调试
# 1. 设置断点
# 2. 运行调试模式
# 3. 查看控制台输出
```

## 📚 文档资源

- `docs/README.md`: 完整文档索引
- `docs/development/`: 开发相关文档
- `docs/deployment/`: 部署相关文档
- `docs/guides/`: 使用指南

## 🤝 贡献指南

### 代码规范
- 使用有意义的变量名
- 添加必要的注释
- 保持代码整洁

### 提交规范
```bash
git commit -m "类型: 简短描述

详细描述:
- 具体变更1
- 具体变更2

相关issue: #123"
```

### 版本管理
- 使用语义化版本号
- 每次发布前创建备份
- 记录版本变更日志

## 🆘 常见问题

### Q: 如何恢复项目到特定版本？
A: 使用版本管理脚本跳转或从备份恢复

### Q: Web版本和原生版本如何同步？
A: 两个版本共享相同的HTML/CSS/JS文件

### Q: 如何添加新功能？
A: 1. 创建功能分支 2. 开发功能 3. 测试 4. 合并到主分支

## 📞 支持

- GitHub Issues: 问题反馈
- 项目文档: `docs/` 目录
- 版本历史: `CHANGELOG.md`
