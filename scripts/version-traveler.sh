#!/bin/bash
# TIME版本时间旅行器 - 支持双向版本跳转

ACTION=$1
VERSION=$2

case $ACTION in
    "go")
        if [ -z "$VERSION" ]; then
            echo "❌ 请指定版本号"
            echo "用法: ./version-traveler.sh go v2.0.0"
            exit 1
        fi
        
        echo "🚀 跳转到版本: $VERSION"
        git checkout $VERSION
        
        if [ $? -eq 0 ]; then
            echo "✅ 成功跳转到 $VERSION"
            echo "📁 当前工作目录: $(pwd)"
            echo "🏷️ 当前版本: $(git describe --tags 2>/dev/null || echo '无标签')"
        else
            echo "❌ 跳转失败，版本 $VERSION 不存在"
            echo "💡 可用版本: $(git tag -l | tr '\n' ' ')"
        fi
        ;;
        
    "list")
        echo "📋 所有可用版本（按时间排序）:"
        git tag -l --sort=-version:refname
        echo ""
        echo "📍 当前版本: $(git describe --tags 2>/dev/null || echo 'main分支')"
        ;;
        
    "current")
        echo "📍 当前版本信息:"
        echo "   版本: $(git describe --tags 2>/dev/null || echo 'main分支')"
        echo "   提交: $(git rev-parse --short HEAD)"
        echo "   时间: $(git log -1 --format=%ci)"
        echo "   目录: $(pwd)"
        ;;
        
    "compare")
        if [ -z "$VERSION" ]; then
            echo "❌ 请指定对比版本"
            echo "用法: ./version-traveler.sh compare v1.0.0"
            exit 1
        fi
        
        echo "🔍 对比当前版本与 $VERSION:"
        git diff $VERSION --name-only
        ;;
        
    "timeline")
        echo "📅 版本时间线:"
        git log --oneline --graph --decorate --all
        ;;
        
    "create")
        if [ -z "$VERSION" ]; then
            echo "❌ 请指定版本号"
            echo "用法: ./version-traveler.sh create v1.0.0"
            exit 1
        fi
        
        echo "🏷️ 创建新版本: $VERSION"
        
        # 检查工作区状态
        if ! git diff --quiet; then
            echo "⚠️ 工作区有未提交的更改，正在暂存..."
            git stash push -m "临时暂存 - 创建版本 $VERSION"
        fi
        
        # 创建版本标签
        git tag -a $VERSION -m "TIME $VERSION - $(date '+%Y-%m-%d %H:%M:%S')"
        
        # 推送到远程
        git push origin $VERSION
        
        if [ $? -eq 0 ]; then
            echo "✅ 版本 $VERSION 创建成功并已推送到GitHub"
        else
            echo "⚠️ 版本创建成功，但推送失败（网络问题）"
            echo "💡 稍后请手动推送: git push origin $VERSION"
        fi
        
        # 恢复暂存的更改
        if git stash list | grep -q "临时暂存"; then
            git stash pop
        fi
        ;;
        
    *)
        echo "🕰️ TIME版本时间旅行器"
        echo ""
        echo "用法:"
        echo "  ./version-traveler.sh go v2.0.0      # 跳转到指定版本"
        echo "  ./version-traveler.sh list            # 列出所有版本"
        echo "  ./version-traveler.sh current        # 显示当前版本"
        echo "  ./version-traveler.sh compare v1.0.0 # 对比版本差异"
        echo "  ./version-traveler.sh timeline       # 显示版本时间线"
        echo "  ./version-traveler.sh create v1.0.0  # 创建新版本"
        echo ""
        echo "💡 提示: 可以在任意版本间自由跳转，包括从过去跳到未来！"
        ;;
esac
