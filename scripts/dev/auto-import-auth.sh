#!/bin/bash
# 自动导入认证信息脚本
# 当Cursor检测到认证目录时自动执行

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

# 检查认证目录
check_auth_directory() {
    if [ -d ~/.cxs-auth ]; then
        print_colored "$GREEN" "✅ 检测到认证目录: ~/.cxs-auth"
        return 0
    else
        print_colored "$YELLOW" "⚠️  认证目录不存在，创建中..."
        mkdir -p ~/.cxs-auth
        print_colored "$GREEN" "✅ 认证目录已创建"
        return 1
    fi
}

# 导入GitHub认证
import_github_auth() {
    local github_file="$HOME/.cxs-auth/github.json"

    if [ -f "$github_file" ]; then
        print_colored "$BLUE" "🔧 导入GitHub认证..."

        # 读取认证信息
        local username=$(jq -r '.username' "$github_file" 2>/dev/null)
        local token=$(jq -r '.token' "$github_file" 2>/dev/null)
        local email=$(jq -r '.email' "$github_file" 2>/dev/null)
        local repo=$(jq -r '.repo' "$github_file" 2>/dev/null)

        if [ "$username" != "null" ] && [ "$token" != "null" ]; then
            # 设置Git配置
            git config --global user.name "$username"
            git config --global user.email "$email"

            # 设置GitHub Token
            git config --global credential.helper store
            echo "https://$username:$token@github.com" > ~/.git-credentials

            print_colored "$GREEN" "✅ GitHub认证已导入"
            print_colored "$WHITE" "   - 用户名: $username"
            print_colored "$WHITE" "   - 邮箱: $email"
            print_colored "$WHITE" "   - 仓库: $repo"
        else
            print_colored "$RED" "❌ GitHub认证文件格式错误"
        fi
    else
        print_colored "$YELLOW" "⚠️  GitHub认证文件不存在: $github_file"
    fi
}

# 导入Netlify认证
import_netlify_auth() {
    local netlify_file="$HOME/.cxs-auth/netlify.json"

    if [ -f "$netlify_file" ]; then
        print_colored "$BLUE" "🔧 导入Netlify认证..."

        # 读取认证信息
        local token=$(jq -r '.token' "$netlify_file" 2>/dev/null)
        local site_id=$(jq -r '.site_id' "$netlify_file" 2>/dev/null)
        local site_url=$(jq -r '.site_url' "$netlify_file" 2>/dev/null)

        if [ "$token" != "null" ] && [ "$site_id" != "null" ]; then
            # 设置环境变量
            export NETLIFY_TOKEN="$token"
            export NETLIFY_SITE_ID="$site_id"
            export NETLIFY_SITE_URL="$site_url"

            # 写入到项目环境文件
            cat > .env.local << EOF
# Netlify认证信息
NETLIFY_TOKEN=$token
NETLIFY_SITE_ID=$site_id
NETLIFY_SITE_URL=$site_url
EOF

            print_colored "$GREEN" "✅ Netlify认证已导入"
            print_colored "$WHITE" "   - 站点ID: $site_id"
            print_colored "$WHITE" "   - 站点URL: $site_url"
        else
            print_colored "$RED" "❌ Netlify认证文件格式错误"
        fi
    else
        print_colored "$YELLOW" "⚠️  Netlify认证文件不存在: $netlify_file"
    fi
}

# 导入Vercel认证
import_vercel_auth() {
    local vercel_file="$HOME/.cxs-auth/vercel.json"

    if [ -f "$vercel_file" ]; then
        print_colored "$BLUE" "🔧 导入Vercel认证..."

        # 读取认证信息
        local token=$(jq -r '.token' "$vercel_file" 2>/dev/null)
        local project_id=$(jq -r '.project_id' "$vercel_file" 2>/dev/null)

        if [ "$token" != "null" ]; then
            # 设置环境变量
            export VERCEL_TOKEN="$token"
            export VERCEL_PROJECT_ID="$project_id"

            # 写入到项目环境文件
            cat >> .env.local << EOF

# Vercel认证信息
VERCEL_TOKEN=$token
VERCEL_PROJECT_ID=$project_id
EOF

            print_colored "$GREEN" "✅ Vercel认证已导入"
            print_colored "$WHITE" "   - 项目ID: $project_id"
        else
            print_colored "$RED" "❌ Vercel认证文件格式错误"
        fi
    else
        print_colored "$YELLOW" "⚠️  Vercel认证文件不存在: $vercel_file"
    fi
}

