// ==================== 智能活动记录系统 ====================

class SmartActivityTracker {
  constructor() {
    this.currentActivity = null;
    this.activities = this.loadActivities();
    this.customCategories = this.loadCustomCategories();
    this.projects = this.loadProjects();
    this.timer = null;
    this._initialized = false;
    // ⚠️ 不在构造函数中调用 init()，由外部在 DOM 完全准备好后调用
  }

  init() {
    if (this._initialized) {
      console.warn('⚠️ SmartActivityTracker 已经初始化，跳过重复初始化');
      return;
    }

    console.log('🧠 智能活动记录系统初始化');
    console.log('🔍 [init] DOM 状态:', document.readyState);
    console.log('🔍 [init] 主页面:', document.getElementById('home'));

    this.setupEventListeners();
    this.updateCategorySelector();
    this.updateUI();

    this._initialized = true;
    console.log('✅ [init] 初始化完成');
  }

  setupEventListeners() {
    console.log('🔧 [setupEventListeners] 开始绑定事件监听器...');

    // 开始记录按钮
    const startBtn = document.getElementById('startActivity');
    if (startBtn) {
      startBtn.addEventListener('click', () => this.handleStartActivity());
      console.log('✅ [setupEventListeners] 开始记录按钮已绑定');
    }

    // 结束活动按钮
    const endBtn = document.getElementById('endActivity');
    if (endBtn) {
      endBtn.addEventListener('click', () => this.handleEndActivity());
      console.log('✅ [setupEventListeners] 结束活动按钮已绑定');
    }

    // 暂停/继续按钮
    const pauseBtn = document.getElementById('pauseActivity');
    if (pauseBtn) {
      pauseBtn.addEventListener('click', () => this.handlePauseActivity());
      console.log('✅ [setupEventListeners] 暂停按钮已绑定');
    }

    // 活动输入框实时建议和智能项目推荐
    const activityInput = document.getElementById('activityInput');
    const projectSelect = document.getElementById('projectSelect');
    if (activityInput) {
      activityInput.addEventListener('input', (e) => {
        const text = e.target.value;
        this.showSmartSuggestions(text);
        
        // 智能推荐项目
        if (projectSelect && text.trim().length >= 2) {
          const recommendedProjectId = this.findRelatedProject(text);
          if (recommendedProjectId) {
            projectSelect.value = recommendedProjectId;
            // 添加推荐提示样式
            projectSelect.style.borderColor = '#667eea';
            projectSelect.style.boxShadow = '0 0 0 3px rgba(102, 126, 234, 0.1)';
          }
        }
      });
      console.log('✅ [setupEventListeners] 输入框建议和智能项目推荐已绑定');
    }

    // 添加自定义分类按钮 - 使用事件委托
    console.log('🔍 [setupEventListeners] 设置自定义分类按钮事件委托...');

    // 方案1: 直接绑定（如果按钮存在）
    const addCustomCategoryBtn = document.getElementById('addCustomCategory');
    console.log('🔍 [setupEventListeners] 按钮元素:', addCustomCategoryBtn);

    if (addCustomCategoryBtn) {
      console.log('✅ [setupEventListeners] 按钮找到，直接绑定事件...');
      addCustomCategoryBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        console.log('🎯 [EVENT] 自定义分类按钮被点击（直接绑定）！');
        this.handleAddCustomCategory();
      });
      console.log('✅ [setupEventListeners] 直接绑定成功');

