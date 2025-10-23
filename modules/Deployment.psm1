# Deployment.psm1 - 企业级部署模块
# TIME应用跨平台部署系统

# 部署配置类
class DeploymentConfig {
    [string]$Environment
    [string]$Platform
    [hashtable]$Targets
    [hashtable]$Security
    [bool]$AutoBackup
    [string]$BackupPath

    DeploymentConfig([string]$env, [string]$platform) {
        $this.Environment = $env
        $this.Platform = $platform
        $this.AutoBackup = $true
        $this.BackupPath = "$HOME/Desktop/TIME-History"
        $this.LoadConfiguration()
    }

    [void]LoadConfiguration() {
        $configPath = "./config/$($this.Environment).json"
        if (Test-Path $configPath) {
            $config = Get-Content $configPath | ConvertFrom-Json
            $this.Targets = $config.Targets
            $this.Security = $config.Security
        } else {
            $this.SetDefaultConfiguration()
        }
    }

    [void]SetDefaultConfiguration() {
        $this.Targets = @{
            Netlify = @{
                URL = "https://time-2025.netlify.app"
                AutoDeploy = $true
            }
            Vercel = @{
                URL = ""
                AutoDeploy = $false
            }
            Local = @{
                Port = 8000
                AutoStart = $true
            }
        }

        $this.Security = @{
            CSPEnabled = $true
            RateLimitEnabled = $true
            SecurityHeaders = $true
        }
    }
}

# 全局部署配置
$Global:DeploymentConfig = [DeploymentConfig]::new("production", "macOS")

# 跨平台部署函数
function Deploy-AllPlatforms {
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("Development","Staging","Production")]
        [string]$Environment = "Production",

        [Parameter(Mandatory=$false)]
        [switch]$Verbose,

        [Parameter(Mandatory=$false)]
        [switch]$DryRun
    )

    Write-Host "🚀 开始跨平台部署..." -ForegroundColor Blue
    Write-Host "环境: $Environment" -ForegroundColor Cyan

    $results = @{
        Local = Deploy-Local -Environment $Environment -Verbose:$Verbose -DryRun:$DryRun
        Netlify = Deploy-Netlify -Environment $Environment -Verbose:$Verbose -DryRun:$DryRun
        Vercel = Deploy-Vercel -Environment $Environment -Verbose:$Verbose -DryRun:$DryRun
    }

    $successCount = ($results.Values | Where-Object { $_.Success }).Count
    $totalCount = $results.Count

    Write-Host "📊 部署结果: $successCount/$totalCount 成功" -ForegroundColor $(if($successCount -eq $totalCount) {'Green'} else {'Yellow'})

    return $results
}

# 本地部署
function Deploy-Local {
    param(
        [string]$Environment,
        [switch]$Verbose,
        [switch]$DryRun
    )

    try {
        Write-Host "🐍 启动本地部署..." -ForegroundColor Blue

        if ($DryRun) {
            Write-Host "  [DRY RUN] 将启动Python服务器" -ForegroundColor Yellow
            return @{ Success = $true; Message = "Dry run completed" }
        }

        # 检查Python是否可用
        if (-not (Get-Command python3 -ErrorAction SilentlyContinue)) {
            throw "Python3 未安装"
        }

        # 启动本地服务器
        $port = 8000
        while (Test-NetConnection -ComputerName localhost -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) {
            $port++
        }

        Start-Process -FilePath "python3" -ArgumentList "-m", "http.server", $port -WindowStyle Hidden
        Start-Sleep -Seconds 2

        Write-Host "✅ 本地服务器已启动: http://localhost:$port" -ForegroundColor Green
        return @{ Success = $true; Message = "本地服务器启动成功"; URL = "http://localhost:$port" }
    }
    catch {
        Write-Host "❌ 本地部署失败: $($_.Exception.Message)" -ForegroundColor Red
        return @{ Success = $false; Message = $_.Exception.Message }
    }
}

