#!/bin/bash
# TIME版本完整备份脚本

VERSION=$1
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/Users/shanwanjun/Desktop/TIME-History"

if [ -z "$VERSION" ]; then
    echo "❌ 请指定版本号"
    echo "用法: ./backup-version.sh v1.0.0"
    exit 1
fi

echo "💾 创建版本 $VERSION 的完整备份..."

# 创建备份目录
mkdir -p "$BACKUP_DIR/$VERSION"

# 获取项目根目录
PROJECT_ROOT="/Users/shanwanjun/Desktop/cxs/time"

# 完整项目备份
echo "📦 正在压缩项目文件..."
cd /Users/shanwanjun/Desktop/cxs
tar -czf "$BACKUP_DIR/$VERSION/time-$VERSION-$DATE.tar.gz" time/

# 创建版本信息文件
cat > "$BACKUP_DIR/$VERSION/version-info.txt" << EOF
TIME版本备份信息
================

版本号: $VERSION
创建时间: $(date '+%Y-%m-%d %H:%M:%S')
Git提交: $(cd $PROJECT_ROOT && git rev-parse HEAD)
Git短提交: $(cd $PROJECT_ROOT && git rev-parse --short HEAD)
项目大小: $(du -sh $PROJECT_ROOT | cut -f1)
备份大小: $(du -sh "$BACKUP_DIR/$VERSION/time-$VERSION-$DATE.tar.gz" | cut -f1)

功能特性:
- 基础计时功能
- 统计分析页面
- iOS/macOS原生应用
- Web版本支持
- 响应式设计

技术栈:
- HTML5/CSS3/JavaScript
- SwiftUI (iOS/macOS)
- ECharts (数据可视化)
- LocalStorage (数据存储)

备份文件:
- time-$VERSION-$DATE.tar.gz (完整项目)
- version-info.txt (版本信息)

恢复方法:
1. 解压: tar -xzf time-$VERSION-$DATE.tar.gz
2. 进入: cd time
3. 检查: git status
EOF

# 复制重要文件到备份目录
cp "$PROJECT_ROOT/README.md" "$BACKUP_DIR/$VERSION/" 2>/dev/null || true
cp "$PROJECT_ROOT/CHANGELOG.md" "$BACKUP_DIR/$VERSION/" 2>/dev/null || true

echo "✅ 版本 $VERSION 备份完成！"
echo "📁 备份位置: $BACKUP_DIR/$VERSION/"
echo "📊 备份大小: $(du -sh "$BACKUP_DIR/$VERSION" | cut -f1)"
echo ""
echo "🔄 恢复方法:"
echo "  cd /Users/shanwanjun/Desktop/cxs"
echo "  rm -rf time"
echo "  tar -xzf $BACKUP_DIR/$VERSION/time-$VERSION-$DATE.tar.gz"