      const isVisible = addCustomCategoryBtn.offsetParent !== null;
      console.log('🔍 [setupEventListeners] 按钮可见性:', isVisible);
    } else {
      console.warn('⚠️ [setupEventListeners] 按钮未找到，将使用事件委托');
    }

    // 方案2: 事件委托（备用方案，确保一定能工作）
    document.body.addEventListener('click', (e) => {
      if (e.target && e.target.id === 'addCustomCategory') {
        e.preventDefault();
        e.stopPropagation();
        console.log('🎯 [EVENT] 自定义分类按钮被点击（事件委托）！');
        this.handleAddCustomCategory();
      }
    });
    console.log('✅ [setupEventListeners] 事件委托已设置（body级别）');

    console.log('✅ [setupEventListeners] 事件监听器绑定完成');
  }

  // 开始新活动
  handleStartActivity() {
    const activityInput = document.getElementById('activityInput');
    const categorySelect = document.getElementById('categorySelect');
    const projectSelect = document.getElementById('projectSelect');

    if (!activityInput || !activityInput.value.trim()) {
      this.showNotification('请输入活动内容', 'error');
      return;
    }

    const activityText = activityInput.value.trim();
    const selectedCategory = categorySelect?.value || null;
    const selectedProject = projectSelect?.value || null;

    // 如果当前有活动，自动结束
    if (this.currentActivity) {
      this.endCurrentActivity();
    }

    // 智能分类
    const suggestedCategory = selectedCategory || this.classifyActivity(activityText);

    // 创建新活动
    this.currentActivity = {
      id: Date.now().toString(),
      startTime: new Date(),
      activity: activityText,
      category: suggestedCategory,
      projectId: selectedProject || this.findRelatedProject(activityText),
      tags: this.extractTags(activityText),
      isAutoEnded: false
    };

    // 清空输入框
    activityInput.value = '';

    // 开始计时
    this.startTimer();

    // 更新UI
    this.updateUI();

    // 显示通知
    this.showNotification(`开始记录: ${activityText}`, 'success');

    console.log('✅ 活动开始:', this.currentActivity);
  }

  // 结束当前活动
  handleEndActivity() {
    if (!this.currentActivity) {
      this.showNotification('当前没有正在进行的活动', 'warning');
      return;
    }

    this.endCurrentActivity();
    this.showNotification('活动已结束', 'success');
  }

  // 暂停/继续当前活动
  handlePauseActivity() {
    if (!this.currentActivity) {
      this.showNotification('当前没有正在进行的活动', 'warning');
      return;
    }

    if (this.currentActivity.isPaused) {
      this.resumeActivity();
    } else {
      this.pauseActivity();
    }
  }

  // 暂停活动
  pauseActivity() {
    if (!this.currentActivity || this.currentActivity.isPaused) return;

    this.currentActivity.isPaused = true;
    this.currentActivity.pauseTime = new Date();

    // 停止计时器
    this.stopTimer();

    // 更新UI
    this.updateCurrentActivityDisplay();

    this.showNotification('活动已暂停', 'info');
    console.log('⏸️ 活动暂停');
  }

  // 继续活动
  resumeActivity() {
    if (!this.currentActivity || !this.currentActivity.isPaused) return;

    const pauseDuration = new Date() - this.currentActivity.pauseTime;

    // 调整开始时间，排除暂停时长
    this.currentActivity.startTime = new Date(this.currentActivity.startTime.getTime() + pauseDuration);

    this.currentActivity.isPaused = false;
    delete this.currentActivity.pauseTime;

    // 重新启动计时器
    this.startTimer();

    // 更新UI
    this.updateCurrentActivityDisplay();

    this.showNotification('活动已继续', 'success');
    console.log('▶️ 活动继续');
  }

  // 结束当前活动（内部方法）
  endCurrentActivity() {
    if (!this.currentActivity) return;

    this.currentActivity.endTime = new Date();
    this.currentActivity.duration = Math.floor(
      (this.currentActivity.endTime - this.currentActivity.startTime) / 60000
    );
    this.currentActivity.date = this.currentActivity.startTime.toISOString().split('T')[0];

    // 保存活动
    this.activities.push(this.currentActivity);
    this.saveActivities();

    // 更新项目进度
    if (this.currentActivity.projectId) {
      this.updateProjectProgress(this.currentActivity);
    }

    // 停止计时
    this.stopTimer();

    // 重置当前活动
    this.currentActivity = null;

    // 更新UI
    this.updateUI();

    console.log('✅ 活动结束');
  }

  // 智能分类（使用AI分类器）
  classifyActivity(activityText) {
    if (typeof aiClassifier !== 'undefined') {
      return aiClassifier.classifyActivity(activityText, {
        currentTime: new Date(),
        relatedProject: null
      });
    }

    // 降级方案：基础关键词匹配
    const categoryPatterns = {
      '工作': ['编程', '开发', '设计', '会议', '文档', '测试', '部署', '代码', '项目'],
      '学习': ['看书', '教程', '课程', '研究', '练习', '复习', '学', '读'],
      '运动': ['跑步', '健身', '游泳', '瑜伽', '骑行', '散步', '锻炼'],
      '娱乐': ['游戏', '电影', '音乐', '阅读', '社交', '旅行', '玩'],
      '生活': ['做饭', '购物', '清洁', '休息', '睡觉', '洗漱', '吃']
    };

    const text = activityText.toLowerCase();

    for (const [category, keywords] of Object.entries(categoryPatterns)) {
      if (keywords.some(keyword => text.includes(keyword))) {
        return category;
      }
    }

    return '其他';
  }

  // 智能项目关联（增强版）
  findRelatedProject(activityText) {
    if (!activityText || activityText.trim().length === 0) {
      return null;
    }

    const text = activityText.toLowerCase();
    const activeProjects = this.projects.filter(p => p.status === 'active');
    
    if (activeProjects.length === 0) {
      return null;
    }

    // 评分系统：为每个项目计算匹配分数
    const projectScores = activeProjects.map(project => {
      let score = 0;
      const projectName = project.name.toLowerCase();
      const projectDesc = (project.description || '').toLowerCase();
      const projectTags = project.tags?.map(tag => tag.toLowerCase()) || [];

      // 1. 项目名称完全匹配（高分）
      if (text.includes(projectName)) {
        score += 100;
      }

      // 2. 项目名称部分匹配
      const projectWords = projectName.split(/[\s\-_]+/);
      projectWords.forEach(word => {
        if (word.length > 1 && text.includes(word)) {
          score += 30;
        }
      });

      // 3. 标签匹配
      projectTags.forEach(tag => {
        if (text.includes(tag)) {
          score += 50;
        }
      });

      // 4. 描述关键词匹配
      if (projectDesc && projectDesc.length > 0) {
        const descWords = projectDesc.split(/[\s,，、]+/).filter(w => w.length > 2);
        descWords.forEach(word => {
          if (text.includes(word)) {
            score += 10;
          }
        });
      }

      // 5. 历史活动学习：该项目的历史活动关键词
      const projectActivities = this.activities.filter(a => a.project === project.id);
      if (projectActivities.length > 0) {
        // 提取该项目历史活动的关键词
        const keywords = this.extractProjectKeywords(projectActivities);
        keywords.forEach(keyword => {
          if (text.includes(keyword)) {
            score += 20;
          }
        });
      }

      return { project, score };
    });

    // 找出分数最高的项目
    const bestMatch = projectScores.reduce((best, current) => 
      current.score > best.score ? current : best
    , { project: null, score: 0 });

    // 只有分数超过阈值才返回推荐
    return bestMatch.score >= 30 ? bestMatch.project.id : null;
  }

  // 从项目的历史活动中提取关键词
  extractProjectKeywords(activities) {
    const keywords = new Set();
    const wordFrequency = {};

    activities.forEach(activity => {
      const words = activity.activity.toLowerCase().split(/[\s,，、]+/);
      words.forEach(word => {
        if (word.length >= 2 && word.length <= 10) {
          wordFrequency[word] = (wordFrequency[word] || 0) + 1;
        }
      });
    });

    // 返回出现频率最高的关键词（至少出现2次）
    Object.entries(wordFrequency)
      .filter(([word, freq]) => freq >= 2)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 10)
      .forEach(([word]) => keywords.add(word));

    return Array.from(keywords);
  }

  // 提取标签
  extractTags(activityText) {
    const tags = [];
    const words = activityText.split(/[\s,，、]+/);

    // 提取关键词作为标签
    words.forEach(word => {
      if (word.length >= 2 && word.length <= 10) {
        tags.push(word);
      }
    });

    return tags.slice(0, 5); // 最多5个标签
  }

  // 更新项目进度
  updateProjectProgress(activity) {
    const project = this.projects.find(p => p.id === activity.projectId);
    if (!project) return;

    // 简单的进度计算：每60分钟增加5%进度
    const progressIncrease = Math.min(5, (activity.duration / 60) * 5);
    project.progress = Math.min(100, project.progress + progressIncrease);

    // 更新里程碑
    this.updateMilestones(project);

    // 保存项目
    this.saveProjects();

    console.log(`📊 项目进度更新: ${project.name} - ${project.progress}%`);
  }

  // 更新里程碑
  updateMilestones(project) {
    if (!project.milestones || project.milestones.length === 0) return;

    const progressPerMilestone = 100 / project.milestones.length;

    project.milestones.forEach((milestone, index) => {
      const minProgress = progressPerMilestone * index;
      const maxProgress = progressPerMilestone * (index + 1);

      if (project.progress >= maxProgress) {
        milestone.status = 'completed';
        milestone.progress = 100;
      } else if (project.progress >= minProgress) {
        milestone.status = 'active';
        milestone.progress = ((project.progress - minProgress) / progressPerMilestone) * 100;
      } else {
        milestone.status = 'pending';
        milestone.progress = 0;
      }
    });
  }

  // 处理添加自定义分类
  handleAddCustomCategory() {
    console.log('🎯 [handleAddCustomCategory] 方法被调用');
    console.log('🔍 [handleAddCustomCategory] 当前自定义分类:', this.customCategories);

    // 使用自定义对话框替代 prompt()（iOS WebView 兼容）
    this.showCustomCategoryDialog();
  }

  // 显示自定义分类对话框
  showCustomCategoryDialog() {
    console.log('🎨 [showCustomCategoryDialog] 显示对话框');

    // 创建对话框 HTML
    const dialogHTML = `
      <div class="modal" id="customCategoryModal" style="display: flex !important;">
        <div class="modal-content">
          <h3>添加自定义分类</h3>
          <div class="form-group">
            <label>分类名称：</label>
            <input type="text" id="customCategoryInput" class="activity-input"
                   placeholder="例如：阅读、健身、编程..." autofocus>
          </div>
          <div class="modal-actions">
            <button class="btn btn-secondary" id="cancelCustomCategory">取消</button>
            <button class="btn btn-primary" id="confirmCustomCategory">确定</button>
          </div>
        </div>
      </div>
    `;

    // 插入到页面
    document.body.insertAdjacentHTML('beforeend', dialogHTML);

    // 获取元素
    const modal = document.getElementById('customCategoryModal');
    const input = document.getElementById('customCategoryInput');
    const cancelBtn = document.getElementById('cancelCustomCategory');
    const confirmBtn = document.getElementById('confirmCustomCategory');

    // 自动聚焦输入框
    setTimeout(() => input.focus(), 100);

    // 取消按钮
    cancelBtn.addEventListener('click', () => {
      console.log('❌ [showCustomCategoryDialog] 用户取消');
      modal.remove();
    });

    // 确定按钮
    confirmBtn.addEventListener('click', () => {
      const categoryName = input.value.trim();
      console.log('✅ [showCustomCategoryDialog] 用户输入:', categoryName);

      if (!categoryName) {
        this.showNotification('请输入分类名称', 'warning');
        input.focus();
        return;
      }

      // 检查是否已存在
      if (this.customCategories.includes(categoryName)) {
        console.log('⚠️ [showCustomCategoryDialog] 分类已存在:', categoryName);
        this.showNotification('该分类已存在', 'warning');
        input.value = '';
        input.focus();
        return;
      }

      // 添加到自定义分类
      this.customCategories.push(categoryName);
      this.saveCustomCategories();
      console.log('✅ [showCustomCategoryDialog] 分类已保存:', this.customCategories);

      // 更新分类选择器
      this.updateCategorySelector();
      console.log('✅ [showCustomCategoryDialog] 分类选择器已更新');

      // 关闭对话框
      modal.remove();

      // 显示成功提示
      this.showNotification(`已添加自定义分类: ${categoryName}`, 'success');
    });

    // 回车键确认
    input.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
        confirmBtn.click();
      }
    });

    // 点击背景关闭
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        console.log('❌ [showCustomCategoryDialog] 点击背景关闭');
        modal.remove();
      }
    });
  }

  // 更新分类选择器
  updateCategorySelector() {
    const categorySelect = document.getElementById('categorySelect');
    if (!categorySelect) {
      console.warn('⚠️ 分类选择器不存在');
      return;
    }

    // 保存当前选中的值
    const currentValue = categorySelect.value;

    // 获取默认分类（前5个选项）
    const defaultOptions = Array.from(categorySelect.options).slice(0, 5);

    // 清空选择器
    categorySelect.innerHTML = '';

    // 重新添加默认分类
    defaultOptions.forEach(option => {
      categorySelect.appendChild(option.cloneNode(true));
    });

    // 添加自定义分类
    this.customCategories.forEach(category => {
      const option = document.createElement('option');
      option.value = category;
      option.textContent = `⭐ ${category}`;
      categorySelect.appendChild(option);
    });

    // 恢复之前的选中值
    if (currentValue) {
      categorySelect.value = currentValue;
    }

    console.log(`📊 分类选择器已更新，包含 ${this.customCategories.length} 个自定义分类`);
  }

  // 显示智能建议
  showSmartSuggestions(text) {
    if (!text || text.length < 2) {
      this.hideSuggestions();
      return;
    }

    // 查找相似的历史活动
    const suggestions = this.activities
      .filter(activity => activity.activity.toLowerCase().includes(text.toLowerCase()))
      .map(activity => activity.activity)
      .filter((value, index, self) => self.indexOf(value) === index)
      .slice(0, 5);

    if (suggestions.length > 0) {
      this.displaySuggestions(suggestions);
    } else {
      this.hideSuggestions();
    }
  }

  displaySuggestions(suggestions) {
    const container = document.getElementById('smartSuggestions');
    if (!container) return;

    container.innerHTML = suggestions
      .map(suggestion => `<div class="suggestion-item" data-suggestion="${suggestion}">${suggestion}</div>`)
      .join('');

    container.style.display = 'block';

    // 添加点击事件
    container.querySelectorAll('.suggestion-item').forEach(item => {
      item.addEventListener('click', (e) => {
        const suggestion = e.target.dataset.suggestion;
        document.getElementById('activityInput').value = suggestion;
        this.hideSuggestions();
      });
    });
  }

  hideSuggestions() {
    const container = document.getElementById('smartSuggestions');
    if (container) {
      container.style.display = 'none';
    }
  }

  // 计时器
  startTimer() {
    this.timer = setInterval(() => {
      if (this.currentActivity && !this.currentActivity.isPaused) {
        const duration = Math.floor((new Date() - this.currentActivity.startTime) / 1000);
        this.updateTimerDisplay(duration);
      }
    }, 1000);
  }

  stopTimer() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  updateTimerDisplay(seconds) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;

    const timeString = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;

    const durationElement = document.querySelector('.activity-duration');
    if (durationElement) {
      durationElement.textContent = timeString;
    }
  }

  // 更新UI
  updateUI() {
    this.updateCurrentActivityDisplay();
    this.updateTodayOverview();
  }

  updateCurrentActivityDisplay() {
    const activityNameElement = document.querySelector('.activity-name');
    const endBtn = document.getElementById('endActivity');
    const pauseBtn = document.getElementById('pauseActivity');

    if (this.currentActivity) {
      if (activityNameElement) {
        activityNameElement.textContent = this.currentActivity.activity;
      }
      if (endBtn) endBtn.disabled = false;
      if (pauseBtn) {
        pauseBtn.disabled = false;
        // 根据暂停状态更新按钮文本和样式
        if (this.currentActivity.isPaused) {
          pauseBtn.textContent = '▶️ 继续';
          pauseBtn.classList.remove('btn-pause');
          pauseBtn.classList.add('btn-resume');
        } else {
          pauseBtn.textContent = '⏸️ 暂停';
          pauseBtn.classList.remove('btn-resume');
          pauseBtn.classList.add('btn-pause');
        }
      }
    } else {
      if (activityNameElement) {
        activityNameElement.textContent = '暂无活动';
      }
      if (endBtn) endBtn.disabled = true;
      if (pauseBtn) {
        pauseBtn.disabled = true;
        pauseBtn.textContent = '⏸️ 暂停';
        pauseBtn.classList.remove('btn-resume');
        pauseBtn.classList.add('btn-pause');
      }

      const durationElement = document.querySelector('.activity-duration');
      if (durationElement) {
        durationElement.textContent = '00:00:00';
      }
    }
  }

  updateTodayOverview() {
    const today = new Date().toISOString().split('T')[0];
    const todayActivities = this.activities.filter(activity => activity.date === today);

    // 更新统计
    const totalTime = todayActivities.reduce((sum, activity) => sum + activity.duration, 0);
    const activityCount = todayActivities.length;

    const totalTimeElement = document.getElementById('totalTime');
    const activityCountElement = document.getElementById('activityCount');

    if (totalTimeElement) {
      const hours = Math.floor(totalTime / 60);
      const minutes = totalTime % 60;
      totalTimeElement.textContent = `${hours}小时${minutes}分钟`;
    }

    if (activityCountElement) {
      activityCountElement.textContent = activityCount;
    }

    // 更新活动时间线
    this.updateActivityTimeline(todayActivities);
  }

  updateActivityTimeline(activities) {
    const timeline = document.getElementById('activityTimeline');
    if (!timeline) return;

    if (activities.length === 0) {
      timeline.innerHTML = '<p class="no-activities">今天还没有记录任何活动</p>';
      return;
    }

    timeline.innerHTML = activities
      .reverse()
      .map(activity => `
                <div class="timeline-item" data-category="${activity.category}" data-id="${activity.id}">
                    <div class="timeline-time">
                        ${new Date(activity.startTime).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })}
                        -
                        ${new Date(activity.endTime).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })}
                    </div>
                    <div class="timeline-content">
                        <span class="timeline-category">${activity.category}</span>
                        <span class="timeline-activity">${activity.activity}</span>
                        <span class="timeline-duration">${activity.duration}分钟</span>
                    </div>
                    <div class="timeline-actions">
                        <button class="btn-icon btn-edit" onclick="window.smartActivityTracker.editActivity('${activity.id}')" title="编辑">✏️</button>
                        <button class="btn-icon btn-delete" onclick="window.smartActivityTracker.deleteActivity('${activity.id}')" title="删除">🗑️</button>
                    </div>
                </div>
            `)
      .join('');
  }

  // 通知
  showNotification(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);

    // 使用现有的toast通知系统
    if (typeof notificationManager !== 'undefined') {
      notificationManager.showToast(message);
    }
  }

  // 数据持久化
  loadActivities() {
    try {
      const data = localStorage.getItem('activities');
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('加载活动数据失败:', error);
      return [];
    }
  }

  saveActivities() {
    try {
      localStorage.setItem('activities', JSON.stringify(this.activities));
    } catch (error) {
      console.error('保存活动数据失败:', error);
    }
  }

  loadProjects() {
    try {
      const data = localStorage.getItem('activityTracker_projects');
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('加载项目数据失败:', error);
      return [];
    }
  }

  saveProjects() {
    try {
      localStorage.setItem('activityTracker_projects', JSON.stringify(this.projects));
    } catch (error) {
      console.error('保存项目数据失败:', error);
    }
  }

  loadCustomCategories() {
    try {
      const data = localStorage.getItem('activityTracker_customCategories');
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('加载自定义分类失败:', error);
      return [];
    }
  }

  saveCustomCategories() {
    try {
      localStorage.setItem('activityTracker_customCategories', JSON.stringify(this.customCategories));
    } catch (error) {
      console.error('保存自定义分类失败:', error);
    }
  }

  // ==================== 新功能：编辑、删除、手动添加活动 ====================

  // 编辑活动
  editActivity(activityId) {
    const activity = this.activities.find(a => a.id === activityId);
    if (!activity) {
      this.showNotification('活动不存在', 'error');
      return;
    }

    // 创建编辑对话框
    const modal = document.createElement('div');
    modal.className = 'modal-overlay';
    
    // 生成项目选项
    const projectOptions = this.projects
      .filter(p => p.status === 'active')
      .map(p => `<option value="${p.id}" ${activity.project === p.id ? 'selected' : ''}>${p.name}</option>`)
      .join('');
    
    modal.innerHTML = `
      <div class="modal-content">
        <div class="modal-header">
          <h3>✏️ 编辑活动</h3>
          <button class="modal-close" onclick="this.closest('.modal-overlay').remove()">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>活动内容：</label>
            <input type="text" id="editActivityText" class="input-field" value="${activity.activity}" required>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>分类：</label>
              <select id="editCategory" class="select-input">
                <option value="工作" ${activity.category === '工作' ? 'selected' : ''}>💼 工作</option>
                <option value="学习" ${activity.category === '学习' ? 'selected' : ''}>📚 学习</option>
                <option value="运动" ${activity.category === '运动' ? 'selected' : ''}>🏃 运动</option>
                <option value="娱乐" ${activity.category === '娱乐' ? 'selected' : ''}>🎮 娱乐</option>
                <option value="生活" ${activity.category === '生活' ? 'selected' : ''}>🏠 生活</option>
              </select>
            </div>
            <div class="form-group">
              <label>关联项目：</label>
              <select id="editProject" class="select-input">
                <option value="">无关联项目</option>
                ${projectOptions}
              </select>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>开始时间：</label>
              <div class="time-picker-group">
                <select id="editStartHour" class="time-select">
                  ${this.generateHourOptions()}
                </select>
                <span class="time-separator">:</span>
                <select id="editStartMinute" class="time-select">
                  ${this.generateMinuteOptions()}
                </select>
              </div>
            </div>
            <div class="form-group">
              <label>结束时间：</label>
              <div class="time-picker-group">
                <select id="editEndHour" class="time-select">
                  ${this.generateHourOptions()}
                </select>
                <span class="time-separator">:</span>
                <select id="editEndMinute" class="time-select">
                  ${this.generateMinuteOptions()}
                </select>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="this.closest('.modal-overlay').remove()">取消</button>
          <button class="btn btn-primary" onclick="window.smartActivityTracker.saveActivityEdit('${activityId}')">保存</button>
        </div>
      </div>
    `;

    document.body.appendChild(modal);
    
    // 设置当前时间到下拉选择器
    const startDate = new Date(activity.startTime);
    const endDate = new Date(activity.endTime);
    document.getElementById('editStartHour').value = startDate.getHours().toString().padStart(2, '0');
    document.getElementById('editStartMinute').value = (Math.floor(startDate.getMinutes() / 5) * 5).toString().padStart(2, '0');
    document.getElementById('editEndHour').value = endDate.getHours().toString().padStart(2, '0');
    document.getElementById('editEndMinute').value = (Math.floor(endDate.getMinutes() / 5) * 5).toString().padStart(2, '0');
  }

  // 保存活动编辑
  saveActivityEdit(activityId) {
    const activity = this.activities.find(a => a.id === activityId);
    if (!activity) return;

    const activityText = document.getElementById('editActivityText').value.trim();
    const category = document.getElementById('editCategory').value;
    const project = document.getElementById('editProject').value || null;
    
    // 从下拉选择器获取时间
    const startHour = parseInt(document.getElementById('editStartHour').value);
    const startMinute = parseInt(document.getElementById('editStartMinute').value);
    const endHour = parseInt(document.getElementById('editEndHour').value);
    const endMinute = parseInt(document.getElementById('editEndMinute').value);

    if (!activityText) {
      this.showNotification('请填写完整信息', 'warning');
      return;
    }

    // 更新活动数据
    const startDate = new Date(activity.startTime);
    const endDate = new Date(activity.endTime);

    startDate.setHours(startHour, startMinute);
    endDate.setHours(endHour, endMinute);

    // 验证时间逻辑
    if (endDate <= startDate) {
      this.showNotification('结束时间必须晚于开始时间', 'warning');
      return;
    }

    activity.activity = activityText;
    activity.category = category;
    activity.project = project;
    activity.startTime = startDate.toISOString();
    activity.endTime = endDate.toISOString();
    activity.duration = Math.round((endDate - startDate) / 60000); // 分钟
    activity.date = startDate.toISOString().split('T')[0]; // 更新日期字段

    this.saveActivities();
    this.updateUI();

    // 关闭对话框
    document.querySelector('.modal-overlay').remove();
    this.showNotification('活动已更新', 'success');
  }

  // 删除活动
  deleteActivity(activityId) {
    const activity = this.activities.find(a => a.id === activityId);
    if (!activity) {
      this.showNotification('活动不存在', 'error');
      return;
    }

    // 创建确认对话框
    const modal = document.createElement('div');
    modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content modal-sm">
        <div class="modal-header">
          <h3>🗑️ 删除活动</h3>
          <button class="modal-close" onclick="this.closest('.modal-overlay').remove()">✕</button>
        </div>
        <div class="modal-body">
          <p>确定要删除这个活动吗？</p>
          <p class="text-secondary">${activity.activity} (${activity.duration}分钟)</p>
          <p class="text-danger">此操作不可撤销！</p>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="this.closest('.modal-overlay').remove()">取消</button>
          <button class="btn btn-danger" onclick="window.smartActivityTracker.confirmDeleteActivity('${activityId}')">删除</button>
        </div>
      </div>
    `;

    document.body.appendChild(modal);
  }

  // 确认删除活动
  confirmDeleteActivity(activityId) {
    this.activities = this.activities.filter(a => a.id !== activityId);
    this.saveActivities();
    this.updateUI();

    // 关闭对话框
    document.querySelector('.modal-overlay').remove();
    this.showNotification('活动已删除', 'success');
  }

  // 生成小时选项（00-23）
  generateHourOptions() {
    let options = '';
    for (let i = 0; i < 24; i++) {
      const hour = i.toString().padStart(2, '0');
      options += `<option value="${hour}">${hour}</option>`;
    }
    return options;
  }

  // 生成分钟选项（00-59，每5分钟）
  generateMinuteOptions() {
    let options = '';
    for (let i = 0; i < 60; i += 5) {
      const minute = i.toString().padStart(2, '0');
      options += `<option value="${minute}">${minute}</option>`;
    }
    return options;
  }

  // 手动添加历史活动
  addManualActivity() {
    // 创建添加对话框
    const modal = document.createElement('div');
    modal.className = 'modal-overlay';
    const today = new Date().toISOString().split('T')[0];
    
    // 生成项目选项
    const projectOptions = this.projects
      .filter(p => p.status === 'active')
      .map(p => `<option value="${p.id}">${p.name}</option>`)
      .join('');

    modal.innerHTML = `
      <div class="modal-content">
        <div class="modal-header">
          <h3>➕ 手动添加活动</h3>
          <button class="modal-close" onclick="this.closest('.modal-overlay').remove()">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>活动内容：</label>
            <input type="text" id="manualActivityText" class="input-field" placeholder="做了什么..." required>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>分类：</label>
              <select id="manualCategory" class="select-input">
                <option value="工作">💼 工作</option>
                <option value="学习">📚 学习</option>
                <option value="运动">🏃 运动</option>
                <option value="娱乐">🎮 娱乐</option>
                <option value="生活">🏠 生活</option>
              </select>
            </div>
            <div class="form-group">
              <label>关联项目：</label>
              <select id="manualProject" class="select-input">
                <option value="">无关联项目</option>
                ${projectOptions}
              </select>
            </div>
          </div>
          <div class="form-group">
            <label>日期：</label>
            <input type="date" id="manualDate" class="input-field" value="${today}" required>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>开始时间：</label>
              <div class="time-picker-group">
                <select id="manualStartHour" class="time-select">
                  ${this.generateHourOptions()}
                </select>
                <span class="time-separator">:</span>
                <select id="manualStartMinute" class="time-select">
                  ${this.generateMinuteOptions()}
                </select>
              </div>
            </div>
            <div class="form-group">
              <label>结束时间：</label>
              <div class="time-picker-group">
                <select id="manualEndHour" class="time-select">
                  ${this.generateHourOptions()}
                </select>
                <span class="time-separator">:</span>
                <select id="manualEndMinute" class="time-select">
                  ${this.generateMinuteOptions()}
                </select>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="this.closest('.modal-overlay').remove()">取消</button>
          <button class="btn btn-primary" onclick="window.smartActivityTracker.saveManualActivity()">添加</button>
        </div>
      </div>
    `;

    document.body.appendChild(modal);
    
    // 添加实时智能推荐功能
    const activityInput = document.getElementById('manualActivityText');
    const projectSelect = document.getElementById('manualProject');
    
    if (activityInput && projectSelect) {
      activityInput.addEventListener('input', () => {
        const activityText = activityInput.value.trim();
        if (activityText.length >= 2) {
          const recommendedProjectId = this.findRelatedProject(activityText);
          if (recommendedProjectId) {
            projectSelect.value = recommendedProjectId;
            // 添加推荐提示样式
            projectSelect.style.borderColor = '#667eea';
            projectSelect.style.boxShadow = '0 0 0 3px rgba(102, 126, 234, 0.1)';
          } else {
            projectSelect.value = '';
            projectSelect.style.borderColor = '';
            projectSelect.style.boxShadow = '';
          }
        }
      });
    }
  }

  // 保存手动添加的活动
  saveManualActivity() {
    const activityText = document.getElementById('manualActivityText').value.trim();
    const category = document.getElementById('manualCategory').value;
    const project = document.getElementById('manualProject').value || null;
    const date = document.getElementById('manualDate').value;
    
    // 从下拉选择器获取时间
    const startHour = document.getElementById('manualStartHour').value;
    const startMinute = document.getElementById('manualStartMinute').value;
    const endHour = document.getElementById('manualEndHour').value;
    const endMinute = document.getElementById('manualEndMinute').value;

    if (!activityText || !date || !startHour || !startMinute || !endHour || !endMinute) {
      this.showNotification('请填写完整信息', 'warning');
      return;
    }

    // 构建时间字符串
    const startTime = `${startHour}:${startMinute}`;
    const endTime = `${endHour}:${endMinute}`;

    // 构建日期时间
    const startDateTime = new Date(`${date}T${startTime}`);
    const endDateTime = new Date(`${date}T${endTime}`);

    // 验证时间逻辑
    if (endDateTime <= startDateTime) {
      this.showNotification('结束时间必须晚于开始时间', 'warning');
      return;
    }

    // 创建新活动
    const newActivity = {
      id: Date.now().toString(),
      activity: activityText,
      category: category,
      startTime: startDateTime.toISOString(),
      endTime: endDateTime.toISOString(),
      duration: Math.round((endDateTime - startDateTime) / 60000),
      date: date, // 添加日期字段用于筛选
      project: project
    };

    this.activities.push(newActivity);
    this.saveActivities();
    this.updateUI();

    // 关闭对话框
    document.querySelector('.modal-overlay').remove();
    this.showNotification('活动已添加', 'success');
  }
}

// 暴露类供 app-main.js 统一初始化
window.SmartActivityTracker = SmartActivityTracker;

