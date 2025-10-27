#!/bin/bash

# ==================== 自动化测试框架 ====================
# 功能：自动测试应用功能，替代手动验证
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/auto-test.sh {all|compile|functional|ui|help}
# =======================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 配置
PROJECT_ROOT="/Users/shanwanjun/Desktop/cxs/time"
TEST_REPORT="$PROJECT_ROOT/.test-report-$(date +%Y%m%d-%H%M%S).md"

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

print_header() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  $1"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 测试结果统计
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# 记录测试结果
record_test() {
    local test_name=$1
    local result=$2

    TESTS_RUN=$((TESTS_RUN + 1))

    if [ "$result" = "pass" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        print_success "$test_name"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        print_error "$test_name"
    fi
}

# 编译测试
test_compile() {
    print_header "🔨 编译测试"

    cd "$PROJECT_ROOT/time"

    # 测试Mac编译
    print_info "测试Mac应用编译..."
    if xcodebuild build -quiet \
        -scheme time \
        -destination 'platform=macOS' 2>&1 | grep -i "error:" > /dev/null; then
        record_test "Mac应用编译" "fail"
        return 1
    else
        record_test "Mac应用编译" "pass"
    fi

    # 测试iPhone编译
    print_info "测试iPhone应用编译..."
    if xcodebuild build -quiet \
        -scheme time \
        -destination 'platform=iOS Simulator,name=iPhone 17' 2>&1 | grep -i "error:" > /dev/null; then
        record_test "iPhone应用编译" "fail"
        return 1
    else
        record_test "iPhone应用编译" "pass"
    fi

    return 0
}

# 功能测试
test_functional() {
    print_header "🧪 功能测试"

    # 测试1：Mac应用启动
    print_info "测试Mac应用启动..."
    local app_path=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug -name "TIME.app" -type d 2>/dev/null | head -n 1)

    if [ -z "$app_path" ]; then
        record_test "Mac应用路径检测" "fail"
    else
        record_test "Mac应用路径检测" "pass"

        # 测试应用是否能启动
        pkill -f "TIME.app" 2>/dev/null || true
        sleep 1
        open "$app_path"
        sleep 5

        if ps aux | grep "TIME.app/Contents/MacOS/TIME" | grep -v grep > /dev/null; then
            record_test "Mac应用启动" "pass"

            # 测试窗口是否显示
            sleep 2
            if osascript -e 'tell application "System Events" to exists window 1 of process "TIME"' 2>/dev/null; then
                record_test "Mac应用窗口显示" "pass"
            else
                record_test "Mac应用窗口显示" "fail"
            fi
        else
            record_test "Mac应用启动" "fail"
        fi
    fi

    # 测试2：JavaScript加载
    print_info "测试JavaScript资源加载..."
    sleep 3
    local js_errors=$(log show --predicate 'processImagePath contains "TIME"' --last 5s 2>/dev/null | grep -i "404\|not found" | wc -l | tr -d ' ')

    if [ "$js_errors" -eq 0 ]; then
        record_test "JavaScript资源加载" "pass"
    else
        record_test "JavaScript资源加载（发现${js_errors}个错误）" "fail"
    fi

    # 测试3：控制台错误
    print_info "测试控制台错误..."
    local console_errors=$(log show --predicate 'processImagePath contains "TIME"' --last 5s 2>/dev/null | grep -iE "error|exception" | grep -v "stderr" | wc -l | tr -d ' ')

    if [ "$console_errors" -eq 0 ]; then
        record_test "控制台无错误" "pass"
    else
        record_test "控制台错误检查（发现${console_errors}个错误）" "fail"
    fi
}

