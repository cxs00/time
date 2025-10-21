#!/bin/bash
# TIME项目完全自动化版本升级脚本

echo "🚀 完全自动化版本升级系统"
echo "================================"

# 检查Git状态
if ! git diff --quiet; then
    echo "📝 检测到未提交的更改，自动提交..."
    git add .
    git commit -m "自动提交: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 运行智能版本升级
./scripts/smart-auto-version.sh

# 推送到GitHub
echo "📤 推送到GitHub..."
git push origin main --tags

if [ $? -eq 0 ]; then
    echo "✅ 自动推送成功"
else
    echo "❌ 推送失败，请检查网络连接"
    exit 1
fi

echo "🎉 完全自动化版本升级完成！"
echo "📊 当前版本: $(git describe --tags --abbrev=0)"
