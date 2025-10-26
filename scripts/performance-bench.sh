#!/bin/bash

# ==================== 性能基准测试系统 ====================
# 功能：测量和对比应用性能
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/performance-bench.sh {baseline|compare|report}
# =========================================================

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
BASELINE_FILE="$PROJECT_ROOT/.performance-baseline.json"
PERF_REPORT="$PROJECT_ROOT/.performance-report-$(date +%Y%m%d-%H%M%S).md"

# 性能阈值
MAX_COMPILE_TIME=60      # 最大编译时间（秒）
MAX_LAUNCH_TIME=10       # 最大启动时间（秒）
MAX_PERFORMANCE_DROP=10  # 最大性能下降（%）

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

# 测量编译时间
measure_compile_time() {
    print_info "测量编译时间..."

    cd "$PROJECT_ROOT/time"

    local start_time=$(date +%s)

    xcodebuild clean build -quiet \
        -scheme time \
        -destination 'platform=macOS' >/dev/null 2>&1 || true

    local end_time=$(date +%s)
    local compile_time=$((end_time - start_time))

    echo "$compile_time"
}

# 测量启动时间
measure_launch_time() {
    print_info "测量启动时间..."

    # 查找应用
    local app_path=$(find ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug -name "TIME.app" -type d 2>/dev/null | head -n 1)

    if [ -z "$app_path" ]; then
        echo "0"
        return 1
    fi

    # 关闭已运行的应用
    pkill -f "TIME.app" 2>/dev/null || true
    sleep 2

    local start_time=$(date +%s)

    # 启动应用
    open "$app_path"

    # 等待窗口出现
    local elapsed=0
    while [ $elapsed -lt 30 ]; do
        if osascript -e 'tell application "System Events" to exists window 1 of process "TIME"' 2>/dev/null; then
            local end_time=$(date +%s)
            local launch_time=$((end_time - start_time))
            echo "$launch_time"
            return 0
        fi
        sleep 1
        elapsed=$((elapsed + 1))
    done

    echo "30"  # 超时
    return 1
}

# 测量应用内存占用
measure_memory_usage() {
    print_info "测量内存占用..."

    if ! ps aux | grep "TIME.app/Contents/MacOS/TIME" | grep -v grep > /dev/null; then
        echo "0"
        return 1
    fi

    # 获取内存占用（KB）
    local memory=$(ps aux | grep "TIME.app/Contents/MacOS/TIME" | grep -v grep | awk '{print $6}' | head -1)

    echo "$memory"
}

# 创建性能基准
create_baseline() {
    print_header "📊 创建性能基准"

    print_info "开始性能测量..."
    echo ""

    # 测量各项指标
    local compile_time=$(measure_compile_time)
    echo "  编译时间：${compile_time}秒"

    local launch_time=$(measure_launch_time)
    echo "  启动时间：${launch_time}秒"

    local memory=$(measure_memory_usage)
    local memory_mb=$((memory / 1024))
    echo "  内存占用：${memory_mb}MB"

    echo ""

    # 保存基准
    cat > "$BASELINE_FILE" << EOF
{
  "timestamp": "$(date '+%Y-%m-%d %H:%M:%S')",
  "compile_time": $compile_time,
  "launch_time": $launch_time,
  "memory_kb": $memory,
  "memory_mb": $memory_mb
}
EOF

    print_success "性能基准已创建"
    print_info "基准文件：$BASELINE_FILE"
}

# 对比性能
compare_performance() {
    print_header "📊 性能对比测试"

    if [ ! -f "$BASELINE_FILE" ]; then
        print_error "未找到性能基准"
        print_info "请先创建基准：$0 baseline"
        return 1
    fi

    # 读取基准数据
    local baseline_compile=$(grep "compile_time" "$BASELINE_FILE" | grep -o "[0-9]\+")
    local baseline_launch=$(grep "launch_time" "$BASELINE_FILE" | grep -o "[0-9]\+")
    local baseline_memory=$(grep "memory_mb" "$BASELINE_FILE" | grep -o "[0-9]\+")

    print_info "基准性能："
    echo "  编译时间：${baseline_compile}秒"
    echo "  启动时间：${baseline_launch}秒"
    echo "  内存占用：${baseline_memory}MB"
    echo ""

    # 测量当前性能
    print_info "测量当前性能..."
    echo ""

    local current_compile=$(measure_compile_time)
    local current_launch=$(measure_launch_time)
    local current_memory=$(measure_memory_usage)
    local current_memory_mb=$((current_memory / 1024))

    echo "  编译时间：${current_compile}秒"
    echo "  启动时间：${current_launch}秒"
    echo "  内存占用：${current_memory_mb}MB"
    echo ""

    # 计算变化
    print_header "📊 性能变化"

    local compile_change=$(( (current_compile - baseline_compile) * 100 / baseline_compile ))
    local launch_change=$(( (current_launch - baseline_launch) * 100 / baseline_launch ))
    local memory_change=$(( (current_memory_mb - baseline_memory) * 100 / baseline_memory ))

    echo "编译时间："
    if [ $compile_change -lt 0 ]; then
        print_success "  改进 ${compile_change#-}%"
    elif [ $compile_change -gt $MAX_PERFORMANCE_DROP ]; then
        print_error "  下降 ${compile_change}% (超过${MAX_PERFORMANCE_DROP}%阈值)"
    else
        print_info "  变化 ${compile_change}%"
    fi

    echo "启动时间："
    if [ $launch_change -lt 0 ]; then
        print_success "  改进 ${launch_change#-}%"
    elif [ $launch_change -gt $MAX_PERFORMANCE_DROP ]; then
        print_error "  下降 ${launch_change}% (超过${MAX_PERFORMANCE_DROP}%阈值)"
    else
        print_info "  变化 ${launch_change}%"
    fi

    echo "内存占用："
    if [ $memory_change -lt 0 ]; then
        print_success "  减少 ${memory_change#-}%"
    elif [ $memory_change -gt $MAX_PERFORMANCE_DROP ]; then
        print_error "  增加 ${memory_change}% (超过${MAX_PERFORMANCE_DROP}%阈值)"
    else
        print_info "  变化 ${memory_change}%"
    fi

    echo ""

    # 生成报告
    generate_performance_report "$baseline_compile" "$baseline_launch" "$baseline_memory" \
                                "$current_compile" "$current_launch" "$current_memory_mb" \
                                "$compile_change" "$launch_change" "$memory_change"

    # 返回结果
    if [ $compile_change -gt $MAX_PERFORMANCE_DROP ] || \
       [ $launch_change -gt $MAX_PERFORMANCE_DROP ] || \
       [ $memory_change -gt $MAX_PERFORMANCE_DROP ]; then
        print_warning "性能下降超过阈值"
        return 1
    else
        print_success "性能变化在可接受范围内"
        return 0
    fi
}

