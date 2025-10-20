# 🚀 GitHub推送指南

## ✅ 已完成的步骤

1. ✅ Git仓库已初始化
2. ✅ 所有文件已添加
3. ✅ 代码已提交到本地
4. ✅ 主分支设置为 main
5. ✅ 远程仓库已配置：https://github.com/cxs00/pomodoro-timer.git

---

## 🔑 接下来需要做的

### 步骤1：在GitHub上创建仓库

**如果您还没有创建仓库：**

1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `pomodoro-timer`
   - Description: `🍅 专注工作的番茄钟应用`
   - 选择 Public 或 Private
   - ❌ **不要勾选** "Initialize this repository with a README"
3. 点击 "Create repository"

**如果您已经创建了仓库：**

直接进行下一步！

---

### 步骤2：推送代码到GitHub

#### 方式A：使用Personal Access Token（推荐）

**GitHub已经不再支持密码推送，需要使用Token！**

**创建Token：**

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 填写信息：
   - Note: `Pomodoro Timer Deploy`
   - Expiration: 选择过期时间（建议90天或更长）
   - 勾选权限：
     - ✅ **repo**（完整的仓库访问权限）
4. 点击 "Generate token"
5. **立即复制token！** （只显示一次，格式如：`ghp_xxxxxxxxxxxx`）

**使用Token推送：**

```bash
cd /Users/shanwanjun/Desktop/cxs/time-deploy
git push -u origin main
```

当提示输入时：
- Username: `cxs00`
- Password: **粘贴您刚才复制的token**（不是GitHub密码！）

---

#### 方式B：使用SSH（更方便，但需要配置）

**生成SSH密钥：**

```bash
# 生成密钥
ssh-keygen -t ed25519 -C "Cxs_0210"

# 按Enter使用默认路径
# 按Enter跳过密码（或设置密码）

# 复制公钥
cat ~/.ssh/id_ed25519.pub
```

**添加到GitHub：**

1. 复制上面命令显示的公钥（以 `ssh-ed25519` 开头）
2. 访问 https://github.com/settings/ssh/new
3. Title: `MacBook`
4. Key: 粘贴公钥
5. 点击 "Add SSH key"

**修改远程仓库为SSH：**

```bash
cd /Users/shanwanjun/Desktop/cxs/time-deploy
git remote set-url origin git@github.com:cxs00/pomodoro-timer.git
git push -u origin main
```

---

## 🎯 推送命令（准备好后执行）

### 使用Token推送：

```bash
cd /Users/shanwanjun/Desktop/cxs/time-deploy
git push -u origin main
```

### 使用SSH推送（需先配置）：

```bash
cd /Users/shanwanjun/Desktop/cxs/time-deploy
git remote set-url origin git@github.com:cxs00/pomodoro-timer.git
git push -u origin main
```

---

## ✅ 推送成功后

您会看到类似输出：

```
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
...
To https://github.com/cxs00/pomodoro-timer.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

**推送成功！** 🎉

---

## 🌐 接下来：Netlify部署

### 步骤1：登录Netlify

1. 访问 https://app.netlify.com
2. 点击 "Sign up with GitHub"（用您的GitHub账号登录）
3. 授权Netlify访问GitHub

### 步骤2：导入项目

1. 点击 "Add new site" → "Import an existing project"
2. 选择 "Deploy with GitHub"
3. 授权Netlify访问您的仓库（如果需要）
4. 在仓库列表中选择 `pomodoro-timer`
5. 点击选择

### 步骤3：配置部署

**Build settings：**
- Branch to deploy: `main`
- Build command: (留空)
- Publish directory: `.`
- Base directory: (留空)

点击 **"Deploy site"**

### 步骤4：等待部署

```
Building...    ⏳ 正在构建（约1-2分钟）
Published!     ✅ 部署成功
```

### 步骤5：获取URL

部署成功后，Netlify会分配一个URL：
```
https://random-name-123456.netlify.app
```

**这就是您的番茄钟应用地址！** 🎉

### 步骤6：自定义域名（可选）

1. Site settings → Domain management
2. Options → Edit site name
3. 输入：`my-pomodoro-timer`
4. 新URL：`https://my-pomodoro-timer.netlify.app`

---

## 🔄 后续更新流程

每次修改代码后：

```bash
# 1. 查看修改
git status

# 2. 添加修改
git add .

# 3. 提交
git commit -m "描述您的修改"

# 4. 推送到GitHub
git push

# 5. Netlify自动检测并重新部署！
```

---

## 📊 当前状态

✅ Git仓库：已初始化  
✅ 代码提交：已完成  
✅ 远程仓库：已配置  
⏳ 推送到GitHub：等待您的Token或SSH配置  
⏳ Netlify部署：等待GitHub推送完成

---

## 🆘 遇到问题？

### 问题1：fatal: Authentication failed

**原因：** GitHub已不支持密码推送

**解决：** 使用Personal Access Token（见上方"方式A"）

### 问题2：fatal: repository not found

**原因：** GitHub仓库还没创建

**解决：** 先在GitHub上创建仓库（见"步骤1"）

### 问题3：error: src refspec main does not match any

**原因：** 没有提交就尝试推送

**解决：** 确保已执行 `git commit`（我已经帮您完成了）

---

## 📞 需要帮助？

**准备好Token后告诉我，我可以帮您：**

1. 自动执行推送命令
2. 验证推送结果
3. 指导Netlify配置
4. 测试部署的网站

---

**🎯 现在去创建GitHub Token，然后我们继续！** 🚀

