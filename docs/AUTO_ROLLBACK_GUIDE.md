# 🔄 实时错误回退系统使用指南

## 📋 概述

实时错误回退系统是一个自动化的代码保护机制，能够在检测到编译错误、运行时错误或测试失败时，自动将代码回退到最近的稳定状态，同时保留您的所有修改，确保不会丢失任何工作成果。

### 核心特性

- ✅ **自动快照**：在关键时刻自动创建代码快照
- ✅ **实时监控**：持续监控编译和运行时错误
- ✅ **智能回退**：检测到错误自动回退到稳定状态
- ✅ **修改保护**：所有修改保存到git stash，可随时恢复
- ✅ **详细报告**：自动生成错误分析和修复建议

---

## 🚀 快速开始

### 1. 创建第一个快照

```bash
cd /Users/shanwanjun/Desktop/cxs/time
./scripts/auto-snapshot.sh create
```

### 2. 正常开发

```bash
# 修改代码...
# 测试功能...
```

### 3. 如果出错，手动回退

```bash
# 查看可用快照
./scripts/auto-snapshot.sh list

# 回退到指定快照
./scripts/rollback-to-snapshot.sh snapshot-20251026-143000
```

---

## 📖 详细使用

### 一、自动快照系统

#### 创建快照

```bash
./scripts/auto-snapshot.sh create
```

**创建时机**（建议）：
- ✅ 开始新功能前
- ✅ 重大功能完成后
- ✅ 测试通过后
- ✅ 每天工作结束前

#### 查看快照列表

```bash
./scripts/auto-snapshot.sh list
```

**输出示例**：
```
📋 可用快照列表（最近10个）：

1. snapshot-20251026-153000 (2025-10-26 15:30:00)
   说明: Auto-snapshot: snapshot-20251026-153000

2. snapshot-20251026-143000 (2025-10-26 14:30:00)
   说明: Auto-snapshot: snapshot-20251026-143000

...
```

#### 清理快照

```bash
./scripts/auto-snapshot.sh clean
```

**注意**：
- 系统自动保留最近20个快照
- 超过20个会自动删除最旧的
- `clean`命令会删除所有快照（需确认）

---

### 二、错误监控系统

#### 执行一次性检查

```bash
./scripts/error-monitor.sh check
```

**检查项目**：
- ✅ 编译错误（Mac版本）
- ✅ 运行时错误（应用崩溃、异常）

**输出示例**：
```
ℹ️  检查编译错误...
✅ 编译检查通过

ℹ️  检查运行时错误...
✅ 运行时检查通过

✅ 检查通过
```

#### 启动持续监控

```bash
./scripts/error-monitor.sh monitor &
```

**监控行为**：
- 每30秒检查一次
- 检测到错误立即触发回退
- 生成详细错误报告
- 回退后停止监控

**停止监控**：
```bash
./scripts/error-monitor.sh stop
```

---

### 三、智能回退系统

#### 查看可用快照

```bash
./scripts/rollback-to-snapshot.sh list
```

#### 回退到指定快照

```bash
./scripts/rollback-to-snapshot.sh snapshot-20251026-143000
```

**回退流程**：
1. 显示快照信息和回退预览
2. 询问确认
3. 保存当前修改到git stash
4. 回退代码到快照状态
5. 显示恢复命令

**输出示例**：
```
🔄 准备回退到: snapshot-20251026-143000

📊 回退预览

快照信息：
  名称: snapshot-20251026-143000
  时间: 2025-10-26 14:30:00 +0800
  说明: Auto-snapshot: snapshot-20251026-143000

⚠️  当前有未提交的修改：

 M js/app.js
 M css/style.css

⚠️  回退将改变 2 个文件：

 js/app.js    |  10 ++++------
 css/style.css|   5 +++--
 2 files changed, 7 insertions(+), 8 deletions(-)

⚠️  ═══════════════════════════════════════
⚠️  即将执行以下操作：
  1. 保存当前所有修改到git stash
  2. 回退代码到快照状态
  3. 保留stash供以后恢复
⚠️  ═══════════════════════════════════════

确认继续? (yes/NO): yes

ℹ️  💾 保存当前状态...
✅ 当前状态已保存到stash

ℹ️  ⏪ 回退代码到快照...
✅ 代码已回退

✅ ═══════════════════════════════════════
✅ 回退完成！
✅ ═══════════════════════════════════════

ℹ️  📋 当前状态：
  • 代码已回退到: snapshot-20251026-143000
  • 原修改已保存到stash
  • Stash消息: Before rollback to snapshot-20251026-143000 (2025-10-26 15:45:30)

ℹ️  🔄 恢复命令（如需要）：
  git stash list          # 查看所有stash
  git stash show          # 查看最近的stash
  git stash apply         # 恢复最近的stash（保留stash）
  git stash pop           # 恢复并删除stash
```

