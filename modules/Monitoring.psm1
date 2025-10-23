# Monitoring.psm1 - 企业级监控模块
# TIME应用监控和告警系统

# 监控配置类
class MonitoringConfig {
    [string]$LogPath
    [string]$AlertEmail
    [int]$HealthCheckInterval
    [hashtable]$Thresholds
    [bool]$EnableAlerts

    MonitoringConfig() {
        $this.LogPath = "./logs"
        $this.AlertEmail = ""
        $this.HealthCheckInterval = 60
        $this.EnableAlerts = $true
        $this.Thresholds = @{
            ResponseTime = 5000  # 5秒
            ErrorRate = 5        # 5%
            MemoryUsage = 80     # 80%
            CPUUsage = 90       # 90%
        }
    }
}

# 全局监控配置
$Global:MonitoringConfig = [MonitoringConfig]::new()

# 应用健康检查
function Test-ApplicationHealth {
    param(
        [Parameter(Mandatory=$false)]
        [string[]]$URLs = @("http://localhost:8000", "https://time-2025.netlify.app"),

        [Parameter(Mandatory=$false)]
        [switch]$Verbose
    )

    Write-Host "🔍 开始应用健康检查..." -ForegroundColor Blue

    $healthResults = @{
        Timestamp = Get-Date
        OverallHealth = $true
        Services = @{}
        Metrics = @{}
    }

    foreach ($url in $URLs) {
        $serviceHealth = Test-ServiceHealth -URL $url -Verbose:$Verbose
        $healthResults.Services[$url] = $serviceHealth

        if (-not $serviceHealth.IsHealthy) {
            $healthResults.OverallHealth = $false
        }
    }

    # 系统指标
    $healthResults.Metrics = Get-SystemMetrics

    if ($Verbose) {
        Write-Host "📊 健康检查结果:" -ForegroundColor Cyan
        foreach ($service in $healthResults.Services.GetEnumerator()) {
            $status = if ($service.Value.IsHealthy) { "✅ 健康" } else { "❌ 异常" }
            Write-Host "  $($service.Key): $status" -ForegroundColor $(if ($service.Value.IsHealthy) { 'Green' } else { 'Red' })
        }
    }

    return $healthResults
}

# 服务健康检查
function Test-ServiceHealth {
    param(
        [Parameter(Mandatory=$true)]
        [string]$URL,

        [Parameter(Mandatory=$false)]
        [switch]$Verbose
    )

    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-WebRequest -Uri $URL -TimeoutSec 10 -ErrorAction Stop
        $stopwatch.Stop()

        $responseTime = $stopwatch.ElapsedMilliseconds

        # 检查响应时间阈值
        $responseTimeOK = $responseTime -lt $Global:MonitoringConfig.Thresholds.ResponseTime

        # 检查状态码
        $statusCodeOK = $response.StatusCode -eq 200

        # 检查内容完整性
        $contentOK = $response.Content -match "TIME" -and $response.Content -match "安全"

        $isHealthy = $responseTimeOK -and $statusCodeOK -and $contentOK

        if ($Verbose) {
            Write-Host "  $URL - 响应时间: ${responseTime}ms, 状态码: $($response.StatusCode)" -ForegroundColor $(if ($isHealthy) { 'Green' } else { 'Red' })
        }

        return @{
            IsHealthy = $isHealthy
            ResponseTime = $responseTime
            StatusCode = $response.StatusCode
            ContentOK = $contentOK
            Timestamp = Get-Date
        }
    }
    catch {
        if ($Verbose) {
            Write-Host "  $URL - 连接失败: $($_.Exception.Message)" -ForegroundColor Red
        }

        return @{
            IsHealthy = $false
            Error = $_.Exception.Message
            Timestamp = Get-Date
        }
    }
}

