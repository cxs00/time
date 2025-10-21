#!/bin/bash
# 自动同步配置文件脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

# 打印带颜色的消息
print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# 配置变量
GIST_ID=""
GIST_TOKEN=""
CONFIG_FILES=(
    "~/.universal-deploy-config"
    "~/.universal-deploy-devices"
    "~/.universal-deploy-accounts"
)

# 上传配置到GitHub Gist
upload_config() {
    print_colored "$BLUE" "📤 上传配置到GitHub Gist..."

    if [ -z "$GIST_ID" ] || [ -z "$GIST_TOKEN" ]; then
        print_colored "$RED" "❌ 请先配置GIST_ID和GIST_TOKEN"
        return 1
    fi

    # 创建临时目录
    local temp_dir=$(mktemp -d)

    # 复制配置文件
    for file in "${CONFIG_FILES[@]}"; do
        local expanded_file=$(eval echo "$file")
        if [ -f "$expanded_file" ]; then
            cp "$expanded_file" "$temp_dir/$(basename "$file")"
        fi
    done

    # 创建压缩包
    local archive="$temp_dir/config.tar.gz"
    tar -czf "$archive" -C "$temp_dir" .

    # 上传到GitHub Gist
    local response=$(curl -s -X PATCH \
        -H "Authorization: token $GIST_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{\"files\":{\"config.tar.gz\":{\"content\":\"$(base64 -i "$archive" | tr -d '\n')\"}}}" \
        "https://api.github.com/gists/$GIST_ID")

    # 检查响应
    if echo "$response" | grep -q "id"; then
        print_colored "$GREEN" "✅ 配置已上传到GitHub Gist"
    else
        print_colored "$RED" "❌ 上传失败"
        echo "$response"
    fi

    # 清理临时目录
    rm -rf "$temp_dir"
}

# 从GitHub Gist下载配置
download_config() {
    print_colored "$BLUE" "📥 从GitHub Gist下载配置..."

    if [ -z "$GIST_ID" ]; then
        print_colored "$RED" "❌ 请先配置GIST_ID"
        return 1
    fi

    # 创建临时目录
    local temp_dir=$(mktemp -d)

    # 从GitHub Gist下载
    local response=$(curl -s "https://api.github.com/gists/$GIST_ID")

    # 检查响应
    if echo "$response" | grep -q "files"; then
        # 提取文件内容
        local content=$(echo "$response" | jq -r '.files["config.tar.gz"].content')
        if [ "$content" != "null" ]; then
            echo "$content" | base64 -d > "$temp_dir/config.tar.gz"

            # 解压文件
            tar -xzf "$temp_dir/config.tar.gz" -C "$temp_dir"

            # 复制到目标位置
            for file in "${CONFIG_FILES[@]}"; do
                local expanded_file=$(eval echo "$file")
                local filename=$(basename "$file")
                if [ -f "$temp_dir/$filename" ]; then
                    cp "$temp_dir/$filename" "$expanded_file"
                    print_colored "$GREEN" "✅ 已下载: $expanded_file"
                fi
            done
        else
            print_colored "$RED" "❌ 未找到配置文件"
        fi
    else
        print_colored "$RED" "❌ 下载失败"
        echo "$response"
    fi

    # 清理临时目录
    rm -rf "$temp_dir"
}

# 检查同步状态
check_sync() {
    print_colored "$BLUE" "🔍 检查同步状态..."

    if [ -z "$GIST_ID" ]; then
        print_colored "$RED" "❌ 请先配置GIST_ID"
        return 1
    fi

    # 获取Gist信息
    local response=$(curl -s "https://api.github.com/gists/$GIST_ID")

    if echo "$response" | grep -q "id"; then
        local updated_at=$(echo "$response" | jq -r '.updated_at')
        print_colored "$GREEN" "✅ 同步状态正常"
        print_colored "$WHITE" "  最后更新: $updated_at"
    else
        print_colored "$RED" "❌ 无法获取同步状态"
    fi
}

# 显示帮助信息
show_help() {
    print_colored "$BLUE" "📖 自动同步配置文件脚本"
    print_colored "$WHITE" "用法: $0 [命令]"
    echo ""
    print_colored "$YELLOW" "可用命令:"
    print_colored "$WHITE" "  upload    - 上传配置到GitHub Gist"
    print_colored "$WHITE" "  download  - 从GitHub Gist下载配置"
    print_colored "$WHITE" "  check     - 检查同步状态"
    print_colored "$WHITE" "  help      - 显示帮助信息"
    echo ""
    print_colored "$YELLOW" "配置变量:"
    print_colored "$WHITE" "  GIST_ID      - GitHub Gist ID"
    print_colored "$WHITE" "  GIST_TOKEN   - GitHub Personal Access Token"
    echo ""
    print_colored "$YELLOW" "示例:"
    print_colored "$WHITE" "  GIST_ID=abc123 $0 upload"
    print_colored "$WHITE" "  GIST_ID=abc123 $0 download"
}

# 主函数
main() {
    case "$1" in
        "upload")
            upload_config
            ;;
        "download")
            download_config
            ;;
        "check")
            check_sync
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            show_help
            ;;
        *)
            print_colored "$RED" "❌ 未知命令: $1"
            show_help
            ;;
    esac
}

# 运行主函数
main "$@"