#### 自动回退（无确认）

```bash
./scripts/rollback-to-snapshot.sh snapshot-20251026-143000 --auto
```

**用途**：
- 错误监控系统自动触发
- 脚本自动化使用
- 不需要人工确认

---

### 四、恢复修改

#### 查看保存的修改

```bash
git stash list
```

**输出示例**：
```
stash@{0}: On main: Before rollback to snapshot-20251026-143000 (2025-10-26 15:45:30)
stash@{1}: On main: Before rollback to snapshot-20251026-120000 (2025-10-26 12:30:15)
```

#### 查看修改详情

```bash
git stash show stash@{0}
```

#### 恢复修改

```bash
# 恢复最近的修改（保留stash）
git stash apply

# 恢复指定的修改
git stash apply stash@{1}

# 恢复并删除stash
git stash pop

# 放弃stash
git stash drop stash@{0}
```

---

## 📝 使用场景

### 场景1：正常开发流程

```bash
# 1. 早上开始工作，创建快照
./scripts/auto-snapshot.sh create

# 2. 开发新功能
# ... 修改代码 ...

# 3. 功能完成，创建快照
./scripts/auto-snapshot.sh create

# 4. 继续下一个功能
# ... 修改代码 ...

# 5. 下班前创建快照
./scripts/auto-snapshot.sh create
```

### 场景2：启用实时监控

```bash
# 1. 启动后台监控
./scripts/error-monitor.sh monitor &

# 2. 正常开发
# ... 修改代码 ...

# 3. 如果引入错误，系统自动：
#    - 检测到错误
#    - 保存当前修改
#    - 回退到最近快照
#    - 生成错误报告
#    - 停止监控

# 4. 查看错误报告
cat .error-report-*.md

# 5. 修复问题后继续
./scripts/auto-snapshot.sh create
./scripts/error-monitor.sh monitor &
```

### 场景3：发现问题手动回退

```bash
# 1. 发现代码有问题
# ... 不确定哪里出错 ...

# 2. 查看可用快照
./scripts/auto-snapshot.sh list

# 3. 回退到之前的稳定版本
./scripts/rollback-to-snapshot.sh snapshot-20251026-120000

# 4. 验证代码是否正常
# ... 测试功能 ...

# 5. 如需恢复之前的修改
git stash list
git stash apply

# 6. 逐步重做修改
# ... 小心地重新修改 ...

# 7. 创建新快照
./scripts/auto-snapshot.sh create
```

### 场景4：实验性修改

```bash
# 1. 尝试新想法前创建快照
./scripts/auto-snapshot.sh create

# 2. 大胆实验
# ... 尝试新方法 ...

# 3. 如果不满意，直接回退
./scripts/rollback-to-snapshot.sh snapshot-20251026-143000

# 4. 如果满意，创建新快照
./scripts/auto-snapshot.sh create
```

---

## ⚙️ 配置选项

### 错误监控配置

编辑 `scripts/error-monitor.sh`：

```bash
# 监控间隔（秒）
MONITOR_INTERVAL=30

# 是否监控编译错误
MONITOR_COMPILE=true

# 是否监控运行时错误
MONITOR_RUNTIME=true

# 是否自动回退
AUTO_ROLLBACK=true
```

### 快照配置

编辑 `scripts/auto-snapshot.sh`：

```bash
# 最多保留快照数
MAX_SNAPSHOTS=20

# 快照标签前缀
SNAPSHOT_PREFIX="snapshot"
```

---

## 📊 错误报告

### 自动生成

