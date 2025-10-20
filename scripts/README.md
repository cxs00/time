# 📜 Scripts 脚本目录

此目录包含项目的各种脚本和演示文件。

---

## 🚀 部署脚本

### deploy.sh
**功能**: 自动部署到Netlify
```bash
./scripts/deploy.sh
```
- 自动添加所有更改
- 提交到Git
- 推送到GitHub
- 触发Netlify自动部署

### push.sh
**功能**: 快速推送到GitHub
```bash
./scripts/push.sh
```

---

## 📱 应用脚本

### run-app.sh
**功能**: 运行iOS/macOS应用
```bash
./scripts/run-app.sh
```
- 在Xcode中运行TIME应用
- 支持Mac和iPhone模拟器

### setup-ios-app.sh
**功能**: 设置iOS应用环境
```bash
./scripts/setup-ios-app.sh
```
- 配置Xcode项目
- 安装依赖

### test-app.sh
**功能**: 测试应用
```bash
./scripts/test-app.sh
```
- 运行单元测试
- 检查应用功能

---

## 🎨 演示文件

### demo.html
**功能**: 演示页面
- TIME应用的演示版本
- 可用于展示和测试

### privacy.html
**功能**: 隐私政策页面
- 独立的隐私政策页面
- 可用于展示或链接

---

## 📝 使用说明

### 权限设置
确保脚本有执行权限：
```bash
chmod +x scripts/*.sh
```

### 运行脚本
```bash
# 从项目根目录运行
./scripts/deploy.sh

# 或进入scripts目录
cd scripts
./deploy.sh
```

---

## 🔧 脚本详情

### deploy.sh
```bash
#!/bin/bash
# 功能：
# - 检查Git状态
# - 暂存所有更改
# - 提交更改
# - 推送到GitHub
# - 触发Netlify部署
```

### 其他脚本
各脚本都有详细的注释说明功能和用法。

---

**最后更新**: 2025-10-20

