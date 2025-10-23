# 🚀 完整安装和配置指南

## 📊 当前状态总结

### ✅ 已完成配置
- **安全防护系统**: 全面启用
- **Python部署方案**: 立即可用
- **Netlify部署配置**: 已准备就绪
- **Vercel部署配置**: 已准备就绪

### ⏳ 需要安装
- **Node.js**: 需要手动安装
- **Vercel CLI**: 需要Node.js安装后配置

## 🎯 立即可用的方案

### 1. 本地测试（推荐）
```bash
# 启动本地服务器
./scripts/deploy-python.sh

# 安全功能测试
./scripts/local-security-test.sh
```

### 2. 网络恢复后部署
```bash
# Netlify自动部署
./scripts/deploy-netlify-only.sh
```

## 📦 Node.js安装方法

### 方法1: 官网下载（推荐）
1. 访问 https://nodejs.org/
2. 下载LTS版本（长期支持版）
3. 双击安装包，按提示安装
4. 重启终端
5. 验证安装：`node --version`

### 方法2: 使用Homebrew
```bash
# 安装Homebrew（需要管理员权限）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装Node.js
brew install node
```

### 方法3: 使用nvm（网络恢复后）
```bash
# 安装nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载终端
source ~/.bashrc

# 安装Node.js
nvm install --lts
nvm use --lts
```

## 🔧 安装完成后配置

### 1. 验证安装
```bash
# 检查Node.js
node --version

# 检查npm
npm --version
```

### 2. 安装Vercel CLI
```bash
# 全局安装Vercel CLI
npm install -g vercel

# 验证安装
vercel --version
```

### 3. 登录Vercel
```bash
# 登录Vercel账户
vercel login
```

### 4. 部署项目
```bash
# 一键安装和部署
./scripts/install-and-deploy.sh

# 或双平台部署
./scripts/deploy-dual.sh
```

## 🛡️ 安全功能验证

### 自动验证
所有安全功能已自动启用：
- ✅ 内容安全策略 (CSP)
- ✅ XSS防护
- ✅ 点击劫持防护
- ✅ 速率限制
- ✅ 输入验证

### 手动验证
1. 打开浏览器访问应用
2. 按F12打开开发者工具
3. 查看Console标签页的安全日志
4. 检查Network标签页的响应头
5. 尝试执行恶意脚本（应被阻止）

## 🌐 部署架构

```
TIME应用
├── 本地测试服务器 (Python) ✅
├── Netlify部署 (GitHub触发) ⏳
└── Vercel部署 (Node.js + CLI) ⏳
```

## 📋 部署命令总结

### 立即可用
```bash
# 本地测试
./scripts/deploy-python.sh

# 安全测试
./scripts/local-security-test.sh
```

### 网络恢复后
```bash
# Netlify部署
./scripts/deploy-netlify-only.sh

# 检查安装状态
./scripts/install-nodejs.sh
```

### Node.js安装后
```bash
# 一键安装和部署
./scripts/install-and-deploy.sh

# 双平台部署
./scripts/deploy-dual.sh
```

## 💡 使用建议

### 开发阶段
- 使用Python方案进行本地测试
- 验证安全功能和用户体验

### 生产部署
- 网络恢复后使用Netlify自动部署
- 安装Node.js后使用Vercel部署

### 双重保障
- Netlify + Vercel 提供高可用性
- 一个平台出问题，另一个继续服务

## 🎯 下一步操作

1. **立即测试**: 运行 `./scripts/deploy-python.sh`
2. **安装Node.js**: 访问 https://nodejs.org/ 下载LTS版本
3. **网络恢复后**: 运行 `git push origin main` 触发Netlify部署
4. **完整部署**: 安装Node.js后运行 `./scripts/install-and-deploy.sh`

## 📞 技术支持

如遇问题，请检查：
- 网络连接状态
- Node.js安装状态
- Git认证配置
- 端口占用情况

所有配置文件和脚本都已准备就绪，可以立即开始使用！🚀
