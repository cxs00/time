# 🔧 手动安装Node.js和Vercel指南

## 📋 安装步骤

### 1. 安装Homebrew（如果未安装）

```bash
# 在终端中运行以下命令
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**注意**: 需要输入管理员密码

### 2. 安装Node.js

```bash
# 使用Homebrew安装Node.js
brew install node

# 验证安装
node --version
npm --version
```

### 3. 安装Vercel CLI

```bash
# 全局安装Vercel CLI
npm install -g vercel

# 验证安装
vercel --version
```

### 4. 登录Vercel

```bash
# 登录Vercel账户
vercel login
```

**注意**: 会打开浏览器进行登录

### 5. 部署项目

```bash
# 在项目根目录执行
vercel

# 生产环境部署
vercel --prod
```

## 🚀 一键安装脚本

安装完成后，运行：

```bash
./scripts/install-and-deploy.sh
```

## 🔄 替代方案

如果无法安装Node.js，可以使用Python方案：

```bash
# 使用Python部署（无需Node.js）
./scripts/deploy-python.sh
```

## 📊 验证安装

```bash
# 检查Node.js
node --version

# 检查npm
npm --version

# 检查Vercel
vercel --version

# 检查登录状态
vercel whoami
```

## 🛠️ 故障排除

### 权限问题
```bash
# 修复npm权限
sudo chown -R $(whoami) ~/.npm
```

### 网络问题
```bash
# 使用国内镜像
npm config set registry https://registry.npmmirror.com
```

### Vercel登录问题
```bash
# 清除缓存重新登录
vercel logout
vercel login
```

## 📞 需要帮助？

如果遇到问题，可以：
1. 使用Python部署方案（立即可用）
2. 网络恢复后使用Netlify部署
3. 联系技术支持
