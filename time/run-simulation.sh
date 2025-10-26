#!/bin/bash

# ==================== Activity Tracker 自动仿真脚本 v3.0 ====================
# 功能：自动编译、启动并验证Mac和iPhone应用仿真
# 版本：v3.0.0（增强验证功能）
# 日期：2025-10-26
# 改进：添加真实的应用验证机制
# ============================================================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_DIR="/Users/shanwanjun/Desktop/cxs/time/time"
PROJECT_NAME="time.xcodeproj"
SCHEME_NAME="time"
BUNDLE_ID="com.cxs.time"
SIMULATOR_NAME="iPhone 17"

# 验证超时设置
VERIFY_TIMEOUT=30
VERIFY_INTERVAL=2

# 打印带颜色的消息
print_header() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  $1"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_step() {
    echo -e "${BLUE}▶️  $1${NC}"
}

# 检查Xcode是否安装
check_xcode() {
    print_step "检查Xcode环境..."

    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode未安装或未配置正确"
        exit 1
    fi

    local xcode_version=$(xcodebuild -version | head -n 1)
    print_success "Xcode环境正常: $xcode_version"
}

# 进入项目目录
enter_project_dir() {
    print_step "进入项目目录..."

    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "项目目录不存在: $PROJECT_DIR"
        exit 1
    fi

    cd "$PROJECT_DIR"
    print_success "当前目录: $(pwd)"
}

# 编译Mac应用
build_mac_app() {
    print_header "🖥️  编译Mac应用"

    print_step "开始编译..."

    if xcodebuild clean build \
        -project "$PROJECT_NAME" \
        -scheme "$SCHEME_NAME" \
        -destination 'platform=macOS' \
        -quiet; then
        print_success "Mac应用编译成功"
        return 0
    else
        print_error "Mac应用编译失败"
        return 1
    fi
}

# 启动Mac应用
launch_mac_app() {
    print_step "查找Mac应用..."

    # 查找正确的Build目录（不是Index.noindex）
    local app_path=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug -name "TIME.app" -type d 2>/dev/null | head -n 1)

    if [ -z "$app_path" ]; then
        print_error "找不到Mac应用"
        return 1
    fi

    print_info "应用路径: $app_path"

    # 先关闭已运行的应用
    pkill -f "TIME.app" 2>/dev/null || true
    sleep 1

    print_step "启动Mac应用..."
    open "$app_path"

    print_success "Mac应用启动命令已执行"
}

# 验证Mac应用是否真正运行
verify_mac_app() {
    print_header "🔍 验证Mac应用"

    print_step "检查应用进程..."

    local elapsed=0
    local verified=false

    while [ $elapsed -lt $VERIFY_TIMEOUT ]; do
        # 1. 检查进程是否存在
        if ps aux | grep "TIME.app/Contents/MacOS/TIME" | grep -v grep > /dev/null; then
            print_success "✓ 应用进程正在运行"

            # 2. 检查窗口是否存在
            sleep 2
            if osascript -e 'tell application "System Events" to exists window 1 of process "TIME"' 2>/dev/null; then
                print_success "✓ 应用窗口已显示"

                # 3. 检查是否有JavaScript错误
                print_step "检查控制台错误..."
                local error_count=$(log show --predicate 'processImagePath contains "TIME"' --last 10s 2>/dev/null | grep -i "error\|404\|not found" | wc -l)

                if [ "$error_count" -eq 0 ]; then
                    print_success "✓ 无JavaScript错误"
                    verified=true
                    break
                else
                    print_warning "发现 $error_count 个错误，继续检查..."
                fi
            fi
        fi

        sleep $VERIFY_INTERVAL
        elapsed=$((elapsed + VERIFY_INTERVAL))
        echo -n "."
    done

    echo ""

    if [ "$verified" = true ]; then
        print_success "Mac应用验证通过！"
        return 0
    else
        print_error "Mac应用验证失败"
        print_warning "可能的问题："
        print_warning "  • 应用崩溃或未正常启动"
        print_warning "  • WebView加载失败"
        print_warning "  • JavaScript资源未找到"
        return 1
    fi
}

