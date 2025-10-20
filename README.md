# ⏰ TIME - 时间管理应用

一个功能完整、界面美观的时间管理Web应用，帮助你提高工作效率和专注力。

![TIME](https://img.shields.io/badge/version-1.0.0-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

🌐 **在线体验**: [https://time-2025.netlify.app](https://time-2025.netlify.app)

## ✨ 功能特性

### 核心功能
- ⏱️ **智能计时** - 25分钟专注工作，5分钟短休息，15分钟长休息
- 🎯 **自动循环** - 完成4个工作周期后自动进入长休息
- ⏸️ **灵活控制** - 随时暂停、继续、重置或跳过
- 📊 **进度可视化** - 圆形进度条实时显示剩余时间
- ⏰ **TIME Logo** - 现代简洁的紫色主题设计

### 数据分析 📈
- **完成趋势图** - 折线图展示7日完成趋势
- **活跃热力图** - 日历热力图显示每日活跃度
- **模式分布饼图** - 分析工作/休息时间占比
- **时段对比柱状图** - 对比上午/下午/晚上专注情况
- **实时数据卡片** - 关键指标一目了然

### 数据统计 📊
- 📅 **今日统计** - 查看今天完成数和工作时长
- 📈 **本周统计** - 展示本周每日完成情况
- 🏆 **历史记录** - 总计数、使用天数、连续天数
- 📝 **最近记录** - 查看最近的工作和休息记录

### 个性化设置 ⚙️
- ⏱️ **自定义时长** - 自由设置工作、休息时间
- 🔔 **通知提醒** - 浏览器通知 + 音效提醒
- 🎵 **音效控制** - 可开关音效反馈
- 🤖 **自动开始** - 可设置自动开始下一阶段
- 🎯 **目标设置** - 自定义每日目标

### 数据管理 💾
- **本地存储** - 所有数据保存在本地，保护隐私
- **数据导出** - 导出统计数据和设置为JSON
- **数据清除** - 一键清除所有数据

## 🚀 快速开始

### 在线使用
直接访问：[https://time-2025.netlify.app](https://time-2025.netlify.app)

### 本地运行
```bash
# 克隆项目
git clone https://github.com/cxs00/time.git
cd time

# 直接打开index.html
open index.html

# 或使用本地服务器
python -m http.server 8000
# 访问 http://localhost:8000
```

### iOS/macOS原生应用
```bash
# 打开Xcode项目
cd time
open time.xcodeproj

# 选择目标设备并运行
# Mac: 选择 "My Mac"
# iPhone: 选择 "iPhone 17 Pro" 或其他模拟器
# 点击运行 (Cmd + R)
```

## 📁 项目结构

```
time/
├── index.html              # Web主页面
├── deploy.sh               # 自动部署脚本
├── netlify.toml           # Netlify配置
├── README.md              # 项目主文档
├── CHANGELOG.md           # 项目时间线
├── css/                   # 样式文件
│   └── style.css          # 主样式（紫色主题）
├── js/                    # JavaScript文件
│   ├── app.js             # 主应用程序
│   ├── timer.js           # 计时器核心逻辑
│   ├── storage.js         # 数据存储管理
│   ├── notification.js    # 通知管理
│   ├── statistics.js      # 统计功能
│   ├── analytics.js       # 数据分析（ECharts）
│   └── adsense.js         # 广告管理
├── time/                  # iOS/macOS原生应用
│   ├── time.xcodeproj     # Xcode项目
│   └── time/
│       ├── timeApp.swift       # 应用入口
│       ├── ContentView.swift   # 主视图
│       ├── TimeWebView.swift   # WebView封装
│       └── Web/               # 内嵌Web资源
├── docs/                  # 项目文档
│   ├── README.md          # 文档索引
│   ├── deployment/        # 部署相关文档
│   ├── development/       # 开发相关文档
│   ├── guides/            # 使用指南
│   └── archive/           # 归档文档
└── scripts/               # 脚本和工具
    ├── README.md          # 脚本说明
    ├── deploy.sh          # 部署脚本（已移至根目录）
    ├── push.sh            # 快速推送脚本
    ├── run-app.sh         # 运行应用脚本
    ├── test-app.sh        # 测试脚本
    └── demo.html          # 演示页面
```

## 🎯 使用方法

### 基本操作
1. **开始专注** - 点击"开始"按钮启动25分钟计时
2. **暂停/继续** - 随时暂停或继续当前计时
3. **重置** - 重置当前计时器到初始状态
4. **跳过** - 跳过当前阶段，进入下一个阶段

### 模式切换
- **工作模式** - 紫色主题，默认25分钟
- **短休息** - 绿色主题，默认5分钟
- **长休息** - 琥珀色主题，默认15分钟

### 查看数据
- **📊 统计** - 查看今日、本周、历史数据
- **📈 分析** - 查看5种可视化图表分析
- **⚙️ 设置** - 自定义时长和功能开关

### 隐私和声明
- **隐私声明** - 查看隐私保护政策
- **开源声明** - MIT开源协议
- **广告声明** - 了解广告政策

## 🎨 界面预览

### 工作模式 💜
- 背景色：紫色渐变 (#818CF8 → #6366F1)
- 专注工作，提升效率

### 短休息模式 💚
- 背景色：绿色渐变 (#34D399 → #10B981)
- 短暂放松，恢复精力

### 长休息模式 🧡
- 背景色：琥珀色渐变 (#FBBF24 → #F59E0B)
- 充分休息，准备新周期

## 💻 技术栈

### 前端
- **HTML5** - 语义化结构
- **CSS3** - 现代化样式
  - CSS变量和渐变
  - Flexbox/Grid布局
  - 流畅动画过渡
  - 响应式设计
- **JavaScript (ES6+)** - 核心功能
  - 面向对象编程
  - LocalStorage API
  - Notification API
  - Canvas绘图

### 数据可视化
- **ECharts 5.5.0** - 专业图表库
  - 折线图、饼图、柱状图
  - 日历热力图
  - 自适应响应式

### 移动端
- **SwiftUI** - iOS/macOS应用框架
- **WebKit** - 高性能WebView
- **Xcode** - 开发工具

### 部署
- **GitHub** - 代码托管
- **Netlify** - 自动部署和CDN
- **Git** - 版本控制

## 🌟 功能亮点

### 1. 现代化UI设计
- 紫色主题，优雅大气
- 流畅的动画过渡
- 响应式布局，完美适配各种设备
- 三种模式对应不同的视觉主题

### 2. 强大的数据分析
- 5种专业图表可视化
- 实时数据统计
- 趋势分析和对比
- ECharts专业图表库

### 3. 跨平台支持
- Web版：任何浏览器访问
- iOS版：原生应用体验
- macOS版：桌面应用
- 数据本地存储，跨设备使用

### 4. 隐私保护
- 纯本地存储，不上传数据
- 无需注册登录
- 支持数据导出备份
- 开源透明

### 5. 灵活自定义
- 可调整时长设置
- 多种自动化选项
- 通知和音效控制
- 目标管理

## 📱 浏览器兼容性

- ✅ Chrome 60+
- ✅ Firefox 55+
- ✅ Safari 11+
- ✅ Edge 79+
- ✅ 移动端浏览器（iOS Safari, Chrome Mobile）

## 🎓 时间管理方法

TIME应用基于经典的时间管理原则：

1. **选择任务** - 确定要完成的任务
2. **设定时间** - 开始25分钟专注计时
3. **专注工作** - 全神贯注完成任务
4. **短暂休息** - 休息5分钟
5. **循环重复** - 每4个周期后，休息15-30分钟

### 使用技巧
- 🎯 一次只专注一件事
- 📵 工作时关闭干扰源
- ✅ 及时记录完成的任务
- 📊 定期回顾和调整
- 🎉 庆祝小成就

## 🔧 部署

### 自动部署
项目已配置Netlify自动部署：
1. Push到GitHub main分支
2. Netlify自动检测并部署
3. 1-2分钟后生效

### 手动部署
```bash
# 使用部署脚本
./deploy.sh

# 或手动推送
git add -A
git commit -m "更新内容"
git push origin main
```

## 📊 数据统计

### 本地存储数据结构
```javascript
{
  settings: {
    workDuration: 25,
    shortBreakDuration: 5,
    longBreakDuration: 15,
    longBreakInterval: 4,
    notificationsEnabled: true,
    soundEnabled: true,
    // ...
  },
  history: [
    {
      date: "2025-10-20",
      type: "work",
      duration: 25,
      completed: true
    }
    // ...
  ]
}
```

## 🐛 问题反馈

如果遇到任何问题或有功能建议，欢迎通过以下方式反馈：

- **GitHub Issues**: [提交Issue](https://github.com/cxs00/time/issues)
- **Pull Requests**: 欢迎贡献代码

## 📄 开源协议

MIT License - 可自由使用、修改和分发

详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- **ECharts** - 数据可视化图表库
- **Netlify** - 免费的自动部署服务
- **所有时间管理爱好者** - 感谢你们的支持

## 🚀 后续计划

- [ ] 添加更多主题颜色
- [ ] 支持数据云同步
- [ ] 添加任务管理功能
- [ ] 社交分享功能
- [ ] 团队协作模式
- [ ] Android原生应用

---

**⏰ 享受时光，专注当下！**

Made with ❤️ for productivity enthusiasts

🌐 [在线体验](https://time-2025.netlify.app) | 📦 [GitHub](https://github.com/cxs00/time) | 📚 [文档](https://github.com/cxs00/time/wiki)
