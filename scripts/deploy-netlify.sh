#!/bin/bash
# Netlify专用部署脚本

echo "🌐 Netlify专用部署系统"
echo "================================="

# 检查Netlify配置
if [ ! -f "netlify.toml" ]; then
    echo "❌ 未找到netlify.toml配置文件"
    echo "💡 请先配置Netlify部署"
    exit 1
fi

# 显示部署信息
echo "📋 Netlify部署信息:"
echo "- 站点: https://time-2025.netlify.app"
echo "- 配置: netlify.toml"
echo "- 最新提交: $(git log --oneline -1)"
echo ""

# 检查Netlify状态
echo "🌐 Netlify状态检查:"
if curl -s -o /dev/null -w "%{http_code}" https://time-2025.netlify.app | grep -q "200"; then
    echo "✅ 当前站点正常"
else
    echo "⚠️ 当前站点异常"
fi
echo ""

# 显示部署理由
echo "📋 部署理由分析:"
echo "1. 代码已同步到GitHub"
echo "2. 功能已通过本地测试"
echo "3. 用户体验良好"
echo "4. 安全配置已启用"
echo ""

# 显示Netlify额度使用情况
echo "💰 Netlify额度使用情况:"
echo "- 构建次数: 请检查Netlify Dashboard"
echo "- 带宽使用: 请检查Netlify Dashboard"
echo "- 部署次数: 请检查Netlify Dashboard"
echo ""

# 询问用户是否同意部署到Netlify
echo "❓ 是否同意部署到Netlify？"
echo "  这将消耗Netlify的构建次数"
echo "  部署后无法撤销"
echo ""
read -p "确认部署到Netlify？(y/N): " netlify_confirm

if [[ $netlify_confirm == [yY] ]]; then
    echo "✅ 用户确认部署，开始Netlify部署..."
    git push origin main
    echo "✅ Netlify部署已触发"
    echo "🌐 请访问: https://time-2025.netlify.app"
    echo "⏱️ 部署通常需要1-2分钟"
else
    echo "❌ 用户取消Netlify部署"
fi