# 生成性能报告
generate_performance_report() {
    local base_comp=$1
    local base_launch=$2
    local base_mem=$3
    local curr_comp=$4
    local curr_launch=$5
    local curr_mem=$6
    local comp_change=$7
    local launch_change=$8
    local mem_change=$9

    cat > "$PERF_REPORT" << EOF
# ⚡ 性能基准测试报告

## 📅 测试时间
$(date '+%Y年%m月%d日 %H:%M:%S')

## 📊 性能对比

| 指标 | 基准值 | 当前值 | 变化 | 状态 |
|------|--------|--------|------|------|
| 编译时间 | ${base_comp}s | ${curr_comp}s | ${comp_change}% | $([ $comp_change -lt $MAX_PERFORMANCE_DROP ] && echo "✅" || echo "❌") |
| 启动时间 | ${base_launch}s | ${curr_launch}s | ${launch_change}% | $([ $launch_change -lt $MAX_PERFORMANCE_DROP ] && echo "✅" || echo "❌") |
| 内存占用 | ${base_mem}MB | ${curr_mem}MB | ${mem_change}% | $([ $mem_change -lt $MAX_PERFORMANCE_DROP ] && echo "✅" || echo "❌") |

## 💡 分析

EOF

    if [ $comp_change -lt 0 ] && [ $launch_change -lt 0 ] && [ $mem_change -lt 0 ]; then
        echo "✅ **全面性能提升**" >> "$PERF_REPORT"
    elif [ $comp_change -gt $MAX_PERFORMANCE_DROP ] || [ $launch_change -gt $MAX_PERFORMANCE_DROP ] || [ $mem_change -gt $MAX_PERFORMANCE_DROP ]; then
        cat >> "$PERF_REPORT" << 'EOF'
⚠️ **性能下降警告**

建议措施：
1. 检查最近的代码修改
2. 考虑回退到上一个快照
3. 优化影响性能的代码
4. 重新运行基准测试
EOF
    else
        echo "✅ 性能变化在可接受范围内" >> "$PERF_REPORT"
    fi

    cat >> "$PERF_REPORT" << EOF

## 🎯 建议

- 编译时间阈值：<${MAX_COMPILE_TIME}秒
- 启动时间阈值：<${MAX_LAUNCH_TIME}秒
- 性能下降阈值：<${MAX_PERFORMANCE_DROP}%

---

报告生成时间：$(date '+%Y-%m-%d %H:%M:%S')
EOF

    print_info "性能报告已生成：$PERF_REPORT"
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}性能基准测试系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {baseline|compare|report|help}"
    echo ""
    echo "命令："
    echo "  baseline  - 创建性能基准"
    echo "  compare   - 对比当前性能与基准"
    echo "  report    - 查看最新报告"
    echo "  help      - 显示帮助"
    echo ""
    echo "测量指标："
    echo "  • 编译时间"
    echo "  • 启动时间"
    echo "  • 内存占用"
    echo ""
    echo "使用流程："
    echo "  1. 创建基准：$0 baseline"
    echo "  2. 修改代码..."
    echo "  3. 性能对比：$0 compare"
    echo ""
}

# 主函数
main() {
    case "${1:-help}" in
        baseline)
            create_baseline
            ;;
        compare)
            compare_performance
            ;;
        report)
            if ls "$PROJECT_ROOT"/.performance-report-*.md 1> /dev/null 2>&1; then
                cat $(ls -t "$PROJECT_ROOT"/.performance-report-*.md | head -1)
            else
                print_warning "没有性能报告"
            fi
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


