# Security.psm1 - 企业级安全模块
# TIME应用安全防护系统

# 安全配置类
class SecurityConfig {
    [string]$CSPPolicy
    [hashtable]$SecurityHeaders
    [string[]]$AllowedDomains
    [bool]$RateLimitEnabled
    [int]$MaxRequestsPerMinute

    SecurityConfig() {
        $this.CSPPolicy = "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://pagead2.googlesyndication.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https:; frame-src 'self' https://googleads.g.doubleclick.net; object-src 'none'; base-uri 'self'; form-action 'self';"

        $this.SecurityHeaders = @{
            'X-Content-Type-Options' = 'nosniff'
            'X-Frame-Options' = 'DENY'
            'X-XSS-Protection' = '1; mode=block'
            'Referrer-Policy' = 'strict-origin-when-cross-origin'
            'Permissions-Policy' = 'camera=(), microphone=(), geolocation=()'
        }

        $this.AllowedDomains = @(
            'localhost',
            'time-2025.netlify.app',
            '*.vercel.app'
        )

        $this.RateLimitEnabled = $true
        $this.MaxRequestsPerMinute = 60
    }
}

# 全局安全配置
$Global:SecurityConfig = [SecurityConfig]::new()

# 安全扫描函数
function Test-SecurityCompliance {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetPath,

        [Parameter(Mandatory=$false)]
        [switch]$Verbose
    )

    Write-Host "🛡️ 开始安全合规检查..." -ForegroundColor Blue

    $results = @{
        CSP = Test-ContentSecurityPolicy -Path $TargetPath
        Headers = Test-SecurityHeaders -Path $TargetPath
        Dependencies = Test-DependencySecurity -Path $TargetPath
        RateLimit = Test-RateLimitConfiguration -Path $TargetPath
    }

    $overallPass = $results.CSP.Pass -and $results.Headers.Pass -and $results.Dependencies.Pass -and $results.RateLimit.Pass

    if ($Verbose) {
        Write-Host "📊 安全检查结果:" -ForegroundColor Cyan
        Write-Host "  CSP策略: $($results.CSP.Status)" -ForegroundColor $(if($results.CSP.Pass) {'Green'} else {'Red'})
        Write-Host "  安全头部: $($results.Headers.Status)" -ForegroundColor $(if($results.Headers.Pass) {'Green'} else {'Red'})
        Write-Host "  依赖安全: $($results.Dependencies.Status)" -ForegroundColor $(if($results.Dependencies.Pass) {'Green'} else {'Red'})
        Write-Host "  速率限制: $($results.RateLimit.Status)" -ForegroundColor $(if($results.RateLimit.Pass) {'Green'} else {'Red'})
    }

    return @{
        Results = $results
        OverallPass = $overallPass
        Timestamp = Get-Date
    }
}

# CSP策略检查
function Test-ContentSecurityPolicy {
    param([string]$Path)

    try {
        $htmlFiles = Get-ChildItem -Path $Path -Filter "*.html" -Recurse

        foreach ($file in $htmlFiles) {
            $content = Get-Content $file.FullName -Raw

            if ($content -notmatch 'Content-Security-Policy') {
                return @{
                    Pass = $false
                    Status = "❌ 缺少CSP策略"
                    Details = "文件 $($file.Name) 缺少Content-Security-Policy头部"
                }
            }
        }

        return @{
            Pass = $true
            Status = "✅ CSP策略已配置"
            Details = "所有HTML文件都包含CSP策略"
        }
    }
    catch {
        return @{
            Pass = $false
            Status = "❌ CSP检查失败"
            Details = $_.Exception.Message
        }
    }
}