# 系统指标收集
function Get-SystemMetrics {
    try {
        $metrics = @{
            Timestamp = Get-Date
            Platform = $PSVersionTable.OS
            PowerShellVersion = $PSVersionTable.PSVersion
        }

        # 内存使用情况
        if ($IsWindows) {
            $memory = Get-WmiObject -Class Win32_OperatingSystem
            $metrics.MemoryUsage = [math]::Round((($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100, 2)
        } else {
            # macOS/Linux
            $memoryInfo = Get-Content /proc/meminfo 2>$null
            if ($memoryInfo) {
                $totalMem = ($memoryInfo | Where-Object { $_ -match 'MemTotal:' }) -replace '\D+', ''
                $freeMem = ($memoryInfo | Where-Object { $_ -match 'MemAvailable:' }) -replace '\D+', ''
                $metrics.MemoryUsage = [math]::Round((($totalMem - $freeMem) / $totalMem) * 100, 2)
            }
        }

        # CPU使用情况（简化版）
        $metrics.CPUUsage = Get-CPUUsage

        return $metrics
    }
    catch {
        return @{
            Timestamp = Get-Date
            Error = $_.Exception.Message
        }
    }
}

# CPU使用率获取
function Get-CPUUsage {
    try {
        if ($IsWindows) {
            $cpu = Get-WmiObject -Class Win32_Processor
            return [math]::Round($cpu.LoadPercentage, 2)
        } else {
            # macOS/Linux - 使用top命令
            $topResult = top -l 1 -n 0 2>$null
            if ($topResult) {
                $cpuLine = $topResult | Where-Object { $_ -match 'CPU usage' }
                if ($cpuLine) {
                    $cpuMatch = $cpuLine -match '(\d+\.\d+)%'
                    if ($cpuMatch) {
                        return [math]::Round([double]$matches[1], 2)
                    }
                }
            }
        }
        return 0
    }
    catch {
        return 0
    }
}

# 日志记录
function Write-EnterpriseLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Info","Warning","Error","Critical")]
        [string]$Level = "Info",

        [Parameter(Mandatory=$false)]
        [string]$Module = "Monitoring",

        [Parameter(Mandatory=$false)]
        [string]$LogPath = "./logs"
    )

    try {
        if (-not (Test-Path $LogPath)) {
            New-Item -ItemType Directory -Path $LogPath -Force
        }

        $logEntry = @{
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Level = $Level
            Module = $Module
            Message = $Message
            Hostname = $env:COMPUTERNAME
            User = $env:USERNAME
        }

        $logFile = Join-Path $LogPath "app-$(Get-Date -Format 'yyyy-MM-dd').log"
        $logEntry | ConvertTo-Json -Compress | Add-Content -Path $logFile -Encoding UTF8

        # 控制台输出
        $color = switch ($Level) {
            "Info" { "White" }
            "Warning" { "Yellow" }
            "Error" { "Red" }
            "Critical" { "Magenta" }
        }

        Write-Host "[$Level] $Message" -ForegroundColor $color
    }
    catch {
        Write-Host "❌ 日志记录失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 告警系统
function Send-Alert {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Low","Medium","High","Critical")]
        [string]$Severity = "Medium",

        [Parameter(Mandatory=$false)]
        [string]$Email = $Global:MonitoringConfig.AlertEmail
    )

    Write-EnterpriseLog -Message "🚨 告警: $Message" -Level "Critical" -Module "Alert"

    # 这里可以集成邮件、Slack、Teams等告警系统
    if ($Email -and $Email -ne "") {
        Write-Host "📧 发送邮件告警到: $Email" -ForegroundColor Yellow
        # Send-MailMessage -To $Email -Subject "TIME应用告警" -Body $Message
    }

    # 控制台告警
    $alertColor = switch ($Severity) {
        "Low" { "Yellow" }
        "Medium" { "Orange" }
        "High" { "Red" }
        "Critical" { "Magenta" }
    }

    Write-Host "🚨 [$Severity] $Message" -ForegroundColor $alertColor
}

# 持续监控
function Start-HealthMonitoring {
    param(
        [Parameter(Mandatory=$false)]
        [int]$IntervalSeconds = 60,

        [Parameter(Mandatory=$false)]
        [string[]]$URLs = @("http://localhost:8000", "https://time-2025.netlify.app"),

        [Parameter(Mandatory=$false)]
        [switch]$Verbose
    )

    Write-Host "🔍 启动持续健康监控..." -ForegroundColor Blue
    Write-Host "监控间隔: ${IntervalSeconds}秒" -ForegroundColor Cyan
    Write-Host "监控目标: $($URLs -join ', ')" -ForegroundColor Cyan
    Write-Host "按 Ctrl+C 停止监控" -ForegroundColor Yellow

    try {
        while ($true) {
            $healthResults = Test-ApplicationHealth -URLs $URLs -Verbose:$Verbose

            if (-not $healthResults.OverallHealth) {
                Send-Alert -Message "应用健康检查失败" -Severity "High"
            }

            # 检查系统指标
            $metrics = $healthResults.Metrics
            if ($metrics.MemoryUsage -gt $Global:MonitoringConfig.Thresholds.MemoryUsage) {
                Send-Alert -Message "内存使用率过高: $($metrics.MemoryUsage)%" -Severity "Medium"
            }

            if ($metrics.CPUUsage -gt $Global:MonitoringConfig.Thresholds.CPUUsage) {
                Send-Alert -Message "CPU使用率过高: $($metrics.CPUUsage)%" -Severity "Medium"
            }

            Start-Sleep -Seconds $IntervalSeconds
        }
    }
    catch {
        Write-Host "❌ 监控异常: $($_.Exception.Message)" -ForegroundColor Red
        Send-Alert -Message "监控系统异常: $($_.Exception.Message)" -Severity "Critical"
    }
}

# 导出函数
Export-ModuleMember -Function Test-ApplicationHealth, Test-ServiceHealth, Get-SystemMetrics, Write-EnterpriseLog, Send-Alert, Start-HealthMonitoring
