# quick-start.ps1 - TIME企业级应用管理脚本
# 跨平台部署和管理系统

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("Development","Staging","Production")]
    [string]$Environment = "Production",

    [Parameter(Mandatory=$false)]
    [switch]$Verbose,

    [Parameter(Mandatory=$false)]
    [switch]$Debug
)

# 设置错误处理
$ErrorActionPreference = "Stop"

# 导入模块
$modulePath = Join-Path $PSScriptRoot "..\modules"
Import-Module (Join-Path $modulePath "Security.psm1") -Force
Import-Module (Join-Path $modulePath "Deployment.psm1") -Force
Import-Module (Join-Path $modulePath "Monitoring.psm1") -Force

# 颜色函数
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# 显示主菜单
function Show-MainMenu {
    Clear-Host
    Write-ColorOutput "🚀 TIME企业级应用管理系统" -Color "Cyan"
    Write-ColorOutput "=================================" -Color "Cyan"
    Write-ColorOutput "环境: $Environment" -Color "Yellow"
    Write-ColorOutput ""
    Write-ColorOutput "📋 请选择操作:" -Color "White"
    Write-ColorOutput ""
    Write-ColorOutput "1. 🚀 跨平台部署" -Color "Green"
    Write-ColorOutput "2. 🛡️ 安全扫描" -Color "Blue"
    Write-ColorOutput "3. 🔍 健康检查" -Color "Yellow"
    Write-ColorOutput "4. 📊 监控面板" -Color "Magenta"
    Write-ColorOutput "5. ⚙️ 配置管理" -Color "Cyan"
    Write-ColorOutput "6. 📦 备份管理" -Color "DarkYellow"
    Write-ColorOutput "7. 🔧 系统诊断" -Color "Red"
    Write-ColorOutput "8. ❓ 帮助信息" -Color "Gray"
    Write-ColorOutput "9. 🚪 退出" -Color "DarkGray"
    Write-ColorOutput ""
}

