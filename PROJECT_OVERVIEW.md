# 📋 TIME 项目概览

## 🎯 项目简介

TIME 是一个现代化的时间管理应用，采用紫色主题设计，支持Web、iOS和macOS多平台。

---

## 📂 目录结构说明

### 根目录（核心文件）
```
time/
├── README.md           - 项目主文档
├── CHANGELOG.md        - 项目时间线
├── index.html          - Web应用入口
├── deploy.sh           - 一键部署脚本
├── netlify.toml        - Netlify配置
├── .gitignore          - Git忽略规则
├── css/                - 样式文件
├── js/                 - JavaScript文件
├── time/               - iOS/macOS应用
├── docs/               - 项目文档
└── scripts/            - 脚本和工具
```

---

## 📚 文档组织

### docs/ 目录
完整的项目文档，按类别组织：

```
docs/
├── README.md                    - 文档导航索引
├── DEPLOYMENT_CHECKLIST.md     - 部署验证清单
├── GITHUB_VERIFICATION.md      - GitHub验证指南
├── VERIFICATION_REPORT.md      - 完整验证报告
├── PROJECT_STRUCTURE.txt       - 详细结构说明
├── deployment/                 - 部署相关 (21个文档)
│   ├── AdSense配置
│   ├── GitHub推送指南
│   ├── Netlify部署
│   └── 广告配置
├── development/                - 开发相关 (12个文档)
│   ├── iOS-App配置
│   ├── macOS配置
│   ├── Xcode指南
│   └── 问题修复
├── guides/                     - 使用指南 (8个文档)
│   ├── 使用指南
│   ├── 快速开始
│   ├── 测试指南
│   └── Debug指南
└── archive/                    - 归档文档 (15个文档)
    ├── 项目总结
    ├── 完成清单
    └── 历史记录
```

---

## 🔧 脚本目录

### scripts/ 目录
所有脚本和演示文件：

```
scripts/
├── README.md          - 脚本使用说明
├── push.sh            - 快速推送GitHub
├── run-app.sh         - 运行iOS/macOS应用
├── setup-ios-app.sh   - 设置应用环境
├── test-app.sh        - 应用测试
├── demo.html          - 演示页面
└── privacy.html       - 隐私政策页面
```

**注意**: `deploy.sh` 在根目录，方便快速访问。

---

## 🚀 快速开始

### 1. Web版本
```bash
# 直接访问
open https://time-2025.netlify.app

# 或本地运行
open index.html
```

### 2. iOS/macOS版本
```bash
# 打开Xcode项目
cd time
open time.xcodeproj

# 或使用脚本
./scripts/run-app.sh
```

### 3. 部署更新
```bash
# 使用部署脚本
./deploy.sh

# 或手动推送
git add -A
git commit -m "更新内容"
git push origin main
```

---

## 📊 文件统计

| 类别 | 数量 |
|------|------|
| 核心文件 | 10个 |
| HTML文件 | 3个 |
| CSS文件 | 1个 |
| JS文件 | 7个 |
| Swift文件 | 4个 |
| 脚本文件 | 6个 |
| 文档文件 | 60+个 |
| **总计** | **90+个** |

---

## 🎯 重要文件

### 必读文档
1. **README.md** - 从这里开始
2. **CHANGELOG.md** - 了解项目历程
3. **docs/README.md** - 文档导航

### 常用脚本
1. **deploy.sh** - 快速部署
2. **scripts/push.sh** - 快速推送
3. **scripts/run-app.sh** - 运行应用

### 配置文件
1. **netlify.toml** - Netlify配置
2. **.gitignore** - Git忽略规则
3. **time.xcodeproj** - Xcode项目

---

## 🔍 查找文档

### 想要部署？
→ `docs/deployment/`

### 想要开发？
→ `docs/development/`

### 需要使用指南？
→ `docs/guides/`

### 查看历史？
→ `docs/archive/`

---

## 💡 项目特点

- ✅ **结构清晰**: 文件分类明确
- ✅ **文档完善**: 60+个文档
- ✅ **易于维护**: 模块化设计
- ✅ **跨平台**: Web/iOS/macOS
- ✅ **自动化**: 一键部署

---

## 📞 快速链接

- 🌐 **在线体验**: https://time-2025.netlify.app
- 📦 **GitHub**: https://github.com/cxs00/time
- 📚 **完整文档**: docs/ 目录
- 🔧 **脚本工具**: scripts/ 目录

---

**最后更新**: 2025-10-20 13:40
