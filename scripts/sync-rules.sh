#!/bin/bash

# ==================== 规则文件同步脚本 ====================
# 功能：自动同步本地和云端的.cursorrules和RULES_INDEX.md文件
# 版本：v1.1.0
# 日期：2025-10-27
# 更新：添加RULES_INDEX.md同步支持
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 项目根目录
PROJECT_ROOT="/Users/shanwanjun/Desktop/cxs/time"

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
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

# 检查云端更新并拉取
sync_rules_from_remote() {
    print_header "📥 检查云端规则更新"

    cd "$PROJECT_ROOT"

    # 获取远程更新
    print_info "获取远程更新..."
    git fetch origin

    # 检查.cursorrules是否有远程更新
    local remote_hash=$(git rev-parse origin/main:.cursorrules 2>/dev/null)
    local local_hash=$(git rev-parse HEAD:.cursorrules 2>/dev/null)

    if [ "$remote_hash" = "$local_hash" ]; then
        print_success "规则已是最新版本"
        return 0
    fi

    print_warning "发现云端规则更新"

    # 检查本地是否有未提交的修改
    if git diff --quiet .cursorrules; then
        # 本地无修改，直接拉取
        print_info "本地无修改，自动拉取云端规则..."
        git pull origin main
        print_success "规则已更新到最新版本"
    else
        # 本地有修改，提示用户
        print_warning "本地规则有未提交的修改"
        echo ""
        echo "选择操作："
        echo "  1) 暂存本地修改，拉取云端，然后恢复（推荐）"
        echo "  2) 放弃本地修改，使用云端版本"
        echo "  3) 保留本地修改，跳过同步"
        echo ""
        read -p "请选择 [1-3]: " choice

        case $choice in
            1)
                print_info "暂存本地修改..."
                git stash push -m "Auto-stash before sync $(date +%Y%m%d-%H%M%S)" .cursorrules

                print_info "拉取云端规则..."
                git pull origin main

                print_info "恢复本地修改..."
                if git stash pop; then
                    print_success "已合并云端更新和本地修改"
                else
                    print_error "合并失败，请手动解决冲突"
                    return 1
                fi
                ;;
            2)
                print_info "使用云端规则..."
                git checkout origin/main -- .cursorrules
                print_success "已使用云端规则（本地修改已丢弃）"
                ;;
            3)
                print_info "跳过同步，保留本地修改"
                ;;
            *)
                print_error "无效选择"
                return 1
                ;;
        esac
    fi
}

