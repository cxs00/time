#!/bin/bash
# TIME项目自动版本升级脚本

echo "📈 开始自动版本升级..."

# 获取当前版本
CURRENT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "当前版本: $CURRENT_VERSION"

# 解析版本号
IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT_VERSION#v}"

# 检测提交信息中的关键词
LAST_COMMIT=$(git log --oneline -1)
echo "最新提交: $LAST_COMMIT"

# 根据提交信息判断版本类型
if echo "$LAST_COMMIT" | grep -qE "(BREAKING|重大|重构|重构|major)"; then
    # 重大更新 -> 主版本号+1
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    echo "🔴 检测到重大更新，升级主版本号"
elif echo "$LAST_COMMIT" | grep -qE "(feat|功能|新功能|添加|feature|minor)"; then
    # 新功能 -> 次版本号+1
    MINOR=$((MINOR + 1))
    PATCH=0
    echo "🟡 检测到新功能，升级次版本号"
else
    # 修复 -> 修订版本号+1
    PATCH=$((PATCH + 1))
    echo "🟢 检测到修复，升级修订版本号"
fi

NEW_VERSION="v$MAJOR.$MINOR.$PATCH"
echo "新版本: $NEW_VERSION"

# 创建版本标签
git tag -a $NEW_VERSION -m "自动版本升级: $NEW_VERSION - $(date '+%Y-%m-%d %H:%M:%S')"

if [ $? -eq 0 ]; then
    echo "✅ 版本标签 $NEW_VERSION 创建成功"
else
    echo "❌ 版本标签创建失败"
    exit 1
fi

# 创建备份
echo "💾 创建版本备份..."
./scripts/backup-version.sh $NEW_VERSION

echo "✅ 版本 $NEW_VERSION 升级完成！"
echo "📊 版本信息:"
echo "  旧版本: $CURRENT_VERSION"
echo "  新版本: $NEW_VERSION"
echo "  升级类型: $([ $MAJOR -gt $(echo $CURRENT_VERSION | cut -d'.' -f1 | sed 's/v//') ] && echo "主版本" || [ $MINOR -gt $(echo $CURRENT_VERSION | cut -d'.' -f2) ] && echo "次版本" || echo "修订版本")"
