# 📢 如何配置AdSense - 完整教程

## 当前状态

✅ **发布商ID已配置**: ca-pub-6680853179152933  
⚠️ **广告位ID待配置**: 需要创建广告单元

---

## 🚀 配置步骤（5分钟完成）

### 第1步：登录AdSense后台

1. 访问：https://www.google.com/adsense
2. 使用你的Google账号登录
3. 确认这是你注册AdSense时使用的账号

---

### 第2步：创建广告单元

#### 2.1 进入广告管理
1. 在左侧菜单中，点击 **"广告"**
2. 选择 **"按广告单元"** 标签
3. 点击蓝色按钮 **"+ 新建广告单元"**

#### 2.2 选择广告类型
- 选择 **"展示广告"** （Display ads）

#### 2.3 配置广告单元

**基本设置：**
```
广告单元名称：Pomodoro Timer Banner
广告类型：展示广告
广告尺寸：自适应
```

**详细配置：**

1. **名称**
   - 输入：`Pomodoro Timer Banner`
   - 这个名称只在后台显示，用户看不到

2. **广告类型**
   - 选择：**"展示广告"**
   
3. **广告尺寸**
   - 选择：**"自适应"**（Responsive）
   - 或选择：**"横幅广告 320x50"**
   
4. **广告格式**
   - 保持默认设置即可

#### 2.4 创建并获取代码

1. 点击底部的 **"创建"** 按钮
2. 会弹出一个代码窗口
3. 找到这段代码：

```html
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6680853179152933"
     crossorigin="anonymous"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-6680853179152933"
     data-ad-slot="1234567890"     👈 这就是你需要的！
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
```

4. **复制 `data-ad-slot` 的值**
   - 例如：`1234567890`
   - 这是一个10位数字

5. 点击 **"完成"** 关闭窗口

---

### 第3步：配置到应用

#### 3.1 打开文件

在编辑器中打开：`js/adsense.js`

#### 3.2 找到配置位置

找到第6-10行：

```javascript
this.adSlots = {
    banner: 'XXXXXXXXXX', // 横幅广告位ID（需要在AdSense后台创建）
    sidebar: 'XXXXXXXXXX', // 侧边栏广告位ID
    inFeed: 'XXXXXXXXXX'  // 信息流广告位ID
};
```

#### 3.3 替换广告位ID

将第7行的 `'XXXXXXXXXX'` 替换为你复制的广告位ID：

```javascript
this.adSlots = {
    banner: '1234567890', // 👈 替换为你的广告位ID
    sidebar: 'XXXXXXXXXX',
    inFeed: 'XXXXXXXXXX'
};
```

#### 3.4 保存文件

按 `Cmd + S` 保存文件

---

### 第4步：更新应用

#### Web版（浏览器）
```bash
# 直接刷新浏览器页面即可
# 按 Cmd + Shift + R 强制刷新
```

#### iOS App版
```bash
# 复制更新的文件
cp -f js/adsense.js time/time/Web/js/adsense.js

# 重新编译
cd time
xcodebuild -project time.xcodeproj -scheme time -sdk iphonesimulator build

# 安装到模拟器
xcrun simctl install booted ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator/time.app

# 重启App
xcrun simctl terminate booted -1.time
xcrun simctl launch booted -1.time
```

或者运行这个一键命令：
```bash
cd /Users/shanwanjun/Desktop/cxs/time
cp -f js/adsense.js time/time/Web/js/adsense.js && cd time && xcodebuild -project time.xcodeproj -scheme time -sdk iphonesimulator build && xcrun simctl install booted ~/Library/Developer/Xcode/DerivedData/time-*/Build/Products/Debug-iphonesimulator/time.app && xcrun simctl terminate booted -1.time 2>/dev/null; xcrun simctl launch booted -1.time
```

---

### 第5步：验证广告显示

#### 等待激活
- ⏰ 新创建的广告位需要 **5分钟-1小时** 激活
- 🌐 首次可能显示空白
- 🔄 刷新几次页面试试

#### 检查是否成功

**Web版：**
1. 打开浏览器控制台（F12）
2. 查看是否有AdSense相关的网络请求
3. 检查是否有错误信息

**iOS App版：**
1. Safari → 开发 → 模拟器 → 选择time
2. 查看控制台信息
3. 确认广告脚本是否加载

#### 预期效果

**配置前（当前）：**
```
┌──────────────────────────────────────┐
│ ✅ AdSense已配置           [待配置]  │
│ ID: 79152933                         │
│ 请在AdSense后台创建广告位             │
└──────────────────────────────────────┘
```

**配置后（真实广告）：**
```
┌──────────────────────────────────────┐
│ [Google AdSense 真实广告内容]        │
│ 可能是文字、图片或视频广告            │
└──────────────────────────────────────┘
```

---

## 🎨 可选：创建更多广告位

### 侧边栏广告（可选）

**用途：** 统计页面右侧显示

**创建步骤：**
1. AdSense后台 → 广告 → 新建广告单元
2. 名称：`Pomodoro Sidebar`
3. 类型：展示广告
4. 尺寸：**300 x 250** (矩形)
5. 复制广告位ID，配置到 `sidebar` 字段

### 信息流广告（可选）

**用途：** 统计记录列表中间

