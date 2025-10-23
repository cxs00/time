#!/bin/bash
# 测试智能Git Hook脚本

echo "🧪 智能Git Hook测试脚本"
echo "================================="

# 测试用例
test_cases=(
    "🔧 修复智能Git Hook系统 - 实现自动检测和智能处理"
    "✨ 添加新功能：用户登录系统"
    "🚀 部署到生产环境"
    "🏷️ 版本升级到v2.0.0"
    "⚙️ 更新配置文件"
    "📝 更新文档"
)

# 智能判断操作类型
detect_operation_type() {
    local commit_msg="$1"

    # 检测部署相关操作
    if echo "$commit_msg" | grep -qE "(部署|deploy|发布|release)"; then
        echo "deploy"
    # 检测版本相关操作
    elif echo "$commit_msg" | grep -qE "(版本|version|v[0-9])"; then
        echo "version"
    # 检测功能开发
    elif echo "$commit_msg" | grep -qE "(功能|feat|新功能|添加|feature)"; then
        echo "feature"
    # 检测修复
    elif echo "$commit_msg" | grep -qE "(修复|fix|bug|错误)"; then
        echo "fix"
    # 检测配置更新
    elif echo "$commit_msg" | grep -qE "(配置|config|设置|setup)"; then
        echo "config"
    # 默认情况
    else
        echo "general"
    fi
}

# 测试每个用例
for i in "${!test_cases[@]}"; do
    commit_msg="${test_cases[$i]}"
    operation_type=$(detect_operation_type "$commit_msg")

    echo ""
    echo "测试用例 $((i+1)): $commit_msg"
    echo "检测结果: $operation_type"

    case $operation_type in
        "deploy")
            echo "🚀 部署操作检测到，自动上传到GitHub..."
            echo "💡 建议运行部署脚本: ./scripts/deploy-universal.sh"
            ;;
        "version")
            echo "🏷️ 版本操作检测到，自动上传到GitHub..."
            echo "💡 版本已更新，建议部署到生产环境"
            ;;
        "feature")
            echo "✨ 新功能开发检测到，自动上传到GitHub..."
            echo "💡 功能开发完成，建议测试后部署"
            ;;
        "fix")
            echo "🔧 修复操作检测到，自动上传到GitHub..."
            echo "💡 修复完成，建议立即部署到生产环境"
            ;;
        "config")
            echo "⚙️ 配置更新检测到，自动上传到GitHub..."
            echo "💡 配置已更新，建议测试后部署"
            ;;
        "general")
            echo "📝 常规更新检测到，自动上传到GitHub..."
            echo "💡 常规更新完成，无需特殊处理"
            ;;
    esac
done

echo ""
echo "✅ 智能Git Hook测试完成！"
