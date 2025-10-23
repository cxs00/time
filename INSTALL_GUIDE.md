# Node.js和Vercel安装配置指南

## 🚀 安装Node.js

### 方法1: 官网下载（推荐）

1. **访问官网**: https://nodejs.org/
2. **下载LTS版本**: 选择 "LTS" 版本（长期支持版）
3. **安装**: 双击下载的 `.pkg` 文件，按提示安装
4. **验证安装**:
   ```bash
   node --version
   npm --version
   ```

### 方法2: 使用Homebrew

```bash
# 安装Homebrew（如果未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装Node.js
brew install node
```

### 方法3: 使用nvm（Node版本管理器）

```bash
# 安装nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载终端配置
source ~/.bashrc

# 安装最新LTS版本
nvm install --lts
nvm use --lts
```

## 🔧 安装Vercel CLI

```bash
# 全局安装Vercel CLI
npm install -g vercel

# 验证安装
vercel --version
```

## 🚀 部署到Vercel

### 1. 登录Vercel
```bash
vercel login
```

### 2. 部署项目
```bash
# 在项目根目录执行
vercel

# 生产环境部署
vercel --prod
```

### 3. 配置自动部署
```bash
# 连接GitHub仓库
vercel link

# 设置环境变量（如果需要）
vercel env add
```

## 🛡️ 安全功能验证

部署完成后，验证安全功能：

```bash
# 运行安全测试
./scripts/security-test.sh

# 检查部署状态
vercel ls
```

## 📊 部署状态检查

```bash
# 查看所有部署
vercel ls

# 查看项目信息
vercel inspect

# 查看部署日志
vercel logs
```

## 🌐 访问地址

部署成功后，你将获得：
- **Vercel URL**: `https://your-project.vercel.app`
- **Netlify URL**: `https://time-2025.netlify.app`

## 💡 故障排除

### 常见问题：

1. **Node.js未找到**
   ```bash
   # 重新加载环境变量
   source ~/.bashrc
   # 或重启终端
   ```

2. **npm权限问题**
   ```bash
   # 修复npm权限
   sudo chown -R $(whoami) ~/.npm
   ```

3. **Vercel登录失败**
   ```bash
   # 清除缓存重新登录
   vercel logout
   vercel login
   ```

4. **部署失败**
   ```bash
   # 检查项目配置
   cat vercel.json

   # 查看详细错误
   vercel --debug
   ```

## 🎯 快速开始

如果网络连接正常，可以运行：

```bash
# 一键安装和部署
./scripts/install-and-deploy.sh
```

## 📋 检查清单

- [ ] Node.js已安装 (`node --version`)
- [ ] npm已安装 (`npm --version`)
- [ ] Vercel CLI已安装 (`vercel --version`)
- [ ] 已登录Vercel (`vercel whoami`)
- [ ] 项目已部署 (`vercel ls`)
- [ ] 安全功能已测试 (`./scripts/security-test.sh`)