# 推送本地规则到云端
push_rules_to_remote() {
    print_header "📤 推送规则到云端"

    cd "$PROJECT_ROOT"

    # 检查.cursorrules是否有修改
    if git diff --quiet .cursorrules && git diff --cached --quiet .cursorrules; then
        print_info "规则文件无修改，无需推送"
        return 0
    fi

    print_warning "检测到规则文件修改"

    # 显示修改内容
    echo ""
    print_info "修改摘要："
    git diff --stat .cursorrules || git diff --cached --stat .cursorrules
    echo ""

    # 获取当前规则版本
    local current_version=$(grep "规则版本：Activity-Tracker-Rules-" .cursorrules | head -1 | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+")
    if [ -z "$current_version" ]; then
        current_version="unknown"
    fi

    print_info "当前规则版本：$current_version"
    echo ""

    # 询问提交说明
    read -p "输入提交说明（回车使用默认）: " commit_msg

    if [ -z "$commit_msg" ]; then
        commit_msg="feat: 更新规则文件 $current_version"
    fi

    # 提交规则
    print_info "提交规则文件..."
    git add .cursorrules
    git commit -m "$commit_msg"

    # 推送到云端
    print_info "推送到云端..."
    if git push origin main; then
        print_success "规则已同步到云端"

        # 询问是否打Tag
        echo ""
        read -p "是否为此规则版本打Tag? (y/N): " tag_choice
        if [ "$tag_choice" = "y" ] || [ "$tag_choice" = "Y" ]; then
            local tag_name="Activity-Tracker-Rules-$current_version"
            print_info "创建Tag: $tag_name"
            git tag -a "$tag_name" -m "规则系统 $current_version"
            git push origin "$tag_name"
            print_success "Tag已推送"
        fi
    else
        print_error "推送失败，请检查网络或权限"
        return 1
    fi
}

# 查看同步状态
check_rules_sync_status() {
    print_header "📊 规则同步状态"

    cd "$PROJECT_ROOT"

    # 本地版本
    local local_version=$(grep "规则版本：Activity-Tracker-Rules-" .cursorrules | head -1 | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+")
    if [ -z "$local_version" ]; then
        local_version="unknown"
    fi
    echo "本地规则版本：$local_version"

    # 最后提交时间
    local last_commit=$(git log -1 --format="%ci" -- .cursorrules 2>/dev/null || echo "无提交记录")
    echo "最后修改时间：$last_commit"
    echo ""

    # 是否有未推送的提交
    git fetch origin 2>/dev/null
    local unpushed=$(git log origin/main..HEAD --oneline -- .cursorrules 2>/dev/null | wc -l | tr -d ' ')
    if [ "$unpushed" -gt 0 ]; then
        print_warning "有 $unpushed 个未推送的规则提交"
    else
        print_success "所有规则修改已推送"
    fi

    # 是否有未拉取的提交
    local unpulled=$(git log HEAD..origin/main --oneline -- .cursorrules 2>/dev/null | wc -l | tr -d ' ')
    if [ "$unpulled" -gt 0 ]; then
        print_warning "云端有 $unpulled 个新的规则提交"
    else
        print_success "已同步所有云端更新"
    fi

    # 是否有未提交的修改
    if ! git diff --quiet .cursorrules; then
        print_warning "有未提交的规则修改"
    else
        print_success "无未提交的修改"
    fi

    echo ""
}

# 解决规则冲突
resolve_rules_conflict() {
    print_header "🔔 解决规则冲突"

    cd "$PROJECT_ROOT"

    # 显示冲突信息
    echo "本地修改："
    git diff HEAD .cursorrules | head -20
    echo ""
    echo "云端修改："
    git diff HEAD origin/main -- .cursorrules | head -20
    echo ""

    # 提供解决方案
    echo "解决方案："
    echo "  1) 合并两者（推荐）- 保留双方的修改"
    echo "  2) 使用本地版本 - 覆盖云端"
    echo "  3) 使用云端版本 - 放弃本地"
    echo "  4) 手动解决 - 打开编辑器"
    echo ""
    read -p "请选择 [1-4]: " choice

    case $choice in
        1)
            # 尝试自动合并
            print_info "尝试自动合并..."
            if git merge origin/main; then
                print_success "自动合并成功"
                git push origin main
            else
                print_error "自动合并失败，需要手动解决"
                echo ""
                echo "请编辑 .cursorrules 解决冲突，然后运行："
                echo "  git add .cursorrules"
                echo "  git commit -m 'merge: 解决规则冲突'"
                echo "  git push origin main"
            fi
            ;;
        2)
            # 使用本地版本
            print_warning "强制推送本地版本..."
            read -p "确认要覆盖云端？(yes/NO): " confirm
            if [ "$confirm" = "yes" ]; then
                git push origin main --force
                print_success "已强制推送本地版本（云端修改已丢失）"
            else
                print_info "已取消操作"
            fi
            ;;
        3)
            # 使用云端版本
            print_warning "使用云端版本..."
            read -p "确认要放弃本地修改？(yes/NO): " confirm
            if [ "$confirm" = "yes" ]; then
                git reset --hard origin/main
                print_success "已使用云端版本（本地修改已丢失）"
            else
                print_info "已取消操作"
            fi
            ;;
        4)
            # 手动解决
            print_info "打开编辑器..."
            ${EDITOR:-vim} .cursorrules
            echo ""
            print_info "请解决冲突后手动提交和推送"
            ;;
        *)
            print_error "无效选择"
            return 1
            ;;
    esac
}

# 主菜单
main() {
    print_header "🔄 规则文件同步工具 v1.0.0"

    echo "请选择操作："
    echo "  1) 检查同步状态"
    echo "  2) 从云端拉取规则"
    echo "  3) 推送规则到云端"
    echo "  4) 解决规则冲突"
    echo "  5) 完整同步（拉取+推送）"
    echo "  0) 退出"
    echo ""
    read -p "请选择 [0-5]: " choice

    case $choice in
        1)
            check_rules_sync_status
            ;;
        2)
            sync_rules_from_remote
            ;;
        3)
            push_rules_to_remote
            ;;
        4)
            resolve_rules_conflict
            ;;
        5)
            sync_rules_from_remote
            echo ""
            push_rules_to_remote
            ;;
        0)
            print_info "再见！"
            exit 0
            ;;
        *)
            print_error "无效选择"
            exit 1
            ;;
    esac
}

# 执行主函数
main

