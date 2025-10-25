# Activity Tracker 项目文件索引

## 📋 项目概览

**项目名称：** Activity Tracker - 智能活动记录与进度管理系统
**当前版本：** v2.0.0
**项目状态：** ✅ 核心功能完成
**最后更新：** 2025年10月24日

---

## 📁 目录结构

### 🎯 根目录文件
```
time/
├── README.md                    # 项目入口文档
├── PROJECT_INDEX.md            # 项目文件索引（本文件）
├── .cursorrules                # Cursor配置
├── .gitignore                  # Git忽略文件
├── netlify.toml                # Netlify配置
├── vercel.json                 # Vercel配置
└── .vercelignore               # Vercel忽略文件
```

### 📦 源代码目录 (`src/`)
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

### 📚 文档目录 (`docs/`)

#### 技术文档 (`docs/technical/`)
```
docs/technical/
├── TECHNICAL_DEVELOPMENT_LOG.md    # 技术开发日志
└── DEVELOPMENT_LOG_GUIDE.md        # 开发日志使用指南
```

#### 用户文档 (`docs/user/`)
```
docs/user/
├── ACTIVITY_TRACKER_README.md      # 详细使用文档
├── IMPLEMENTATION_SUMMARY.md       # 实现总结
├── PROJECT_STATUS.md               # 项目状态
├── HANDOVER_GUIDE.md               # 交接指南
├── PROJECT_COMPLETION_SUMMARY.md  # 完成总结
└── RELEASE_NOTES.md               # 发布说明
```

#### 部署文档 (`docs/deployment/`)
```
docs/deployment/
├── (原部署相关文档)
└── (Netlify、Vercel等部署文档)
```

### 🧪 测试目录 (`tests/`)
```
tests/
├── TEST_CHECKLIST.md           # 测试清单
├── unit/                       # 单元测试
├── integration/                # 集成测试
└── e2e/                        # 端到端测试
```

### 🔧 脚本目录 (`scripts/`)

#### 开发脚本 (`scripts/dev/`)
```
scripts/dev/
├── auto-import-auth.sh         # 自动导入认证
├── cursor-auth-detector.sh     # Cursor认证检测
├── update-dev-log.sh          # 开发日志更新
└── quick-log.sh               # 快速日志记录
```

#### 部署脚本 (`scripts/deploy/`)
```
scripts/deploy/
├── start-activity-tracker.sh   # 启动脚本
├── deploy-netlify-only.sh     # Netlify部署
├── deploy-vercel.sh           # Vercel部署
└── deploy-universal.sh        # 通用部署
```

#### 工具脚本 (`scripts/utils/`)
```
scripts/utils/
└── (工具脚本)
```

### 🎨 资源目录 (`assets/`)
```
assets/
├── images/                     # 图片资源
├── icons/                      # 图标资源
└── fonts/                      # 字体资源
```

### 📱 原生应用目录 (`time/`)
```
time/
├── time.xcodeproj/             # Xcode项目文件
├── time/                       # iOS/macOS应用
│   ├── timeApp.swift          # 应用入口
│   ├── ContentView.swift       # 主视图
│   ├── TimeWebView.swift      # WebView组件
│   └── Web/                   # Web文件（已同步）
│       ├── html/              # HTML文件
│       ├── css/               # CSS文件
│       └── js/                # JavaScript文件
├── timeTests/                 # 单元测试
└── timeUITests/               # UI测试
```

### 📄 原文档目录 (`docs/`)
```
docs/
├── deployment/                # 部署文档
├── development/               # 开发文档
├── guides/                    # 使用指南
└── archive/                   # 归档文档
```

---

## 🔍 文件分类说明

### 📝 源代码文件
- **HTML文件**：`src/html/` - 应用页面和演示页面
- **CSS文件**：`src/css/` - 样式文件和主题
- **JavaScript文件**：`src/js/` - 核心逻辑和功能模块

### 📚 文档文件
- **技术文档**：`docs/technical/` - 开发日志和技术说明
- **用户文档**：`docs/user/` - 使用说明和项目状态
- **部署文档**：`docs/deployment/` - 部署相关文档

### 🧪 测试文件
- **测试清单**：`tests/TEST_CHECKLIST.md` - 测试项目清单
- **单元测试**：`tests/unit/` - 单元测试文件
- **集成测试**：`tests/integration/` - 集成测试文件
- **端到端测试**：`tests/e2e/` - 端到端测试文件

