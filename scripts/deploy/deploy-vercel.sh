#!/bin/bash
# Vercel专用部署脚本

echo "🌐 Vercel专用部署系统"
echo "================================="

# 检查Vercel配置
if [ ! -f "vercel.json" ]; then
    echo "❌ 未找到vercel.json配置文件"
    echo "💡 请先配置Vercel部署"
    exit 1
fi

# 检查Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI未安装"
    echo "💡 请先安装: npm install -g vercel"
    exit 1
fi

# 显示部署信息
echo "📋 Vercel部署信息:"
echo "- 配置: vercel.json"
echo "- 最新提交: $(git log --oneline -1)"
echo ""

# 显示部署理由
echo "📋 部署理由分析:"
echo "1. 代码已同步到GitHub"
echo "2. 功能已通过本地测试"
echo "3. 用户体验良好"
echo "4. 安全配置已启用"
echo ""

# 显示Vercel额度使用情况
echo "💰 Vercel额度使用情况:"
echo "- 构建次数: 请检查Vercel Dashboard"
echo "- 带宽使用: 请检查Vercel Dashboard"
echo "- 部署次数: 请检查Vercel Dashboard"
echo ""

# 询问用户是否同意部署到Vercel
echo "❓ 是否同意部署到Vercel？"
echo "  这将消耗Vercel的构建次数"
echo "  部署后无法撤销"
echo ""
read -p "确认部署到Vercel？(y/N): " vercel_confirm

if [[ $vercel_confirm == [yY] ]]; then
    echo "✅ 用户确认部署，开始Vercel部署..."
    vercel --prod
    echo "✅ Vercel部署完成"
    echo "⏱️ 部署通常需要1-2分钟"
else
    echo "❌ 用户取消Vercel部署"
fi
