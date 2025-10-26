#!/bin/bash

# ==================== 实时错误监控系统 ====================
# 功能：监控编译、运行、测试错误，自动触发回退
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/error-monitor.sh {check|monitor|stop}
# ========================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 配置
PROJECT_ROOT="/Users/shanwanjun/Desktop/cxs/time"
ERROR_LOG="$PROJECT_ROOT/.error-monitor.log"
PID_FILE="$PROJECT_ROOT/.error-monitor.pid"
MONITOR_INTERVAL=30  # 监控间隔（秒）

# 监控选项
MONITOR_COMPILE=true
MONITOR_RUNTIME=true
AUTO_ROLLBACK=true  # 是否自动回退

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

# 检查编译错误
check_compile_errors() {
    cd "$PROJECT_ROOT/time"

    print_info "检查编译错误..."

    # 尝试编译Mac版本
    local compile_output=$(xcodebuild build \
        -scheme time \
        -destination 'platform=macOS' \
        -quiet 2>&1)

    if echo "$compile_output" | grep -i "error:" > /dev/null; then
        print_error "检测到编译错误"

        # 提取错误信息
        local error_details=$(echo "$compile_output" | grep -i "error:" | head -5)
        echo "$error_details"

        # 记录到日志
        echo "$(date): 编译错误" >> "$ERROR_LOG"
        echo "$error_details" >> "$ERROR_LOG"

        return 1
    fi

    print_success "编译检查通过"
    return 0
}

# 检查运行时错误
check_runtime_errors() {
    print_info "检查运行时错误..."

    # 检查TIME应用进程是否存在
    if ! ps aux | grep "TIME.app/Contents/MacOS/TIME" | grep -v grep > /dev/null; then
        print_warning "应用未运行"
        return 0  # 应用未运行不算错误
    fi

    # 检查最近的系统日志
    local errors=$(log show \
        --predicate 'processImagePath contains "TIME"' \
        --last 30s 2>/dev/null | \
        grep -iE "error|crash|exception|fatal" | \
        grep -v "stderr" | \
        wc -l | tr -d ' ')

    if [ "$errors" -gt 0 ]; then
        print_error "检测到 $errors 个运行时错误"

        # 记录详细错误
        log show --predicate 'processImagePath contains "TIME"' \
            --last 30s 2>/dev/null | \
            grep -iE "error|crash|exception|fatal" | \
            head -5 >> "$ERROR_LOG"

        return 1
    fi

    print_success "运行时检查通过"
    return 0
}

# 触发自动回退
trigger_auto_rollback() {
    local error_type=$1

    echo ""
    print_warning "═══════════════════════════════════════"
    print_error "检测到错误：$error_type"
    print_warning "═══════════════════════════════════════"
    echo ""

    # 记录错误
    echo "$(date): $error_type - 触发自动回退" >> "$ERROR_LOG"

    # 获取最近的稳定快照
    local latest_snapshot=$(cd "$PROJECT_ROOT" && git tag -l "snapshot-*" --sort=-creatordate | head -1)

    if [ -z "$latest_snapshot" ]; then
        print_error "没有可用的快照，无法自动回退"
        print_info "建议："
        echo "  1. 先创建快照: ./scripts/auto-snapshot.sh create"
        echo "  2. 手动修复错误"
        return 1
    fi

    print_info "找到最近快照: $latest_snapshot"

    if [ "$AUTO_ROLLBACK" = true ]; then
        print_warning "准备自动回退..."
        sleep 2

        # 执行回退
        "$PROJECT_ROOT/scripts/rollback-to-snapshot.sh" "$latest_snapshot" --auto

        # 生成错误报告
        generate_error_report "$error_type" "$latest_snapshot"

        print_success "已自动回退到稳定状态"
    else
        print_warning "自动回退已禁用"
        print_info "手动回退命令: ./scripts/rollback-to-snapshot.sh $latest_snapshot"
    fi
}