**创建步骤：**
1. AdSense后台 → 广告 → 新建广告单元
2. 名称：`Pomodoro In-Feed`
3. 类型：**信息流广告**
4. 配置样式
5. 复制广告位ID，配置到 `inFeed` 字段

---

## 📊 收益跟踪

### 查看收益报告

1. AdSense后台 → **报告**
2. 可以看到：
   - 📈 每日展示次数
   - 💰 预估收益
   - 📊 点击率
   - 🎯 CPM数据

### 收款设置

1. AdSense后台 → **付款**
2. 设置收款方式：
   - 银行账户（推荐）
   - 支票
3. 达到 **$100** 后会自动付款

---

## ⚠️ 重要注意事项

### 必须遵守的规则

❌ **绝对不能做：**
1. 点击自己的广告
2. 要求别人点击广告
3. 使用机器人刷流量
4. 在广告旁边放"点击支持"等诱导文字
5. 修改AdSense代码

✅ **应该做的：**
1. 提供优质内容
2. 获取自然流量
3. 遵守AdSense政策
4. 定期查看报告
5. 优化用户体验

### 账号安全

- 🔒 定期检查异常流量
- 📧 关注AdSense的邮件提醒
- ⚖️ 遵守服务条款
- 🛡️ 不要分享账号信息

---

## 🐛 常见问题

### Q1: 广告不显示怎么办？

**检查清单：**
- [ ] 广告位ID是否正确配置
- [ ] 是否等待5分钟-1小时激活时间
- [ ] 浏览器是否安装广告拦截插件
- [ ] 在设置中是否启用了"显示广告"
- [ ] 控制台是否有错误信息

**解决方法：**
```bash
# 在浏览器控制台运行
console.log(window.adSenseManager.adClient);
console.log(window.adSenseManager.adSlots.banner);
```

### Q2: 显示空白广告位

**原因：**
- 新广告位未激活（等待即可）
- 当前地区没有合适的广告
- 流量太少，暂无广告填充

**解决：**
- 等待几小时再查看
- 尝试VPN切换地区测试
- 增加网站流量

### Q3: 收益为0

**可能原因：**
- 仅有展示，没有点击
- 流量太少
- 广告填充率低
- CPM单价低

**优化建议：**
- 提高网站流量
- 优化广告位置
- 改善内容质量
- 增加用户停留时间

### Q4: 账号被警告或封禁

**预防措施：**
- 严格遵守AdSense政策
- 不要点击自己的广告
- 避免无效流量
- 内容合规

**申诉流程：**
1. 查看邮件了解原因
2. 修复问题
3. 提交申诉
4. 等待审核

---

## 📚 快速参考

### 配置文件位置
```
js/adsense.js
第5行：发布商ID（已配置）
第7行：横幅广告位ID（待配置）
```

### 当前配置
```javascript
this.adClient = 'ca-pub-6680853179152933'; ✅
this.adSlots = {
    banner: 'XXXXXXXXXX', // ⚠️ 待配置
    sidebar: 'XXXXXXXXXX',
    inFeed: 'XXXXXXXXXX'
};
```

### 完整配置示例
```javascript
this.adClient = 'ca-pub-6680853179152933';
this.adSlots = {
    banner: '1234567890',   // 替换为真实ID
    sidebar: '9876543210',  // 可选
    inFeed: '5678901234'    // 可选
};
```

---

## 🎯 立即行动

### 现在就去做：

1. ✅ **打开AdSense** - https://www.google.com/adsense
2. ✅ **创建广告单元** - "展示广告" → "自适应"
3. ✅ **复制广告位ID** - 10位数字
4. ✅ **配置到应用** - 编辑 `js/adsense.js` 第7行
5. ✅ **保存并测试** - 刷新页面查看

### 预计时间

- 创建广告单元：2分钟
- 配置到应用：1分钟
- 等待激活：5分钟-1小时
- **总计：约10分钟**

---

## 💰 收益预期

### 基于你的发布商ID

假设每日1000访问量：

```
展示收益：
- 展示次数：1000 × 3页 = 3000次
- CPM：$2
- 收益：(3000/1000) × $2 = $6/天

点击收益：
- 点击率：1%
- 点击次数：30次
- CPC：$0.5
- 收益：30 × $0.5 = $15/天

总计：
- 日收益：~$20-25
- 月收益：~$600-750
- 年收益：~$7,200-9,000
```

*注：实际收益取决于流量质量、地区、广告类型等*

---

## 🔗 有用的链接

- **AdSense登录**: https://www.google.com/adsense
- **帮助中心**: https://support.google.com/adsense
- **政策中心**: https://support.google.com/adsense/answer/48182
- **社区论坛**: https://support.google.com/adsense/community

---

## 📱 在iOS App中测试

配置完成后，在iPhone模拟器中：

1. 打开App
2. 进入"设置"
3. 确认"显示广告"开关是开启的
4. 返回主页
5. 等待5分钟后查看底部广告

---

## ✨ 配置完成后

你会看到：
- ✅ 底部显示真实的Google广告
- ✅ 广告会自动轮换
- ✅ 不同用户看到不同广告
- ✅ 点击会产生收益
- ✅ 可在AdSense后台查看数据

---

**现在就去AdSense后台创建广告位吧！** 🚀💰

只需要2分钟就能完成配置！

---

*帮助文档：AdSense接入指南.md*  
*快速配置：AdSense快速配置.txt*

