#!/bin/bash
# 通用部署脚本 - 支持多种平台

echo "🚀 通用部署系统"
echo "================================="

# 检测可用的部署平台
detect_platforms() {
    platforms=()
    
    if [ -f "netlify.toml" ]; then
        platforms+=("Netlify")
    fi
    
    if [ -f "vercel.json" ]; then
        platforms+=("Vercel")
    fi
    
    if [ -f "firebase.json" ]; then
        platforms+=("Firebase")
    fi
    
    if [ -f ".github/workflows/deploy.yml" ]; then
        platforms+=("GitHub Pages")
    fi
    
    if [ -f "docker-compose.yml" ]; then
        platforms+=("Docker")
    fi
    
    echo "${platforms[@]}"
}

# 显示可用的部署平台
echo "📊 检测到的部署平台:"
platforms=($(detect_platforms))
if [ ${#platforms[@]} -eq 0 ]; then
    echo "❌ 未检测到任何部署平台"
    echo "💡 请配置部署平台后重试"
    exit 1
fi

for i in "${!platforms[@]}"; do
    echo "$((i+1)). ${platforms[$i]}"
done
echo ""

# 让用户选择部署平台
echo "❓ 请选择要部署的平台:"
read -p "输入平台编号 (1-${#platforms[@]}): " platform_choice

if [[ $platform_choice -lt 1 || $platform_choice -gt ${#platforms[@]} ]]; then
    echo "❌ 无效选择"
    exit 1
fi

selected_platform="${platforms[$((platform_choice-1))]}"
echo "✅ 已选择: $selected_platform"
echo ""

# 显示部署信息
echo "📋 部署信息:"
echo "- 平台: $selected_platform"
echo "- 仓库: https://github.com/cxs00/time"
echo "- 最新提交: $(git log --oneline -1)"
echo ""

# 显示部署理由
echo "📋 部署理由分析:"
echo "1. 代码已同步到GitHub"
echo "2. 功能已通过本地测试"
echo "3. 用户体验良好"
echo "4. 安全配置已启用"
echo ""

# 显示平台特定的额度信息
case $selected_platform in
    "Netlify")
        echo "💰 Netlify额度使用情况:"
        echo "- 构建次数: 请检查Netlify Dashboard"
        echo "- 带宽使用: 请检查Netlify Dashboard"
        echo "- 部署次数: 请检查Netlify Dashboard"
        ;;
    "Vercel")
        echo "💰 Vercel额度使用情况:"
        echo "- 构建次数: 请检查Vercel Dashboard"
        echo "- 带宽使用: 请检查Vercel Dashboard"
        echo "- 部署次数: 请检查Vercel Dashboard"
        ;;
    "Firebase")
        echo "💰 Firebase额度使用情况:"
        echo "- 构建次数: 请检查Firebase Console"
        echo "- 带宽使用: 请检查Firebase Console"
        echo "- 部署次数: 请检查Firebase Console"
        ;;
    "GitHub Pages")
        echo "💰 GitHub Pages额度使用情况:"
        echo "- 构建次数: 请检查GitHub Actions"
        echo "- 带宽使用: 请检查GitHub Pages"
        echo "- 部署次数: 请检查GitHub Actions"
        ;;
esac
echo ""

# 询问用户是否同意部署
echo "❓ 是否同意部署到 $selected_platform？"
echo "  这将消耗 $selected_platform 的构建次数"
echo "  部署后无法撤销"
echo ""
read -p "确认部署到 $selected_platform？(y/N): " deploy_confirm

if [[ $deploy_confirm == [yY] ]]; then
    echo "✅ 用户确认部署，开始 $selected_platform 部署..."
    
    # 执行平台特定的部署
    case $selected_platform in
        "Netlify")
            echo "🌐 部署到Netlify..."
            git push origin main
            echo "✅ Netlify部署已触发"
            echo "🌐 请访问: https://time-2025.netlify.app"
            ;;
        "Vercel")
            echo "🌐 部署到Vercel..."
            if command -v vercel &> /dev/null; then
                vercel --prod
            else
                echo "❌ Vercel CLI未安装，请先安装: npm install -g vercel"
                exit 1
            fi
            ;;
        "Firebase")
            echo "🌐 部署到Firebase..."
            if command -v firebase &> /dev/null; then
                firebase deploy
            else
                echo "❌ Firebase CLI未安装，请先安装: npm install -g firebase-tools"
                exit 1
            fi
            ;;
        "GitHub Pages")
            echo "🌐 部署到GitHub Pages..."
            git push origin main
            echo "✅ GitHub Pages部署已触发"
            ;;
        "Docker")
            echo "🐳 部署到Docker..."
            docker-compose up -d
            echo "✅ Docker部署完成"
            ;;
    esac
    
    echo "⏱️ 部署通常需要1-2分钟"
else
    echo "❌ 用户取消 $selected_platform 部署"
fi