# 启动模拟器
start_simulator() {
    print_header "📱 启动iPhone模拟器"

    print_step "检查模拟器状态..."

    # 检查模拟器是否已启动
    local booted_device=$(xcrun simctl list devices | grep "Booted" | grep "iPhone" | head -n 1)

    if [ -n "$booted_device" ]; then
        print_success "模拟器已运行: $booted_device"
        return 0
    fi

    print_step "启动模拟器..."
    open -a Simulator

    # 等待模拟器启动
    print_info "等待模拟器启动（最多30秒）..."
    local count=0
    while [ $count -lt 30 ]; do
        sleep 1
        booted_device=$(xcrun simctl list devices | grep "Booted" | grep "iPhone" | head -n 1)
        if [ -n "$booted_device" ]; then
            print_success "模拟器启动成功"
            return 0
        fi
        count=$((count + 1))
        echo -n "."
    done

    echo ""
    print_warning "模拟器启动超时，但继续执行..."
    return 0
}

# 编译iPhone应用
build_iphone_app() {
    print_header "📱 编译iPhone应用"

    print_step "开始编译..."

    if xcodebuild clean build \
        -project "$PROJECT_NAME" \
        -scheme "$SCHEME_NAME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" \
        -quiet; then
        print_success "iPhone应用编译成功"
        return 0
    else
        print_error "iPhone应用编译失败"
        return 1
    fi
}

# 安装并启动iPhone应用
install_and_launch_iphone_app() {
    print_step "查找iPhone应用..."

    # 查找正确的Build目录
    local app_path=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator -name "TIME.app" -type d 2>/dev/null | head -n 1)

    if [ -z "$app_path" ]; then
        print_error "找不到iPhone应用"
        return 1
    fi

    print_info "应用路径: $app_path"
    print_step "安装到模拟器..."

    if xcrun simctl install booted "$app_path"; then
        print_success "应用安装成功"
    else
        print_warning "应用安装失败，可能已安装"
    fi

    print_step "启动iPhone应用..."

    # 先终止可能正在运行的应用
    xcrun simctl terminate booted "$BUNDLE_ID" 2>/dev/null || true
    sleep 1

    # 启动应用
    if xcrun simctl launch booted "$BUNDLE_ID" &>/dev/null; then
        print_success "iPhone应用启动命令已执行"
    else
        print_warning "应用启动失败，请手动在模拟器中打开TIME应用"
    fi
}

# 验证iPhone应用是否真正运行
verify_iphone_app() {
    print_header "🔍 验证iPhone应用"

    print_step "检查应用状态..."

    local elapsed=0
    local verified=false

    while [ $elapsed -lt $VERIFY_TIMEOUT ]; do
        # 1. 检查应用是否在运行
        local app_state=$(xcrun simctl launch --console booted "$BUNDLE_ID" 2>&1 | grep -i "already running" || echo "not_running")

        if [[ "$app_state" == *"already running"* ]]; then
            print_success "✓ 应用正在运行"

            # 2. 检查模拟器中是否有TIME进程
            sleep 2
            local device_uuid=$(xcrun simctl list devices | grep "Booted" | grep "iPhone" | grep -o '[A-F0-9-]\{36\}' | head -n 1)

            if [ -n "$device_uuid" ]; then
                print_success "✓ 模拟器设备ID: $device_uuid"

                # 3. 简单验证（应用能响应launch命令说明已正常运行）
                verified=true
                break
            fi
        else
            # 尝试启动
            xcrun simctl launch booted "$BUNDLE_ID" &>/dev/null || true
        fi

        sleep $VERIFY_INTERVAL
        elapsed=$((elapsed + VERIFY_INTERVAL))
        echo -n "."
    done

    echo ""

    if [ "$verified" = true ]; then
        print_success "iPhone应用验证通过！"
        return 0
    else
        print_warning "iPhone应用验证超时"
        print_info "请手动在模拟器中检查应用状态"
        return 1
    fi
}