当错误监控系统检测到错误并触发回退时，会自动生成错误报告。

**报告位置**：`.error-report-<timestamp>.md`

**报告内容**：
- 错误类型和时间
- 回退的快照信息
- 最近20条错误日志
- 回退前的文件状态
- 修复建议
- 恢复命令

### 查看报告

```bash
# 查看最新错误报告
ls -lt .error-report-*.md | head -1 | xargs cat

# 查看错误日志
tail -50 .error-monitor.log
```

---

## 🔒 安全保护

### 1. 修改永不丢失

- ✅ 所有修改都保存到git stash
- ✅ 可以随时恢复
- ✅ Stash有详细说明（时间、快照）

### 2. 快照自动管理

- ✅ 自动保留最近20个快照
- ✅ 超过数量自动删除最旧的
- ✅ 避免占用过多磁盘空间

### 3. 操作可撤销

- ✅ 回退操作完全可逆
- ✅ 通过git stash恢复
- ✅ Git历史完整保留

### 4. 确认机制

- ✅ 手动模式：需要确认
- ✅ 自动模式：直接执行
- ✅ 显示详细预览

---

## 🐛 故障排除

### 问题1：找不到快照

**症状**：
```
❌ 没有可用的快照
```

**解决**：
```bash
# 创建第一个快照
./scripts/auto-snapshot.sh create
```

### 问题2：监控无法启动

**症状**：
```
xcodebuild: command not found
```

**解决**：
```bash
# 安装Xcode Command Line Tools
xcode-select --install
```

### 问题3：回退失败

**症状**：
```
❌ 快照不存在
```

**解决**：
```bash
# 查看可用快照
./scripts/auto-snapshot.sh list

# 使用正确的快照名称
./scripts/rollback-to-snapshot.sh <正确的快照名称>
```

### 问题4：无法恢复修改

**症状**：
```
No stash entries found
```

**解决**：
- 可能stash已被删除
- 检查Git历史：`git reflog`
- 从reflog恢复：`git stash apply <ref>`

---

## 💡 最佳实践

### 1. 定期创建快照

```bash
# 每天早上
./scripts/auto-snapshot.sh create

# 完成功能后
./scripts/auto-snapshot.sh create

# 下班前
./scripts/auto-snapshot.sh create
```

### 2. 重大修改前创建快照

```bash
# 重构代码前
./scripts/auto-snapshot.sh create

# 升级依赖前
./scripts/auto-snapshot.sh create

# 大范围修改前
./scripts/auto-snapshot.sh create
```

### 3. 启用后台监控

```bash
# 长时间开发时启用
./scripts/error-monitor.sh monitor &
```

### 4. 及时清理stash

```bash
# 定期查看stash
git stash list

# 清理不需要的stash
git stash drop stash@{N}

# 清理全部stash（谨慎）
git stash clear
```

---

## 🎯 命令速查表

| 命令 | 说明 |
|------|------|
| `./scripts/auto-snapshot.sh create` | 创建快照 |
| `./scripts/auto-snapshot.sh list` | 查看快照列表 |
| `./scripts/auto-snapshot.sh clean` | 清理所有快照 |
| `./scripts/error-monitor.sh check` | 执行一次检查 |
| `./scripts/error-monitor.sh monitor` | 启动持续监控 |
| `./scripts/error-monitor.sh stop` | 停止监控 |
| `./scripts/rollback-to-snapshot.sh list` | 查看快照 |
| `./scripts/rollback-to-snapshot.sh <快照>` | 回退到快照 |
| `./scripts/rollback-to-snapshot.sh <快照> --auto` | 自动回退 |
| `git stash list` | 查看保存的修改 |
| `git stash apply` | 恢复修改 |
| `git stash pop` | 恢复并删除stash |

---

## 📞 获取帮助

### 查看脚本帮助

```bash
./scripts/auto-snapshot.sh help
./scripts/error-monitor.sh help
./scripts/rollback-to-snapshot.sh help
```

### 查看规则文档

```bash
grep -A 50 "实时错误回退系统" .cursorrules
```

---

**最后更新**：2025-10-26  
**版本**：v1.0.0  
**维护者**：Activity Tracker项目团队

