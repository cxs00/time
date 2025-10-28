// ==================== 日记和备忘录系统 ====================

class DiaryMemoManager {
  constructor() {
    this.diaries = this.loadDiaries();
    this.memos = this.loadMemos();
    this.init();
  }

  init() {
    console.log('📖 日记和备忘录系统初始化');
    this.setupEventListeners();
    this.updateUI();
  }

  setupEventListeners() {
    console.log('🔧 [setupEventListeners] 绑定日记备忘录事件监听器...');

    // 保存日记按钮
    const saveDiaryBtn = document.getElementById('saveDiary');
    if (saveDiaryBtn) {
      saveDiaryBtn.addEventListener('click', () => {
        console.log('💾 [EVENT] 保存日记按钮被点击');
        this.saveDiary();
      });
      console.log('✅ [setupEventListeners] 保存日记按钮已绑定');
    } else {
      console.warn('⚠️ [setupEventListeners] 保存日记按钮未找到');
    }

    // AI 建议按钮
    const aiSuggestBtn = document.getElementById('aiSuggest');
    if (aiSuggestBtn) {
      aiSuggestBtn.addEventListener('click', () => {
        console.log('🤖 [EVENT] AI建议按钮被点击');
        this.generateAISuggestion();
      });
      console.log('✅ [setupEventListeners] AI建议按钮已绑定');
    } else {
      console.warn('⚠️ [setupEventListeners] AI建议按钮未找到');
    }

    // 添加备忘录按钮
    const addMemoBtn = document.getElementById('addMemo');
    if (addMemoBtn) {
      addMemoBtn.addEventListener('click', () => {
        console.log('📝 [EVENT] 添加备忘录按钮被点击');
        this.addMemo();
      });
      console.log('✅ [setupEventListeners] 添加备忘录按钮已绑定');
    } else {
      console.warn('⚠️ [setupEventListeners] 添加备忘录按钮未找到');
    }

    // 备忘录输入框回车事件
    const memoInput = document.getElementById('memoInput');
    if (memoInput) {
      memoInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
          console.log('⏎ [EVENT] 备忘录输入框回车');
          this.addMemo();
        }
      });
      console.log('✅ [setupEventListeners] 备忘录输入框回车已绑定');
    } else {
      console.warn('⚠️ [setupEventListeners] 备忘录输入框未找到');
    }

    console.log('✅ [setupEventListeners] 日记备忘录事件监听器绑定完成');
  }

  // 生成 AI 建议
  generateAISuggestion() {
    console.log('🤖 [generateAISuggestion] 生成AI建议');

    const contentElement = document.getElementById('diaryContent');
    console.log('🔍 [generateAISuggestion] 日记输入框:', contentElement);

    if (!contentElement) {
      console.error('❌ 日记内容输入框未找到');
      alert('⚠️ 日记输入框未找到，请确保在日记页面');
      return;
    }

    // 基于今天的活动生成建议
    console.log('🔍 [generateAISuggestion] 检查 smartActivityTracker:', window.smartActivityTracker);
    const activities = window.smartActivityTracker?.activities || [];
    console.log('🔍 [generateAISuggestion] 所有活动数量:', activities.length);

    const todayActivities = activities.filter(a => {
      const activityDate = new Date(a.startTime).toDateString();
      const today = new Date().toDateString();
      return activityDate === today;
    });

    console.log('📊 今天的活动数量:', todayActivities.length);

    let suggestion = '';

    if (todayActivities.length === 0) {
      suggestion = '今天还没有记录任何活动。建议：\n\n';
      suggestion += '• 记录一下今天做了什么\n';
      suggestion += '• 分享今天的心情和感受\n';
      suggestion += '• 写下明天的计划和目标';
    } else {
      // 统计活动分类
      const categories = {};
      todayActivities.forEach(a => {
        categories[a.category] = (categories[a.category] || 0) + 1;
      });

      const mainCategory = Object.keys(categories).sort((a, b) => categories[b] - categories[a])[0];
      const totalDuration = todayActivities.reduce((sum, a) => sum + (a.duration || 0), 0);
      const hours = Math.floor(totalDuration / 60);
      const minutes = totalDuration % 60;

      suggestion = `今天记录了 ${todayActivities.length} 项活动，主要是「${mainCategory}」类活动。\n\n`;
      suggestion += `总计用时：${hours > 0 ? hours + '小时' : ''}${minutes}分钟\n\n`;
      suggestion += '建议记录：\n';
      suggestion += `• 今天在${mainCategory}方面的收获和感受\n`;
      suggestion += '• 遇到的挑战和解决方法\n';
      suggestion += '• 明天想要改进或继续的事项';
    }

    console.log('📝 [generateAISuggestion] 生成的建议长度:', suggestion.length);

    // 将建议添加到日记内容
    const currentContent = contentElement.value.trim();
    if (currentContent) {
      contentElement.value = currentContent + '\n\n---\n\n' + suggestion;
    } else {
      contentElement.value = suggestion;
    }

    console.log('✅ [generateAISuggestion] 建议已填充到输入框');

    // 显示通知
    if (typeof notificationManager !== 'undefined') {
      notificationManager.showToast('✨ AI建议已生成');
      console.log('✅ [generateAISuggestion] 通知已显示');
    } else {
      console.warn('⚠️ [generateAISuggestion] notificationManager 未定义');
      // 使用 alert 作为备用
      alert('✨ AI建议已生成');
    }

    console.log('✅ AI建议生成完成');
  }

  // 保存日记
  saveDiary() {
    console.log('💾 [saveDiary] 开始保存日记');

    const content = document.getElementById('diaryContent')?.value;
    const mood = document.getElementById('moodSelect')?.value || '😊';
    const date = document.getElementById('diaryDate')?.textContent || new Date().toISOString().split('T')[0];

    console.log('📝 日记内容长度:', content?.length || 0);
    console.log('😊 心情:', mood);
    console.log('📅 日期:', date);

    if (!content || !content.trim()) {
      console.warn('⚠️ 日记内容为空');
      if (typeof notificationManager !== 'undefined') {
        notificationManager.showToast('请输入日记内容');
      }
      return;
    }

    // 查找今天的日记
    const existingDiary = this.diaries.find(d => d.date === date);

    if (existingDiary) {
      // 更新现有日记
      existingDiary.content = content.trim();
      existingDiary.mood = mood;
      existingDiary.updatedAt = new Date();
    } else {
      // 创建新日记
      const diary = {
        id: Date.now().toString(),
        date: date,
        content: content.trim(),
        mood: mood,
        activities: [],
        tags: this.extractTags(content),
        createdAt: new Date(),
        updatedAt: new Date()
      };
      this.diaries.push(diary);
    }

    this.saveDiaries();

    // 刷新历史日记列表
    console.log('🔄 [saveDiary] 刷新历史日记列表...');
    this.renderDiaryList();

    if (typeof notificationManager !== 'undefined') {
      notificationManager.showToast('✅ 日记保存成功');
    }

    console.log('✅ 日记保存成功');
  }

  // 添加备忘录
  addMemo() {
    const input = document.getElementById('memoInput');
    if (!input || !input.value.trim()) {
      return;
    }

    const memo = {
      id: Date.now().toString(),
      content: input.value.trim(),
      priority: 'medium',
      isCompleted: false,
      createdAt: new Date()
    };

    this.memos.push(memo);
    this.saveMemos();

    input.value = '';
    this.updateMemosList();

    if (typeof notificationManager !== 'undefined') {
      notificationManager.showToast('✅ 备忘录已添加');
    }

    console.log('✅ 备忘录已添加:', memo);
  }

  // 切换备忘录完成状态
  toggleMemo(memoId) {
    const memo = this.memos.find(m => m.id === memoId);
    if (!memo) return;

    memo.isCompleted = !memo.isCompleted;
    this.saveMemos();
    this.updateMemosList();

    console.log('✅ 备忘录状态已更新');
  }

  // 删除备忘录
  deleteMemo(memoId) {
    this.memos = this.memos.filter(m => m.id !== memoId);
    this.saveMemos();
    this.updateMemosList();

    console.log('✅ 备忘录已删除');
  }

  // 提取标签
  extractTags(content) {
    const tags = [];
    const words = content.split(/[\s,，。！？、]+/);

    words.forEach(word => {
      if (word.length >= 2 && word.length <= 10) {
        tags.push(word);
      }
    });

    return tags.slice(0, 10);
  }

  // 更新UI
  updateUI() {
    console.log('📖 更新日记UI');
    console.log(`📊 当前日记数量: ${this.diaries.length}`);
    console.log(`📊 当前备忘录数量: ${this.memos.length}`);
    this.loadTodayDiary();
    this.updateMemosList();
    this.renderDiaryList();  // 添加历史日记列表渲染
  }

  // 渲染历史日记列表
  renderDiaryList() {
    console.log('📖 渲染历史日记列表（方案5：双层卡片效果）');

    const container = document.getElementById('diaryList');
    console.log('🔍 查找日记列表容器:', container ? '找到' : '未找到');

    if (!container) {
      console.warn('⚠️ 日记列表容器不存在，尝试创建...');
      const diarySection = document.querySelector('.diary-history-card');
      if (diarySection) {
        const newContainer = document.createElement('div');
        newContainer.className = 'diary-list';
        newContainer.id = 'diaryList';
        diarySection.appendChild(newContainer);
        console.log('✅ 已创建日记列表容器');
        return this.renderDiaryList();
      } else {
        console.error('❌ 无法找到日记历史卡片容器');
        return;
      }
    }

    if (this.diaries.length === 0) {
      container.innerHTML = '<p class="no-diaries">还没有写任何日记</p>';
      console.log('📝 显示空日记提示');
      return;
    }

    // 按日期倒序排列
    const sortedDiaries = [...this.diaries].sort((a, b) =>
      new Date(b.date) - new Date(a.date)
    );

    // 简洁卡片结构（与项目卡片一致）
    container.innerHTML = sortedDiaries.map((diary, index) => `
      <div class="diary-item" data-diary-id="${diary.id || index}">
        <div class="diary-item-header">
          <h4>${diary.title || '无标题日记'}</h4>
          <div class="diary-item-actions">
            <button class="btn-edit-diary" onclick="window.diaryMemoManager.editDiary(${index})">✏️ 编辑</button>
            <button class="btn-delete-diary" onclick="window.diaryMemoManager.deleteDiary(${index})">🗑️ 删除</button>
          </div>
        </div>
        <div>
          <span class="diary-date">${diary.date}</span>
          <span class="diary-mood">${diary.mood || '😊'}</span>
        </div>
        <div class="diary-content">${diary.content || '暂无内容'}</div>
        ${diary.tags && diary.tags.length > 0 ? `
          <div class="diary-tags">
            ${diary.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
          </div>
        ` : ''}
      </div>
    `).join('');

    console.log(`✅ 已渲染 ${sortedDiaries.length} 篇日记（简洁卡片样式）`);
  }

  // 编辑日记
  editDiary(index) {
    console.log(`✏️ 编辑日记: ${index}`);
    const sortedDiaries = [...this.diaries].sort((a, b) =>
      new Date(b.date) - new Date(a.date)
    );
    const diary = sortedDiaries[index];

    if (!diary) {
      console.error('❌ 日记不存在');
      return;
    }

    // 切换到日记页面
    const diaryTab = document.querySelector('[data-page="diary"]');
    if (diaryTab) {
      diaryTab.click();
    }

    // 填充到今日日记编辑器
    setTimeout(() => {
      const contentElement = document.getElementById('diaryContent');
      const moodElement = document.getElementById('moodSelect');

      if (contentElement) {
        contentElement.value = diary.content || '';
      }
      if (moodElement) {
        moodElement.value = diary.mood || '😊';
      }

      // 滚动到今日日记区域
      const diaryCard = document.querySelector('.diary-card');
      if (diaryCard) {
        diaryCard.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }

      alert(`✏️ 正在编辑：${diary.title || '日记'}\n\n编辑完成后点击"💾 保存"按钮保存修改`);
    }, 100);
  }

  // 删除日记
  deleteDiary(index) {
    console.log(`🗑️ 删除日记: ${index}`);
    const sortedDiaries = [...this.diaries].sort((a, b) =>
      new Date(b.date) - new Date(a.date)
    );
    const diary = sortedDiaries[index];

    if (!diary) {
      console.error('❌ 日记不存在');
      return;
    }

    if (confirm(`🗑️ 确定要删除「${diary.title || '日记'}」吗？\n\n⚠️ 删除后无法恢复！`)) {
      // 从原始数组中找到并删除
      const originalIndex = this.diaries.findIndex(d => d.date === diary.date);
      if (originalIndex !== -1) {
        this.diaries.splice(originalIndex, 1);
        this.saveDiaries();
        this.renderDiaryList();
        console.log('✅ 日记已删除');
        alert('✅ 日记已成功删除！');
      }
    }
  }

  // 加载今天的日记
  loadTodayDiary() {
    const today = new Date().toISOString().split('T')[0];
    const todayDiary = this.diaries.find(d => d.date === today);

    const contentElement = document.getElementById('diaryContent');
    const moodElement = document.getElementById('moodSelect');
    const dateElement = document.getElementById('diaryDate');

    if (dateElement) {
      dateElement.textContent = today;
    }

    if (todayDiary) {
      if (contentElement) {
        contentElement.value = todayDiary.content;
      }
      if (moodElement) {
        moodElement.value = todayDiary.mood;
      }
    } else {
      if (contentElement) {
        contentElement.value = '';
      }
      if (moodElement) {
        moodElement.value = '😊';
      }
    }
  }

  // 更新备忘录列表
  updateMemosList() {
    const container = document.getElementById('memoList');
    if (!container) return;

    if (this.memos.length === 0) {
      container.innerHTML = '<p class="no-memos">还没有添加任何备忘录</p>';
      return;
    }

    // 按创建时间倒序排列
    const sortedMemos = this.memos.sort((a, b) =>
      new Date(b.createdAt) - new Date(a.createdAt)
    );

    container.innerHTML = sortedMemos
      .map(memo => `
                <div class="memo-item ${memo.isCompleted ? 'completed' : ''}" data-memo-id="${memo.id}">
                    <div class="memo-checkbox">
                        <input type="checkbox"
                               ${memo.isCompleted ? 'checked' : ''}
                               onchange="diaryMemoManager.toggleMemo('${memo.id}')">
                    </div>
                    <div class="memo-content">
                        <span class="memo-text">${memo.content}</span>
                        <span class="memo-time">${this.formatTime(memo.createdAt)}</span>
                    </div>
                    <div class="memo-actions">
                        <button class="btn btn-delete" onclick="diaryMemoManager.deleteMemo('${memo.id}')">🗑️</button>
                    </div>
                </div>
            `)
      .join('');
  }

  // 格式化日期
  formatDate(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // 格式化时间
  formatTime(date) {
    const d = new Date(date);
    const now = new Date();
    const diffMs = now - d;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) return '刚刚';
    if (diffMins < 60) return `${diffMins}分钟前`;
    if (diffHours < 24) return `${diffHours}小时前`;
    if (diffDays < 7) return `${diffDays}天前`;

    return d.toLocaleDateString('zh-CN');
  }

  // 数据持久化
  loadDiaries() {
    try {
      const data = localStorage.getItem('activityTracker_diary');
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('加载日记数据失败:', error);
      return [];
    }
  }

  saveDiaries() {
    try {
      localStorage.setItem('activityTracker_diary', JSON.stringify(this.diaries));
    } catch (error) {
      console.error('保存日记数据失败:', error);
    }
  }

  loadMemos() {
    try {
      const data = localStorage.getItem('activityTracker_memos');
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('加载备忘录数据失败:', error);
      return [];
    }
  }

  saveMemos() {
    try {
      localStorage.setItem('activityTracker_memos', JSON.stringify(this.memos));
    } catch (error) {
      console.error('保存备忘录数据失败:', error);
    }
  }
}

// 导出单例
const diaryMemoManager = new DiaryMemoManager();

