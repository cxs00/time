#!/bin/bash
# 版本清理脚本 - 重置版本号到合理范围

echo "🧹 版本清理开始..."
echo "================================="

# 获取当前版本
current_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "当前版本: $current_version"

# 计算合理的版本号
# 基于项目实际开发进度，建议设置为 v1.5.0
target_version="v1.5.0"

echo "目标版本: $target_version"

# 创建新的版本标签
echo "🏷️ 创建新版本标签: $target_version"
git tag -a $target_version -m "版本清理: 重置到合理版本号 $target_version"

# 删除过高的版本标签（可选，谨慎操作）
echo "⚠️ 注意: 以下版本标签将被删除（仅本地）:"
git tag --sort=-version:refname | grep -E "v1\.(1[0-9][0-9]|[2-9][0-9]|[0-9]{3,})" | head -10

read -p "是否删除过高的版本标签？(y/N): " confirm
if [[ $confirm == [yY] ]]; then
    echo "🗑️ 删除过高的版本标签..."
    git tag --sort=-version:refname | grep -E "v1\.(1[0-9][0-9]|[2-9][0-9]|[0-9]{3,})" | xargs -I {} git tag -d {}
    echo "✅ 版本标签清理完成"
else
    echo "ℹ️ 跳过版本标签删除"
fi

echo "📊 版本统计:"
echo "总标签数: $(git tag | wc -l)"
echo "最新版本: $(git describe --tags --abbrev=0)"

echo "✅ 版本清理完成！"
echo "💡 建议: 今后只在重要里程碑时手动创建版本标签"
