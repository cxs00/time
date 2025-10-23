# 🚀 TIME企业级应用完整安装指南

## 📋 系统要求

- **操作系统**: macOS (Apple Silicon/Intel), Windows, Linux
- **PowerShell**: 7.0+ (推荐 7.5.4)
- **Node.js**: 18.0+ (用于Vercel部署)
- **Git**: 2.0+ (用于版本控制)

## 🔧 安装步骤

### 1. 安装PowerShell

#### macOS (Apple Silicon)
```bash
# 方法1: 官网下载（推荐）
# 访问: https://github.com/PowerShell/PowerShell/releases
# 下载: powershell-7.5.4-osx-arm64.pkg
# 双击安装

# 方法2: 使用Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask powershell
```

#### macOS (Intel)
```bash
# 下载: powershell-7.5.4-osx-x64.pkg
# 双击安装
```

#### Windows
```powershell
# 使用winget
winget install Microsoft.PowerShell

# 或使用Chocolatey
choco install powershell-core
```

#### Linux
```bash
# Ubuntu/Debian
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# CentOS/RHEL
sudo yum install -y powershell
```

### 2. 验证安装

```powershell
# 检查PowerShell版本
pwsh --version

# 启动PowerShell
pwsh
```

### 3. 运行企业级测试

```powershell
# 在项目根目录执行
pwsh ./scripts-ps/install-and-test.ps1
```

### 4. 启动企业级管理系统

```powershell
# 启动主管理界面
pwsh ./scripts-ps/quick-start.ps1

# 或指定环境
pwsh ./scripts-ps/quick-start.ps1 -Environment Production
```

## 🏗️ 企业级架构

### 目录结构
```
TIME/
├── modules/                 # PowerShell模块
│   ├── Security.psm1       # 安全模块
│   ├── Deployment.psm1     # 部署模块
│   └── Monitoring.psm1     # 监控模块
├── scripts-ps/              # PowerShell脚本
│   ├── quick-start.ps1     # 主管理界面
│   └── install-and-test.ps1 # 安装测试
├── config/                  # 配置文件
│   ├── production.json     # 生产环境
│   └── development.json     # 开发环境
├── logs/                    # 日志文件
└── scripts/                 # Bash脚本（兼容）
```

### 核心功能

#### 🛡️ 安全模块 (Security.psm1)
- **CSP策略检查**: 内容安全策略验证
- **安全头部检查**: XSS、点击劫持防护
- **依赖安全检查**: 恶意代码检测
- **速率限制检查**: DDoS防护验证

#### 🚀 部署模块 (Deployment.psm1)
- **跨平台部署**: 本地、Netlify、Vercel
- **环境管理**: 开发、测试、生产
- **健康检查**: 服务状态监控
- **备份管理**: 自动备份和恢复

#### 📊 监控模块 (Monitoring.psm1)
- **应用监控**: 响应时间、可用性
- **系统监控**: CPU、内存使用率
- **日志管理**: 结构化日志记录
- **告警系统**: 异常检测和通知

## 🎯 使用指南

### 主管理界面
```powershell
pwsh ./scripts-ps/quick-start.ps1
```

**功能菜单:**
1. 🚀 **跨平台部署** - 一键部署到所有平台
2. 🛡️ **安全扫描** - 全面安全合规检查
3. 🔍 **健康检查** - 应用和服务状态监控
4. 📊 **监控面板** - 系统指标和性能监控
5. ⚙️ **配置管理** - 环境配置和部署设置
6. 📦 **备份管理** - 自动备份和版本管理
7. 🔧 **系统诊断** - 环境检查和故障排除
8. ❓ **帮助信息** - 详细使用说明

### 命令行使用

#### 跨平台部署
```powershell
# 部署到所有平台
Deploy-AllPlatforms -Environment Production -Verbose

# 仅本地部署
Deploy-Local -Environment Development

# 仅Netlify部署
Deploy-Netlify -Environment Production

# 仅Vercel部署
Deploy-Vercel -Environment Production
```

