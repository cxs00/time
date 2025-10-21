# TIME项目快速开始指南

## 🚀 5分钟快速上手

### 1. 获取项目
```bash
# 克隆项目
git clone https://github.com/cxs00/time.git
cd time

# 用Cursor打开
cursor .
```

### 2. 启动开发
```bash
# 启动Web服务器 (在Cursor终端中)
python -m http.server 8000

# 访问: http://localhost:8000
```

### 3. 版本管理
```bash
# 查看所有版本
./scripts/version-traveler.sh list

# 跳转到历史版本
./scripts/version-traveler.sh go v1.0.0
```

## 📁 项目结构速览

```
TIME/
├── index.html              # 🌐 Web版本入口
├── css/style.css           # 🎨 样式文件
├── js/                     # ⚡ JavaScript功能
│   ├── app.js             # 主应用逻辑
│   ├── timer.js           # 计时器
│   ├── statistics.js      # 统计功能
│   └── analytics.js       # 数据分析
├── time/                   # 📱 原生应用
│   └── time.xcodeproj     # Xcode项目
└── scripts/               # 🔧 版本管理工具
```

## 🎯 开发重点

### Web版本开发
- 修改 `index.html` - 页面结构
- 修改 `css/style.css` - 样式设计
- 修改 `js/*.js` - 功能逻辑

### 原生应用开发
- 打开 `time/time.xcodeproj` 在Xcode中
- 修改Swift文件在 `time/time/` 目录

### 同步更新
- Web版本和原生版本共享HTML/CSS/JS文件
- 修改后需要同步到两个版本

## 🔧 Cursor使用技巧

### 快捷键
- `Ctrl+Shift+V`: 启动Web服务器
- `Ctrl+Shift+B`: 查看版本列表
- `Ctrl+Shift+C`: 显示当前版本
- `Ctrl+Shift+G`: Git状态检查

### 智能功能
- 自动代码补全
- 语法高亮
- 错误检测
- 代码格式化

## 🚀 常用命令

```bash
# 版本管理
./scripts/version-traveler.sh list          # 查看版本
./scripts/version-traveler.sh go v1.0.0     # 跳转版本
./scripts/version-traveler.sh create v1.1.0 # 创建版本

# 备份管理
./scripts/backup-version.sh v1.1.0          # 创建备份

# Git操作
git status                                   # 查看状态
git add .                                    # 添加更改
git commit -m "描述"                         # 提交更改
git push origin main                         # 推送到GitHub
```

## 📚 详细文档

- `DEVELOPER_GUIDE.md` - 完整开发者指南
- `CURSOR_SETUP.md` - Cursor配置指南
- `docs/` - 详细项目文档
- `README.md` - 项目说明

## 🆘 遇到问题？

1. **项目无法运行**: 检查Python是否安装
2. **版本跳转失败**: 确保在项目根目录
3. **Git推送失败**: 检查网络连接和权限
4. **Xcode项目打不开**: 确保Xcode已安装

## 💡 开发建议

1. **先熟悉项目结构** - 了解文件组织
2. **测试版本管理** - 确保功能正常
3. **小步迭代** - 每次修改后测试
4. **及时备份** - 重要修改前创建版本
5. **保持同步** - Web和原生版本保持一致

## 🎉 开始开发！

现在你已经了解了项目结构，可以开始：
1. 修改Web版本功能
2. 测试版本管理
3. 创建新功能
4. 发布新版本

**祝你开发愉快！** 🚀
