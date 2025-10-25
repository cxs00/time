#!/bin/bash
# 严格Netlify部署控制脚本

echo "🛡️ 严格Netlify部署控制系统"
echo "================================="

# 检查部署历史
echo "📊 部署历史检查:"
echo "- 当前时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "- 今日部署次数: $(git log --since="today" --grep="部署" --oneline | wc -l)"
echo ""

# 显示部署警告
echo "⚠️ 重要提醒:"
echo "1. 每次Netlify部署都会消耗免费额度"
echo "2. 请确保真的需要部署到生产环境"
echo "3. 建议批量更新后统一部署"
echo ""

# 显示部署理由检查清单
echo "📋 部署理由检查清单:"
echo "请确认以下条件:"
echo ""
echo "✅ 功能完整性:"
echo "  - [ ] 所有功能正常工作"
echo "  - [ ] 登录系统正常"
echo "  - [ ] 广告显示正常"
echo "  - [ ] 响应式设计正常"
echo ""
echo "✅ 测试验证:"
echo "  - [ ] 本地测试通过"
echo "  - [ ] 功能测试完成"
echo "  - [ ] 性能测试通过"
echo "  - [ ] 安全测试通过"
echo ""
echo "✅ 部署必要性:"
echo "  - [ ] 这是重要的功能更新"
echo "  - [ ] 这是紧急的bug修复"
echo "  - [ ] 这是版本发布"
echo "  - [ ] 用户需要看到最新版本"
echo ""

# 严格确认流程
echo "🔒 严格确认流程:"
echo ""

# 第一层确认：部署必要性
echo "❓ 第一层确认：是否真的需要部署到Netlify？"
echo "   这将消耗Netlify的构建次数"
echo "   部署后无法撤销"
echo ""
read -p "确认需要部署到Netlify？(y/N): " confirm1

if [[ $confirm1 != [yY] ]]; then
    echo "❌ 用户取消部署"
    echo "💡 建议："
    echo "  1. 继续本地开发"
    echo "  2. 使用 ./scripts/upload-github.sh 仅上传到GitHub"
    echo "  3. 重要更新时再部署"
    exit 0
fi

# 第二层确认：部署类型
echo ""
echo "❓ 第二层确认：请选择部署类型:"
echo "1. 紧急修复 (bug修复，需要立即部署)"
echo "2. 重要功能 (新功能发布，用户需要)"
echo "3. 版本发布 (正式版本发布)"
echo "4. 取消部署"
echo ""
read -p "请选择部署类型 (1-4): " deploy_type

case $deploy_type in
    1)
        echo "🔧 紧急修复部署确认"
        deploy_reason="紧急修复"
        ;;
    2)
        echo "✨ 重要功能部署确认"
        deploy_reason="重要功能"
        ;;
    3)
        echo "🏷️ 版本发布部署确认"
        deploy_reason="版本发布"
        ;;
    4)
        echo "❌ 用户取消部署"
        exit 0
        ;;
    *)
        echo "❌ 无效选择，取消部署"
        exit 1
        ;;
esac

# 第三层确认：最终确认
echo ""
echo "❓ 第三层确认：最终确认部署"
echo "部署类型: $deploy_reason"
echo "部署目标: https://time-2025.netlify.app"
echo "部署时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "⚠️ 最终警告:"
echo "  - 这将消耗Netlify的构建次数"
echo "  - 部署后无法撤销"
echo "  - 请确保所有测试已完成"
echo ""
read -p "最终确认部署？(输入 'DEPLOY' 确认): " final_confirm

if [[ $final_confirm != "DEPLOY" ]]; then
    echo "❌ 用户取消部署"
    echo "💡 如需部署，请重新运行脚本"
    exit 0
fi

# 执行部署
echo ""
echo "🚀 开始Netlify部署..."
echo "部署类型: $deploy_reason"
echo "部署时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 推送到GitHub触发Netlify部署
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Netlify部署已触发"
    echo "🌐 请访问: https://time-2025.netlify.app"
    echo "⏱️ 部署通常需要1-2分钟"
    echo ""
    echo "📊 部署记录:"
    echo "- 部署类型: $deploy_reason"
    echo "- 部署时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "- 部署状态: 已触发"
    echo "- 访问地址: https://time-2025.netlify.app"
else
    echo "❌ 部署失败"
    echo "💡 请检查网络连接或Git配置"
    exit 1
fi

echo ""
echo "✅ 严格Netlify部署完成！"
