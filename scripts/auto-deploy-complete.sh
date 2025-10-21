#!/bin/bash
# 完整的自动部署脚本

echo "🚀 完整自动部署系统"
echo "================================"

# 检查Git状态
if ! git diff --quiet; then
    echo "📝 检测到未提交的更改，自动提交..."
    git add .
    git commit -m "自动提交: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 运行智能版本升级
./scripts/smart-auto-version.sh

# 创建备份
if [ -f "./scripts/backup-version.sh" ]; then
    ./scripts/backup-version.sh $(git describe --tags --abbrev=0)
else
    echo "⚠️ 备份脚本不存在，跳过备份"
fi

# 推送到GitHub（包括tags）
echo "📤 推送到GitHub..."
git push origin main --tags

if [ $? -eq 0 ]; then
    echo "✅ 自动推送成功"
    echo "📦 当前版本: $(git describe --tags --abbrev=0)"
    echo "🌐 GitHub: https://github.com/cxs00/time"
    echo "🌐 Netlify: https://time-2025.netlify.app"
else
    echo "❌ 推送失败，请检查网络连接"
    exit 1
fi

echo "🎉 完整自动部署完成！"
