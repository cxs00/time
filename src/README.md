# 源代码目录

## 📁 目录结构

```
src/
├── html/                       # HTML文件
│   ├── activity-tracker.html   # 主应用入口
│   └── demo-activity-tracker.html # 功能演示页面
├── css/                        # 样式文件
│   └── activity-tracker.css   # 应用样式（1100+行）
└── js/                         # JavaScript文件
    ├── activity-tracker.js     # 活动记录核心（450行）
    ├── project-manager.js      # 项目管理（320行）
    ├── diary-memo.js          # 日记备忘（280行）
    ├── ai-classifier.js       # AI分类器（520行）
    └── app-main.js            # 主应用逻辑（420行）
```

## 🎯 文件说明

### HTML文件
- **activity-tracker.html** - 主应用入口，包含完整的Activity Tracker功能
- **demo-activity-tracker.html** - 功能演示页面，展示核心特性

### CSS文件
- **activity-tracker.css** - 应用样式文件，包含响应式设计和Material Design风格

### JavaScript文件
- **activity-tracker.js** - 智能活动记录系统核心
- **project-manager.js** - 项目进度管理系统
- **diary-memo.js** - 日记与备忘录功能
- **ai-classifier.js** - AI智能分类器
- **app-main.js** - 主应用逻辑和图表管理

## 🚀 使用方法

### 启动应用
```bash
# 启动本地服务器
./scripts/deploy/start-activity-tracker.sh

# 或直接打开
open src/html/activity-tracker.html
```

### 开发调试
```bash
# 使用浏览器开发者工具
# 检查Console输出
# 查看LocalStorage数据
```

## 🔧 开发说明

### 代码规范
- 使用ES6+语法
- 模块化设计
- 清晰的注释
- 统一的命名规范

### 调试技巧
- 使用Console.log输出调试信息
- 检查LocalStorage数据
- 使用浏览器开发者工具
- 查看Network请求

---

**维护者**: AI Assistant + User
**最后更新**: 2025年10月24日
