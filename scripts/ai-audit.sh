#!/bin/bash

# ==================== AI行为审计系统 ====================
# 功能：记录和验证AI是否遵守规则
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/ai-audit.sh {log|verify|report|clear}
# ======================================================

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
AUDIT_LOG="$PROJECT_ROOT/.ai-audit.log"
AUDIT_DB="$PROJECT_ROOT/.ai-audit.json"

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

# 记录AI操作
log_action() {
    local checkpoint=$1
    local action=$2
    local rule_ref=$3
    local status=$4

    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # 记录到文本日志
    echo "[$timestamp] [$checkpoint] $action | 规则:$rule_ref | 状态:$status" >> "$AUDIT_LOG"

    # 记录到JSON数据库
    local entry=$(cat <<EOF
{
  "timestamp": "$timestamp",
  "checkpoint": "$checkpoint",
  "action": "$action",
  "rule_reference": "$rule_ref",
  "status": "$status"
}
EOF
)

    # 追加到JSON数组
    if [ ! -f "$AUDIT_DB" ]; then
        echo "[]" > "$AUDIT_DB"
    fi

    # 简单追加（实际应该用jq，但这里保持简单）
    print_info "记录：$checkpoint - $action - $status"
}

# 验证检查点执行
verify_checkpoints() {
    print_header "🔍 验证AI检查点执行情况"

    if [ ! -f "$AUDIT_LOG" ]; then
        print_warning "没有审计日志"
        print_info "AI尚未记录任何操作"
        return
    fi

    # 检查今天的记录
    local today=$(date '+%Y-%m-%d')
    local today_logs=$(grep "$today" "$AUDIT_LOG")

    if [ -z "$today_logs" ]; then
        print_warning "今天没有AI操作记录"
        return
    fi

    echo -e "${CYAN}今天的AI操作记录：${NC}"
    echo ""

    # 统计各检查点执行情况
    local cp0_count=$(echo "$today_logs" | grep -c "检查点0" || echo "0")
    local cp1_count=$(echo "$today_logs" | grep -c "检查点1" || echo "0")
    local cp2_count=$(echo "$today_logs" | grep -c "检查点2" || echo "0")
    local cp3_count=$(echo "$today_logs" | grep -c "检查点3" || echo "0")

    echo "检查点执行统计："
    echo "  检查点0（搜索规则）: $cp0_count 次"
    echo "  检查点1（全局分析）: $cp1_count 次"
    echo "  检查点2（沙盒验证）: $cp2_count 次"
    echo "  检查点3（最终验证）: $cp3_count 次"
    echo ""

    # 检查违规
    local violations=$(echo "$today_logs" | grep "状态:失败\|状态:跳过" || echo "")

    if [ -n "$violations" ]; then
        print_error "发现违规操作："
        echo "$violations"
        echo ""
    else
        print_success "所有检查点都正确执行"
    fi

    # 检查完整性
    if [ $cp0_count -eq 0 ]; then
        print_warning "检查点0未执行（AI可能未搜索规则）"
    fi

    if [ $cp2_count -eq 0 ]; then
        print_warning "检查点2未执行（AI可能未进行沙盒验证）"
    fi
}

