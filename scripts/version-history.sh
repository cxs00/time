#!/bin/bash
# TIME项目版本历史查看脚本

echo "📋 TIME项目版本历史"
echo "================================"

# 显示所有版本
echo "🏷️ 所有版本标签:"
git tag -l --sort=-version:refname

echo ""
echo "📊 版本统计:"
TOTAL_VERSIONS=$(git tag -l | wc -l)
echo "  总版本数: $TOTAL_VERSIONS"
echo "  最新版本: $(git describe --tags --abbrev=0)"
echo "  当前提交: $(git rev-parse --short HEAD)"

echo ""
echo "📁 本地备份:"
if [ -d "/Users/shanwanjun/Desktop/TIME-History" ]; then
    echo "  备份目录: /Users/shanwanjun/Desktop/TIME-History/"
    if [ "$(ls -A /Users/shanwanjun/Desktop/TIME-History/ 2>/dev/null)" ]; then
        ls -la /Users/shanwanjun/Desktop/TIME-History/
    else
        echo "  无本地备份"
    fi
else
    echo "  备份目录不存在"
fi

echo ""
echo "🔄 版本管理命令:"
echo "  ./scripts/version-traveler.sh list                    # 查看所有版本"
echo "  ./scripts/version-traveler.sh go <版本号>            # 跳转到指定版本"
echo "  ./scripts/version-traveler.sh current                 # 显示当前版本"
echo "  ./scripts/one-click-deploy.sh                        # 一键部署"
echo "  ./scripts/auto-version-upgrade.sh                    # 自动版本升级"

echo ""
echo "📈 最近版本变更:"
git log --oneline --decorate --graph -10
