#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 推送到GitHub..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "目标：https://github.com/cxs00/pomodoro-timer.git"
echo ""

cd /Users/shanwanjun/Desktop/cxs/time-deploy

# 尝试推送
git push -u origin main

RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ 推送成功！"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎉 代码已成功推送到GitHub！"
    echo ""
    echo "📊 仓库地址："
    echo "https://github.com/cxs00/pomodoro-timer"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🌐 下一步：Netlify部署"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. 访问：https://app.netlify.com"
    echo "2. 使用GitHub登录"
    echo "3. 点击：Add new site → Import an existing project"
    echo "4. 选择：pomodoro-timer 仓库"
    echo "5. 点击：Deploy site"
    echo "6. 等待部署完成（1-2分钟）"
    echo "7. 获取网站URL"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  需要认证"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "请确保："
    echo "1. GitHub仓库已创建"
    echo "2. Personal Access Token已准备好"
    echo ""
    echo "然后重新运行："
    echo "bash push.sh"
    echo ""
    echo "输入认证信息时："
    echo "Username: cxs00"
    echo "Password: [粘贴您的Token]"
    echo ""
fi

