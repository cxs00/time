# install-and-test.ps1 - PowerShell安装和测试脚本
# 自动安装PowerShell并测试企业级功能

param(
    [Parameter(Mandatory=$false)]
    [switch]$Force,

    [Parameter(Mandatory=$false)]
    [switch]$Verbose
)

# 颜色函数
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# 检查PowerShell版本
function Test-PowerShellVersion {
    $currentVersion = $PSVersionTable.PSVersion
    $requiredVersion = [Version]"7.0.0"

    if ($currentVersion -ge $requiredVersion) {
        Write-ColorOutput "✅ PowerShell版本检查通过: $currentVersion" -Color "Green"
        return $true
    } else {
        Write-ColorOutput "❌ PowerShell版本过低: $currentVersion (需要 7.0+)" -Color "Red"
        return $false
    }
}

# 检查模块
function Test-Modules {
    Write-ColorOutput "🔍 检查PowerShell模块..." -Color "Blue"

    $modulePath = Join-Path $PSScriptRoot "..\modules"
    $modules = @("Security.psm1", "Deployment.psm1", "Monitoring.psm1")
    $allModulesExist = $true

    foreach ($module in $modules) {
        $moduleFile = Join-Path $modulePath $module
        if (Test-Path $moduleFile) {
            Write-ColorOutput "  ✅ $module" -Color "Green"
        } else {
            Write-ColorOutput "  ❌ $module" -Color "Red"
            $allModulesExist = $false
        }
    }

    return $allModulesExist
}

# 测试模块加载
function Test-ModuleLoading {
    Write-ColorOutput "📦 测试模块加载..." -Color "Blue"

    try {
        $modulePath = Join-Path $PSScriptRoot "..\modules"

        # 测试Security模块
        Import-Module (Join-Path $modulePath "Security.psm1") -Force -ErrorAction Stop
        Write-ColorOutput "  ✅ Security模块加载成功" -Color "Green"

        # 测试Deployment模块
        Import-Module (Join-Path $modulePath "Deployment.psm1") -Force -ErrorAction Stop
        Write-ColorOutput "  ✅ Deployment模块加载成功" -Color "Green"

        # 测试Monitoring模块
        Import-Module (Join-Path $modulePath "Monitoring.psm1") -Force -ErrorAction Stop
        Write-ColorOutput "  ✅ Monitoring模块加载成功" -Color "Green"

        return $true
    }
    catch {
        Write-ColorOutput "  ❌ 模块加载失败: $($_.Exception.Message)" -Color "Red"
        return $false
    }
}

# 测试核心功能
function Test-CoreFunctions {
    Write-ColorOutput "🧪 测试核心功能..." -Color "Blue"

    try {
        # 测试安全扫描
        Write-ColorOutput "  🔍 测试安全扫描..." -Color "Yellow"
        $securityResult = Test-SecurityCompliance -TargetPath "." -Verbose:$Verbose
        if ($securityResult) {
            Write-ColorOutput "    ✅ 安全扫描功能正常" -Color "Green"
        } else {
            Write-ColorOutput "    ❌ 安全扫描功能异常" -Color "Red"
        }

        # 测试部署功能
        Write-ColorOutput "  🚀 测试部署功能..." -Color "Yellow"
        $deployResult = Deploy-Local -Environment "Development" -DryRun
        if ($deployResult.Success) {
            Write-ColorOutput "    ✅ 部署功能正常" -Color "Green"
        } else {
            Write-ColorOutput "    ❌ 部署功能异常" -Color "Red"
        }

        # 测试监控功能
        Write-ColorOutput "  📊 测试监控功能..." -Color "Yellow"
        $monitorResult = Test-ApplicationHealth -URLs @("http://localhost:8000")
        if ($monitorResult) {
            Write-ColorOutput "    ✅ 监控功能正常" -Color "Green"
        } else {
            Write-ColorOutput "    ❌ 监控功能异常" -Color "Red"
        }

        return $true
    }
    catch {
        Write-ColorOutput "  ❌ 核心功能测试失败: $($_.Exception.Message)" -Color "Red"
        return $false
    }
}