# 导入Cursor配置
import_cursor_config() {
    local cursor_file="$HOME/.cxs-auth/cursor-config.json"

    if [ -f "$cursor_file" ]; then
        print_colored "$BLUE" "🔧 导入Cursor配置..."

        # 读取配置信息
        local user_name=$(jq -r '.user_name' "$cursor_file" 2>/dev/null)
        local user_email=$(jq -r '.user_email' "$cursor_file" 2>/dev/null)
        local preferred_theme=$(jq -r '.preferred_theme' "$cursor_file" 2>/dev/null)
        local project_path=$(jq -r '.project_path' "$cursor_file" 2>/dev/null)

        if [ "$user_name" != "null" ]; then
            # 设置项目信息
            echo "# Cursor配置信息" >> .env.local
            echo "CURSOR_USER_NAME=$user_name" >> .env.local
            echo "CURSOR_USER_EMAIL=$user_email" >> .env.local
            echo "CURSOR_THEME=$preferred_theme" >> .env.local
            echo "CURSOR_PROJECT_PATH=$project_path" >> .env.local

            print_colored "$GREEN" "✅ Cursor配置已导入"
            print_colored "$WHITE" "   - 用户名: $user_name"
            print_colored "$WHITE" "   - 主题: $preferred_theme"
        else
            print_colored "$RED" "❌ Cursor配置文件格式错误"
        fi
    else
        print_colored "$YELLOW" "⚠️  Cursor配置文件不存在: $cursor_file"
    fi
}

# 验证认证信息
verify_auth() {
    print_colored "$CYAN" "🔍 验证认证信息..."

    # 验证GitHub
    if git config --get user.name > /dev/null 2>&1; then
        print_colored "$GREEN" "✅ GitHub认证有效"
    else
        print_colored "$RED" "❌ GitHub认证无效"
    fi

    # 验证Netlify
    if [ -n "$NETLIFY_TOKEN" ]; then
        print_colored "$GREEN" "✅ Netlify认证有效"
    else
        print_colored "$RED" "❌ Netlify认证无效"
    fi

    # 验证Vercel
    if [ -n "$VERCEL_TOKEN" ]; then
        print_colored "$GREEN" "✅ Vercel认证有效"
    else
        print_colored "$YELLOW" "⚠️  Vercel认证未设置"
    fi
}

# 创建认证模板
create_auth_templates() {
    print_colored "$BLUE" "📝 创建认证模板..."

    # GitHub认证模板
    cat > ~/.cxs-auth/github.json.template << 'EOF'
{
  "username": "your_github_username",
  "token": "ghp_xxxxxxxxxxxxxxxxxxxx",
  "email": "your_email@example.com",
  "repo": "cxs00/time"
}
EOF

    # Netlify认证模板
    cat > ~/.cxs-auth/netlify.json.template << 'EOF'
{
  "token": "your_netlify_token",
  "site_id": "your_site_id",
  "site_url": "https://your-site.netlify.app"
}
EOF

    # Vercel认证模板
    cat > ~/.cxs-auth/vercel.json.template << 'EOF'
{
  "token": "your_vercel_token",
  "project_id": "your_project_id"
}
EOF

    # Cursor配置模板
    cat > ~/.cxs-auth/cursor-config.json.template << 'EOF'
{
  "user_name": "Your Name",
  "user_email": "your_email@example.com",
  "preferred_theme": "dark",
  "auto_import_auth": true,
  "project_path": "/Users/username/Desktop/cxs/time"
}
EOF

    print_colored "$GREEN" "✅ 认证模板已创建"
    print_colored "$WHITE" "   请复制模板文件并填入真实信息"
}

# 主函数
main() {
    print_colored "$CYAN" "🚀 自动导入认证信息"
    print_colored "$CYAN" "================================="

    # 检查认证目录
    check_auth_directory

    # 导入各种认证
    import_github_auth
    import_netlify_auth
    import_vercel_auth
    import_cursor_config

    # 验证认证
    verify_auth

    # 创建模板（如果不存在认证文件）
    if [ ! -f ~/.cxs-auth/github.json ] || [ ! -f ~/.cxs-auth/netlify.json ]; then
        create_auth_templates
    fi

    print_colored "$GREEN" "🎉 认证导入完成！"
    print_colored "$WHITE" "   现在可以开始开发了"
}

# 运行主函数
main "$@"
