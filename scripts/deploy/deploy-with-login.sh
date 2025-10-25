#!/bin/bash
# 带登录功能的部署脚本

echo "🚀 TIME应用部署和登录系统"
echo "================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# 检查是否在项目根目录
if [ ! -f "index.html" ]; then
    print_colored "$RED" "❌ 错误: 请在项目根目录执行此脚本"
    exit 1
fi

# 1. 检查Node.js
print_colored "$BLUE" "🔍 检查Node.js安装状态..."
if ! command -v node &> /dev/null; then
    print_colored "$YELLOW" "⚠️ Node.js未安装"
    print_colored "$WHITE" "请按照以下步骤安装Node.js:"
    print_colored "$WHITE" "1. 访问 https://nodejs.org/"
    print_colored "$WHITE" "2. 下载LTS版本"
    print_colored "$WHITE" "3. 安装后重启终端"
    print_colored "$WHITE" "4. 重新运行此脚本"
    exit 1
else
    NODE_VERSION=$(node --version)
    print_colored "$GREEN" "✅ Node.js已安装: $NODE_VERSION"
fi

# 2. 安装Vercel CLI
print_colored "$BLUE" "📦 安装Vercel CLI..."
if ! command -v vercel &> /dev/null; then
    npm install -g vercel
    if [ $? -eq 0 ]; then
        print_colored "$GREEN" "✅ Vercel CLI安装成功"
    else
        print_colored "$RED" "❌ Vercel CLI安装失败"
        exit 1
    fi
else
    VERCEL_VERSION=$(vercel --version)
    print_colored "$GREEN" "✅ Vercel CLI已安装: $VERCEL_VERSION"
fi