### 🔧 脚本文件
- **开发脚本**：`scripts/dev/` - 开发相关脚本
- **部署脚本**：`scripts/deploy/` - 部署相关脚本
- **工具脚本**：`scripts/utils/` - 工具和实用脚本

### 🎨 资源文件
- **图片资源**：`assets/images/` - 应用图片
- **图标资源**：`assets/icons/` - 应用图标
- **字体资源**：`assets/fonts/` - 字体文件

---

## 🚀 快速导航

### 开始使用
- **项目入口**：[README.md](README.md)
- **主应用**：[src/html/activity-tracker.html](src/html/activity-tracker.html)
- **功能演示**：[src/html/demo-activity-tracker.html](src/html/demo-activity-tracker.html)

### 开发相关
- **技术日志**：[docs/technical/TECHNICAL_DEVELOPMENT_LOG.md](docs/technical/TECHNICAL_DEVELOPMENT_LOG.md)
- **开发指南**：[docs/technical/DEVELOPMENT_LOG_GUIDE.md](docs/technical/DEVELOPMENT_LOG_GUIDE.md)
- **项目状态**：[docs/user/PROJECT_STATUS.md](docs/user/PROJECT_STATUS.md)

### 用户文档
- **使用说明**：[docs/user/ACTIVITY_TRACKER_README.md](docs/user/ACTIVITY_TRACKER_README.md)
- **交接指南**：[docs/user/HANDOVER_GUIDE.md](docs/user/HANDOVER_GUIDE.md)
- **完成总结**：[docs/user/PROJECT_COMPLETION_SUMMARY.md](docs/user/PROJECT_COMPLETION_SUMMARY.md)

### 测试相关
- **测试清单**：[tests/TEST_CHECKLIST.md](tests/TEST_CHECKLIST.md)

### 脚本工具
- **快速记录**：[scripts/dev/quick-log.sh](scripts/dev/quick-log.sh)
- **开发日志**：[scripts/dev/update-dev-log.sh](scripts/dev/update-dev-log.sh)
- **启动应用**：[scripts/deploy/start-activity-tracker.sh](scripts/deploy/start-activity-tracker.sh)

---

## 📊 文件统计

### 代码文件
- **HTML文件**：2个
- **CSS文件**：1个（1100+行）
- **JavaScript文件**：5个（2000+行）
- **Swift文件**：3个（iOS/macOS应用）

### 文档文件
- **技术文档**：2个
- **用户文档**：6个
- **测试文档**：1个
- **总计文档**：2000+行

### 脚本文件
- **开发脚本**：4个
- **部署脚本**：4个
- **工具脚本**：待添加

### 资源文件
- **图片资源**：待添加
- **图标资源**：待添加
- **字体资源**：待添加

---

## 🔄 文件更新记录

### 2025-10-24
- ✅ 项目结构重新整理
- ✅ 文件分类到独立目录
- ✅ 创建项目索引文件
- ✅ 更新README文档

### 文件移动记录
```
原位置 → 新位置
activity-tracker.html → src/html/activity-tracker.html
demo-activity-tracker.html → src/html/demo-activity-tracker.html
css/activity-tracker.css → src/css/activity-tracker.css
js/*.js → src/js/
TECHNICAL_DEVELOPMENT_LOG.md → docs/technical/
ACTIVITY_TRACKER_README.md → docs/user/
TEST_CHECKLIST.md → tests/
scripts/*.sh → scripts/dev/ 或 scripts/deploy/
```

---

## 🎯 使用建议

### 开发时
1. **源代码**：在 `src/` 目录下开发
2. **技术文档**：在 `docs/technical/` 目录下记录
3. **开发脚本**：使用 `scripts/dev/` 目录下的脚本

### 部署时
1. **部署脚本**：使用 `scripts/deploy/` 目录下的脚本
2. **部署文档**：参考 `docs/deployment/` 目录下的文档

### 测试时
1. **测试文件**：在 `tests/` 目录下编写
2. **测试清单**：参考 `tests/TEST_CHECKLIST.md`

### 文档维护
1. **技术文档**：及时更新 `docs/technical/` 目录下的文档
2. **用户文档**：保持 `docs/user/` 目录下的文档最新
3. **项目索引**：定期更新本文件

---

**最后更新**：2025年10月24日
**维护者**：AI Assistant + User
**状态**：✅ 项目结构整理完成

---

*此索引文件帮助快速定位项目中的各种文件，建议定期更新以保持准确性。*