# 生成错误报告
generate_error_report() {
    local error_type=$1
    local snapshot=$2
    local report_file="$PROJECT_ROOT/.error-report-$(date +%Y%m%d-%H%M%S).md"

    cat > "$report_file" << EOF
# 🚨 自动回退报告

## 错误信息
- **类型**: $error_type
- **时间**: $(date '+%Y-%m-%d %H:%M:%S')
- **回退到**: $snapshot

## 最近错误日志
\`\`\`
$(tail -20 "$ERROR_LOG")
\`\`\`

## 回退前的文件状态
\`\`\`
$(cd "$PROJECT_ROOT" && git status --short)
\`\`\`

## 建议措施
1. **查看错误日志**
   \`\`\`bash
   tail -50 $ERROR_LOG
   \`\`\`

2. **检查回退前的修改**
   \`\`\`bash
   git diff $snapshot
   \`\`\`

3. **恢复修改（如需要）**
   \`\`\`bash
   git stash list              # 查看保存的修改
   git stash show stash@{0}    # 查看最近的修改
   git stash apply stash@{0}   # 恢复修改
   \`\`\`

4. **重新开始开发**
   \`\`\`bash
   # 修复错误后
   ./scripts/auto-snapshot.sh create  # 创建新快照
   # 继续开发...
   \`\`\`

## 错误分析
根据错误类型 **$error_type**，可能的原因：

### 如果是编译错误：
- 语法错误
- 类型不匹配
- 缺少依赖
- 文件路径错误

### 如果是运行时错误：
- 空指针异常
- 资源加载失败
- JavaScript错误
- 内存问题

## 快照管理
\`\`\`bash
# 查看所有快照
./scripts/auto-snapshot.sh list

# 回退到特定快照
./scripts/rollback-to-snapshot.sh <快照名称>

# 创建新快照
./scripts/auto-snapshot.sh create
\`\`\`

---
报告生成时间: $(date)
EOF

    print_success "错误报告已生成: $report_file"
    print_info "查看报告: cat $report_file"
}

# 持续监控
monitor_continuous() {
    print_info "启动持续监控..."
    echo ""
    print_info "监控间隔: ${MONITOR_INTERVAL}秒"
    print_info "编译检查: $MONITOR_COMPILE"
    print_info "运行时检查: $MONITOR_RUNTIME"
    print_info "自动回退: $AUTO_ROLLBACK"
    echo ""
    print_warning "按Ctrl+C停止监控"
    echo ""

    # 保存PID
    echo $$ > "$PID_FILE"

    local check_count=0

    while true; do
        check_count=$((check_count + 1))
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        print_info "检查 #$check_count ($(date +%H:%M:%S))"
        echo ""

        local has_error=false
        local error_type=""

        # 检查编译错误
        if [ "$MONITOR_COMPILE" = true ]; then
            if ! check_compile_errors; then
                has_error=true
                error_type="编译错误"
            fi
        fi

        # 检查运行时错误
        if [ "$has_error" = false ] && [ "$MONITOR_RUNTIME" = true ]; then
            if ! check_runtime_errors; then
                has_error=true
                error_type="运行时错误"
            fi
        fi

        # 如果有错误，触发回退
        if [ "$has_error" = true ]; then
            trigger_auto_rollback "$error_type"

            print_warning "监控已停止，请修复错误后重新启动"
            rm -f "$PID_FILE"
            exit 1
        fi

        print_success "所有检查通过"
        echo ""
        print_info "下次检查: $(date -v+${MONITOR_INTERVAL}S +%H:%M:%S)"

        sleep $MONITOR_INTERVAL
    done
}

# 执行一次检查
check_once() {
    print_info "执行一次性检查..."
    echo ""

    local has_error=false

    if [ "$MONITOR_COMPILE" = true ]; then
        check_compile_errors || has_error=true
    fi

    echo ""

    if [ "$has_error" = false ] && [ "$MONITOR_RUNTIME" = true ]; then
        check_runtime_errors || has_error=true
    fi

    echo ""

    if [ "$has_error" = true ]; then
        print_error "检查失败"
        return 1
    else
        print_success "检查通过"
        return 0
    fi
}

# 停止监控
stop_monitor() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        print_info "停止监控进程 (PID: $pid)..."
        kill "$pid" 2>/dev/null || true
        rm -f "$PID_FILE"
        print_success "监控已停止"
    else
        print_warning "监控未运行"
    fi
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}实时错误监控系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {check|monitor|stop|help}"
    echo ""
    echo "命令："
    echo "  check   - 执行一次性检查"
    echo "  monitor - 启动持续监控（后台）"
    echo "  stop    - 停止监控"
    echo "  help    - 显示此帮助信息"
    echo ""
    echo "示例："
    echo "  $0 check                    # 检查一次"
    echo "  $0 monitor                  # 启动监控"
    echo "  $0 stop                     # 停止监控"
    echo ""
    echo "配置："
    echo "  监控间隔: ${MONITOR_INTERVAL}秒"
    echo "  错误日志: $ERROR_LOG"
    echo ""
}

# 主函数
main() {
    case "${1:-help}" in
        check)
            check_once
            ;;
        monitor)
            monitor_continuous
            ;;
        stop)
            stop_monitor
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