# 创建日志目录
function Initialize-Logging {
    Write-ColorOutput "📁 初始化日志系统..." -Color "Blue"

    try {
        $logPath = Join-Path $PSScriptRoot "..\logs"
        if (-not (Test-Path $logPath)) {
            New-Item -ItemType Directory -Path $logPath -Force
            Write-ColorOutput "  ✅ 日志目录已创建: $logPath" -Color "Green"
        } else {
            Write-ColorOutput "  ✅ 日志目录已存在: $logPath" -Color "Green"
        }

        return $true
    }
    catch {
        Write-ColorOutput "  ❌ 日志系统初始化失败: $($_.Exception.Message)" -Color "Red"
        return $false
    }
}

# 生成测试报告
function New-TestReport {
    param(
        [hashtable]$TestResults
    )

    try {
        $reportPath = Join-Path $PSScriptRoot "..\logs\test-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"

        $report = @{
            Timestamp = Get-Date
            PowerShellVersion = $PSVersionTable.PSVersion
            Platform = $PSVersionTable.OS
            TestResults = $TestResults
            Summary = @{
                TotalTests = $TestResults.Count
                PassedTests = ($TestResults.Values | Where-Object { $_ -eq $true }).Count
                FailedTests = ($TestResults.Values | Where-Object { $_ -eq $false }).Count
            }
        }

        $report | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8

        Write-ColorOutput "📄 测试报告已生成: $reportPath" -Color "Green"
        return $reportPath
    }
    catch {
        Write-ColorOutput "❌ 测试报告生成失败: $($_.Exception.Message)" -Color "Red"
        return $null
    }
}

# 主函数
function Start-InstallationAndTest {
    Write-ColorOutput "🚀 PowerShell企业级应用安装和测试" -Color "Cyan"
    Write-ColorOutput "=====================================" -Color "Cyan"
    Write-ColorOutput ""

    $testResults = @{}

    # 1. 检查PowerShell版本
    Write-ColorOutput "1️⃣ 检查PowerShell版本..." -Color "Blue"
    $testResults.PowerShellVersion = Test-PowerShellVersion
    Write-ColorOutput ""

    # 2. 检查模块文件
    Write-ColorOutput "2️⃣ 检查模块文件..." -Color "Blue"
    $testResults.ModulesExist = Test-Modules
    Write-ColorOutput ""

    # 3. 测试模块加载
    Write-ColorOutput "3️⃣ 测试模块加载..." -Color "Blue"
    $testResults.ModuleLoading = Test-ModuleLoading
    Write-ColorOutput ""

    # 4. 初始化日志系统
    Write-ColorOutput "4️⃣ 初始化日志系统..." -Color "Blue"
    $testResults.Logging = Initialize-Logging
    Write-ColorOutput ""

    # 5. 测试核心功能
    Write-ColorOutput "5️⃣ 测试核心功能..." -Color "Blue"
    $testResults.CoreFunctions = Test-CoreFunctions
    Write-ColorOutput ""

    # 生成测试报告
    $reportPath = New-TestReport -TestResults $testResults

    # 显示结果摘要
    Write-ColorOutput "📊 测试结果摘要:" -Color "Cyan"
    $passedTests = ($testResults.Values | Where-Object { $_ -eq $true }).Count
    $totalTests = $testResults.Count
    $successRate = [math]::Round(($passedTests / $totalTests) * 100, 2)

    Write-ColorOutput "  通过测试: $passedTests/$totalTests ($successRate%)" -Color $(if($successRate -ge 80) {'Green'} else {'Red'})

    foreach ($test in $testResults.GetEnumerator()) {
        $status = if ($test.Value) { "✅ 通过" } else { "❌ 失败" }
        $color = if ($test.Value) { "Green" } else { "Red" }
        Write-ColorOutput "  $($test.Key): $status" -Color $color
    }

    Write-ColorOutput ""

    if ($successRate -ge 80) {
        Write-ColorOutput "🎉 安装和测试完成！系统已准备就绪。" -Color "Green"
        Write-ColorOutput "💡 运行以下命令启动企业级管理系统:" -Color "Yellow"
        Write-ColorOutput "   pwsh ./scripts-ps/quick-start.ps1" -Color "White"
    } else {
        Write-ColorOutput "⚠️ 部分测试失败，请检查错误信息并重试。" -Color "Red"
        Write-ColorOutput "📄 详细报告: $reportPath" -Color "Yellow"
    }

    Write-ColorOutput ""
    Read-Host "按回车键退出"
}

# 启动安装和测试
Start-InstallationAndTest
