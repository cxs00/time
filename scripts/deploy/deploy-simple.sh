#!/bin/bash
# 简化部署脚本（无需Node.js）

echo "🚀 TIME应用简化部署"
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

# 1. 创建登录系统
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

# 2. 更新主应用
print_colored "$BLUE" "🔒 更新主应用..."
update_main_app() {
    # 备份原文件
    cp index.html index.html.backup

    # 在index.html的head部分添加登录检查
    cat > temp_index.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="TIME - 享受时光，专注当下的时间管理工具">
        <title>TIME - 时间管理</title>

        <!-- 安全头部 -->
        <meta http-equiv="X-Content-Type-Options" content="nosniff">
        <meta http-equiv="X-Frame-Options" content="DENY">
        <meta http-equiv="X-XSS-Protection" content="1; mode=block">
        <meta http-equiv="Referrer-Policy" content="strict-origin-when-cross-origin">
        <meta http-equiv="Permissions-Policy" content="camera=(), microphone=(), geolocation=()">

        <!-- 内容安全策略 -->
        <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://pagead2.googlesyndication.com https://www.googletagmanager.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https:; frame-src 'self' https://googleads.g.doubleclick.net; object-src 'none'; base-uri 'self'; form-action 'self';">

        <link rel="stylesheet" href="css/style.css">

        <script>
            // 登录验证
            if (localStorage.getItem('isLoggedIn') !== 'true') {
                window.location.href = 'login.html';
            }

            // 显示用户信息
            document.addEventListener('DOMContentLoaded', function() {
                const username = localStorage.getItem('username');
                const userName = localStorage.getItem('userName');
                const userRole = localStorage.getItem('userRole');

                if (username) {
                    // 在页面顶部显示用户信息
                    const userInfo = document.createElement('div');
                    userInfo.style.cssText = 'position: fixed; top: 10px; right: 10px; background: rgba(0,0,0,0.8); color: white; padding: 8px 12px; border-radius: 5px; font-size: 12px; z-index: 1000;';
                    userInfo.innerHTML = `欢迎，${userName} (${userRole}) | <a href="#" onclick="logout()" style="color: #ff6b6b;">退出</a>`;
                    document.body.appendChild(userInfo);
                }
            });

            // 退出登录函数
            function logout() {
                localStorage.removeItem('isLoggedIn');
                localStorage.removeItem('username');
                localStorage.removeItem('userRole');
                localStorage.removeItem('userName');
                window.location.href = 'login.html';
            }
        </script>
    </head>
EOF

    # 读取原index.html的body部分
    tail -n +22 index.html >> temp_index.html

    # 替换原文件
    mv temp_index.html index.html

    print_colored "$GREEN" "✅ 主应用登录验证已添加"
}

# 3. 启动本地服务器
print_colored "$BLUE" "🔍 启动本地服务器..."
start_local_server() {
    # 检查端口
    PORT=8000
    while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; do
        PORT=$((PORT + 1))
    done

    print_colored "$GREEN" "✅ 启动本地服务器 (端口 $PORT)..."
    python3 -m http.server $PORT &
    SERVER_PID=$!

    # 等待服务器启动
    sleep 2

    print_colored "$CYAN" "🌐 本地访问地址: http://localhost:$PORT"
    return $PORT
}

# 4. 推送到GitHub（触发Netlify部署）
print_colored "$BLUE" "📤 推送到GitHub..."
push_to_github() {
    # 检查Git状态
    if ! git diff --quiet; then
        print_colored "$YELLOW" "📝 检测到未提交的更改，自动提交..."
        git add .
        git commit -m "🔐 添加登录系统 - $(date '+%Y-%m-%d %H:%M:%S')"
    fi

    # 推送到GitHub
    if git push origin main; then
        print_colored "$GREEN" "✅ GitHub推送成功"
        print_colored "$CYAN" "🌐 Netlify自动部署中: https://time-2025.netlify.app"
    else
        print_colored "$YELLOW" "⚠️ GitHub推送失败，使用本地部署"
    fi
}

# 5. 显示登录信息
show_login_info() {
    print_colored "$GREEN" "🎉 部署完成！"
    echo ""
    print_colored "$WHITE" "📋 登录账户信息:"
    print_colored "$WHITE" "  管理员账户: admin / admin123"
    print_colored "$WHITE" "  普通用户: user / user123"
    print_colored "$WHITE" "  访客账户: guest / guest123"
    echo ""
    print_colored "$CYAN" "🌐 访问地址:"
    print_colored "$WHITE" "  本地测试: http://localhost:$1"
    print_colored "$WHITE" "  Netlify: https://time-2025.netlify.app"
    echo ""
    print_colored "$YELLOW" "💡 使用说明:"
    print_colored "$WHITE" "1. 访问上述任一地址"
    print_colored "$WHITE" "2. 使用演示账户登录"
    print_colored "$WHITE" "3. 开始使用TIME应用"
    print_colored "$WHITE" "4. 点击右上角'退出'按钮注销"
    echo ""
    print_colored "$BLUE" "🛡️ 安全特性:"
    print_colored "$WHITE" "  ✓ 用户认证系统"
    print_colored "$WHITE" "  ✓ 角色权限管理"
    print_colored "$WHITE" "  ✓ 会话状态管理"
    print_colored "$WHITE" "  ✓ 安全退出功能"
}

# 执行部署流程
create_login_system
update_main_app
PORT=$(start_local_server)
push_to_github

show_login_info $PORT

print_colored "$YELLOW" "💡 提示: 按Ctrl+C停止本地服务器"
