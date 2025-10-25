# 🚀 快速开始指南

## 📋 环境检查
在开始开发前，请确保你的环境满足以下要求：

### ✅ 必需软件
- **macOS** (用于iOS/macOS开发)
- **Xcode** (最新版本)
- **Python 3** (用于本地服务器)
- **Git** (版本控制)

### 🔧 可选软件
- **Cursor** (推荐IDE)
- **Node.js** (用于高级开发)

## 🎯 三种启动方式

### 方式1: Web版本 (最简单)
```bash
# 1. 进入项目目录
cd /path/to/time

# 2. 启动本地服务器
python3 -m http.server 8000

# 3. 打开浏览器
open http://localhost:8000/src/html/activity-tracker.html
```

### 方式2: iOS模拟器
```bash
# 1. 进入Xcode项目目录
cd time/time

# 2. 构建iOS应用
xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=iOS Simulator,name=iPhone 17'

# 3. 安装并启动
xcrun simctl install booted /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app
xcrun simctl launch booted -1.time
```

### 方式3: macOS应用
```bash
# 1. 进入Xcode项目目录
cd time/time

# 2. 构建macOS应用
xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=macOS'

# 3. 启动应用
open /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug/TIME.app
```

## 🔍 验证安装

### Web版本验证
1. 打开浏览器访问 `http://localhost:8000/src/html/activity-tracker.html`
2. 检查是否显示"Activity Tracker"标题
3. 点击各个导航按钮测试功能
4. 查看是否有数据显示

### iOS/macOS验证
1. 应用启动后检查界面是否正常
2. 测试导航功能
3. 查看数据是否正常显示
4. 检查响应式布局

## 🛠️ 开发工具

### 使用Cursor开发
1. 用Cursor打开项目根目录
2. Cursor会自动读取 `.cursorrules` 配置
3. 开始开发，Cursor会提供智能提示

### 文件同步
```bash
# 同步Web文件到Xcode项目
./scripts/dev/sync-xcode-web.sh

# 自动监控文件变化
./scripts/dev/auto-sync-xcode.sh
```

## 📊 项目状态
- ✅ 所有功能正常工作
- ✅ 界面显示正常
- ✅ 数据完整 (9,171条活动记录)
- ✅ 响应式设计完成
- ✅ iOS安全区域适配完成

## 🆘 遇到问题？

### 常见问题解决
1. **应用无法启动**: 检查Xcode是否正确安装
2. **数据不显示**: 清除浏览器缓存或重新构建
3. **界面异常**: 检查CSS文件是否正确加载
4. **构建失败**: 运行 `xcodebuild clean` 清理缓存

### 获取帮助
- 查看 `docs/` 目录获取详细文档
- 参考 `.cursorrules` 了解开发规则
- 查看 `PROJECT_HISTORY_VERSION.md` 了解项目历史

## 🎉 开始开发！
现在你可以开始开发了！项目已经准备就绪，所有功能都正常工作。