#### 安全扫描
```powershell
# 完整安全扫描
Test-SecurityCompliance -TargetPath "." -Verbose

# 生成安全报告
New-SecurityReport -OutputPath "./logs/security-report.json" -IncludeDetails
```

#### 健康检查
```powershell
# 应用健康检查
Test-ApplicationHealth -Verbose

# 持续监控
Start-HealthMonitoring -IntervalSeconds 60
```

## 🔧 配置管理

### 环境配置

#### 生产环境 (config/production.json)
```json
{
  "Environment": "Production",
  "Security": {
    "CSPEnabled": true,
    "RateLimitEnabled": true,
    "MaxRequestsPerMinute": 60
  },
  "Monitoring": {
    "HealthCheckInterval": 60,
    "EnableAlerts": true
  }
}
```

#### 开发环境 (config/development.json)
```json
{
  "Environment": "Development",
  "Security": {
    "RateLimitEnabled": false,
    "MaxRequestsPerMinute": 120
  },
  "Monitoring": {
    "HealthCheckInterval": 30,
    "EnableAlerts": false
  }
}
```

## 📊 监控和告警

### 系统指标
- **响应时间**: 应用响应时间监控
- **可用性**: 服务可用性检查
- **资源使用**: CPU、内存使用率
- **错误率**: 应用错误率统计

### 告警配置
```powershell
# 设置告警阈值
$Global:MonitoringConfig.Thresholds.ResponseTime = 5000  # 5秒
$Global:MonitoringConfig.Thresholds.MemoryUsage = 80     # 80%
$Global:MonitoringConfig.Thresholds.CPUUsage = 90       # 90%

# 启用告警
$Global:MonitoringConfig.EnableAlerts = $true
```

## 🚀 部署流程

### 1. 开发阶段
```powershell
# 启动开发环境
pwsh ./scripts-ps/quick-start.ps1 -Environment Development

# 本地测试
Deploy-Local -Environment Development
```

### 2. 测试阶段
```powershell
# 安全扫描
Test-SecurityCompliance -TargetPath "." -Verbose

# 健康检查
Test-ApplicationHealth -Verbose
```

### 3. 生产部署
```powershell
# 跨平台部署
Deploy-AllPlatforms -Environment Production -Verbose

# 监控部署状态
Start-HealthMonitoring -IntervalSeconds 60
```

## 🔧 故障排除

### 常见问题

#### PowerShell未安装
```bash
# 检查安装状态
pwsh --version

# 如果未安装，按照上述步骤安装
```

#### 模块加载失败
```powershell
# 检查模块文件
Test-Path ./modules/Security.psm1

# 重新导入模块
Import-Module ./modules/Security.psm1 -Force
```

#### 网络连接问题
```powershell
# 测试网络连接
Test-NetConnection -ComputerName github.com -Port 443
Test-NetConnection -ComputerName netlify.com -Port 443
```

### 日志分析
```powershell
# 查看应用日志
Get-Content ./logs/app-*.log | Select-Object -Last 50

# 查看错误日志
Get-Content ./logs/app-*.log | Where-Object { $_ -match "Error" }
```

## 📞 技术支持

### 系统诊断
```powershell
# 运行完整诊断
pwsh ./scripts-ps/install-and-test.ps1 -Verbose
```

### 性能优化
```powershell
# 监控系统性能
Get-SystemMetrics

# 优化建议
Test-ApplicationHealth -Verbose
```

## 🎉 完成！

你的TIME应用现在已经具备企业级功能：

- ✅ **跨平台支持** - Windows, macOS, Linux
- ✅ **企业级安全** - CSP, 安全头部, 速率限制
- ✅ **自动化部署** - 本地, Netlify, Vercel
- ✅ **监控告警** - 健康检查, 性能监控
- ✅ **配置管理** - 多环境支持
- ✅ **日志系统** - 结构化日志记录

开始使用企业级TIME应用管理系统吧！🚀
