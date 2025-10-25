# Activity Tracker - 智能活动记录与进度管理系统

[![Version](https://img.shields.io/badge/version-v2.0.0-blue.svg)](https://github.com/cxs00/time)
[![Status](https://img.shields.io/badge/status-完成-green.svg)](https://github.com/cxs00/time)
[![License](https://img.shields.io/badge/license-开源-orange.svg)](https://github.com/cxs00/time)

> 从简单的番茄时钟升级为全功能的智能活动记录与进度管理系统

## 📋 项目概览

Activity Tracker 是一个功能强大的智能活动记录与进度管理系统，帮助用户记录每天的活动、管理项目进度、撰写日记和备忘录，并通过数据可视化了解自己的时间分配。

### ✨ 核心特性

- 🤖 **AI智能分类** - 四层算法自动识别活动类型
- 🎯 **项目管理** - 可视化进度追踪和里程碑管理
- 📊 **数据可视化** - 多维度图表分析时间分配
- 📖 **日记备忘** - 心情记录和待办事项管理
- 🎨 **现代UI** - Material Design风格，响应式布局
- 📱 **跨平台** - Web版本 + iOS/macOS原生应用
- 🔒 **隐私安全** - 完全本地存储，无服务器通信

## 🚀 快速开始

### 1. 环境准备

#### 系统要求
- **浏览器：** Chrome 90+, Safari 14+, Firefox 88+, Edge 90+
- **设备：** macOS 11+, iOS 14+, Windows 10+, Android 10+
- **开发工具：** Cursor 或 VS Code（推荐）

#### 克隆项目
```bash
git clone https://github.com/cxs00/time.git
cd time
```

### 2. 启动应用

#### 方式1：功能演示
```bash
open src/html/demo-activity-tracker.html
```

#### 方式2：完整应用
```bash
./scripts/deploy/start-activity-tracker.sh
# 访问 http://localhost:8000/src/html/activity-tracker.html
```

#### 方式3：iOS/macOS App
```bash
cd time
open time.xcodeproj
# 在Xcode中运行
```

## 📁 项目结构

```
time/
├── README.md                           # 项目入口文档（本文件）
├── PROJECT_INDEX.md                    # 项目文件索引
│
├── src/                                # 源代码目录
│   ├── html/                           # HTML文件
│   │   ├── activity-tracker.html       # 主应用入口
│   │   └── demo-activity-tracker.html  # 功能演示页面
│   ├── css/                            # 样式文件
│   │   └── activity-tracker.css        # 应用样式
│   └── js/                             # JavaScript文件
│       ├── activity-tracker.js         # 活动记录核心
│       ├── project-manager.js          # 项目管理
│       ├── diary-memo.js               # 日记备忘
│       ├── ai-classifier.js            # AI分类器
│       └── app-main.js                 # 主应用逻辑
│
├── docs/                               # 文档目录
│   ├── technical/                      # 技术文档
│   │   ├── TECHNICAL_DEVELOPMENT_LOG.md # 技术开发日志
│   │   └── DEVELOPMENT_LOG_GUIDE.md    # 开发日志使用指南
│   ├── user/                           # 用户文档
│   │   ├── ACTIVITY_TRACKER_README.md  # 详细使用文档
│   │   ├── IMPLEMENTATION_SUMMARY.md   # 实现总结
│   │   ├── PROJECT_STATUS.md           # 项目状态
│   │   ├── HANDOVER_GUIDE.md           # 交接指南
│   │   ├── PROJECT_COMPLETION_SUMMARY.md # 完成总结
│   │   └── RELEASE_NOTES.md            # 发布说明
│   └── deployment/                     # 部署文档
│       └── (部署相关文档)
│
├── tests/                              # 测试目录
│   ├── TEST_CHECKLIST.md               # 测试清单
│   ├── unit/                           # 单元测试
│   ├── integration/                    # 集成测试
│   └── e2e/                            # 端到端测试
│
├── scripts/                            # 脚本目录
│   ├── dev/                            # 开发脚本
│   │   ├── auto-import-auth.sh         # 自动导入认证
│   │   ├── cursor-auth-detector.sh     # Cursor认证检测
│   │   ├── update-dev-log.sh          # 开发日志更新
│   │   └── quick-log.sh                # 快速日志记录
│   ├── deploy/                         # 部署脚本
│   │   ├── start-activity-tracker.sh  # 启动脚本
│   │   └── deploy-*.sh                 # 部署脚本
│   └── utils/                          # 工具脚本
│
├── assets/                             # 资源目录
│   ├── images/                         # 图片资源
│   ├── icons/                          # 图标资源
│   └── fonts/                          # 字体资源
│
├── time/                               # iOS/macOS原生应用
│   └── time/Web/                       # 已同步所有Web文件
│
└── docs/                               # 原文档目录（保留）
    ├── deployment/                     # 部署文档
    ├── development/                    # 开发文档
    └── guides/                         # 使用指南
```

## 🎯 核心功能

### 1. 智能活动记录
- **AI四层分类算法**：关键词层、历史学习层、时间上下文层、项目关联层
- **智能建议系统**：基于历史记录和用户习惯
- **实时计时功能**：精确记录每个活动的时间
- **项目自动关联**：智能关联到相关项目

### 2. 项目进度管理
- **可视化进度条**：直观显示项目进度
- **里程碑追踪**：设置和跟踪项目里程碑
- **智能进度计算**：根据活动时长和质量自动更新
- **优先级管理**：高/中/低三级优先级

### 3. 数据可视化
- **活动时间分布**（饼图）：各分类时间占比
- **时间趋势**（折线图）：每日活动时长变化
- **活动热力图**（柱状图）：24小时活动分布

### 4. 日记与备忘录
- **每日日记**：心情记录和想法记录
- **备忘录管理**：待办事项和提醒
- **智能标签**：自动提取关键词作为标签

## 🛠️ 技术栈

### 前端技术
- **语言**：JavaScript ES6+
- **框架**：Vanilla JS (模块化)
- **样式**：CSS3 (Grid + Flexbox)
- **图表**：ECharts 5.5.0
- **存储**：LocalStorage API
- **架构**：Module Pattern + Singleton

### 开发工具
- **编辑器**：Cursor / VS Code
- **浏览器**：Chrome DevTools
- **版本控制**：Git
- **部署**：Netlify / GitHub Pages

## 🚀 部署选项

### 1. 本地使用
```bash
# 直接打开
open src/html/activity-tracker.html

# 或启动服务器
./scripts/deploy/start-activity-tracker.sh
```

### 2. Web部署
```bash
# GitHub Pages
git push origin main

# Netlify部署
./scripts/deploy/deploy-netlify-only.sh
```

### 3. iOS/macOS应用
```bash
# 在Xcode中构建
cd time
open time.xcodeproj
# Product → Archive → Upload to App Store
```

## 📚 文档资源

### 用户文档
- [详细使用文档](docs/user/ACTIVITY_TRACKER_README.md)
- [项目状态](docs/user/PROJECT_STATUS.md)
- [交接指南](docs/user/HANDOVER_GUIDE.md)
- [完成总结](docs/user/PROJECT_COMPLETION_SUMMARY.md)

### 技术文档
- [技术开发日志](docs/technical/TECHNICAL_DEVELOPMENT_LOG.md)
- [开发日志使用指南](docs/technical/DEVELOPMENT_LOG_GUIDE.md)
- [实现总结](docs/user/IMPLEMENTATION_SUMMARY.md)
- [发布说明](docs/user/RELEASE_NOTES.md)

### 测试文档
- [测试清单](tests/TEST_CHECKLIST.md)

## 🔧 开发指南

### 开发环境设置
```bash
# 1. 克隆项目
git clone https://github.com/cxs00/time.git
cd time

# 2. 启动开发服务器
./scripts/deploy/start-activity-tracker.sh

# 3. 开始开发
cursor .
```

### 开发日志记录
```bash
# 快速记录
./scripts/dev/quick-log.sh "完成功能开发"

# 详细记录
./scripts/dev/update-dev-log.sh -a "完成AI分类器优化"

# 查看状态
./scripts/dev/update-dev-log.sh --status
```

### 代码规范
- **命名规范**：PascalCase (类名), camelCase (方法名)
- **文件结构**：一个类一个文件，模块化导入导出
- **注释规范**：清晰的注释说明
- **Git提交**：遵循约定式提交规范

## 🐛 故障排除

### 常见问题

#### 1. 图表不显示
- 检查网络连接
- 确认ECharts CDN可访问
- 或下载ECharts到本地

#### 2. 数据丢失
- 定期导出数据备份
- 不要清除浏览器数据
- 使用数据导入功能恢复

#### 3. 移动端显示异常
- 使用桌面或平板浏览
- 检查CSS响应式设计
- 调整浏览器缩放

## 🔮 后续计划

### 短期优化（1-2周）
- [ ] 性能优化（大数据量处理）
- [ ] PWA离线支持
- [ ] 更多图表类型
- [ ] 单元测试覆盖

### 中期功能（1-2月）
- [ ] AI日记建议
- [ ] 习惯追踪
- [ ] 数据云同步
- [ ] 团队协作

### 长期规划（3-6月）
- [ ] 移动端原生App
- [ ] 第三方集成
- [ ] API开放平台
- [ ] AI助手功能

## 📞 支持与反馈

### 获取帮助
1. 查阅详细文档
2. 查看代码注释
3. 提交GitHub Issue

### 反馈渠道
- **GitHub**: https://github.com/cxs00/time
- **项目主页**: https://time-2025.netlify.app
- **问题反馈**: GitHub Issues

## 📄 许可证

基于原TIME项目，开源发布

## 🤝 贡献

欢迎提交Issues和Pull Requests！

---

## 🏆 总结

Activity Tracker 是一个功能完整、架构清晰的智能活动记录系统。从简单的番茄时钟升级为全功能的时间管理平台，具备：

- **完整的核心功能**
- **现代化的技术架构**
- **优秀的用户体验**
- **详细的文档说明**
- **良好的可维护性**
- **自动化的认证系统**

**项目已准备好投入使用和继续开发！**

---

**开发完成时间：** 2025年10月23日
**版本：** v2.0.0
**状态：** ✅ 完成
**下一步：** 部署使用或继续开发

**🎉 Enjoy tracking your time! 享受记录时光！⏰**
