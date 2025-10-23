# Vercel部署指南

## 🚀 为什么Vercel没有部署？

Vercel部署需要Node.js环境，但你的系统目前没有安装Node.js。

## 📋 解决方案

### 方案1: 安装Node.js后部署Vercel

#### 1. 安装Node.js
```bash
# 方法1: 从官网下载
# 访问 https://nodejs.org/ 下载LTS版本

# 方法2: 使用Homebrew (如果已安装)
brew install node

# 方法3: 使用nvm (推荐)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

#### 2. 安装Vercel CLI
```bash
npm install -g vercel
```

#### 3. 部署到Vercel
```bash
# 在项目根目录执行
vercel login
vercel --prod
```

### 方案2: 仅使用Netlify (推荐)

由于Netlify已经配置好自动部署，你可以直接使用：

```bash
# 运行Netlify部署
./scripts/deploy-netlify-only.sh
```

## 🌐 当前部署状态

- ✅ **Netlify**: 已配置自动部署
- ⏳ **Vercel**: 需要Node.js安装

## 🛡️ 安全功能

无论使用哪个平台，安全功能都已配置：

- ✅ 内容安全策略 (CSP)
- ✅ XSS防护
- ✅ 点击劫持防护
- ✅ 速率限制
- ✅ 输入验证

## 📊 部署命令

```bash
# Netlify部署 (推荐)
./scripts/deploy-netlify-only.sh

# 双平台部署 (需要Node.js)
./scripts/deploy-dual.sh

# 安全测试
./scripts/security-test.sh
```

## 💡 建议

1. **优先使用Netlify** - 已经配置好，无需额外安装
2. **如需Vercel** - 先安装Node.js，然后运行双平台部署
3. **双重保障** - 两个平台都部署可以提供更好的可用性