# 跨平台部署
function Start-CrossPlatformDeployment {
    Write-ColorOutput "🚀 开始跨平台部署..." -Color "Blue"

    try {
        $results = Deploy-AllPlatforms -Environment $Environment -Verbose:$Verbose

        Write-ColorOutput "📊 部署结果:" -Color "Cyan"
        foreach ($result in $results.GetEnumerator()) {
            $status = if ($result.Value.Success) { "✅ 成功" } else { "❌ 失败" }
            $color = if ($result.Value.Success) { "Green" } else { "Red" }
            Write-ColorOutput "  $($result.Key): $status" -Color $color
            if ($result.Value.Message) {
                Write-ColorOutput "    消息: $($result.Value.Message)" -Color "Gray"
            }
        }

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 部署失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 安全扫描
function Start-SecurityScan {
    Write-ColorOutput "🛡️ 开始安全扫描..." -Color "Blue"

    try {
        $securityResults = Test-SecurityCompliance -TargetPath "." -Verbose:$Verbose

        Write-ColorOutput "📊 安全扫描结果:" -Color "Cyan"
        Write-ColorOutput "  整体状态: $(if($securityResults.OverallPass) {'✅ 通过'} else {'❌ 失败'})" -Color $(if($securityResults.OverallPass) {'Green'} else {'Red'})

        foreach ($result in $securityResults.Results.GetEnumerator()) {
            $status = if ($result.Value.Pass) { "✅ 通过" } else { "❌ 失败" }
            $color = if ($result.Value.Pass) { "Green" } else { "Red" }
            Write-ColorOutput "  $($result.Key): $status" -Color $color
            Write-ColorOutput "    详情: $($result.Value.Status)" -Color "Gray"
        }

        # 生成安全报告
        $reportPath = New-SecurityReport -OutputPath "./logs/security-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json" -IncludeDetails
        Write-ColorOutput "📄 安全报告已生成: $reportPath" -Color "Green"

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 安全扫描失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 健康检查
function Start-HealthCheck {
    Write-ColorOutput "🔍 开始健康检查..." -Color "Blue"

    try {
        $healthResults = Test-ApplicationHealth -Verbose:$Verbose

        Write-ColorOutput "📊 健康检查结果:" -Color "Cyan"
        Write-ColorOutput "  整体健康: $(if($healthResults.OverallHealth) {'✅ 健康'} else {'❌ 异常'})" -Color $(if($healthResults.OverallHealth) {'Green'} else {'Red'})

        foreach ($service in $healthResults.Services.GetEnumerator()) {
            $status = if ($service.Value.IsHealthy) { "✅ 健康" } else { "❌ 异常" }
            $color = if ($service.Value.IsHealthy) { "Green" } else { "Red" }
            Write-ColorOutput "  $($service.Key): $status" -Color $color
            if ($service.Value.ResponseTime) {
                Write-ColorOutput "    响应时间: $($service.Value.ResponseTime)ms" -Color "Gray"
            }
        }

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 健康检查失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 监控面板
function Show-MonitoringPanel {
    Write-ColorOutput "📊 监控面板" -Color "Magenta"
    Write-ColorOutput "=============" -Color "Magenta"

    try {
        # 系统指标
        $metrics = Get-SystemMetrics
        Write-ColorOutput "💻 系统指标:" -Color "Cyan"
        Write-ColorOutput "  平台: $($metrics.Platform)" -Color "White"
        Write-ColorOutput "  PowerShell版本: $($metrics.PowerShellVersion)" -Color "White"
        if ($metrics.MemoryUsage) {
            Write-ColorOutput "  内存使用率: $($metrics.MemoryUsage)%" -Color $(if($metrics.MemoryUsage -gt 80) {'Red'} else {'Green'})
        }
        if ($metrics.CPUUsage) {
            Write-ColorOutput "  CPU使用率: $($metrics.CPUUsage)%" -Color $(if($metrics.CPUUsage -gt 90) {'Red'} else {'Green'})
        }

        # 服务状态
        $healthResults = Test-ApplicationHealth
        Write-ColorOutput "🌐 服务状态:" -Color "Cyan"
        foreach ($service in $healthResults.Services.GetEnumerator()) {
            $status = if ($service.Value.IsHealthy) { "✅ 在线" } else { "❌ 离线" }
            $color = if ($service.Value.IsHealthy) { "Green" } else { "Red" }
            Write-ColorOutput "  $($service.Key): $status" -Color $color
        }

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 监控面板加载失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 配置管理
function Show-ConfigurationManager {
    Write-ColorOutput "⚙️ 配置管理" -Color "Cyan"
    Write-ColorOutput "=============" -Color "Cyan"

    try {
        $configPath = "./config/$Environment.json"
        if (Test-Path $configPath) {
            $config = Get-Content $configPath | ConvertFrom-Json
            Write-ColorOutput "📄 当前配置 ($Environment):" -Color "Green"
            Write-ColorOutput "  环境: $($config.Environment)" -Color "White"
            Write-ColorOutput "  平台: $($config.Platform)" -Color "White"

            Write-ColorOutput "🎯 部署目标:" -Color "Yellow"
            foreach ($target in $config.Targets.PSObject.Properties) {
                Write-ColorOutput "  $($target.Name): $($target.Value.URL)" -Color "White"
            }

            Write-ColorOutput "🛡️ 安全配置:" -Color "Yellow"
            Write-ColorOutput "  CSP启用: $($config.Security.CSPEnabled)" -Color "White"
            Write-ColorOutput "  速率限制: $($config.Security.RateLimitEnabled)" -Color "White"
            Write-ColorOutput "  最大请求/分钟: $($config.Security.MaxRequestsPerMinute)" -Color "White"
        } else {
            Write-ColorOutput "❌ 配置文件不存在: $configPath" -Color "Red"
        }

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 配置管理失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 备份管理
function Show-BackupManager {
    Write-ColorOutput "📦 备份管理" -Color "DarkYellow"
    Write-ColorOutput "=============" -Color "DarkYellow"

    try {
        $backupPath = "$HOME/Desktop/TIME-History"
        if (Test-Path $backupPath) {
            $backups = Get-ChildItem $backupPath -Directory | Sort-Object LastWriteTime -Descending
            Write-ColorOutput "📁 可用备份:" -Color "Green"
            foreach ($backup in $backups | Select-Object -First 5) {
                $size = (Get-ChildItem $backup.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
                $sizeMB = [math]::Round($size / 1MB, 2)
                Write-ColorOutput "  $($backup.Name) - $sizeMB MB - $($backup.LastWriteTime)" -Color "White"
            }
        } else {
            Write-ColorOutput "📁 备份目录不存在: $backupPath" -Color "Yellow"
        }

        Write-ColorOutput ""
        Write-ColorOutput "🔄 创建新备份..." -Color "Blue"
        $newBackup = New-DeploymentBackup
        if ($newBackup) {
            Write-ColorOutput "✅ 备份已创建: $newBackup" -Color "Green"
        } else {
            Write-ColorOutput "❌ 备份创建失败" -Color "Red"
        }

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 备份管理失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 系统诊断
function Start-SystemDiagnostics {
    Write-ColorOutput "🔧 系统诊断" -Color "Red"
    Write-ColorOutput "=============" -Color "Red"

    try {
        Write-ColorOutput "🔍 检查系统环境..." -Color "Blue"

        # PowerShell版本
        Write-ColorOutput "PowerShell版本: $($PSVersionTable.PSVersion)" -Color "White"

        # 模块检查
        Write-ColorOutput "📦 模块状态:" -Color "Cyan"
        $modules = @("Security", "Deployment", "Monitoring")
        foreach ($module in $modules) {
            $modulePath = Join-Path $PSScriptRoot "..\modules\$module.psm1"
            if (Test-Path $modulePath) {
                Write-ColorOutput "  ✅ $module" -Color "Green"
            } else {
                Write-ColorOutput "  ❌ $module" -Color "Red"
            }
        }

        # 配置文件检查
        Write-ColorOutput "📄 配置文件:" -Color "Cyan"
        $configFiles = @("production.json", "development.json")
        foreach ($config in $configFiles) {
            $configPath = Join-Path $PSScriptRoot "..\config\$config"
            if (Test-Path $configPath) {
                Write-ColorOutput "  ✅ $config" -Color "Green"
            } else {
                Write-ColorOutput "  ❌ $config" -Color "Red"
            }
        }

        # 网络连接测试
        Write-ColorOutput "🌐 网络连接测试:" -Color "Cyan"
        $testURLs = @("https://github.com", "https://netlify.com", "https://vercel.com")
        foreach ($url in $testURLs) {
            try {
                $response = Invoke-WebRequest -Uri $url -TimeoutSec 5 -ErrorAction Stop
                Write-ColorOutput "  ✅ $url" -Color "Green"
            } catch {
                Write-ColorOutput "  ❌ $url" -Color "Red"
            }
        }

        Read-Host "按回车键继续..."
    }
    catch {
        Write-ColorOutput "❌ 系统诊断失败: $($_.Exception.Message)" -Color "Red"
        Read-Host "按回车键继续..."
    }
}

# 帮助信息
function Show-Help {
    Write-ColorOutput "❓ 帮助信息" -Color "Gray"
    Write-ColorOutput "=============" -Color "Gray"
    Write-ColorOutput ""
    Write-ColorOutput "📋 功能说明:" -Color "White"
    Write-ColorOutput "• 跨平台部署: 支持本地、Netlify、Vercel部署" -Color "White"
    Write-ColorOutput "• 安全扫描: 检查CSP、安全头部、依赖安全" -Color "White"
    Write-ColorOutput "• 健康检查: 监控应用和服务状态" -Color "White"
    Write-ColorOutput "• 监控面板: 系统指标和服务状态" -Color "White"
    Write-ColorOutput "• 配置管理: 环境配置和部署设置" -Color "White"
    Write-ColorOutput "• 备份管理: 自动备份和恢复" -Color "White"
    Write-ColorOutput "• 系统诊断: 环境检查和故障排除" -Color "White"
    Write-ColorOutput ""
    Write-ColorOutput "🎯 使用流程:" -Color "White"
    Write-ColorOutput "1. 选择跨平台部署进行部署" -Color "White"
    Write-ColorOutput "2. 运行安全扫描确保安全" -Color "White"
    Write-ColorOutput "3. 使用健康检查监控状态" -Color "White"
    Write-ColorOutput "4. 通过监控面板查看指标" -Color "White"
    Write-ColorOutput ""
    Write-ColorOutput "💡 提示:" -Color "White"
    Write-ColorOutput "• 使用 -Verbose 参数获取详细信息" -Color "White"
    Write-ColorOutput "• 使用 -Debug 参数启用调试模式" -Color "White"
    Write-ColorOutput "• 配置文件位于 ./config/ 目录" -Color "White"
    Write-ColorOutput "• 日志文件位于 ./logs/ 目录" -Color "White"
    Write-ColorOutput ""
    Read-Host "按回车键继续..."
}

# 主循环
function Start-MainLoop {
    while ($true) {
        Show-MainMenu

        $choice = Read-Host "请输入选项 (1-9)"

        switch ($choice) {
            "1" { Start-CrossPlatformDeployment }
            "2" { Start-SecurityScan }
            "3" { Start-HealthCheck }
            "4" { Show-MonitoringPanel }
            "5" { Show-ConfigurationManager }
            "6" { Show-BackupManager }
            "7" { Start-SystemDiagnostics }
            "8" { Show-Help }
            "9" {
                Write-ColorOutput "👋 再见！" -Color "Green"
                exit 0
            }
            default {
                Write-ColorOutput "❌ 无效选项，请重新选择" -Color "Red"
                Start-Sleep -Seconds 1
            }
        }
    }
}

# 启动主程序
try {
    Write-ColorOutput "🚀 TIME企业级应用管理系统启动中..." -Color "Cyan"
    Write-ColorOutput "环境: $Environment" -Color "Yellow"

    if ($Debug) {
        Write-ColorOutput "🐛 调试模式已启用" -Color "Yellow"
    }

    Start-MainLoop
}
catch {
    Write-ColorOutput "❌ 系统启动失败: $($_.Exception.Message)" -Color "Red"
    exit 1
}
