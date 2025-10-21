# TIME项目复刻指南

## 🎯 项目复刻概述

本指南将帮助协作者使用Cursor AI助手完整复刻TIME时间管理应用。

## 🚀 快速开始

### 1. 获取项目
```bash
# 克隆项目到本地
git clone https://github.com/cxs00/time.git
cd time

# 用Cursor打开项目
cursor .
```

### 2. 设置环境
```bash
# 运行协作者设置脚本
./scripts/setup-collaborator.sh

# 启动开发服务器
python -m http.server 8000

# 访问应用
# http://localhost:8000
```

### 3. 开始复刻
1. 阅读 `prompts/` 目录中的提示词
2. 使用Cursor AI助手 (Ctrl+K)
3. 按照 `templates/` 模板开发
4. 参考开发检查清单

## 🤖 AI助手使用指南

### 1. 项目理解阶段
使用提示词：`prompts/project-overview.md`
- 理解项目整体架构
- 分析核心功能需求
- 确定技术栈选择
- 制定开发计划

### 2. 功能实现阶段
使用提示词：`prompts/feature-implementation.md`
- 实现计时器核心逻辑
- 开发数据存储方案
- 创建统计功能
- 设计UI界面

### 3. 开发流程阶段
使用提示词：`prompts/development-workflow.md`
- 设置开发环境
- 配置版本管理
- 实现代码规范
- 进行测试验证

### 4. 调试优化阶段
使用提示词：`prompts/debugging-guide.md`
- 定位和修复bug
- 性能优化
- 兼容性测试
- 用户体验改进

### 5. 部署发布阶段
使用提示词：`prompts/deployment-guide.md`
- 配置部署环境
- 设置版本管理
- 配置CI/CD
- 发布到应用商店

## 📁 项目结构

```
TIME/
├── index.html              # Web版本入口
├── css/style.css           # 样式文件
├── js/                     # JavaScript功能
├── time/                   # iOS/macOS项目
├── scripts/                # 版本管理工具
├── prompts/                # AI提示词库
├── templates/              # 项目模板
├── docs/                   # 项目文档
├── .env.template           # 环境变量模板
├── .cursorrules            # Cursor AI配置
└── README.md               # 项目说明
```

## 🛠️ 开发工具配置

### Cursor IDE配置
- 自动代码格式化
- 智能代码补全
- 语法高亮和错误检测
- 文件关联和Emmet支持

### 快捷键设置
- `Ctrl+Shift+V`: 启动Web服务器
- `Ctrl+Shift+B`: 查看版本列表
- `Ctrl+Shift+C`: 显示当前版本
- `Ctrl+Shift+G`: Git状态检查

### 任务配置
- 一键启动开发服务器
- 版本管理任务
- Git操作任务
- 备份创建任务

## 📋 开发检查清单

### 基础设置
- [ ] 创建项目目录结构
- [ ] 设置Git仓库
- [ ] 配置开发环境
- [ ] 安装必要工具

### 核心功能
- [ ] 计时器功能实现
- [ ] 数据存储功能
- [ ] 统计功能实现
- [ ] UI界面设计

### 高级功能
- [ ] 数据分析图表
- [ ] 响应式设计
- [ ] 原生应用支持
- [ ] 部署配置

### 测试验证
- [ ] 功能测试
- [ ] 跨浏览器测试
- [ ] 移动端测试
- [ ] 性能测试

## 🔧 版本管理

### 查看版本
```bash
# 查看所有版本
./scripts/version-traveler.sh list

# 显示当前版本
./scripts/version-traveler.sh current
```

### 版本跳转
```bash
# 跳转到历史版本
./scripts/version-traveler.sh go v1.0.0

# 跳转到最新版本
git checkout main
```

### 创建版本
```bash
# 创建新版本
./scripts/version-traveler.sh create v1.1.0

# 创建备份
./scripts/backup-version.sh v1.1.0
```

## 🎨 开发技巧

### 1. 使用AI助手
- 使用Ctrl+K打开AI助手
- 参考prompts/目录中的提示词
- 逐步实现项目功能
- 利用AI助手优化代码

### 2. 代码规范
- 使用现代JavaScript语法
- 遵循响应式设计原则
- 保持代码整洁和注释
- 支持多设备适配

### 3. 测试策略
- 在多个浏览器中测试
- 在移动设备上测试
- 验证版本跳转功能
- 测试数据存储功能

## 🚀 部署发布

### Web版本部署
- 配置Netlify自动部署
- 设置环境变量
- 启用HTTPS
- 配置CDN

### 原生应用发布
- 在Xcode中配置应用
- 创建Archive
- 提交应用商店
- 配置应用分发

## 📚 文档资源

### 快速开始
- `QUICK_START.md` - 5分钟上手
- `DEVELOPER_GUIDE.md` - 完整开发指南
- `CURSOR_SETUP.md` - Cursor配置指南

### 详细文档
- `docs/` - 完整项目文档
- `prompts/` - AI提示词库
- `templates/` - 项目模板

## 🆘 常见问题

### 1. 项目无法运行
- 检查Python是否安装
- 确保在项目根目录
- 检查端口是否被占用

### 2. 版本跳转失败
- 确保在项目根目录
- 检查Git状态
- 验证版本标签

### 3. AI助手不工作
- 检查Cursor IDE版本
- 确保网络连接正常
- 重启Cursor IDE

### 4. 功能实现困难
- 参考prompts/目录中的提示词
- 使用开发检查清单
- 查看项目模板

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

## 🎉 开始复刻

现在你已经了解了项目结构，可以开始：

1. **阅读提示词** - 理解项目需求
2. **使用AI助手** - 开始功能开发
3. **参考模板** - 按照最佳实践
4. **测试验证** - 确保功能正常
5. **部署发布** - 完成项目复刻

**祝你复刻成功！** 🚀
