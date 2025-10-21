# 项目结构模板

## 基础项目结构
```
TIME/
├── index.html              # Web版本入口
├── css/
│   └── style.css          # 样式文件
├── js/
│   ├── app.js             # 主应用逻辑
│   ├── timer.js           # 计时器功能
│   ├── statistics.js      # 统计功能
│   ├── analytics.js       # 数据分析
│   ├── storage.js         # 数据存储
│   └── notification.js    # 通知功能
├── time/                   # iOS/macOS项目
│   ├── time.xcodeproj     # Xcode项目
│   └── time/              # Swift源码
├── scripts/                # 版本管理工具
│   ├── version-traveler.sh
│   ├── backup-version.sh
│   └── setup-collaborator.sh
├── prompts/                # AI提示词库
│   ├── project-overview.md
│   ├── feature-implementation.md
│   ├── development-workflow.md
│   ├── debugging-guide.md
│   └── deployment-guide.md
├── templates/              # 项目模板
│   ├── cursor-prompt-template.md
│   ├── project-structure.md
│   └── development-checklist.md
├── docs/                   # 项目文档
│   ├── README.md
│   ├── deployment/
│   ├── development/
│   └── guides/
├── .env.template           # 环境变量模板
├── .cursorrules            # Cursor AI配置
├── .gitignore              # Git忽略文件
├── netlify.toml            # Netlify配置
└── README.md               # 项目说明
```

## 文件功能说明

### 核心文件
- `index.html` - Web应用入口，包含完整的HTML结构
- `css/style.css` - 样式文件，包含响应式设计和主题
- `js/app.js` - 主应用逻辑，处理页面交互和状态管理
- `js/timer.js` - 计时器核心功能，实现番茄工作法逻辑
- `js/statistics.js` - 统计功能，处理数据收集和计算
- `js/analytics.js` - 数据分析，使用ECharts进行可视化
- `js/storage.js` - 数据存储，使用LocalStorage管理数据

### 原生应用
- `time/time.xcodeproj` - Xcode项目文件
- `time/time/` - Swift源码目录
  - `timeApp.swift` - 应用入口
  - `ContentView.swift` - 主视图
  - `TimeWebView.swift` - WebView组件
  - `Web/` - 嵌入的Web资源

### 开发工具
- `scripts/version-traveler.sh` - 版本管理脚本
- `scripts/backup-version.sh` - 备份脚本
- `scripts/setup-collaborator.sh` - 协作者设置脚本

### AI助手支持
- `prompts/` - AI提示词库，包含各种开发场景的提示词
- `templates/` - 项目模板，用于快速开始新项目
- `.cursorrules` - Cursor AI助手配置

### 文档系统
- `docs/` - 完整项目文档
- `README.md` - 项目总览
- `QUICK_START.md` - 快速开始指南
- `DEVELOPER_GUIDE.md` - 开发者指南
- `CURSOR_SETUP.md` - Cursor配置指南

## 开发环境配置

### 必需工具
- **Cursor IDE** - 主要开发环境
- **Python** - 本地服务器
- **Xcode** - iOS/macOS开发
- **Git** - 版本控制

### 环境设置
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

### 1. 功能开发
```bash
# 创建功能分支
git checkout -b feature/new-feature

# 开发功能
# 使用Cursor AI助手实现功能

# 测试功能
# 在浏览器中测试

# 提交更改
git add .
git commit -m "添加新功能"
git push origin feature/new-feature
```

### 2. 版本管理
```bash
# 查看所有版本
./scripts/version-traveler.sh list

# 跳转到历史版本
./scripts/version-traveler.sh go v1.0.0

# 创建新版本
./scripts/version-traveler.sh create v1.1.0
```

### 3. 项目复刻
```bash
# 使用AI助手复刻项目
# 1. 阅读prompts/目录中的提示词
# 2. 使用Cursor AI助手
# 3. 按照templates/模板开发
# 4. 参考开发检查清单
```

## 最佳实践

### 代码规范
- 使用现代JavaScript语法
- 遵循响应式设计原则
- 保持代码整洁和注释
- 支持多设备适配

### 测试策略
- 功能测试
- 性能测试
- 兼容性测试
- 用户体验测试

### 部署策略
- Web版本：Netlify自动部署
- 原生应用：Xcode Archive
- 版本管理：Git标签和备份
