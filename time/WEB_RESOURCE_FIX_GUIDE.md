# Web资源路径问题 - 完整解决方案

## 🔴 问题根源

### 当前状态
```
应用包中的实际结构：
TIME.app/
├── activity-tracker.html
├── activity-tracker.css  ← CSS在根目录
├── diary-memo.js         ← JS在根目录
└── ... (其他文件)

HTML中的引用：
<link rel="stylesheet" href="css/activity-tracker.css">  ← 引用css/子目录
<script src="diary-memo.js">                             ← 引用根目录

结果：
❌ CSS 404 - 完全没有加载样式！
✅ JS部分加载（根目录的JS文件）
❌ js/advanced-charts.js 404（引用了js/子目录）
```

## ✅ 解决方案A：统一扁平化（快速修复）

### 优点
- 修改最少
- 立即生效
- 不需要改Xcode配置

### 实施步骤

#### 1. 修改HTML - 移除所有路径前缀

修改 `time/time/Web/activity-tracker.html`：

```html
<!-- 修改前 -->
<link rel="stylesheet" href="css/activity-tracker.css">
<script src="js/advanced-charts.js"></script>
<script src="js/pwa-register.js"></script>

<!-- 修改后 -->
<link rel="stylesheet" href="activity-tracker.css">
<script src="advanced-charts.js"></script>
<script src="pwa-register.js"></script>
```

#### 2. 重新编译

```bash
cd /Users/shanwanjun/Desktop/cxs/time/time
xcodebuild -scheme time -destination 'platform=iOS Simulator,name=iPhone 17' clean build
```

#### 3. 安装并测试

---

## ✅ 解决方案B：保留目录结构（推荐，符合规范）

### 优点
- 符合 .cursorrules 规范
- 代码组织清晰
- 便于维护

### 实施步骤

#### 1. 在Xcode中添加Web文件夹（使用Folder Reference）

**重要：必须以 Folder Reference（蓝色文件夹）方式添加**

1. 打开 `time.xcodeproj` in Xcode
2. 右键点击 `time` 组
3. 选择 "Add Files to time..."
4. 选择 `time/Web` 文件夹
5. **在弹窗中勾选：**
   - ✅ "Create folder references"（蓝色文件夹）
   - ❌ 不要选 "Create groups"（黄色文件夹）
   - ✅ Target: time
6. 点击 "Add"

#### 2. 验证目录结构会被保留

编译后应该看到：
```
TIME.app/
└── Web/
    ├── activity-tracker.html
    ├── css/
    │   └── activity-tracker.css
    └── js/
        ├── diary-memo.js
        ├── advanced-charts.js
        └── ...
```

#### 3. 修改 TimeWebView.swift 加载路径

```swift
// iOS版本
if let htmlPath = Bundle.main.path(forResource: "activity-tracker", ofType: "html", inDirectory: "Web") {
    let fileURL = URL(fileURLWithPath: htmlPath)
    let webDirectory = fileURL.deletingLastPathComponent()
    webView.loadFileURL(fileURL, allowingReadAccessTo: webDirectory.deletingLastPathComponent())
    // 注意：allowingReadAccessTo 必须指向 Web 父目录
}

// macOS版本
if let urlInWeb = Bundle.main.url(forResource: "activity-tracker", withExtension: "html", subdirectory: "Web") {
    let webDirectory = urlInWeb.deletingLastPathComponent()
    webView.loadFileURL(urlInWeb, allowingReadAccessTo: webDirectory.deletingLastPathComponent())
}
```

---

## 🎯 我的推荐

**选择方案A（快速修复）**，原因：
1. 修改最少（只改HTML）
2. 立即生效（无需改Xcode配置）
3. 避免Xcode配置错误

## 📋 验证清单

修复后必须验证：
- [ ] 应用启动无黑屏
- [ ] CSS样式正确加载（看到双层卡片）
- [ ] JS功能正常（按钮可点击）
- [ ] 控制台无404错误
- [ ] Mac和iPhone均正常

---

**现在开始修复？请确认方案选择：**
- 回复 "A" = 快速修复（推荐）
- 回复 "B" = 保留目录结构

