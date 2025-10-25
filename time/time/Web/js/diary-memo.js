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
    // 保存日记按钮
    const saveDiaryBtn = document.getElementById('saveDiary');
    if (saveDiaryBtn) {
      saveDiaryBtn.addEventListener('click', () => this.saveDiary());
    }

    // 添加备忘录按钮
    const addMemoBtn = document.getElementById('addMemo');
    if (addMemoBtn) {
      addMemoBtn.addEventListener('click', () => this.addMemo());
    }

    // 备忘录输入框回车事件
    const memoInput = document.getElementById('memoInput');
    if (memoInput) {
      memoInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
          this.addMemo();
        }
      });
    }
  }

  // 保存日记
  saveDiary() {
    const content = document.getElementById('diaryContent')?.value;
    const mood = document.getElementById('moodSelect')?.value || '😊';
    const date = document.getElementById('diaryDate')?.textContent || new Date().toISOString().split('T')[0];

    if (!content || !content.trim()) {
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

    this.saveDiariesData();

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
    this.saveMemosData();

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
    this.saveMemosData();
    this.updateMemosList();

    console.log('✅ 备忘录状态已更新');
  }

  // 删除备忘录
  deleteMemo(memoId) {
    this.memos = this.memos.filter(m => m.id !== memoId);
    this.saveMemosData();
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
    console.log('📖 渲染历史日记列表');

    const container = document.getElementById('diaryList');
    console.log('🔍 查找日记列表容器:', container ? '找到' : '未找到');

    if (!container) {
      console.warn('⚠️ 日记列表容器不存在，尝试创建...');
      // 如果容器不存在，尝试找到父容器并添加
      const diarySection = document.querySelector('.diary-history-card');
      if (diarySection) {
        const newContainer = document.createElement('div');
        newContainer.className = 'diary-list';
        newContainer.id = 'diaryList';
        diarySection.appendChild(newContainer);
        console.log('✅ 已创建日记列表容器');
        return this.renderDiaryList(); // 递归调用
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

    container.innerHTML = sortedDiaries.map(diary => `
      <div class="diary-item">
        <div class="diary-item-header">
          <h4>${diary.title || '日记'}</h4>
          <span class="diary-date">${this.formatDate(new Date(diary.date))}</span>
        </div>
        <div class="diary-mood">${diary.mood || '😊'}</div>
        <div class="diary-preview">${(diary.content || '').substring(0, 100)}${diary.content && diary.content.length > 100 ? '...' : ''}</div>
        ${diary.tags && diary.tags.length > 0 ? `
          <div class="diary-tags">
            ${diary.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
          </div>
        ` : ''}
      </div>
    `).join('');

    console.log(`✅ 已渲染 ${sortedDiaries.length} 篇日记`);
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
                        <button class="btn-delete" onclick="diaryMemoManager.deleteMemo('${memo.id}')">🗑️</button>
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

