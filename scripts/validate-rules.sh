#!/bin/bash

# ==================== 规则有效性验证系统 ====================
# 功能：验证.cursorrules文件本身的正确性
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/validate-rules.sh {check|fix|help}
# ===========================================================

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
RULES_FILE="$PROJECT_ROOT/.cursorrules"
VALIDATION_REPORT="$PROJECT_ROOT/.rules-validation-$(date +%Y%m%d).md"

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

# 验证结果
CHECKS_PASSED=0
CHECKS_FAILED=0
ISSUES=()

record_issue() {
    local issue=$1
    ISSUES+=("$issue")
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
    print_error "$issue"
}

record_pass() {
    local check=$1
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "$check"
}

# 检查文件存在性
check_file_exists() {
    print_info "检查规则文件存在性..."

    if [ -f "$RULES_FILE" ]; then
        record_pass "规则文件存在"
    else
        record_issue "规则文件不存在"
        exit 1
    fi
}

# 检查版本号一致性
check_version_consistency() {
    print_info "检查版本号一致性..."

    local versions=$(grep -o "Activity-Tracker-Rules-v[0-9]\+\.[0-9]\+\.[0-9]\+" "$RULES_FILE" | sort -u)
    local version_count=$(echo "$versions" | wc -l | tr -d ' ')

    if [ "$version_count" -eq 1 ]; then
        record_pass "版本号一致"
    else
        record_issue "发现多个版本号：\n$versions"
    fi
}

# 检查脚本路径
check_script_paths() {
    print_info "检查脚本路径..."

    # 提取所有脚本路径
    local script_paths=$(grep -o "scripts/[a-z-]\+\.sh" "$RULES_FILE" | sort -u)

    local missing=0
    while IFS= read -r script; do
        if [ -f "$PROJECT_ROOT/$script" ]; then
            : # 文件存在
        else
            print_warning "脚本不存在：$script"
            missing=$((missing + 1))
        fi
    done <<< "$script_paths"

    if [ $missing -eq 0 ]; then
        record_pass "所有脚本路径有效"
    else
        record_issue "发现 $missing 个无效脚本路径"
    fi
}

# 检查文档链接
check_doc_links() {
    print_info "检查文档链接..."

    # 提取所有文档路径
    local doc_paths=$(grep -o "docs/[a-zA-Z/_-]\+\.md" "$RULES_FILE" | sort -u)

    local missing=0
    while IFS= read -r doc; do
        if [ -f "$PROJECT_ROOT/$doc" ]; then
            : # 文件存在
        else
            print_warning "文档不存在：$doc"
            missing=$((missing + 1))
        fi
    done <<< "$doc_paths"

    if [ $missing -eq 0 ]; then
        record_pass "所有文档链接有效"
    else
        record_issue "发现 $missing 个无效文档链接"
    fi
}

# 检查规则冲突
check_rule_conflicts() {
    print_info "检查规则冲突..."

    # 检查是否有矛盾的规则
    # 例如：既说"必须"又说"可选"

    local conflicts=0

    # 简单检查：同一概念的不同说法
    if grep -q "必须.*沙盒" "$RULES_FILE" && grep -q "可选.*沙盒" "$RULES_FILE"; then
        print_warning "发现沙盒相关规则冲突"
        conflicts=$((conflicts + 1))
    fi

    if [ $conflicts -eq 0 ]; then
        record_pass "无明显规则冲突"
    else
        record_issue "发现 $conflicts 个可能的规则冲突"
    fi
}

# 检查规则完整性
check_completeness() {
    print_info "检查规则完整性..."

    # 检查必须包含的章节
    local required_sections=(
        "元规则"
        "检查点"
        "PWA功能集成"
        "新功能开发"
        "代码设计规范"
        "自动化.*验证"
    )

    local missing=0
    for section in "${required_sections[@]}"; do
        if ! grep -q "$section" "$RULES_FILE"; then
            print_warning "缺少章节：$section"
            missing=$((missing + 1))
        fi
    done

    if [ $missing -eq 0 ]; then
        record_pass "规则完整性检查通过"
    else
        record_issue "缺少 $missing 个必要章节"
    fi
}

# 检查PWA集成规则
check_pwa_integration_rules() {
    print_info "检查PWA集成规则..."

    local pwa_checks=0
    local pwa_issues=0

    # 检查是否包含PWA检查点
    if grep -q "PWA功能集成.*CRITICAL" "$RULES_FILE"; then
        ((pwa_checks++))
        print_success "  PWA检查点存在"
    else
        ((pwa_issues++))
        print_warning "  缺少PWA检查点"
    fi

    # 检查PWA文件清单
    local pwa_files=(
        "service-worker\.js"
        "pwa-register\.js"
        "manifest\.json"
        "offline\.html"
    )

    for file in "${pwa_files[@]}"; do
        if grep -q "$file" "$RULES_FILE"; then
            ((pwa_checks++))
        else
            ((pwa_issues++))
            print_warning "  缺少PWA文件：$file"
        fi
    done

    if [ $pwa_issues -eq 0 ]; then
        record_pass "PWA集成规则完整"
    else
        record_issue "PWA集成规则缺少 $pwa_issues 项"
    fi
}

