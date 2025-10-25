// ==================== 智能活动记录系统 ====================

class SmartActivityTracker {
  constructor() {
    this.currentActivity = null;
    this.activities = this.loadActivities();
    this.customCategories = this.loadCustomCategories();
    this.projects = this.loadProjects();
    this.timer = null;
    this.init();
  }

  init() {
    console.log('🧠 智能活动记录系统初始化');
    this.setupEventListeners();
    this.updateUI();
  }

  setupEventListeners() {
    // 开始记录按钮
    const startBtn = document.getElementById('startActivity');
    if (startBtn) {
      startBtn.addEventListener('click', () => this.handleStartActivity());
    }

    // 结束活动按钮
    const endBtn = document.getElementById('endActivity');
    if (endBtn) {
      endBtn.addEventListener('click', () => this.handleEndActivity());
    }

    // 暂停/继续按钮
    const pauseBtn = document.getElementById('pauseActivity');
    if (pauseBtn) {
      pauseBtn.addEventListener('click', () => this.handlePauseActivity());
    }

    // 活动输入框实时建议
    const activityInput = document.getElementById('activityInput');
    if (activityInput) {
      activityInput.addEventListener('input', (e) => {
        this.showSmartSuggestions(e.target.value);
      });
    }
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

  // 智能项目关联
  findRelatedProject(activityText) {
    const text = activityText.toLowerCase();

    for (const project of this.projects) {
      const projectName = project.name.toLowerCase();
      const projectTags = project.tags?.map(tag => tag.toLowerCase()) || [];

      if (text.includes(projectName) || projectTags.some(tag => text.includes(tag))) {
        return project.id;
      }
    }

    return null;
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
                <div class="timeline-item" data-category="${activity.category}">
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
}

// 导出单例
const smartActivityTracker = new SmartActivityTracker();

