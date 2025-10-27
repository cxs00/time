# 📦 TIME Activity Tracker - TIME-v2.4.0 发布说明

> **发布日期：** 2025年10月27日
> **版本标签：** TIME-v2.4.0
> **版本类型：** 重大修复版本
> **状态：** ✅ 已验证通过

---

## 🎯 本次发布重点

本次v2.4.0版本主要解决了**Mac端黑屏问题**和**手机端饼状图样式回退问题**，同时新增了主题切换和UI尺寸配置功能。

---

## ✨ 新功能

### 1. 主题切换功能
- 🌌 **星夜主题**：深邃星空背景，动态星星动画
- 💐 **睡莲主题**：紫色渐变背景，优雅配色
- 🎨 **默认主题**：经典蓝色主题
- 💾 主题选择自动保存到localStorage

### 2. UI尺寸配置功能
- 📏 **标准尺寸**：输入框48px，按钮48px，字体16px
- 📐 **大尺寸**：输入框54px，按钮54px，字体17px
- 📏 **超大尺寸**：输入框60px，按钮60px，字体18px
- 🎯 基于人体工程学设计，符合iOS触控目标尺寸规范
- 💾 尺寸选择自动保存到localStorage

---

## 🐛 重大修复

### 1. Mac端黑屏问题（彻底解决）✅

**问题描述：**
- Cursor运行仿真后Mac应用黑屏
- 手动在Xcode编译正常，但自动仿真黑屏
- 根本原因：Web资源未被打包到`Contents/Resources`目录

**解决方案：**
```bash
# 修改 run-simulation.sh
# 在编译成功后自动复制Web资源到app bundle
cp -R "$PROJECT_DIR/time/Web/"* "$resources_dir/Web/"
```

**技术细节：**
- 修正Web目录路径：`time/Web`而非`Web`
- 同时搜索两个可能的编译输出目录：
  - `Build/Products/Debug`
  - `Index.noindex/Build/Products/Debug`
- 每次编译自动复制20个文件（HTML/CSS/JS）

**验证结果：**
- ✅ Mac应用：成功复制20个文件到`Contents/Resources/Web/`
- ✅ Mac应用正常启动，不再黑屏
- ✅ 界面显示正常，所有功能正常工作

### 2. 手机端记录页饼状图切换后样式回退问题 ✅

**问题描述：**
- 首次打开记录页面，饼状图显示正确（外部标签+引线）
- 切换到统计页面后再回来，饼状图变回旧样式（内部标签）

**根本原因：**
- 切换回记录页面时，未调用`updateTodayDistributionChart()`
- ECharts的`setOption`默认merge模式导致样式被覆盖

**解决方案：**
```javascript
// 在 onPageChange() 函数的 case 'home' 中添加
setTimeout(() => {
  if (typeof updateTodayDistributionChart === 'function') {
    updateTodayDistributionChart();
    console.log('✅ 记录页饼状图已刷新');
  }
}, 100);
```

**技术细节：**
- 使用`chart.setOption(option, true)`（notMerge=true）强制完整刷新
- 添加`chart.resize()`确保图表尺寸正确
- 延迟100ms确保DOM渲染完成

**验证结果：**
- ✅ 切换到统计页面后再回来，饼状图样式保持一致
- ✅ 外部标签和引线始终显示正确
- ✅ 移动端和Mac端行为一致

---

## 📝 技术改进

### 1. Xcode项目配置优化
- ✅ 添加`PBXCopyFilesBuildPhase`到项目配置
- ✅ 创建Web文件夹的`PBXFileReference`
- ✅ 尝试多种Xcode资源打包策略（最终采用脚本方案）

### 2. run-simulation.sh脚本增强
```bash
# 关键改进
1. 自动复制Web资源到app bundle
2. 支持Index.noindex目录
3. 显示复制文件数量
4. 详细的日志输出
```

### 3. 页面切换逻辑优化
- ✅ `onPageChange()`函数中为每个页面添加刷新逻辑
- ✅ 统计页面延迟100ms刷新图表
- ✅ 记录页面延迟100ms刷新饼状图

---

## 🎯 验证通过清单

### Mac端验证 ✅
- [x] Mac应用正常启动（不再黑屏）
- [x] 界面显示正常
- [x] 主题切换功能正常
- [x] UI尺寸调整功能正常
- [x] 所有功能按钮正常工作
- [x] Web资源正确加载（20个文件）

### iPhone端验证 ✅
- [x] iPhone应用正常安装并启动
- [x] 记录页饼状图显示正确
- [x] 切换页面后饼状图样式保持一致
- [x] 主题切换功能正常
- [x] UI尺寸调整功能正常
- [x] 所有功能按钮正常工作

---

## 📊 提交记录

```bash
f8172ad - Merge remote-tracking branch 'origin/main' - 保留本地最新验证版本
499e37c - fix: 修复手机端记录页饼状图切换后样式回退
fc10778 - fix: 修复run-simulation.sh中Mac应用路径查找
dbe3464 - fix: 修正run-simulation.sh中Web目录路径
1fbb90d - fix: 修改run-simulation.sh，在编译后自动复制Web资源到app bundle
215c730 - fix: 自动将Web文件夹添加到Xcode项目作为Folder Reference
```

---

## 🔗 链接

- **GitHub仓库：** https://github.com/cxs00/time
- **版本标签：** TIME-v2.4.0
- **发布分支：** main
- **命名规则：** {项目名称}-v{版本号}

---

## 📋 升级说明

### 从v2.3.1升级到TIME-v2.4.0

**自动升级：**
```bash
git pull origin main
git checkout TIME-v2.4.0
```

**手动升级：**
1. 下载最新代码：`git clone https://github.com/cxs00/time.git`
2. 切换到TIME-v2.4.0：`git checkout TIME-v2.4.0`
3. 运行仿真：`cd time && echo "3" | ./run-simulation.sh`

**注意事项：**
- ✅ 本地数据会自动迁移（localStorage）
- ✅ 主题和UI尺寸设置需要重新配置
- ✅ Mac应用首次启动会清理WebView缓存

---

## 🎉 致谢

感谢用户的耐心测试和反馈！本次版本解决了两个困扰已久的重大问题，让应用在Mac和iPhone上都能完美运行。

---

## 📞 反馈与支持

如有问题或建议，请通过以下方式联系：
- **GitHub Issues：** https://github.com/cxs00/time/issues
- **项目Wiki：** https://github.com/cxs00/time/wiki

---

**Happy Tracking! 🎯**