# 检查Markdown语法
check_markdown_syntax() {
    print_info "检查Markdown语法..."

    # 检查代码块是否闭合
    local code_block_start=$(grep -c "^\`\`\`" "$RULES_FILE")

    if [ $((code_block_start % 2)) -eq 0 ]; then
        record_pass "代码块标记闭合"
    else
        record_issue "代码块标记未闭合（奇数个\`\`\`）"
    fi
}

# 运行所有验证
run_validation() {
    print_header "🔍 规则有效性验证"

    check_file_exists
    check_version_consistency
    check_script_paths
    check_doc_links
    check_rule_conflicts
    check_completeness
    check_pwa_integration_rules
    check_markdown_syntax

    # 显示结果
    print_header "📊 验证结果"

    local total=$((CHECKS_PASSED + CHECKS_FAILED))
    local score=$(( CHECKS_PASSED * 100 / total ))

    echo "  通过检查：$CHECKS_PASSED / $total"
    echo "  质量得分：${score}分"
    echo ""

    if [ $CHECKS_FAILED -eq 0 ]; then
        print_success "═══════════════════════════════════════"
        print_success "规则文件验证通过！"
        print_success "═══════════════════════════════════════"
    else
        print_warning "═══════════════════════════════════════"
        print_warning "发现 $CHECKS_FAILED 个问题"
        print_warning "═══════════════════════════════════════"
        echo ""
        print_info "问题列表："
        for issue in "${ISSUES[@]}"; do
            echo "  • $issue"
        done
    fi

    # 生成报告
    generate_validation_report "$total" "$score"

    return $CHECKS_FAILED
}

# 生成验证报告
generate_validation_report() {
    local total=$1
    local score=$2

    cat > "$VALIDATION_REPORT" << EOF
# 🔍 规则有效性验证报告

## 📅 验证时间
$(date '+%Y年%m月%d日 %H:%M:%S')

## 📊 验证结果

**质量得分：${score}/100**

| 指标 | 结果 |
|------|------|
| 通过检查 | $CHECKS_PASSED |
| 失败检查 | $CHECKS_FAILED |
| 总检查数 | $total |

## 📋 检查项

1. ✅ 文件存在性
2. $([ $CHECKS_FAILED -eq 0 ] && echo "✅" || echo "⚠️") 版本号一致性
3. $([ $CHECKS_FAILED -eq 0 ] && echo "✅" || echo "⚠️") 脚本路径有效性
4. $([ $CHECKS_FAILED -eq 0 ] && echo "✅" || echo "⚠️") 文档链接有效性
5. $([ $CHECKS_FAILED -eq 0 ] && echo "✅" || echo "⚠️") 规则冲突检查
6. $([ $CHECKS_FAILED -eq 0 ] && echo "✅" || echo "⚠️") 规则完整性
7. $([ $CHECKS_FAILED -eq 0 ] && echo "✅" || echo "⚠️") Markdown语法

## ❌ 发现的问题

EOF

    if [ ${#ISSUES[@]} -eq 0 ]; then
        echo "✅ 无问题" >> "$VALIDATION_REPORT"
    else
        for issue in "${ISSUES[@]}"; do
            echo "- $issue" >> "$VALIDATION_REPORT"
        done
    fi

    cat >> "$VALIDATION_REPORT" << 'EOF'

## 💡 建议

EOF

    if [ $CHECKS_FAILED -eq 0 ]; then
        echo "✅ 规则文件质量良好，继续保持" >> "$VALIDATION_REPORT"
    else
        cat >> "$VALIDATION_REPORT" << 'EOF'
建议措施：
1. 修复发现的问题
2. 统一版本号
3. 检查并修复无效链接
4. 解决规则冲突
5. 补充缺失章节
EOF
    fi

    echo "" >> "$VALIDATION_REPORT"
    echo "---" >> "$VALIDATION_REPORT"
    echo "报告位置：$VALIDATION_REPORT" >> "$VALIDATION_REPORT"

    print_info "验证报告已生成：$VALIDATION_REPORT"
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}规则有效性验证系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {check|report|help}"
    echo ""
    echo "命令："
    echo "  check   - 运行规则验证"
    echo "  report  - 查看最新报告"
    echo "  help    - 显示帮助"
    echo ""
    echo "验证项："
    echo "  • 文件存在性"
    echo "  • 版本号一致性"
    echo "  • 脚本路径有效性"
    echo "  • 文档链接有效性"
    echo "  • 规则冲突检查"
    echo "  • 规则完整性"
    echo "  • Markdown语法"
    echo ""
}

# 主函数
main() {
    case "${1:-check}" in
        check)
            run_validation
            ;;
        report)
            if ls "$PROJECT_ROOT"/.rules-validation-*.md 1> /dev/null 2>&1; then
                cat $(ls -t "$PROJECT_ROOT"/.rules-validation-*.md | head -1)
            else
                print_warning "没有验证报告"
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


