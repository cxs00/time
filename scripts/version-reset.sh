#!/bin/bash
# 版本重置和重新计算脚本

echo "🔄 版本重置和重新计算系统"
echo "================================="

# 显示当前版本状态
echo "📊 当前版本状态:"
echo "- 当前标签: $(git describe --tags --abbrev=0 2>/dev/null || echo '无标签')"
echo "- 总提交数: $(git rev-list --count HEAD)"
echo "- 分支: $(git branch --show-current)"
echo ""

# 显示提交历史
echo "📝 最近提交历史:"
git log --oneline -10
echo ""

# 计算新的版本号
calculate_new_version() {
    local total_commits=$(git rev-list --count HEAD)
    local major=1
    local minor=0
    local patch=0

    # 基于提交数计算版本
    if [ $total_commits -ge 100 ]; then
        major=2
        minor=$((($total_commits - 100) / 10))
        patch=$(($total_commits % 10))
    elif [ $total_commits -ge 50 ]; then
        major=1
        minor=5
        patch=$(($total_commits - 50))
    elif [ $total_commits -ge 20 ]; then
        major=1
        minor=2
        patch=$(($total_commits - 20))
    else
        major=1
        minor=1
        patch=$total_commits
    fi

    echo "v$major.$minor.$patch"
}

# 计算新版本号
new_version=$(calculate_new_version)
echo "🧮 版本计算:"
echo "- 总提交数: $(git rev-list --count HEAD)"
echo "- 计算版本: $new_version"
echo ""

# 显示版本选项
echo "🎯 版本选项:"
echo "1. 使用计算版本: $new_version"
echo "2. 使用语义版本: v1.0.0"
echo "3. 使用当前时间: v$(date '+%Y.%m.%d')"
echo "4. 自定义版本号"
echo "5. 取消"
echo ""

read -p "请选择版本选项 (1-5): " version_choice

case $version_choice in
    1)
        selected_version="$new_version"
        echo "✅ 选择计算版本: $selected_version"
        ;;
    2)
        selected_version="v1.0.0"
        echo "✅ 选择语义版本: $selected_version"
        ;;
    3)
        selected_version="v$(date '+%Y.%m.%d')"
        echo "✅ 选择时间版本: $selected_version"
        ;;
    4)
        read -p "请输入自定义版本号 (格式: v1.0.0): " custom_version
        if [[ $custom_version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            selected_version="$custom_version"
            echo "✅ 选择自定义版本: $selected_version"
        else
            echo "❌ 版本号格式错误，使用默认版本"
            selected_version="v1.0.0"
        fi
        ;;
    5)
        echo "❌ 取消版本重置"
        exit 0
        ;;
    *)
        echo "❌ 无效选择，使用默认版本"
        selected_version="v1.0.0"
        ;;
esac

echo ""
echo "🏷️ 创建新版本标签: $selected_version"

# 创建新版本标签
git tag -a "$selected_version" -m "TIME项目 - 重新计算版本

版本信息:
- 版本号: $selected_version
- 创建时间: $(date '+%Y-%m-%d %H:%M:%S')
- 总提交数: $(git rev-list --count HEAD)
- 分支: $(git branch --show-current)

功能特性:
- ⏰ 专注的时间管理工具
- 🧠 智能Git Hook系统
- 🚀 分离式部署系统
- 🛡️ 安全防护机制
- 📊 数据统计分析
- 🎯 AdSense广告集成

技术栈:
- HTML5 + CSS3 + JavaScript
- SwiftUI (iOS/macOS)
- ECharts数据可视化
- 响应式设计

版本状态: 稳定版本，功能完整"

echo "✅ 版本标签创建成功: $selected_version"

# 询问是否推送到GitHub
echo ""
echo "❓ 是否推送到GitHub？"
read -p "推送版本标签到GitHub？(y/N): " push_confirm

if [[ $push_confirm == [yY] ]]; then
    echo "📤 推送版本标签到GitHub..."
    git push origin "$selected_version"

    if [ $? -eq 0 ]; then
        echo "✅ 版本标签推送成功"
        echo "🌐 GitHub标签: https://github.com/cxs00/time/releases/tag/$selected_version"
    else
        echo "❌ 版本标签推送失败"
        echo "💡 请检查网络连接或Git配置"
    fi
else
    echo "ℹ️ 跳过GitHub推送"
fi

echo ""
echo "📊 版本重置完成:"
echo "- 新版本: $selected_version"
echo "- 创建时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "- 总提交数: $(git rev-list --count HEAD)"
echo "- 标签状态: $(git tag -l | tail -1)"

echo ""
echo "✅ 版本重置和重新计算完成！"