# 显示验证清单
show_verification_checklist() {
    print_header "🔍 手动验证清单"

    echo -e "${CYAN}请在应用中验证以下功能：${NC}"
    echo ""
    echo "📱 基础功能："
    echo "  □ 应用成功启动"
    echo "  □ 界面正常显示"
    echo "  □ 导航栏功能正常"
    echo "  □ 数据正确加载"
    echo ""
    echo "🎨 主题功能："
    echo "  □ 主题切换正常"
    echo "  □ UI尺寸设置正常"
    echo "  □ 预览显示正确"
    echo ""
    echo "⏸️  暂停按钮功能："
    echo "  □ 开始新活动"
    echo "  □ 点击「⏸️ 暂停」→ 计时器停止，按钮变为「▶️ 继续」"
    echo "  □ 点击「▶️ 继续」→ 计时器恢复，按钮变为「⏸️ 暂停」"
    echo "  □ 总时长不包含暂停时间"
    echo ""
    echo "📱 iPhone特定（仅iPhone模拟器）："
    echo "  □ 导航栏不超出系统状态栏"
    echo "  □ 输入框大小合适，不触发自动缩放"
    echo "  □ 选择输入框时界面不拉伸"
    echo "  □ 底部内容不被Home Indicator遮挡"
    echo ""
}

# 显示日志查看命令
show_log_commands() {
    print_header "📝 日志查看命令"

    echo -e "${CYAN}Mac应用日志：${NC}"
    echo "  log stream --predicate 'processImagePath contains \"TIME\"' --level debug"
    echo ""
    echo -e "${CYAN}iPhone模拟器日志：${NC}"
    echo "  xcrun simctl spawn booted log stream --predicate 'processImagePath contains \"TIME\"'"
    echo ""
}

# 生成验证报告
generate_verification_report() {
    local mac_result=$1
    local iphone_result=$2

    print_header "📊 验证报告"

    echo -e "${CYAN}自动验证结果：${NC}"
    echo ""

    if [ "$mac_result" = "0" ]; then
        echo -e "  Mac应用:    ${GREEN}✅ 通过${NC}"
    elif [ "$mac_result" = "skipped" ]; then
        echo -e "  Mac应用:    ${YELLOW}⊘ 跳过${NC}"
    else
        echo -e "  Mac应用:    ${RED}❌ 失败${NC}"
    fi

    if [ "$iphone_result" = "0" ]; then
        echo -e "  iPhone应用: ${GREEN}✅ 通过${NC}"
    elif [ "$iphone_result" = "skipped" ]; then
        echo -e "  iPhone应用: ${YELLOW}⊘ 跳过${NC}"
    else
        echo -e "  iPhone应用: ${RED}❌ 失败${NC}"
    fi

    echo ""

    if [ "$mac_result" = "0" ] && [ "$iphone_result" = "0" ]; then
        echo -e "${GREEN}🎉 所有自动验证都通过！${NC}"
        echo -e "${CYAN}建议：继续进行手动功能验证${NC}"
    else
        echo -e "${YELLOW}⚠️  部分验证未通过或被跳过${NC}"
        echo -e "${CYAN}建议：手动检查应用状态和功能${NC}"
    fi

    echo ""
}

# 主函数
main() {
    print_header "🚀 Activity Tracker 自动仿真启动 v3.0"

    # 检查环境
    check_xcode
    enter_project_dir

    # 询问用户要运行哪个平台
    echo -e "${CYAN}请选择要运行的平台：${NC}"
    echo "  1) Mac应用"
    echo "  2) iPhone应用"
    echo "  3) 两者都运行（推荐）"
    echo ""
    read -p "请输入选择 [1-3] (默认: 3): " choice
    choice=${choice:-3}

    echo ""

    # 验证结果变量
    local mac_verify_result="skipped"
    local iphone_verify_result="skipped"

    # Mac应用
    if [ "$choice" = "1" ] || [ "$choice" = "3" ]; then
        if build_mac_app; then
            launch_mac_app
            if verify_mac_app; then
                mac_verify_result="0"
            else
                mac_verify_result="1"
            fi
        else
            print_error "Mac应用构建失败"
            mac_verify_result="1"
        fi
        echo ""
    fi

    # iPhone应用
    if [ "$choice" = "2" ] || [ "$choice" = "3" ]; then
        start_simulator
        if build_iphone_app; then
            install_and_launch_iphone_app
            if verify_iphone_app; then
                iphone_verify_result="0"
            else
                iphone_verify_result="1"
            fi
        else
            print_error "iPhone应用构建失败"
            iphone_verify_result="1"
        fi
        echo ""
    fi

    # 生成验证报告
    generate_verification_report "$mac_verify_result" "$iphone_verify_result"

    # 显示验证清单和日志命令
    show_verification_checklist
    show_log_commands

    print_header "✅ 仿真启动完成"
    print_info "如有问题，请查看上方的验证报告、清单和日志命令"
    echo ""
}

# 执行主函数
main
