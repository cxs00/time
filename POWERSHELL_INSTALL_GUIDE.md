# 🚀 PowerShell安装指南

## 📋 系统信息
- **Mac类型**: Apple Silicon (arm64)
- **推荐版本**: PowerShell 7.5.4 arm64

## 🔧 安装方法

### 方法1: 使用Homebrew（推荐）

#### 1. 安装Homebrew
在终端中运行：
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**注意**: 需要输入管理员密码

#### 2. 安装PowerShell
```bash
brew install --cask powershell
```

#### 3. 验证安装
```bash
pwsh --version
```

### 方法2: 官网下载（无需管理员权限）

#### 1. 访问下载页面
打开浏览器访问：
https://github.com/PowerShell/PowerShell/releases

#### 2. 下载对应版本
下载文件：`powershell-7.5.4-osx-arm64.pkg`

#### 3. 安装
1. 双击下载的 `.pkg` 文件
2. 按提示完成安装
3. 重启终端

#### 4. 验证安装
```bash
pwsh --version
```

## 🎯 安装完成后

### 启动PowerShell
```bash
pwsh
```

### 检查版本
```powershell
$PSVersionTable.PSVersion
```

### 退出PowerShell
```powershell
exit
```

## 💡 使用建议

### 对于TIME项目
PowerShell可以用于：
- 更强大的脚本编写
- 跨平台兼容性
- 与.NET生态系统集成

### 当前bash脚本
你的TIME项目已经有完整的bash脚本：
- `./scripts/quick-start.sh` - 快速启动
- `./scripts/deploy-python.sh` - Python部署
- `./scripts/install-and-deploy.sh` - 一键部署

## 🔄 安装步骤总结

1. **选择安装方法**:
   - Homebrew（需要管理员权限）
   - 官网下载（无需权限）

2. **安装PowerShell**:
   - 使用Homebrew: `brew install --cask powershell`
   - 或下载安装包手动安装

3. **验证安装**:
   - 运行 `pwsh --version`
   - 检查版本信息

4. **开始使用**:
   - 运行 `pwsh` 启动PowerShell
   - 或继续使用现有的bash脚本

## 📞 需要帮助？

如果遇到问题：
1. 检查网络连接
2. 确认管理员权限
3. 重启终端
4. 使用官网下载方式
