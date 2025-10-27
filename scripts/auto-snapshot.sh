#!/bin/bash

# ==================== 自动快照系统 ====================
# 功能：在每次修改前自动创建Git快照
# 版本：v1.0.0
# 日期：2025-10-26
# 用法：./scripts/auto-snapshot.sh {create|list|clean}
# ====================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 配置
SNAPSHOT_PREFIX="snapshot"
MAX_SNAPSHOTS=20  # 最多保留20个快照
PROJECT_ROOT="/Users/shanwanjun/Desktop/cxs/time"

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

# 创建快照
create_snapshot() {
    cd "$PROJECT_ROOT"

    local timestamp=$(date +%Y%m%d-%H%M%S)
    local snapshot_tag="${SNAPSHOT_PREFIX}-${timestamp}"

    echo -e "${BLUE}📸 创建快照: $snapshot_tag${NC}"
    echo ""

    # 检查是否有未保存的修改
    if git diff --quiet && git diff --cached --quiet; then
        print_info "没有未保存的修改，创建当前状态快照..."
    else
        print_warning "检测到未提交的修改"

        # 显示修改摘要
        echo ""
        print_info "修改摘要："
        git status --short
        echo ""
    fi

    # 1. 创建快照前先提交当前状态（如果有修改）
    if ! git diff --quiet || ! git diff --cached --quiet; then
        print_info "提交当前修改..."
        git add -A
        git commit -m "Auto-snapshot: $snapshot_tag" --no-verify 2>/dev/null || true
    fi

    # 2. 创建轻量级标签（快照）
    print_info "创建快照标签..."
    git tag "$snapshot_tag"

    # 3. 清理旧快照
    cleanup_old_snapshots

    print_success "快照创建成功！"
    echo ""
    print_info "快照标签: $snapshot_tag"
    print_info "回退命令: ./scripts/rollback-to-snapshot.sh $snapshot_tag"
    echo ""
}

# 清理旧快照
cleanup_old_snapshots() {
    local snapshots=$(git tag -l "${SNAPSHOT_PREFIX}-*" --sort=-creatordate)
    local count=0

    while IFS= read -r tag; do
        count=$((count + 1))
        if [ $count -gt $MAX_SNAPSHOTS ]; then
            print_info "删除旧快照: $tag"
            git tag -d "$tag" 2>/dev/null
        fi
    done <<< "$snapshots"

    if [ $count -gt $MAX_SNAPSHOTS ]; then
        print_success "已清理 $((count - MAX_SNAPSHOTS)) 个旧快照"
    fi
}

# 列出快照
list_snapshots() {
    cd "$PROJECT_ROOT"

    echo -e "${BLUE}📋 可用快照列表（最近10个）：${NC}"
    echo ""

    local snapshots=$(git tag -l "${SNAPSHOT_PREFIX}-*" --sort=-creatordate | head -10)

    if [ -z "$snapshots" ]; then
        print_warning "没有可用的快照"
        echo ""
        print_info "创建第一个快照: ./scripts/auto-snapshot.sh create"
        return
    fi

    local count=1
    while IFS= read -r tag; do
        # 获取快照的创建时间
        local tag_date=$(git log -1 --format=%ai "$tag" 2>/dev/null | cut -d' ' -f1,2)

        # 获取快照的提交信息
        local tag_msg=$(git log -1 --format=%s "$tag" 2>/dev/null)

        echo -e "${CYAN}$count.${NC} $tag"
        echo "   时间: $tag_date"
        echo "   说明: $tag_msg"
        echo ""

        count=$((count + 1))
    done <<< "$snapshots"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    print_info "回退到快照: ./scripts/rollback-to-snapshot.sh <快照名称>"
}

# 清理所有快照
clean_all_snapshots() {
    cd "$PROJECT_ROOT"

    local snapshots=$(git tag -l "${SNAPSHOT_PREFIX}-*")

    if [ -z "$snapshots" ]; then
        print_info "没有快照需要清理"
        return
    fi

    local count=$(echo "$snapshots" | wc -l | tr -d ' ')

    print_warning "将删除 $count 个快照"
    echo ""
    read -p "确认删除所有快照? (yes/NO): " confirm

    if [ "$confirm" != "yes" ]; then
        print_info "已取消"
        return
    fi

    while IFS= read -r tag; do
        git tag -d "$tag" 2>/dev/null
    done <<< "$snapshots"

    print_success "已删除 $count 个快照"
}

# 显示帮助
show_help() {
    echo ""
    echo -e "${BLUE}自动快照系统 v1.0.0${NC}"
    echo ""
    echo "用法: $0 {create|list|clean|help}"
    echo ""
    echo "命令："
    echo "  create  - 创建新快照"
    echo "  list    - 列出可用快照"
    echo "  clean   - 清理所有快照"
    echo "  help    - 显示此帮助信息"
    echo ""
    echo "示例："
    echo "  $0 create          # 创建快照"
    echo "  $0 list            # 查看快照列表"
    echo ""
}

# 主函数
main() {
    case "${1:-help}" in
        create)
            create_snapshot
            ;;
        list)
            list_snapshots
            ;;
        clean)
            clean_all_snapshots
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

