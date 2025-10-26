#!/bin/bash

# ==================== 智能回退系统 ====================
# 功能：回退到指定快照，保留当前修改
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/rollback-to-snapshot.sh <快照名称> [--auto]
# ===================================================

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
SNAPSHOT_TAG=$1
AUTO_MODE=${2:-""}  # --auto 表示自动模式，不询问

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

# 列出快照
list_snapshots() {
    cd "$PROJECT_ROOT"
    
    echo -e "${BLUE}📋 可用快照：${NC}"
    echo ""
    
    local snapshots=$(git tag -l "snapshot-*" --sort=-creatordate | head -10)
    
    if [ -z "$snapshots" ]; then
        print_warning "没有可用的快照"
        echo ""
        print_info "创建快照: ./scripts/auto-snapshot.sh create"
        return
    fi
    
    local count=1
    while IFS= read -r tag; do
        local tag_date=$(git log -1 --format=%ai "$tag" 2>/dev/null | cut -d' ' -f1,2)
        echo -e "${CYAN}$count.${NC} $tag (${tag_date})"
        count=$((count + 1))
    done <<< "$snapshots"
    
    echo ""
}

# 验证快照
validate_snapshot() {
    local snapshot=$1
    
    cd "$PROJECT_ROOT"
    
    if ! git tag -l | grep -q "^${snapshot}$"; then
        print_error "快照不存在: $snapshot"
        echo ""
        list_snapshots
        return 1
    fi
    
    return 0
}

# 显示回退预览
show_rollback_preview() {
    local snapshot=$1
    
    cd "$PROJECT_ROOT"
    
    echo -e "${BLUE}📊 回退预览${NC}"
    echo ""
    
    # 显示快照信息
    local tag_date=$(git log -1 --format=%ai "$snapshot" 2>/dev/null)
    local tag_msg=$(git log -1 --format=%s "$snapshot" 2>/dev/null)
    
    echo "快照信息："
    echo "  名称: $snapshot"
    echo "  时间: $tag_date"
    echo "  说明: $tag_msg"
    echo ""
    
    # 显示当前未提交的修改
    if ! git diff --quiet || ! git diff --cached --quiet; then
        print_warning "当前有未提交的修改："
        echo ""
        git status --short | head -10
        echo ""
    else
        print_info "当前没有未提交的修改"
        echo ""
    fi
    
    # 显示回退将产生的变化
    local changes=$(git diff --stat HEAD "$snapshot" | wc -l | tr -d ' ')
    
    if [ "$changes" -gt 0 ]; then
        print_warning "回退将改变 $changes 个文件："
        echo ""
        git diff --stat HEAD "$snapshot" | head -10
        echo ""
    else
        print_info "当前状态与快照一致"
        echo ""
    fi
}

# 执行回退
rollback_to_snapshot() {
    local snapshot=$1
    
    cd "$PROJECT_ROOT"
    
    if [ -z "$snapshot" ]; then
        print_error "请指定快照标签"
        echo ""
        list_snapshots
        exit 1
    fi
    
    # 验证快照存在
    if ! validate_snapshot "$snapshot"; then
        exit 1
    fi
    
    echo -e "${BLUE}🔄 准备回退到: $snapshot${NC}"
    echo ""
    
    # 显示预览
    show_rollback_preview "$snapshot"
    
    # 非自动模式需要确认
    if [ "$AUTO_MODE" != "--auto" ]; then
        print_warning "═══════════════════════════════════════"
        print_warning "即将执行以下操作："
        echo "  1. 保存当前所有修改到git stash"
        echo "  2. 回退代码到快照状态"
        echo "  3. 保留stash供以后恢复"
        print_warning "═══════════════════════════════════════"
        echo ""
        read -p "确认继续? (yes/NO): " confirm
        
        if [ "$confirm" != "yes" ]; then
            print_info "已取消回退"
            exit 0
        fi
        echo ""
    fi
    
    # 1. 保存当前状态
    print_info "💾 保存当前状态..."
    
    local stash_msg="Before rollback to $snapshot ($(date '+%Y-%m-%d %H:%M:%S'))"
    
    # 保存所有修改（包括未跟踪的文件）
    git add -A
    if git stash push -m "$stash_msg"; then
        print_success "当前状态已保存到stash"
    else
        print_info "没有需要保存的修改"
    fi
    
    echo ""
    
    # 2. 回退到快照
    print_info "⏪ 回退代码到快照..."
    
    if git reset --hard "$snapshot"; then
        print_success "代码已回退"
    else
        print_error "回退失败"
        exit 1
    fi
    
    echo ""
    
    # 3. 显示结果
    print_success "═══════════════════════════════════════"
    print_success "回退完成！"
    print_success "═══════════════════════════════════════"
    echo ""
    
    print_info "📋 当前状态："
    echo "  • 代码已回退到: $snapshot"
    echo "  • 原修改已保存到stash"
    echo "  • Stash消息: $stash_msg"
    echo ""
    
    print_info "🔄 恢复命令（如需要）："
    echo "  git stash list          # 查看所有stash"
    echo "  git stash show          # 查看最近的stash"
    echo "  git stash apply         # 恢复最近的stash（保留stash）"
    echo "  git stash pop           # 恢复并删除stash"
    echo ""
    
    print_info "📸 继续开发建议："
    echo "  1. 验证当前代码是否正常"
    echo "  2. 如需恢复修改: git stash apply"
    echo "  3. 修复问题后创建新快照: ./scripts/auto-snapshot.sh create"
    echo ""
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}智能回退系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 <快照名称> [选项]"
    echo ""
    echo "选项："
    echo "  --auto      自动模式，不询问确认"
    echo "  list        列出可用快照"
    echo "  help        显示此帮助信息"
    echo ""
    echo "示例："
    echo "  $0 list                              # 查看快照"
    echo "  $0 snapshot-20251026-143000          # 回退到指定快照"
    echo "  $0 snapshot-20251026-143000 --auto   # 自动回退（无确认）"
    echo ""
    echo "恢复修改："
    echo "  git stash list                       # 查看保存的修改"
    echo "  git stash apply                      # 恢复修改"
    echo ""
}

# 主函数
main() {
    if [ "$1" = "list" ]; then
        list_snapshots
    elif [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ -z "$1" ]; then
        show_help
    else
        rollback_to_snapshot "$SNAPSHOT_TAG"
    fi
}

# 执行主函数
main

