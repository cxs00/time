#!/bin/bash
# 手动版本管理脚本

echo "🎯 手动版本管理"
echo "================================="

# 显示当前版本
current_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "当前版本: $current_version"

# 显示最近5个版本
echo "最近版本:"
git tag --sort=-version:refname | head -5

echo ""
echo "请选择版本升级类型:"
echo "1. 主版本升级 (重大更新) - v2.0.0"
echo "2. 次版本升级 (新功能) - v1.6.0" 
echo "3. 修订版本升级 (修复) - v1.5.1"
echo "4. 自定义版本号"
echo "5. 取消"

read -p "请选择 (1-5): " choice

case $choice in
    1)
        new_version="v2.0.0"
        echo "🔴 主版本升级到: $new_version"
        ;;
    2)
        # 解析当前版本并升级次版本
        IFS='.' read -r major minor patch <<< "${current_version#v}"
        minor=$((minor + 1))
        patch=0
        new_version="v$major.$minor.$patch"
        echo "🟡 次版本升级到: $new_version"
        ;;
    3)
        # 解析当前版本并升级修订版本
        IFS='.' read -r major minor patch <<< "${current_version#v}"
        patch=$((patch + 1))
        new_version="v$major.$minor.$patch"
        echo "🟢 修订版本升级到: $new_version"
        ;;
    4)
        read -p "请输入新版本号 (格式: v1.0.0): " new_version
        if [[ ! $new_version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "❌ 版本号格式错误，应为 v1.0.0 格式"
            exit 1
        fi
        ;;
    5)
        echo "取消版本升级"
        exit 0
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

# 确认创建版本
echo ""
echo "即将创建版本: $new_version"
read -p "确认创建？(y/N): " confirm

if [[ $confirm == [yY] ]]; then
    # 创建版本标签
    git tag -a $new_version -m "手动版本升级: $new_version"
    
    # 推送到远程
    git push origin $new_version
    
    echo "✅ 版本 $new_version 创建成功！"
    echo "📤 已推送到远程仓库"
else
    echo "❌ 取消版本创建"
fi
