# Cursor开发环境设置指南

## 🎯 为TIME项目配置Cursor

### 1. 项目导入
```bash
# 克隆项目
git clone https://github.com/cxs00/time.git
cd time

# 用Cursor打开项目
cursor .
```

### 2. Cursor扩展推荐

#### 必需扩展
- **GitLens**: Git增强功能
- **Prettier**: 代码格式化
- **ESLint**: JavaScript代码检查
- **Swift**: Swift语言支持
- **HTML CSS Support**: HTML/CSS智能提示

#### 可选扩展
- **Auto Rename Tag**: HTML标签自动重命名
- **Bracket Pair Colorizer**: 括号配对高亮
- **Live Server**: 本地服务器
- **Git Graph**: Git可视化

### 3. 工作区配置

#### `.vscode/settings.json`
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "files.associations": {
    "*.html": "html",
    "*.css": "css",
    "*.js": "javascript",
    "*.swift": "swift"
  },
  "emmet.includeLanguages": {
    "html": "html"
  },
  "liveServer.settings.port": 8000,
  "liveServer.settings.root": "/"
}
```

#### `.vscode/tasks.json`
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "启动Web服务器",
      "type": "shell",
      "command": "python",
      "args": ["-m", "http.server", "8000"],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "new"
      }
    },
    {
      "label": "版本管理",
      "type": "shell",
      "command": "./scripts/version-traveler.sh",
      "args": ["list"],
      "group": "build"
    }
  ]
}
```

### 4. 快捷键配置

#### `.vscode/keybindings.json`
```json
[
  {
    "key": "ctrl+shift+v",
    "command": "workbench.action.tasks.runTask",
    "args": "启动Web服务器"
  },
  {
    "key": "ctrl+shift+b",
    "command": "workbench.action.tasks.runTask", 
    "args": "版本管理"
  }
]
```

## 🚀 开发工作流

### 1. 项目启动
```bash
# 在Cursor终端中
cd /path/to/TIME
cursor .

# 启动开发服务器
python -m http.server 8000
```

### 2. 版本管理
```bash
# 查看版本
./scripts/version-traveler.sh list

# 跳转版本
./scripts/version-traveler.sh go v1.0.0

# 创建新版本
./scripts/version-traveler.sh create v1.1.0
```

### 3. 调试设置

#### Web版本调试
- 打开浏览器开发者工具
- 设置断点调试JavaScript
- 使用Console查看日志

#### 原生应用调试
- 在Xcode中设置断点
- 使用Xcode调试器
- 查看控制台输出

## 📁 项目结构理解

### 核心文件
```
TIME/
├── index.html              # Web入口
├── css/style.css           # 样式
├── js/                     # JavaScript
├── time/                  # 原生应用
│   └── time.xcodeproj    # Xcode项目
└── scripts/              # 版本管理
```

### 开发重点
1. **Web版本**: 修改 `index.html`, `css/style.css`, `js/*.js`
2. **原生版本**: 修改 `time/time/` 目录下的Swift文件
3. **同步更新**: 两个版本需要保持同步

## 🔧 常用Cursor功能

### 1. 智能代码补全
- 输入时自动提示
- 函数参数提示
- 变量类型推断

### 2. 代码导航
- `Ctrl+Click`: 跳转到定义
- `F12`: 查看定义
- `Shift+F12`: 查看引用

### 3. 重构功能
- `F2`: 重命名符号
- `Ctrl+Shift+R`: 重构菜单
- 自动导入/导出

### 4. 调试功能
- 设置断点
- 单步调试
- 变量监视
- 调用堆栈

## 🎨 开发技巧

### 1. 多文件编辑
- `Ctrl+Tab`: 切换文件
- `Ctrl+Shift+E`: 文件资源管理器
- 分屏编辑

### 2. 搜索替换
- `Ctrl+F`: 当前文件搜索
- `Ctrl+Shift+F`: 全局搜索
- 正则表达式支持

### 3. Git集成
- 源代码管理面板
- 差异对比
- 提交历史

## 🚀 快速开始检查清单

- [ ] 克隆项目到本地
- [ ] 用Cursor打开项目
- [ ] 安装推荐扩展
- [ ] 配置工作区设置
- [ ] 启动开发服务器
- [ ] 测试版本管理功能
- [ ] 熟悉项目结构
- [ ] 开始开发新功能

## 💡 开发建议

### 1. 保持同步
- Web版本和原生版本使用相同的HTML/CSS/JS
- 修改后及时同步到两个版本

### 2. 版本管理
- 每次重大修改前创建版本
- 使用版本管理脚本
- 定期备份项目

### 3. 代码质量
- 使用Prettier格式化代码
- 遵循ESLint规则
- 添加必要的注释

### 4. 测试验证
- 在多个浏览器中测试
- 在iOS/macOS设备上测试
- 验证版本跳转功能
