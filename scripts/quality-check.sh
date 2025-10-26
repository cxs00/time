#!/bin/bash

# ==================== 代码质量检测系统 ====================
# 功能：自动检测代码质量指标
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/quality-check.sh {check|report|help}
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
QUALITY_REPORT="$PROJECT_ROOT/.quality-report-$(date +%Y%m%d).md"

# 质量阈值
MAX_FILE_LINES=500
MAX_FUNCTION_LINES=50
MIN_COMMENT_RATE=15
MAX_DUPLICATE_RATE=5

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

# 检查文件大小
check_file_size() {
    print_info "检查文件大小..."

    local large_files=0
    local total_files=0

    # 检查JavaScript文件
    while IFS= read -r file; do
        total_files=$((total_files + 1))
        local lines=$(wc -l < "$file" | tr -d ' ')

        if [ "$lines" -gt $MAX_FILE_LINES ]; then
            print_warning "$(basename $file): ${lines}行 (超过${MAX_FILE_LINES}行限制)"
            large_files=$((large_files + 1))
        fi
    done < <(find "$PROJECT_ROOT/time/time/Web/js" -name "*.js" 2>/dev/null)

    if [ $large_files -eq 0 ]; then
        print_success "文件大小检查通过"
        return 0
    else
        print_warning "发现 $large_files 个超大文件"
        return 1
    fi
}

# 检查注释覆盖率
check_comment_coverage() {
    print_info "检查注释覆盖率..."

    local js_dir="$PROJECT_ROOT/time/time/Web/js"

    if [ ! -d "$js_dir" ]; then
        print_warning "JavaScript目录不存在"
        return 1
    fi

    local total_lines=$(find "$js_dir" -name "*.js" -exec cat {} \; | wc -l | tr -d ' ')
    local comment_lines=$(find "$js_dir" -name "*.js" -exec grep -c "^[[:space:]]*//\|^[[:space:]]*\*\|^[[:space:]]/\*" {} \; 2>/dev/null | awk '{s+=$1} END {print s}')

    if [ "$total_lines" -eq 0 ]; then
        print_warning "没有JavaScript文件"
        return 1
    fi

    local comment_rate=$(( comment_lines * 100 / total_lines ))

    echo "  总代码行数：$total_lines"
    echo "  注释行数：$comment_lines"
    echo "  注释率：${comment_rate}%"

    if [ "$comment_rate" -ge $MIN_COMMENT_RATE ]; then
        print_success "注释覆盖率良好"
        return 0
    else
        print_warning "注释率${comment_rate}%低于${MIN_COMMENT_RATE}%"
        return 1
    fi
}