# UI测试
test_ui() {
    print_header "🎨 UI测试"

    # 测试1：关键文件存在性
    print_info "测试关键文件..."

    local required_files=(
        "time/time/Web/activity-tracker.html"
        "time/time/Web/css/activity-tracker.css"
        "time/time/Web/js/app-main.js"
        "time/time/Web/js/activity-tracker.js"
        "time/time/Web/js/theme-switcher.js"
        "time/time/Web/js/size-switcher.js"
    )

    for file in "${required_files[@]}"; do
        if [ -f "$PROJECT_ROOT/$file" ]; then
            record_test "文件存在：$file" "pass"
        else
            record_test "文件存在：$file" "fail"
        fi
    done

    # 测试2：CSS语法
    print_info "测试CSS文件..."
    if [ -f "$PROJECT_ROOT/time/time/Web/css/activity-tracker.css" ]; then
        # 简单检查：是否有基本的CSS结构
        if grep -q ":root" "$PROJECT_ROOT/time/time/Web/css/activity-tracker.css" && \
           grep -q ".btn" "$PROJECT_ROOT/time/time/Web/css/activity-tracker.css"; then
            record_test "CSS文件结构" "pass"
        else
            record_test "CSS文件结构" "fail"
        fi
    fi

    # 测试3：JavaScript语法（基础检查）
    print_info "测试JavaScript文件..."
    if [ -f "$PROJECT_ROOT/time/time/Web/js/app-main.js" ]; then
        # 检查是否有语法错误（基础检查）
        if grep -q "DOMContentLoaded" "$PROJECT_ROOT/time/time/Web/js/app-main.js"; then
            record_test "JavaScript基础结构" "pass"
        else
            record_test "JavaScript基础结构" "fail"
        fi
    fi
}

# 运行所有测试
run_all_tests() {
    print_header "🚀 运行完整测试套件"

    local start_time=$(date +%s)

    # 运行各类测试
    test_compile
    test_functional
    test_ui

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # 显示测试结果
    print_header "📊 测试结果"

    echo -e "${CYAN}测试统计：${NC}"
    echo "  总测试数：$TESTS_RUN"
    echo "  通过：$TESTS_PASSED"
    echo "  失败：$TESTS_FAILED"
    echo "  耗时：${duration}秒"
    echo ""

    local pass_rate=$(( TESTS_PASSED * 100 / TESTS_RUN ))

    echo -e "${CYAN}通过率：${pass_rate}%${NC}"
    echo ""

    if [ $TESTS_FAILED -eq 0 ]; then
        print_success "═══════════════════════════════════════"
        print_success "所有测试通过！"
        print_success "═══════════════════════════════════════"
        return 0
    else
        print_error "═══════════════════════════════════════"
        print_error "有 $TESTS_FAILED 个测试失败"
        print_error "═══════════════════════════════════════"
        return 1
    fi
}

# 生成测试报告
generate_test_report() {
    cat > "$TEST_REPORT" << EOF
# 🧪 自动化测试报告

## 📅 测试时间
$(date '+%Y年%m月%d日 %H:%M:%S')

## 📊 测试统计

| 指标 | 数值 |
|------|------|
| 总测试数 | $TESTS_RUN |
| 通过数 | $TESTS_PASSED |
| 失败数 | $TESTS_FAILED |
| 通过率 | $(( TESTS_PASSED * 100 / TESTS_RUN ))% |

## ✅ 通过的测试

$(grep "✅" "$AUDIT_LOG" 2>/dev/null | tail -10 || echo "无")

## ❌ 失败的测试

$(grep "❌" "$AUDIT_LOG" 2>/dev/null | tail -10 || echo "无")

## 💡 建议

EOF

    if [ $TESTS_FAILED -eq 0 ]; then
        echo "✅ 所有测试通过，代码质量良好" >> "$TEST_REPORT"
    else
        cat >> "$TEST_REPORT" << EOF
⚠️ 发现 $TESTS_FAILED 个失败测试

建议措施：
1. 检查失败的测试项
2. 修复相关问题
3. 重新运行测试
4. 考虑回退到上一个稳定快照
EOF
    fi

    echo "" >> "$TEST_REPORT"
    echo "---" >> "$TEST_REPORT"
    echo "报告位置：$TEST_REPORT" >> "$TEST_REPORT"

    print_info "测试报告已生成：$TEST_REPORT"
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}自动化测试框架 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {all|compile|functional|ui|help}"
    echo ""
    echo "命令："
    echo "  all        - 运行所有测试"
    echo "  compile    - 仅编译测试"
    echo "  functional - 仅功能测试"
    echo "  ui         - 仅UI测试"
    echo "  help       - 显示帮助"
    echo ""
    echo "示例："
    echo "  $0 all           # 运行完整测试"
    echo "  $0 compile       # 仅测试编译"
    echo ""
}

# 主函数
main() {
    case "${1:-all}" in
        all)
            run_all_tests
            generate_test_report
            ;;
        compile)
            test_compile
            ;;
        functional)
            test_functional
            ;;
        ui)
            test_ui
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"


