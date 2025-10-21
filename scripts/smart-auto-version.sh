#!/bin/bash
# TIME项目智能自动版本升级脚本

echo "🧠 智能版本升级系统启动..."

# 检测提交类型
detect_commit_type() {
    local commit_msg=$(git log --oneline -1)

    if echo "$commit_msg" | grep -qE "(BREAKING|重大|重构|重构)"; then
        echo "major"
    elif echo "$commit_msg" | grep -qE "(feat|功能|新功能|添加|feature)"; then
        echo "minor"
    else
        echo "patch"
    fi
}

# 自动升级版本
auto_upgrade_version() {
    local change_type=$(detect_commit_type)
    local current_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

    echo "当前版本: $current_version"
    echo "检测到变更类型: $change_type"

    # 解析版本号
    IFS='.' read -r major minor patch <<< "${current_version#v}"

    case $change_type in
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            echo "🔴 重大更新，升级主版本号"
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            echo "🟡 新功能，升级次版本号"
            ;;
        "patch")
            patch=$((patch + 1))
            echo "🟢 修复，升级修订版本号"
            ;;
    esac

    local new_version="v$major.$minor.$patch"

    # 创建版本标签
    git tag -a $new_version -m "自动版本升级: $new_version - $(date '+%Y-%m-%d %H:%M:%S')"

    # 创建备份
    if [ -f "./scripts/backup-version.sh" ]; then
        ./scripts/backup-version.sh $new_version
    else
        echo "⚠️ 备份脚本不存在，跳过备份"
    fi

    echo "✅ 自动升级到版本: $new_version"
}

# 执行自动升级
auto_upgrade_version