# 安全头部检查
function Test-SecurityHeaders {
    param([string]$Path)

    try {
        $htmlFiles = Get-ChildItem -Path $Path -Filter "*.html" -Recurse

        $requiredHeaders = @(
            'X-Content-Type-Options',
            'X-Frame-Options',
            'X-XSS-Protection',
            'Referrer-Policy'
        )

        foreach ($file in $htmlFiles) {
            $content = Get-Content $file.FullName -Raw

            foreach ($header in $requiredHeaders) {
                if ($content -notmatch $header) {
                    return @{
                        Pass = $false
                        Status = "❌ 缺少安全头部"
                        Details = "文件 $($file.Name) 缺少 $header 头部"
                    }
                }
            }
        }

        return @{
            Pass = $true
            Status = "✅ 安全头部已配置"
            Details = "所有HTML文件都包含必要的安全头部"
        }
    }
    catch {
        return @{
            Pass = $false
            Status = "❌ 安全头部检查失败"
            Details = $_.Exception.Message
        }
    }
}

# 依赖安全检查
function Test-DependencySecurity {
    param([string]$Path)

    try {
        $jsFiles = Get-ChildItem -Path $Path -Filter "*.js" -Recurse

        $suspiciousPatterns = @(
            'eval\s*\(',
            'Function\s*\(',
            'setTimeout\s*\([^,]*,\s*0\)',
            'setInterval\s*\([^,]*,\s*0\)'
        )

        foreach ($file in $jsFiles) {
            $content = Get-Content $file.FullName -Raw

            foreach ($pattern in $suspiciousPatterns) {
                if ($content -match $pattern) {
                    return @{
                        Pass = $false
                        Status = "❌ 发现可疑代码"
                        Details = "文件 $($file.Name) 包含可疑模式: $pattern"
                    }
                }
            }
        }

        return @{
            Pass = $true
            Status = "✅ 依赖安全检查通过"
            Details = "未发现可疑代码模式"
        }
    }
    catch {
        return @{
            Pass = $false
            Status = "❌ 依赖安全检查失败"
            Details = $_.Exception.Message
        }
    }
}

# 速率限制配置检查
function Test-RateLimitConfiguration {
    param([string]$Path)

    try {
        $jsFiles = Get-ChildItem -Path $Path -Filter "*security*.js" -Recurse

        if ($jsFiles.Count -eq 0) {
            return @{
                Pass = $false
                Status = "❌ 缺少安全模块"
                Details = "未找到安全配置文件"
            }
        }

        foreach ($file in $jsFiles) {
            $content = Get-Content $file.FullName -Raw

            if ($content -notmatch 'rateLimit|RateLimit') {
                return @{
                    Pass = $false
                    Status = "❌ 缺少速率限制"
                    Details = "文件 $($file.Name) 缺少速率限制配置"
                }
            }
        }

        return @{
            Pass = $true
            Status = "✅ 速率限制已配置"
            Details = "安全模块包含速率限制功能"
        }
    }
    catch {
        return @{
            Pass = $false
            Status = "❌ 速率限制检查失败"
            Details = $_.Exception.Message
        }
    }
}

# 生成安全报告
function New-SecurityReport {
    param(
        [Parameter(Mandatory=$true)]
        [string]$OutputPath,

        [Parameter(Mandatory=$false)]
        [switch]$IncludeDetails
    )

    $report = @{
        Timestamp = Get-Date
        SecurityCheck = Test-SecurityCompliance -TargetPath "." -Verbose
        Recommendations = @()
    }

    if (-not $report.SecurityCheck.OverallPass) {
        $report.Recommendations += "修复安全合规问题"
    }

    if ($IncludeDetails) {
        $report.Details = @{
            CSPPolicy = $Global:SecurityConfig.CSPPolicy
            SecurityHeaders = $Global:SecurityConfig.SecurityHeaders
            AllowedDomains = $Global:SecurityConfig.AllowedDomains
        }
    }

    $report | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputPath -Encoding UTF8

    Write-Host "📊 安全报告已生成: $OutputPath" -ForegroundColor Green
    return $OutputPath
}

# 导出函数
Export-ModuleMember -Function Test-SecurityCompliance, Test-ContentSecurityPolicy, Test-SecurityHeaders, Test-DependencySecurity, Test-RateLimitConfiguration, New-SecurityReport
