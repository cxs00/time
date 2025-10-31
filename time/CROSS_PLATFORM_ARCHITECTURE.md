# Activity Tracker 跨平台架构文档

**文档版本**: v1.0.0
**创建日期**: 2025-10-31
**最后更新**: 2025-10-31
**状态**: ✅ 生效中

---

## 📋 目录

1. [问题背景](#问题背景)
2. [根本原因分析](#根本原因分析)
3. [解决方案](#解决方案)
4. [技术架构](#技术架构)
5. [实施细节](#实施细节)
6. [验证清单](#验证清单)
7. [故障排除](#故障排除)
8. [未来改进](#未来改进)

---

## 问题背景

### 症状描述

**iPhone 端反复出现以下问题**：
- ❌ 无法切换界面（导航失效）
- ❌ 关联项目选项中没有任何项目数据
- ❌ 手动添加活动按钮无法弹出
- ❌ 快速记录无法开始计时
- ❌ 今日概览数据为 0
- ❌ 今日活动分布没有饼状图加载

**三平台轮流出现类似问题**：
- 修复 Web → Mac 失败
- 修复 Mac → iPhone 失败
- 修复 iPhone → Web 失败
- 循环往复，无法根治

### 影响范围

- **用户体验**: 应用完全不可用
- **开发效率**: 反复修复同一问题
- **维护成本**: 无统一标准，难以维护

---

## 根本原因分析

### 🔴 核心矛盾：平台资源路径不一致

#### 1. Web 平台 (Vercel)

**加载方式**: HTTP 直接加载
**路径要求**:
```html
<script src="js/storage.js"></script>
<link href="css/activity-tracker.css">
```

**工作原理**:
- Vercel 服务器按照相对路径提供文件
- `js/` 和 `css/` 是实际的目录结构
- ✅ 状态: 正常工作

#### 2. Mac 平台 (macOS WKWebView)

**加载方式**: `loadFileURL` + `allowingReadAccessTo`
**路径要求**:
```swift
Bundle.main.url(forResource: "activity-tracker",
                withExtension: "html",
                subdirectory: "Web")
```

**应用包结构**:
```
TIME.app/Contents/Resources/
└── Web/
    ├── activity-tracker.html
    ├── js/
    │   ├── storage.js
    │   └── ...
    └── css/
        └── activity-tracker.css
```

**工作原理**:
- HTML 从 `Web/` 子目录加载
- `loadFileURL` 允许访问父目录 (`Resources/`)
- HTML 中的相对路径 `js/storage.js` 正确解析
- ✅ 状态: 正常工作

#### 3. iPhone 平台 (iOS WKWebView) - **问题所在**

**原设计 (内联化方案)**:
```swift
// 尝试内联所有 JS 文件
html = html.replacingOccurrences(
    of: "<script src=\"\(jsFile)\"></script>",  // ❌ 匹配 storage.js
    with: "<script>...(content)...</script>"
)
```

**实际 HTML**:
```html
<script src="js/storage.js"></script>  <!-- ✅ 有 js/ 前缀 -->
```

**结果**:
- ❌ 匹配失败: `"storage.js"` ≠ `"js/storage.js"`
- ❌ 内联化完全失败
- ❌ HTML 仍引用外部 `file://` 资源
- ❌ iOS 同源策略阻止加载
- ❌ **JavaScript 完全未执行**

### 🔄 问题循环链

```
1. 为 Web 添加 js/ 前缀 → Web 正常
2. Mac 使用 subdirectory: "Web" → Mac 正常
3. iPhone 内联化路径不匹配 → iPhone 失败 ← 💥 瓶颈
4. 修复 iPhone (去掉前缀) → Web 失败
5. 回到步骤 1 (循环)
```

### 🎯 深层原因

**技术层面**:
1. **平台差异未统一**: 三个平台使用不同的资源加载方式
2. **路径约定未文档化**: 没有明确的路径格式规范
3. **内联化逻辑错误**: 字符串匹配失败
4. **缺少自动化测试**: 无法及时发现跨平台问题

**流程层面**:
1. **修改时未考虑全局影响**: 只测试当前平台
2. **没有回归测试机制**: 修复后未全平台验证
3. **缺少统一的开发规范**: `.cursorrules` 未强制执行

---

## 解决方案

### ✅ 方案 B: 统一使用 loadFileURL（已采用）

#### 核心思想

**三平台统一资源加载方式**:
- Web: HTTP 加载（不变）
- Mac: `loadFileURL` + `allowingReadAccessTo` (已验证)
- iPhone: `loadFileURL` + `allowingReadAccessTo` (新方案)

#### 关键修改

**TimeWebView.swift - iOS 分支** (第 47-110 行):

```swift
#if os(iOS)
struct TimeWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        // ... 配置 ...

        // 🔧 方案B：统一使用 loadFileURL（与 Mac 一致）
        if let htmlURL = Bundle.main.url(forResource: "activity-tracker",
                                         withExtension: "html",
                                         subdirectory: "Web") {
            // 关键：允许访问父目录
            let webDir = htmlURL.deletingLastPathComponent()  // .app/Web/
            let resourcesDir = webDir.deletingLastPathComponent()  // .app/

            // ✅ 与 Mac 完全一致的加载方式
            webView.loadFileURL(htmlURL, allowingReadAccessTo: resourcesDir)

            // 📊 详细验证
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // 验证 JavaScript 模块加载
                // 验证 DOM 状态
                // 验证数据存储
            }
        }

        return webView
    }
}
```

#### 为什么有效？

1. **与 Mac 完全一致**: 使用相同的代码逻辑
2. **路径格式统一**: HTML 中的 `js/storage.js` 保持不变
3. **权限配置正确**:
   - `allowUniversalAccessFromFileURLs = true` (第 23 行)
   - `allowFileAccessFromFileURLs = true` (第 24 行)
   - `allowingReadAccessTo: resourcesDir` (第 62 行)

4. **消除内联化复杂性**: 不再需要字符串替换

#### Build Phase Script 修复

**问题**: iOS 和 macOS 的应用包结构不同

```bash
# macOS: Contents/Resources/Web/
# iOS: .app/Web/ (没有 Contents 目录)
```

**解决**: 使用平台特定的环境变量

```bash
if [ "${PLATFORM_NAME}" == "macosx" ]; then
    RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${CONTENTS_FOLDER_PATH}/Resources"
    cp -R "${SRCROOT}/time/Web" "$RESOURCES_DIR/"
elif [ "${PLATFORM_NAME}" == "iphonesimulator" ] || [ "${PLATFORM_NAME}" == "iphoneos" ]; then
    RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH%/}"
    cp -R "${SRCROOT}/time/Web" "$RESOURCES_DIR/"
fi
```

---

## 技术架构

### 统一资源架构图

```
┌─────────────────────────────────────────────────────────┐
│                    HTML 文件                             │
│  activity-tracker.html                                  │
│    ├── <script src="js/storage.js">                    │
│    ├── <script src="js/activity-tracker.js">           │
│    └── <link href="css/activity-tracker.css">          │
└─────────────────────────────────────────────────────────┘
                            │
                            │ 统一路径格式
                            ▼
┌─────────────────┬──────────────────┬──────────────────┐
│   Web (Vercel)  │   Mac (SwiftUI)  │ iPhone (SwiftUI) │
├─────────────────┼──────────────────┼──────────────────┤
│                 │                  │                  │
│  HTTP 加载      │  loadFileURL     │  loadFileURL     │
│  ✓ 相对路径     │  ✓ subdirectory  │  ✓ subdirectory  │
│  ✓ 直接访问     │  ✓ 权限控制      │  ✓ 权限控制      │
│                 │                  │                  │
│  Web/           │  Contents/       │  .app/           │
│   ├── js/       │   Resources/     │   └── Web/       │
│   └── css/      │    └── Web/      │       ├── js/    │
│                 │       ├── js/    │       └── css/   │
│                 │       └── css/   │                  │
│                 │                  │                  │
│  ✅ 正常工作    │  ✅ 正常工作     │  ✅ 已修复       │
└─────────────────┴──────────────────┴──────────────────┘
```

### 关键配置对比

| 配置项 | Web | Mac | iPhone |
|-------|-----|-----|--------|
| **加载方式** | HTTP | loadFileURL | loadFileURL |
| **路径前缀** | `js/`, `css/` | `js/`, `css/` | `js/`, `css/` |
| **应用包结构** | `/Web/` | `Contents/Resources/Web/` | `.app/Web/` |
| **访问权限** | N/A | `allowingReadAccessTo: Resources/` | `allowingReadAccessTo: .app/` |
| **JavaScript 权限** | N/A | `allowUniversalAccessFromFileURLs = true` | `allowUniversalAccessFromFileURLs = true` |
| **同源策略** | 标准 HTTP | 配置允许 | 配置允许 |

---

## 实施细节

### 修改文件清单

1. **TimeWebView.swift** (核心修改)
   - 第 47-110 行: iOS 分支改用 loadFileURL
   - 第 64-104 行: 添加详细验证逻辑
   - 删除: 内联化代码 (原 52-126 行)

2. **time.xcodeproj/project.pbxproj** (构建配置)
   - 添加: Build Phase Script
   - 修复: iOS 资源路径处理

3. **activity-tracker.html** (路径格式)
   - ✅ 保持: `src="js/storage.js"` 格式
   - ✅ 保持: `href="css/activity-tracker.css"` 格式

4. **index.html** (Web 入口)
   - ✅ 保持: 与 activity-tracker.html 一致

### JavaScript 验证清单

**启动后 3 秒自动验证**:

```swift
let checks = [
    ("window.AppMain", "AppMain 主应用"),
    ("window.smartActivityTracker", "Activity Tracker"),
    ("window.projectManager", "Project Manager"),
    ("window.chartManager", "Chart Manager"),
    ("window.diaryMemoManager", "Diary Memo Manager")
]

for (script, name) in checks {
    webView.evaluateJavaScript("typeof \(script)") { result, error in
        if result == "undefined" {
            print("  ❌ \(name): 未加载")
        } else {
            print("  ✅ \(name): 加载成功 (type: \(result))")
        }
    }
}
```

**预期输出** (Xcode Console):
```
📱 iOS - 从Web子目录加载（统一方案）
   HTML路径: /path/to/TIME.app/Web/activity-tracker.html
   Web目录: /path/to/TIME.app/Web/
   访问权限根目录: /path/to/TIME.app/

📊 iOS - JavaScript 模块验证:
  ✅ AppMain 主应用: 加载成功 (type: object)
  ✅ Activity Tracker: 加载成功 (type: object)
  ✅ Project Manager: 加载成功 (type: object)
  ✅ Chart Manager: 加载成功 (type: object)
  ✅ Diary Memo Manager: 加载成功 (type: object)
  📄 DOM 状态: complete
  💾 项目数据: 已加载
```

---

## 验证清单

### 编译后验证 (每次修改必须执行)

#### Mac 平台
```bash
# 1. 编译
xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=macOS'

# 2. 验证资源
ls -la ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug/TIME.app/Contents/Resources/Web/

# 3. 启动应用
open ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug/TIME.app

# 4. 验证功能
# ✅ 界面切换正常
# ✅ 项目选择器显示数据
# ✅ 图表正常显示
```

#### iPhone 平台
```bash
# 1. 编译
xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=iOS Simulator,name=iPhone 17'

# 2. 手动拷贝资源 (临时方案，直到 sandbox 问题解决)
IPHONE_APP=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator -name "TIME.app" -type d | head -n 1)
cp -R time/Web "$IPHONE_APP/"

# 3. 验证资源
ls -la "$IPHONE_APP/Web/"

# 4. 安装并启动
xcrun simctl install booted "$IPHONE_APP"
xcrun simctl launch booted com.cxs.time

# 5. 查看日志 (Xcode Console)
# 期待看到: "✅ AppMain 主应用: 加载成功"
```

#### Web 平台
```bash
# 1. 部署到 Vercel (自动)
git push origin main

# 2. 访问
open https://time-tracker-three-mu.vercel.app

# 3. 验证功能
# ✅ 界面切换正常
# ✅ 项目选择器显示数据
# ✅ 图表正常显示
```

### 功能验证矩阵

| 功能 | Web | Mac | iPhone |
|------|-----|-----|--------|
| 界面切换 (导航栏) | ✅ | ✅ | ✅ |
| 项目选择器 | ✅ | ✅ | ✅ |
| 添加活动弹窗 | ✅ | ✅ | ✅ |
| 快速记录计时 | ✅ | ✅ | ✅ |
| 今日概览数据 | ✅ | ✅ | ✅ |
| 活动分布饼图 | ✅ | ✅ | ✅ |
| 项目进度显示 | ✅ | ✅ | ✅ |
| LocalStorage 持久化 | ✅ | ✅ | ✅ |

---

## 故障排除

### 问题 1: iPhone 应用黑屏/白屏

**症状**: 应用启动后显示空白

**排查步骤**:
1. 查看 Xcode Console 日志
2. 确认是否有 "📱 iOS - 从Web子目录加载" 日志
3. 确认 Web 目录是否存在

```bash
IPHONE_APP=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator -name "TIME.app" -type d | head -n 1)
ls -la "$IPHONE_APP/Web/"
```

**解决**:
- 如果 Web 目录不存在，手动拷贝: `cp -R time/Web "$IPHONE_APP/"`
- 重新启动应用

### 问题 2: JavaScript 未加载 (所有功能失效)

**症状**: 无法切换界面，所有按钮无响应

**排查步骤**:
1. 查看 Xcode Console 验证日志
2. 如果看到 "❌ AppMain: 未加载"，说明 JavaScript 未执行

**可能原因**:
- ❌ Web 资源未正确拷贝
- ❌ `allowingReadAccessTo` 权限不足
- ❌ HTML 路径格式错误

**解决**:
```swift
// 确认访问权限到父目录
let resourcesDir = webDir.deletingLastPathComponent()  // 不是 webDir!
webView.loadFileURL(htmlURL, allowingReadAccessTo: resourcesDir)
```

### 问题 3: 项目数据为空

**症状**: 项目选择器显示空

**排查**:
```swift
webView.evaluateJavaScript("localStorage.getItem('activityTracker_projects')") { result, error in
    print("项目数据: \(result ?? "nil")")
}
```

**解决**:
- 如果返回 `null`，说明首次启动，需要初始化数据
- 检查 `app-main.js` 中的数据生成逻辑

### 问题 4: Build Phase Script 在 Xcode 中失效

**症状**: 直接在 Xcode 点 Run，Web 目录未创建

**原因**: Xcode sandbox 可能阻止脚本访问某些路径

**临时方案**: 手动拷贝
```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
alias fix-ios-web='IPHONE_APP=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator -name "TIME.app" -type d | head -n 1) && cp -R ~/Desktop/cxs/time/time/time/Web "$IPHONE_APP/"'
```

**长期方案**:
1. 在 Xcode Build Settings 中禁用 sandbox
2. 或使用 Xcode的 Copy Bundle Resources (但会丢失目录结构)

---

## 未来改进

### 短期 (1-2 周)

1. **添加单元测试**
   ```swift
   func testHTMLPathFormat() {
       let html = try! String(contentsOf: htmlURL)
       XCTAssertTrue(html.contains("src=\"js/storage.js\""))
   }
   ```

2. **自动化跨平台测试**
   - CI/CD 集成
   - 每次提交自动运行三平台仿真

3. **完善错误处理**
   - 更友好的错误页面
   - 详细的错误日志

### 中期 (1-3 个月)

1. **统一 WebView 封装**
   - 创建 `UnifiedWebView` 协议
   - iOS 和 macOS 共享同一套逻辑

2. **资源热更新**
   - 支持动态下载 Web 资源
   - 不需要重新编译应用

3. **性能优化**
   - 资源预加载
   - JavaScript 打包优化

### 长期 (3-6 个月)

1. **考虑统一技术栈**
   - React Native 或 Flutter
   - 完全统一三平台代码

2. **建立完整的测试矩阵**
   - 单元测试
   - 集成测试
   - E2E 测试
   - 视觉回归测试

3. **监控和分析**
   - 用户行为分析
   - 错误追踪 (Sentry)
   - 性能监控

---

## 附录

### A. 相关文件路径

```
time/
├── time/
│   ├── TimeWebView.swift           # 核心修改
│   ├── ContentView.swift
│   └── Web/                        # 资源目录
│       ├── activity-tracker.html
│       ├── index.html
│       ├── js/
│       │   ├── storage.js
│       │   ├── activity-tracker.js
│       │   └── ...
│       └── css/
│           └── activity-tracker.css
├── time.xcodeproj/
│   └── project.pbxproj             # Build Phase Script
└── .cursorrules                    # 开发规范
```

### B. 环境要求

- **Xcode**: 17.0+ (Build 17A400)
- **macOS**: 15.0+
- **iOS Simulator**: 18.0+
- **Swift**: 6.0+

### C. 相关命令速查

```bash
# 完整清理重建
cd ~/Desktop/cxs/time/time
rm -rf ~/Library/Developer/Xcode/DerivedData/time-*
xcodebuild clean build -project time.xcodeproj -scheme time -destination 'platform=macOS'

# 三平台仿真
./run-simulation.sh

# 查看应用包结构
find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products -name "TIME.app" -type d -exec ls -la {}/Web/ \;

# Git 回退
git log --oneline -10
git reset --hard HEAD~1
```

### D. 关键技术点

**WKWebView 本地文件加载**:
```swift
// ✅ 正确：允许访问父目录
webView.loadFileURL(htmlURL, allowingReadAccessTo: parentDirectory)

// ❌ 错误：只允许当前目录
webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
```

**iOS 同源策略配置**:
```swift
configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
```

**路径约定 (强制)**:
```html
<!-- ✅ 正确 -->
<script src="js/storage.js"></script>
<link href="css/activity-tracker.css">

<!-- ❌ 错误 -->
<script src="storage.js"></script>  <!-- 无前缀 -->
<script src="./js/storage.js"></script>  <!-- ./ 前缀 -->
```

---

## 维护者

- **创建者**: Cursor AI Assistant
- **审核者**: 项目负责人
- **联系方式**: 通过项目 GitHub Issues

## 变更日志

| 日期 | 版本 | 变更内容 |
|------|------|---------|
| 2025-10-31 | v1.0.0 | 初始版本，记录方案 B 实施 |

---

**© 2025 Activity Tracker Project. All Rights Reserved.**

