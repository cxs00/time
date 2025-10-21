#!/bin/bash
# TIME项目一键部署脚本

echo "🚀 TIME项目一键部署系统"
echo "================================"

# 检查Git状态
if ! git diff --quiet; then
    echo "📝 检测到未提交的更改..."
    read -p "是否自动提交？(y/n): " AUTO_COMMIT
    
    if [ "$AUTO_COMMIT" = "y" ]; then
        git add .
        git commit -m "自动提交: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "✅ 更改已提交"
    else
        echo "❌ 请先提交更改"
        exit 1
    fi
fi

# 运行基础测试
echo "🧪 运行基础测试..."

# 检查Python环境
if command -v python3 &> /dev/null; then
    echo "✅ Python3 环境正常"
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    echo "✅ Python 环境正常"
    PYTHON_CMD="python"
else
    echo "❌ Python环境异常，请安装Python"
    exit 1
fi

# 检查必要文件
if [ ! -f "index.html" ]; then
    echo "❌ 缺少index.html文件"
    exit 1
fi

if [ ! -f "css/style.css" ]; then
    echo "❌ 缺少css/style.css文件"
    exit 1
fi

echo "✅ 基础文件检查通过"

# 自动升级版本
echo "📈 自动升级版本..."
./scripts/auto-version-upgrade.sh

if [ $? -eq 0 ]; then
    echo "✅ 版本升级成功"
else
    echo "❌ 版本升级失败"
    exit 1
fi

# 推送到GitHub
echo "📤 推送到GitHub..."
git push origin main --tags

if [ $? -eq 0 ]; then
    echo "✅ 成功推送到GitHub"
else
    echo "❌ 推送失败，请检查网络连接和Git配置"
    exit 1
fi

# 创建本地备份
echo "💾 创建本地备份..."
./scripts/backup-version.sh $(git describe --tags --abbrev=0)

echo ""
echo "🎉 部署完成！"
echo "📊 版本信息:"
echo "  当前版本: $(git describe --tags --abbrev=0)"
echo "  提交信息: $(git log --oneline -1)"
echo "  备份位置: /Users/shanwanjun/Desktop/TIME-History/$(git describe --tags --abbrev=0)/"
echo ""
echo "🌐 访问地址:"
echo "  本地: http://localhost:8000"
echo "  在线: https://time-2025.netlify.app"
echo ""
echo "🔄 版本管理命令:"
echo "  ./scripts/version-traveler.sh list    # 查看所有版本"
echo "  ./scripts/version-traveler.sh go v1.0.0  # 跳转到指定版本"