# 检查命名规范
check_naming_convention() {
    print_info "检查命名规范..."

    local issues=0

    # 检查CSS类名（应该使用BEM或kebab-case）
    local bad_classes=$(grep -r "class=\"[A-Z]" "$PROJECT_ROOT/time/time/Web" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$bad_classes" -gt 0 ]; then
        print_warning "发现 $bad_classes 个不规范的class名（应使用小写）"
        issues=$((issues + 1))
    fi

    # 检查JavaScript文件名（应该使用kebab-case）
    local bad_filenames=$(find "$PROJECT_ROOT/time/time/Web/js" -name "*[A-Z]*.js" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$bad_filenames" -gt 0 ]; then
        print_warning "发现 $bad_filenames 个不规范的文件名"
        issues=$((issues + 1))
    fi

    if [ $issues -eq 0 ]; then
        print_success "命名规范检查通过"
        return 0
    else
        return 1
    fi
}

# 检查代码重复
check_code_duplication() {
    print_info "检查代码重复..."

    # 简单检查：查找重复的函数名
    local js_files=$(find "$PROJECT_ROOT/time/time/Web/js" -name "*.js" 2>/dev/null)

    if [ -z "$js_files" ]; then
        print_warning "没有JavaScript文件"
        return 1
    fi

    # 提取所有函数名
    local functions=$(grep -h "function\s\|^\s*\w\+\s*(" $js_files 2>/dev/null | wc -l | tr -d ' ')
    local unique_functions=$(grep -h "function\s\|^\s*\w\+\s*(" $js_files 2>/dev/null | sort -u | wc -l | tr -d ' ')

    if [ "$functions" -eq 0 ]; then
        print_info "未检测到函数定义"
        return 0
    fi

    local duplicates=$((functions - unique_functions))
    local dup_rate=$(( duplicates * 100 / functions ))

    echo "  总函数数：$functions"
    echo "  唯一函数：$unique_functions"
    echo "  重复率：${dup_rate}%"

    if [ "$dup_rate" -le $MAX_DUPLICATE_RATE ]; then
        print_success "代码重复率良好"
        return 0
    else
        print_warning "代码重复率${dup_rate}%超过${MAX_DUPLICATE_RATE}%"
        return 1
    fi
}

# 检查错误处理
check_error_handling() {
    print_info "检查错误处理..."

    local js_files=$(find "$PROJECT_ROOT/time/time/Web/js" -name "*.js" 2>/dev/null)

    if [ -z "$js_files" ]; then
        return 1
    fi

    # 统计try-catch使用
    local try_count=$(grep -c "try\s*{" $js_files 2>/dev/null | awk '{s+=$1} END {print s}')
    local catch_count=$(grep -c "catch\s*(" $js_files 2>/dev/null | awk '{s+=$1} END {print s}')

    echo "  try块数量：$try_count"
    echo "  catch块数量：$catch_count"

    if [ "$try_count" -eq "$catch_count" ] && [ "$try_count" -gt 0 ]; then
        print_success "错误处理检查通过"
        return 0
    elif [ "$try_count" -eq 0 ]; then
        print_warning "未发现try-catch错误处理"
        return 1
    else
        print_warning "try-catch不匹配"
        return 1
    fi
}

# 运行完整质量检查
run_quality_check() {
    print_header "🔍 代码质量检查"

    local checks_passed=0
    local checks_failed=0

    # 执行各项检查
    check_file_size && checks_passed=$((checks_passed + 1)) || checks_failed=$((checks_failed + 1))
    echo ""

    check_comment_coverage && checks_passed=$((checks_passed + 1)) || checks_failed=$((checks_failed + 1))
    echo ""

    check_naming_convention && checks_passed=$((checks_passed + 1)) || checks_failed=$((checks_failed + 1))
    echo ""

    check_code_duplication && checks_passed=$((checks_passed + 1)) || checks_failed=$((checks_failed + 1))
    echo ""

    check_error_handling && checks_passed=$((checks_passed + 1)) || checks_failed=$((checks_failed + 1))
    echo ""

    # 显示结果
    print_header "📊 质量检查结果"

    local total=$((checks_passed + checks_failed))
    local score=$(( checks_passed * 100 / total ))

    echo "  通过检查：$checks_passed / $total"
    echo "  质量得分：${score}分"
    echo ""

    if [ "$score" -ge 80 ]; then
        print_success "代码质量优秀（${score}分）"
    elif [ "$score" -ge 60 ]; then
        print_warning "代码质量良好（${score}分）"
    else
        print_error "代码质量需要改进（${score}分）"
    fi

    generate_quality_report "$checks_passed" "$checks_failed" "$score"
}

# 生成质量报告
generate_quality_report() {
    local passed=$1
    local failed=$2
    local score=$3

    cat > "$QUALITY_REPORT" << EOF
# 📊 代码质量检查报告

## 📅 检查时间
$(date '+%Y年%m月%d日 %H:%M:%S')

## 🎯 质量得分

**总分：${score}/100**

| 检查项 | 结果 |
|--------|------|
| 通过检查 | $passed |
| 失败检查 | $failed |

## 📋 检查详情

### 1. 文件大小检查
- 阈值：最大 $MAX_FILE_LINES 行/文件
- 状态：查看上方输出

### 2. 注释覆盖率检查
- 阈值：最小 $MIN_COMMENT_RATE%
- 状态：查看上方输出

### 3. 命名规范检查
- 标准：BEM/kebab-case
- 状态：查看上方输出

### 4. 代码重复检查
- 阈值：最大 $MAX_DUPLICATE_RATE%
- 状态：查看上方输出

### 5. 错误处理检查
- 标准：try-catch匹配
- 状态：查看上方输出

## 💡 改进建议

EOF

    if [ "$score" -ge 80 ]; then
        echo "✅ 代码质量优秀，继续保持" >> "$QUALITY_REPORT"
    elif [ "$score" -ge 60 ]; then
        cat >> "$QUALITY_REPORT" << 'EOF'
⚠️ 代码质量良好，建议改进：
1. 增加代码注释
2. 拆分过大文件
3. 统一命名规范
4. 减少代码重复
EOF
    else
        cat >> "$QUALITY_REPORT" << 'EOF'
❌ 代码质量需要改进：
1. 立即增加错误处理
2. 重构超大文件
3. 添加必要注释
4. 统一命名规范
5. 消除代码重复
EOF
    fi

    echo "" >> "$QUALITY_REPORT"
    echo "---" >> "$QUALITY_REPORT"
    echo "报告位置：$QUALITY_REPORT" >> "$QUALITY_REPORT"

    print_info "质量报告已生成：$QUALITY_REPORT"
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}代码质量检测系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {check|report|help}"
    echo ""
    echo "命令："
    echo "  check   - 运行质量检查"
    echo "  report  - 查看最新报告"
    echo "  help    - 显示帮助"
    echo ""
    echo "检查项："
    echo "  • 文件大小（最大${MAX_FILE_LINES}行）"
    echo "  • 注释率（最小${MIN_COMMENT_RATE}%）"
    echo "  • 命名规范（BEM/kebab-case）"
    echo "  • 代码重复（最大${MAX_DUPLICATE_RATE}%）"
    echo "  • 错误处理（try-catch）"
    echo ""
}

# 主函数
main() {
    case "${1:-check}" in
        check)
            run_quality_check
            ;;
        report)
            if [ -f "$PROJECT_ROOT"/.quality-report-*.md ]; then
                cat $(ls -t "$PROJECT_ROOT"/.quality-report-*.md | head -1)
            else
                print_warning "没有质量报告"
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


