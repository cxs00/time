# 📋 规则快速查找索引

> **版本：** v3.2.0
> **更新日期：** 2025年10月27日
> **状态：** ✅ 最新

---

## 🎯 快速导航

| 规则类别 | 优先级 | 跳转 |
|---------|--------|------|
| **元规则系统** | 🔴 CRITICAL | [查看](#元规则系统) |
| **Git操作规则** | 🔴 CRITICAL | [查看](#git操作规则) |
| **PWA集成规则** | 🔴 CRITICAL | [查看](#pwa集成规则) |
| **代码修改规则** | 🟡 MUST FOLLOW | [查看](#代码修改规则) |
| **新功能开发** | 🟡 MUST FOLLOW | [查看](#新功能开发规则) |
| **Web资源规则** | 🟡 MUST FOLLOW | [查看](#web资源规则) |
| **分步骤开发** | 🟡 MUST FOLLOW | [查看](#分步骤开发规则) |

---

## 🔴 元规则系统

### 规则优先级（从高到低）

1. 🔴 **CRITICAL规则**：违反将导致严重问题，**必须100%遵守**
2. 🟡 **MUST FOLLOW规则**：核心开发规范，**强烈建议遵守**
3. 🟢 **SHOULD规则**：最佳实践，**建议遵守**
4. ⚪ **MAY规则**：可选优化，**可以遵守**

### AI行为准则

✅ **必须执行：**
- 主动检查规则
- 不确定时优先询问
- 报告规则冲突
- 完整执行流程

❌ **严格禁止：**
- 依赖记忆或假设
- 跳过检查步骤
- 自行简化规则
- 猜测行为

📍 **详细位置：** `.cursorrules` 第1-100行

---

## 🔴 Git操作规则

### Git Tag命名规则

**格式：** `{项目名称}-v{版本号}`

**示例：**
```bash
✅ 正确：TIME-v2.4.0, Activity-Tracker-v2.5.0
❌ 错误：v2.4.0, 2.4.0, TIME_v2.4.0
```

### 版本号规则

**格式：** `v主版本.次版本.修订版本`

- **主版本**：重大架构变更
- **次版本**：新功能添加
- **修订版本**：Bug修复

### 检查清单

执行Git Tag/Commit/Push前：
- [ ] Tag命名符合规范
- [ ] 版本号递增正确
- [ ] 分步骤开发规则（如适用）

📍 **详细位置：** `.cursorrules` 第19-30行, 第896-911行

---

## 🔴 PWA集成规则

### 必须检查项

在集成PWA功能时：
- [ ] **PWA文件位置正确**
- [ ] **HTML引用完整**
- [ ] **Service Worker路径一致**
- [ ] **缓存策略配置完整**
- [ ] **离线页面可用**

### PWA文件清单

```bash
✅ service-worker.js → Web/service-worker.js
✅ pwa-register.js → Web/js/pwa-register.js
✅ manifest.json → Web/manifest.json
✅ offline.html → Web/offline.html
✅ activity-tracker.html 中引用以上文件
```

### HTML引用检查

```html
<!-- 在 <head> 中 -->
<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#667eea">

<!-- 在 </body> 前 -->
<script src="js/pwa-register.js"></script>
```

📍 **详细位置：** `.cursorrules` 第44-60行

---

## 🟡 代码修改规则

### 自动仿真规则

**每次代码修改后，必须运行仿真验证**

### 标准流程

```bash
1. 完成代码修改
2. 等待10秒（确保文件保存）
3. 自动运行仿真
4. 显示验证清单
```

### 执行命令

```bash
sleep 10 && cd /Users/shanwanjun/Desktop/cxs/time/time && echo "3" | ./run-simulation.sh
```

### 例外情况（不运行仿真）

- 仅修改文档文件（*.md）
- 仅修改配置文件
- 用户明确说明"不要运行仿真"
- 仅进行Git操作

### 验证要点

- [ ] 编译成功
- [ ] 应用正常启动
- [ ] 控制台无错误
- [ ] 功能正常工作

📍 **详细位置：** `.cursorrules` 第32-36行, 第90-138行

---

## 🟡 新功能开发规则

### 开发前必须确认

在开始开发新功能前：
- [ ] **功能需求明确**（用户确认需求）
- [ ] **技术方案评估**（可行性分析）
- [ ] **影响范围评估**（对现有功能的影响）
- [ ] **测试计划制定**（如何验证功能）
- [ ] **回退方案准备**（出问题如何回退）

### 开发流程

```
1. 需求确认 → 2. 方案设计 → 3. 影响评估
    ↓
4. 测试计划 → 5. 实施开发 → 6. 验证测试
    ↓
7. 用户确认 → 8. Git提交 → 9. 部署发布
```

📍 **详细位置：** `.cursorrules` 第62-68行

---

## 🟡 Web资源规则

### 路径一致性规则

**所有JavaScript文件必须使用 `js/` 前缀**

```html
✅ 正确：
<script src="js/activity-tracker.js"></script>
<script src="js/project-manager.js"></script>

❌ 错误：
<script src="activity-tracker.js"></script>
<script src="../js/project-manager.js"></script>
```

### 资源打包策略

- **策略A**：扁平化拷贝（不推荐）
- **策略B**：保留目录结构（推荐）

### WebView加载配置

```swift
// 允许本地文件访问
allowUniversalAccessFromFileURLs = true

// 使用loadFileURL
loadFileURL(fileURL, allowingReadAccessTo: webDirectory)
```

📍 **详细位置：** `.cursorrules` 第38-42行, 第1067-1123行

---

## 🟡 分步骤开发规则

### 适用场景

用户明确要求时：
- "分步骤实施"
- "一步一步来"
- "每步验证"
- "逐步完成"

### 强制执行流程

```
Step 1: 实施功能
   ↓
立即 git commit
   ↓
运行仿真验证
   ↓
等待用户确认
   ├─ "功能正常" → Step 2
   ├─ "撤回" → git reset HEAD~1
   └─ "有问题" → 修复后重新commit
```

### 每步必须操作

1. ✅ 立即创建Git提交
2. ✅ 运行仿真验证
3. ✅ 等待用户明确确认

### Git提交格式

```bash
git commit -m "Step X: [功能描述] - 待用户验证"

# 示例
git commit -m "Step 1: PWA文件移动到正确位置 - 待用户验证"
```

### 撤回操作

```bash
# 撤回最后一步（保留文件）
git reset --soft HEAD~1

# 撤回最后一步（删除文件修改）
git reset --hard HEAD~1

# 撤回最近N步
git reset --hard HEAD~N
```

📍 **详细位置：** `.cursorrules` 第915-1006行

---

## 📊 规则统计

| 指标 | 数值 |
|------|------|
| 规则文件行数 | 1150+行 |
| 规则版本 | v3.2.0 |
| CRITICAL规则 | 3个 |
| MUST FOLLOW规则 | 5个 |
| 检查点总数 | 5个 |
| 代码示例 | 60+个 |

---

## 🔧 常用命令速查

### Git操作

```bash
# 创建Tag
git tag -a TIME-v2.7.1 -m "功能描述"
git push origin TIME-v2.7.1

# 查看Tag
git tag -l

# 删除Tag
git tag -d TAG_NAME
git push origin :refs/tags/TAG_NAME

# 回退
git reset --hard HEAD~1
git reset --soft HEAD~1
```

### 仿真验证

```bash
# 标准仿真命令
cd /Users/shanwanjun/Desktop/cxs/time/time
echo "3" | ./run-simulation.sh

# 带延时的仿真
sleep 10 && cd /Users/shanwanjun/Desktop/cxs/time/time && echo "3" | ./run-simulation.sh
```

### 规则验证

```bash
# 验证规则文件
./scripts/validate-rules.sh check

# 自动修复规则问题
./scripts/validate-rules.sh fix

# 同步规则到GitHub
./scripts/sync-rules.sh
```

---

## 🆘 规则违反处理

### 如果违反了规则

1. ⏸️ **立即停止** - 停止当前操作
2. 🔍 **分析原因** - 找出为什么违反
3. 📝 **记录问题** - 记录到AI_COMPLIANCE_ANALYSIS.md
4. 🔧 **修正操作** - 按规则重新执行
5. 💡 **改进机制** - 提出避免方案

### 常见违规及修正

| 违规类型 | 症状 | 修正方法 |
|---------|------|---------|
| Tag命名错误 | 缺少项目名前缀 | 删除错误Tag，重新创建 |
| 未运行仿真 | 直接提交代码 | 立即运行仿真验证 |
| 路径不一致 | 资源加载失败 | 统一使用`js/`前缀 |
| 跳过Git commit | 多步合并提交 | 每步独立commit |

---

## 📚 相关文档

| 文档 | 说明 | 位置 |
|------|------|------|
| `.cursorrules` | 完整规则文件 | 项目根目录 |
| `AI_COMPLIANCE_ANALYSIS.md` | AI合规分析 | 项目根目录 |
| `PROJECT_ANALYSIS_REPORT.md` | 项目分析报告 | 项目根目录 |
| `AUTO_ROLLBACK_GUIDE.md` | 回退系统指南 | docs/ |
| `PWA_GUIDE.md` | PWA使用指南 | docs/user/ |

---

## 🔄 更新日志

### v3.2.0 (2025-10-27)
- ✅ 新增PWA集成检查点（CRITICAL）
- ✅ 新增新功能开发前检查规则
- ✅ 创建规则快速索引文件
- ✅ 更新规则快速索引表

### v3.1.1 (2025-10-26)
- ✅ 新增Web资源路径一致性规则
- ✅ 完善分步骤开发规则

### v3.0.0 (2025-10-26)
- ✅ 建立元规则系统
- ✅ 实现规则优先级机制
- ✅ 添加强制检查点

---

**最后更新：** 2025年10月27日
**维护者：** AI Assistant
**反馈：** 发现规则问题请更新 `AI_COMPLIANCE_ANALYSIS.md`

