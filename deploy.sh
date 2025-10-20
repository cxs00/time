#!/bin/bash

# TIME - 一键部署脚本
# 推送更新到GitHub，触发Netlify自动部署

echo "🚀 TIME 项目部署脚本"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 进入项目目录
cd "$(dirname "$0")"

# 检查Git状态
echo "📋 检查项目状态..."
git status

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 添加所有更改
echo "📦 添加所有更改..."
git add .

# 显示将要提交的文件
echo ""
echo "将要提交的文件："
git diff --cached --name-status

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 提交信息
read -p "💬 请输入提交信息 (直接回车使用默认): " commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="🔄 更新: 部署TIME项目到Netlify"
fi

echo ""
echo "📝 提交更改: $commit_msg"
git commit -m "$commit_msg"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 推送到GitHub
echo "🚀 推送到GitHub..."
git push origin main

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 完成
echo "✅ 代码已推送到GitHub！"
echo ""
echo "🌐 Netlify将自动部署（约1-2分钟）"
echo "📍 你的网站: https://time-2025.netlify.app"
echo ""
echo "💡 提示："
echo "   1. 等待1-2分钟让Netlify完成部署"
echo "   2. 访问网站并硬刷新 (Cmd+Shift+R)"
echo "   3. 检查是否显示TIME紫色主题"
echo "   4. 查看Netlify后台: https://app.netlify.com"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 部署完成！"
echo ""

