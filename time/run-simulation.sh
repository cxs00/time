#!/bin/bash

# ==================== Activity Tracker 自动仿真脚本 ====================
# 功能：自动编译并启动Mac和iPhone应用仿真
# 版本：v2.2.0
# 日期：2025-10-25
# =====================================================================

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
        
        # 🔧 关键修复：编译后立即复制Web资源到app bundle
        print_step "复制Web资源到应用包..."
        local app_path=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug -name "TIME.app" -type d 2>/dev/null | head -n 1)
        if [ -n "$app_path" ]; then
            local resources_dir="$app_path/Contents/Resources"
            mkdir -p "$resources_dir/Web"
            
            # 复制整个Web目录到Resources
            if cp -R "$PROJECT_DIR/Web/"* "$resources_dir/Web/" 2>/dev/null; then
                print_success "Web资源复制成功"
                print_info "目标目录: $resources_dir/Web/"
                # 显示复制的文件数量
                local file_count=$(find "$resources_dir/Web" -type f | wc -l | tr -d ' ')
                print_info "已复制 $file_count 个文件"
            else
                print_warning "Web资源复制失败，应用可能黑屏"
            fi
        else
            print_warning "找不到应用包，跳过资源复制"
        fi
        
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
    print_step "启动Mac应用..."

    open "$app_path"
    print_success "Mac应用已启动"
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
        
        # 🔧 关键修复：编译后立即复制Web资源到app bundle
        print_step "复制Web资源到应用包..."
        local app_path=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator -name "TIME.app" -type d 2>/dev/null | head -n 1)
        if [ -n "$app_path" ]; then
            # iOS应用资源直接在app根目录
            mkdir -p "$app_path/Web"
            
            # 复制整个Web目录
            if cp -R "$PROJECT_DIR/Web/"* "$app_path/Web/" 2>/dev/null; then
                print_success "Web资源复制成功"
                print_info "目标目录: $app_path/Web/"
                local file_count=$(find "$app_path/Web" -type f | wc -l | tr -d ' ')
                print_info "已复制 $file_count 个文件"
            else
                print_warning "Web资源复制失败"
            fi
        else
            print_warning "找不到应用包，跳过资源复制"
        fi
        
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

    # 启动应用
    if xcrun simctl launch booted "$BUNDLE_ID" &>/dev/null; then
        print_success "iPhone应用已启动"
    else
        print_warning "应用启动失败，请手动在模拟器中打开TIME应用"
    fi
}

# 显示验证清单
show_verification_checklist() {
    print_header "🔍 验证清单"

    echo -e "${CYAN}请在应用中验证以下功能：${NC}"
    echo ""
    echo "📱 基础功能："
    echo "  □ 应用成功启动"
    echo "  □ 界面正常显示"
    echo "  □ 导航栏功能正常"
    echo "  □ 数据正确加载（12个项目）"
    echo ""
    echo "⏸️  暂停按钮功能："
    echo "  □ 开始新活动"
    echo "  □ 点击「⏸️ 暂停」→ 计时器停止，按钮变为「▶️ 继续」"
    echo "  □ 点击「▶️ 继续」→ 计时器恢复，按钮变为「⏸️ 暂停」"
    echo "  □ 总时长不包含暂停时间"
    echo ""
    echo "📱 iPhone特定（仅iPhone模拟器）："
    echo "  □ 导航栏不超出系统状态栏"
    echo "  □ 卡片滑动不超出状态栏"
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

# 主函数
main() {
    print_header "🚀 Activity Tracker 自动仿真启动"

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

    # Mac应用
    if [ "$choice" = "1" ] || [ "$choice" = "3" ]; then
        if build_mac_app; then
            launch_mac_app
        else
            print_error "Mac应用构建失败"
        fi
        echo ""
    fi

    # iPhone应用
    if [ "$choice" = "2" ] || [ "$choice" = "3" ]; then
        start_simulator
        if build_iphone_app; then
            install_and_launch_iphone_app
        else
            print_error "iPhone应用构建失败"
        fi
        echo ""
    fi

    # 显示验证清单和日志命令
    show_verification_checklist
    show_log_commands

    print_header "✅ 仿真启动完成"
    print_info "如有问题，请查看上方的验证清单和日志命令"
    echo ""
}

# 执行主函数
main