# Netlify部署
function Deploy-Netlify {
    param(
        [string]$Environment,
        [switch]$Verbose,
        [switch]$DryRun
    )

    try {
        Write-Host "🌐 开始Netlify部署..." -ForegroundColor Blue

        if ($DryRun) {
            Write-Host "  [DRY RUN] 将推送到GitHub触发Netlify部署" -ForegroundColor Yellow
            return @{ Success = $true; Message = "Dry run completed" }
        }

        # 检查Git状态
        $gitStatus = git status --porcelain
        if ($gitStatus) {
            Write-Host "📝 检测到未提交的更改，自动提交..." -ForegroundColor Yellow
            git add .
            git commit -m "🔄 PowerShell自动部署 - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }

        # 推送到GitHub
        $pushResult = git push origin main 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ GitHub推送成功，Netlify自动部署中..." -ForegroundColor Green
            return @{ Success = $true; Message = "Netlify部署已触发"; URL = "https://time-2025.netlify.app" }
        } else {
            throw "GitHub推送失败: $pushResult"
        }
    }
    catch {
        Write-Host "❌ Netlify部署失败: $($_.Exception.Message)" -ForegroundColor Red
        return @{ Success = $false; Message = $_.Exception.Message }
    }
}

# Vercel部署
function Deploy-Vercel {
    param(
        [string]$Environment,
        [switch]$Verbose,
        [switch]$DryRun
    )

    try {
        Write-Host "⚡ 开始Vercel部署..." -ForegroundColor Blue

        # 检查Vercel CLI
        if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
            throw "Vercel CLI 未安装，请先安装: npm install -g vercel"
        }

        if ($DryRun) {
            Write-Host "  [DRY RUN] 将部署到Vercel" -ForegroundColor Yellow
            return @{ Success = $true; Message = "Dry run completed" }
        }

        # 部署到Vercel
        $vercelResult = vercel --prod --yes 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Vercel部署成功" -ForegroundColor Green
            return @{ Success = $true; Message = "Vercel部署成功"; URL = "检查vercel ls获取URL" }
        } else {
            throw "Vercel部署失败: $vercelResult"
        }
    }
    catch {
        Write-Host "❌ Vercel部署失败: $($_.Exception.Message)" -ForegroundColor Red
        return @{ Success = $false; Message = $_.Exception.Message }
    }
}

# 健康检查
function Test-DeploymentHealth {
    param(
        [Parameter(Mandatory=$false)]
        [string[]]$URLs = @("http://localhost:8000", "https://time-2025.netlify.app")
    )

    Write-Host "🔍 开始健康检查..." -ForegroundColor Blue

    $results = @{}

    foreach ($url in $URLs) {
        try {
            $response = Invoke-WebRequest -Uri $url -TimeoutSec 10 -ErrorAction Stop
            $results[$url] = @{
                Status = "✅ 健康"
                StatusCode = $response.StatusCode
                ResponseTime = $response.Headers.'X-Response-Time'
            }
        }
        catch {
            $results[$url] = @{
                Status = "❌ 不可用"
                Error = $_.Exception.Message
            }
        }
    }

    return $results
}

# 备份管理
function New-DeploymentBackup {
    param(
        [Parameter(Mandatory=$false)]
        [string]$BackupPath = "$HOME/Desktop/TIME-History"
    )

    try {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupDir = Join-Path $BackupPath "backup_$timestamp"

        if (-not (Test-Path $BackupPath)) {
            New-Item -ItemType Directory -Path $BackupPath -Force
        }

        New-Item -ItemType Directory -Path $backupDir -Force

        # 复制项目文件
        Copy-Item -Path "." -Destination $backupDir -Recurse -Exclude @("node_modules", ".git", "*.log")

        Write-Host "✅ 备份已创建: $backupDir" -ForegroundColor Green
        return $backupDir
    }
    catch {
        Write-Host "❌ 备份失败: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# 导出函数
Export-ModuleMember -Function Deploy-AllPlatforms, Deploy-Local, Deploy-Netlify, Deploy-Vercel, Test-DeploymentHealth, New-DeploymentBackup