# 3. 创建登录页面
print_colored "$BLUE" "🔐 创建登录系统..."
create_login_system() {
    # 创建登录页面
    cat > login.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TIME - 用户登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo h1 {
            color: #333;
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .logo .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .login-btn {
            width: 100%;
            padding: 0.75rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .login-btn:hover {
            transform: translateY(-2px);
        }

        .demo-accounts {
            margin-top: 1.5rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }

        .demo-accounts h3 {
            color: #333;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .demo-accounts p {
            color: #666;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }

        .error {
            color: #e74c3c;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            display: none;
        }

        .success {
            color: #27ae60;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            display: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <div class="icon">⏰</div>
            <h1>TIME</h1>
            <p>时间管理应用</p>
        </div>

        <form id="loginForm">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="login-btn">登录</button>

            <div class="error" id="errorMessage"></div>
            <div class="success" id="successMessage"></div>
        </form>

        <div class="demo-accounts">
            <h3>演示账户</h3>
            <p><strong>管理员:</strong> admin / admin123</p>
            <p><strong>用户:</strong> user / user123</p>
            <p><strong>访客:</strong> guest / guest123</p>
        </div>
    </div>

    <script>
        // 演示账户数据
        const accounts = {
            'admin': { password: 'admin123', role: 'admin', name: '管理员' },
            'user': { password: 'user123', role: 'user', name: '普通用户' },
            'guest': { password: 'guest123', role: 'guest', name: '访客' }
        };

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const errorDiv = document.getElementById('errorMessage');
            const successDiv = document.getElementById('successMessage');

            // 隐藏之前的消息
            errorDiv.style.display = 'none';
            successDiv.style.display = 'none';

            // 验证账户
            if (accounts[username] && accounts[username].password === password) {
                const user = accounts[username];

                // 保存登录状态
                localStorage.setItem('isLoggedIn', 'true');
                localStorage.setItem('username', username);
                localStorage.setItem('userRole', user.role);
                localStorage.setItem('userName', user.name);

                successDiv.textContent = `欢迎回来，${user.name}！正在跳转...`;
                successDiv.style.display = 'block';

                // 延迟跳转到主应用
                setTimeout(() => {
                    window.location.href = 'index.html';
                }, 1500);
            } else {
                errorDiv.textContent = '用户名或密码错误，请重试';
                errorDiv.style.display = 'block';
            }
        });

        // 检查是否已登录
        if (localStorage.getItem('isLoggedIn') === 'true') {
            window.location.href = 'index.html';
        }
    </script>
</body>
</html>
EOF

    print_colored "$GREEN" "✅ 登录页面已创建"
}

# 4. 更新主应用以支持登录验证
print_colored "$BLUE" "🔒 更新主应用登录验证..."
update_main_app() {
    # 在index.html中添加登录检查
    if [ -f "index.html" ]; then
        # 备份原文件
        cp index.html index.html.backup

        # 在head部分添加登录检查脚本
        sed -i '' '/<head>/a\
    <script>\
        // 登录验证\
        if (localStorage.getItem("isLoggedIn") !== "true") {\
            window.location.href = "login.html";\
        }\
        \
        // 显示用户信息\
        document.addEventListener("DOMContentLoaded", function() {\
            const username = localStorage.getItem("username");\
            const userName = localStorage.getItem("userName");\
            const userRole = localStorage.getItem("userRole");\
            \
            if (username) {\
                // 在页面顶部显示用户信息\
                const userInfo = document.createElement("div");\
                userInfo.style.cssText = "position: fixed; top: 10px; right: 10px; background: rgba(0,0,0,0.8); color: white; padding: 8px 12px; border-radius: 5px; font-size: 12px; z-index: 1000;";\
                userInfo.innerHTML = `欢迎，${userName} (${userRole}) | <a href="#" onclick="logout()" style="color: #ff6b6b;">退出</a>`;\
                document.body.appendChild(userInfo);\
            }\
        });\
        \
        // 退出登录函数\
        function logout() {\
            localStorage.removeItem("isLoggedIn");\
            localStorage.removeItem("username");\
            localStorage.removeItem("userRole");\
            localStorage.removeItem("userName");\
            window.location.href = "login.html";\
        }\
    </script>' index.html

        print_colored "$GREEN" "✅ 主应用登录验证已添加"
    fi
}

# 5. 部署到Vercel
print_colored "$BLUE" "🚀 部署到Vercel..."
deploy_to_vercel() {
    # 检查是否已登录Vercel
    if ! vercel whoami &> /dev/null; then
        print_colored "$YELLOW" "🔑 请登录Vercel账户..."
        print_colored "$WHITE" "1. 浏览器将自动打开"
        print_colored "$WHITE" "2. 登录你的Vercel账户"
        print_colored "$WHITE" "3. 授权CLI访问"
        echo ""
        read -p "按回车键继续登录..." -r
        vercel login
    fi

    # 部署到Vercel
    print_colored "$BLUE" "📤 开始部署..."
    vercel --prod --yes

    if [ $? -eq 0 ]; then
        print_colored "$GREEN" "✅ Vercel部署成功"

        # 获取部署URL
        VERCEL_URL=$(vercel ls | grep -o 'https://[^[:space:]]*' | head -1)
        if [ -n "$VERCEL_URL" ]; then
            print_colored "$CYAN" "🌐 部署URL: $VERCEL_URL"
        fi
    else
        print_colored "$RED" "❌ Vercel部署失败"
        return 1
    fi
}

# 6. 显示登录信息
show_login_info() {
    print_colored "$GREEN" "🎉 部署完成！"
    echo ""
    print_colored "$WHITE" "📋 登录信息:"
    print_colored "$WHITE" "  管理员账户: admin / admin123"
    print_colored "$WHITE" "  普通用户: user / user123"
    print_colored "$WHITE" "  访客账户: guest / guest123"
    echo ""
    print_colored "$CYAN" "🌐 访问地址:"
    if [ -n "$VERCEL_URL" ]; then
        print_colored "$WHITE" "  Vercel: $VERCEL_URL"
    fi
    print_colored "$WHITE" "  Netlify: https://time-2025.netlify.app"
    print_colored "$WHITE" "  本地: http://localhost:8000"
    echo ""
    print_colored "$YELLOW" "💡 使用说明:"
    print_colored "$WHITE" "1. 访问部署URL"
    print_colored "$WHITE" "2. 使用上述账户登录"
    print_colored "$WHITE" "3. 开始使用TIME应用"
    print_colored "$WHITE" "4. 点击右上角'退出'按钮注销"
}

# 执行部署流程
create_login_system
update_main_app
deploy_to_vercel

if [ $? -eq 0 ]; then
    show_login_info
else
    print_colored "$RED" "❌ 部署失败，请检查错误信息"
    exit 1
fi
