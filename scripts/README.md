# 脚本目录

## 📁 目录结构

```
scripts/
├── dev/                        # 开发脚本
│   ├── auto-import-auth.sh     # 自动导入认证
│   ├── cursor-auth-detector.sh # Cursor认证检测
│   ├── update-dev-log.sh      # 开发日志更新
│   └── quick-log.sh           # 快速日志记录
├── deploy/                     # 部署脚本
│   ├── start-activity-tracker.sh # 启动脚本
│   ├── deploy-netlify-only.sh # Netlify部署
│   ├── deploy-vercel.sh       # Vercel部署
│   └── deploy-universal.sh    # 通用部署
└── utils/                      # 工具脚本
    └── (工具脚本)
```

## 🔧 脚本分类

### 开发脚本 (`dev/`)
- **auto-import-auth.sh** - 自动导入认证信息
- **cursor-auth-detector.sh** - Cursor认证检测器
- **update-dev-log.sh** - 开发日志更新工具
- **quick-log.sh** - 快速日志记录工具

### 部署脚本 (`deploy/`)
- **start-activity-tracker.sh** - 启动Activity Tracker应用
- **deploy-netlify-only.sh** - 仅部署到Netlify
- **deploy-vercel.sh** - 部署到Vercel
- **deploy-universal.sh** - 通用部署脚本

### 工具脚本 (`utils/`)
- 包含各种工具和实用脚本

## 🚀 使用方法

### 开发脚本
```bash
# 快速记录开发过程
./scripts/dev/quick-log.sh "完成功能开发"

# 详细记录开发过程
./scripts/dev/update-dev-log.sh -a "完成AI分类器优化"

# 检测认证信息
./scripts/dev/cursor-auth-detector.sh

# 自动导入认证
./scripts/dev/auto-import-auth.sh
```

### 部署脚本
```bash
# 启动应用
./scripts/deploy/start-activity-tracker.sh

# 部署到Netlify
./scripts/deploy/deploy-netlify-only.sh

# 部署到Vercel
./scripts/deploy/deploy-vercel.sh

# 通用部署
./scripts/deploy/deploy-universal.sh
```

## 📋 脚本说明

### 权限设置
所有脚本都已设置执行权限，可以直接运行：
```bash
chmod +x scripts/**/*.sh
```

### 依赖要求
- **bash** - 所有脚本都使用bash
- **git** - 版本控制
- **curl** - 网络请求
- **jq** - JSON处理（可选）

### 环境变量
部分脚本需要环境变量：
- `GITHUB_TOKEN` - GitHub认证
- `NETLIFY_TOKEN` - Netlify认证
- `VERCEL_TOKEN` - Vercel认证

## 🔍 故障排除

### 常见问题
1. **权限问题** - 确保脚本有执行权限
2. **路径问题** - 确保在项目根目录运行
3. **依赖问题** - 确保安装了必要的工具

### 调试方法
```bash
# 启用调试模式
bash -x ./scripts/dev/quick-log.sh "测试记录"

# 检查脚本语法
bash -n ./scripts/dev/quick-log.sh
```

---

**维护者**: AI Assistant + User
**最后更新**: 2025年10月24日