# 生成审计报告
generate_report() {
    print_header "📊 生成AI行为审计报告"

    if [ ! -f "$AUDIT_LOG" ]; then
        print_warning "没有审计数据"
        return
    fi

    local report_file="$PROJECT_ROOT/.ai-audit-report-$(date +%Y%m%d).md"

    cat > "$report_file" << 'EOF'
# 🔍 AI行为审计报告

## 📅 报告日期
EOF

    echo "$(date '+%Y年%m月%d日')" >> "$report_file"

    cat >> "$report_file" << 'EOF'

## 📊 执行统计

### 检查点执行情况
EOF

    # 统计各检查点
    local cp0=$(grep -c "检查点0" "$AUDIT_LOG" || echo "0")
    local cp1=$(grep -c "检查点1" "$AUDIT_LOG" || echo "0")
    local cp2=$(grep -c "检查点2" "$AUDIT_LOG" || echo "0")
    local cp3=$(grep -c "检查点3" "$AUDIT_LOG" || echo "0")

    cat >> "$report_file" << EOF

| 检查点 | 执行次数 | 状态 |
|--------|---------|------|
| 检查点0（搜索规则） | $cp0 | $([ $cp0 -gt 0 ] && echo "✅" || echo "⚠️") |
| 检查点1（全局分析） | $cp1 | $([ $cp1 -gt 0 ] && echo "✅" || echo "⚠️") |
| 检查点2（沙盒验证） | $cp2 | $([ $cp2 -gt 0 ] && echo "✅" || echo "⚠️") |
| 检查点3（最终验证） | $cp3 | $([ $cp3 -gt 0 ] && echo "✅" || echo "⚠️") |

### 合规性分析

EOF

    # 检查违规
    local violations=$(grep -c "状态:失败\|状态:跳过" "$AUDIT_LOG" || echo "0")
    local total=$(wc -l < "$AUDIT_LOG")
    local compliance=$(( (total - violations) * 100 / total ))

    cat >> "$report_file" << EOF
- 总操作数：$total
- 违规操作：$violations
- 合规率：${compliance}%

### 违规记录

EOF

    if [ "$violations" -gt 0 ]; then
        echo '```' >> "$report_file"
        grep "状态:失败\|状态:跳过" "$AUDIT_LOG" >> "$report_file"
        echo '```' >> "$report_file"
    else
        echo "✅ 无违规记录" >> "$report_file"
    fi

    cat >> "$report_file" << 'EOF'

## 📋 详细日志

最近20条操作：

```
EOF

    tail -20 "$AUDIT_LOG" >> "$report_file"

    cat >> "$report_file" << 'EOF'
```

## 💡 建议

EOF

    if [ "$violations" -gt 0 ]; then
        cat >> "$report_file" << 'EOF'
⚠️ **发现违规操作**

建议措施：
1. 检查AI是否正确理解规则
2. 更新规则使其更明确
3. 增加强制验证机制
4. 考虑增加技术约束

EOF
    else
        cat >> "$report_file" << 'EOF'
✅ **合规性良好**

继续保持：
1. 定期查看审计日志
2. 及时更新规则
3. 持续监控AI行为

EOF
    fi

    cat >> "$report_file" << EOF

---

报告生成时间：$(date '+%Y-%m-%d %H:%M:%S')
EOF

    print_success "报告已生成：$report_file"
    print_info "查看报告：cat $report_file"
}

# 查看最近日志
view_recent_logs() {
    print_header "📋 最近AI操作日志"

    if [ ! -f "$AUDIT_LOG" ]; then
        print_warning "没有审计日志"
        return
    fi

    echo -e "${CYAN}最近20条记录：${NC}"
    echo ""
    tail -20 "$AUDIT_LOG"
    echo ""
}

# 清理日志
clear_logs() {
    print_header "🗑️ 清理审计日志"

    if [ ! -f "$AUDIT_LOG" ]; then
        print_info "没有日志需要清理"
        return
    fi

    local log_size=$(wc -l < "$AUDIT_LOG")

    print_warning "将删除 $log_size 条审计记录"
    echo ""
    read -p "确认清理？(yes/NO): " confirm

    if [ "$confirm" = "yes" ]; then
        # 备份后清理
        cp "$AUDIT_LOG" "$AUDIT_LOG.backup-$(date +%Y%m%d)"
        rm -f "$AUDIT_LOG" "$AUDIT_DB"
        print_success "日志已清理（已备份）"
    else
        print_info "已取消"
    fi
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}AI行为审计系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {log|verify|report|view|clear|help}"
    echo ""
    echo "命令："
    echo "  log <检查点> <操作> <规则> <状态>  - 记录AI操作"
    echo "  verify                              - 验证检查点执行"
    echo "  report                              - 生成审计报告"
    echo "  view                                - 查看最近日志"
    echo "  clear                               - 清理审计日志"
    echo "  help                                - 显示帮助"
    echo ""
    echo "示例："
    echo "  $0 log '检查点0' '搜索规则' '.cursorrules:45' '成功'"
    echo "  $0 verify"
    echo "  $0 report"
    echo ""
}

# 主函数
main() {
    case "${1:-help}" in
        log)
            log_action "$2" "$3" "$4" "$5"
            ;;
        verify)
            verify_checkpoints
            ;;
        report)
            generate_report
            ;;
        view)
            view_recent_logs
            ;;
        clear)
            clear_logs
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


