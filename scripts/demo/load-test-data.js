// ==================== Activity Tracker 测试数据加载器 ====================

class TestDataLoader {
  constructor() {
    this.testData = {
      activities: [],
      projects: [],
      diary: [],
      memos: []
    };
    this.loadTestData();
  }

  loadTestData() {
    console.log('📊 加载Activity Tracker测试数据...');

    // 生成今日活动数据
    this.generateTodayActivities();

    // 生成项目数据
    this.generateTestProjects();

    // 生成日记数据
    this.generateTestDiary();

    // 生成备忘录数据
    this.generateTestMemos();

    // 保存到LocalStorage
    this.saveToLocalStorage();

    console.log('✅ 测试数据加载完成！');
    this.displayDataSummary();
  }

  generateTodayActivities() {
    const today = new Date();
    const todayActivities = [
      { text: '编写React组件', category: '工作', duration: 120, startTime: '09:00', efficiency: 85 },
      { text: '阅读技术文档', category: '学习', duration: 60, startTime: '10:30', efficiency: 90 },
      { text: '跑步锻炼', category: '运动', duration: 45, startTime: '12:00', efficiency: 95 },
      { text: '午餐休息', category: '生活', duration: 30, startTime: '12:45', efficiency: 100 },
      { text: '开会讨论需求', category: '工作', duration: 90, startTime: '14:00', efficiency: 80 },
      { text: '练习钢琴', category: '学习', duration: 60, startTime: '16:00', efficiency: 88 },
      { text: '看电影放松', category: '娱乐', duration: 90, startTime: '20:00', efficiency: 100 },
      { text: '整理桌面', category: '生活', duration: 15, startTime: '21:30', efficiency: 95 }
    ];

    todayActivities.forEach((activity, index) => {
      const startTime = new Date(today);
      const [hours, minutes] = activity.startTime.split(':');
      startTime.setHours(parseInt(hours), parseInt(minutes), 0, 0);

      const endTime = new Date(startTime);
      endTime.setMinutes(endTime.getMinutes() + activity.duration);

      this.testData.activities.push({
        id: `today_${index + 1}`,
        text: activity.text,
        category: activity.category,
        startTime: startTime,
        endTime: endTime,
        duration: activity.duration,
        efficiency: activity.efficiency,
        mood: this.getRandomMood(),
        tags: this.generateTags(activity.category),
        project: this.getRelatedProject(activity.category)
      });
    });
  }

  generateTestProjects() {
    this.testData.projects = [
      {
        id: 1,
        name: '前端开发项目',
        description: 'React应用开发',
        startDate: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
        targetDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        progress: 75,
        priority: 'high',
        status: 'active',
        milestones: [
          { name: '需求分析', completed: true, date: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000) },
          { name: 'UI设计', completed: true, date: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) },
          { name: '核心功能开发', completed: false, date: null },
          { name: '测试优化', completed: false, date: null }
        ],
        totalTime: 480,
        completedTime: 360,
        teamMembers: ['张三', '李四'],
        technologies: ['React', 'TypeScript', 'Tailwind CSS']
      },
      {
        id: 2,
        name: '技能提升计划',
        description: '学习新技术',
        startDate: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000),
        targetDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000),
        progress: 40,
        priority: 'medium',
        status: 'active',
        milestones: [
          { name: '基础知识学习', completed: true, date: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000) },
          { name: '实践项目', completed: false, date: null },
          { name: '总结分享', completed: false, date: null }
        ],
        totalTime: 200,
        completedTime: 80,
        teamMembers: ['自己'],
        technologies: ['Vue.js', 'Node.js', 'MongoDB']
      },
      {
        id: 3,
        name: '健康管理',
        description: '保持身体健康',
        startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
        targetDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        progress: 60,
        priority: 'medium',
        status: 'active',
        milestones: [
          { name: '建立运动习惯', completed: true, date: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000) },
          { name: '改善饮食', completed: true, date: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000) },
          { name: '保持规律作息', completed: false, date: null }
        ],
        totalTime: 300,
        completedTime: 180,
        teamMembers: ['自己'],
        technologies: ['跑步', '瑜伽', '健康饮食']
      }
    ];
  }

  generateTestDiary() {
    const diaryEntries = [
      {
        mood: 'productive',
        content: '今天完成了React组件的开发，感觉很有成就感。学习了一些新的Hook用法，对函数式组件有了更深的理解。',
        tags: ['工作', '学习', '成就感']
      },
      {
        mood: 'happy',
        content: '今天和朋友一起跑步，天气很好，心情也很棒。运动真的能让人心情变好。',
        tags: ['运动', '朋友', '好心情']
      },
      {
        mood: 'focused',
        content: '专注学习了3个小时的新技术，虽然有点累，但是收获很大。明天继续深入学习。',
        tags: ['学习', '专注', '收获']
      }
    ];

    diaryEntries.forEach((entry, index) => {
      const date = new Date();
      date.setDate(date.getDate() - index);

      this.testData.diary.push({
        id: `diary_${index + 1}`,
        date: date,
        mood: entry.mood,
        content: entry.content,
        tags: entry.tags,
        weather: this.getRandomWeather(),
        location: this.getRandomLocation()
      });
    });
  }

  generateTestMemos() {
    this.testData.memos = [
      {
        id: 1,
        content: '完成项目文档编写',
        priority: 'high',
        completed: false,
        dueDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000),
        created: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
        category: '工作',
        tags: ['文档', '项目']
      },
      {
        id: 2,
        content: '学习TypeScript高级特性',
        priority: 'medium',
        completed: false,
        dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        created: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
        category: '学习',
        tags: ['TypeScript', '技能']
      },
      {
        id: 3,
        content: '整理桌面文件',
        priority: 'low',
        completed: true,
        dueDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
        completedDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
        created: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
        category: '生活',
        tags: ['整理', '桌面']
      },
      {
        id: 4,
        content: '准备下周的会议材料',
        priority: 'high',
        completed: false,
        dueDate: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000),
        created: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
        category: '工作',
        tags: ['会议', '准备']
      },
      {
        id: 5,
        content: '购买运动装备',
        priority: 'medium',
        completed: false,
        dueDate: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000),
        created: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
        category: '生活',
        tags: ['购物', '运动']
      }
    ];
  }

  getRandomMood() {
    const moods = ['productive', 'happy', 'tired', 'focused', 'relaxed'];
    return moods[Math.floor(Math.random() * moods.length)];
  }

  generateTags(category) {
    const tagMap = {
      '工作': ['编程', '开发', '会议'],
      '学习': ['阅读', '练习', '研究'],
      '运动': ['跑步', '健身', '瑜伽'],
      '娱乐': ['电影', '音乐', '游戏'],
      '生活': ['购物', '做饭', '休息']
    };
    return tagMap[category] || ['其他'];
  }

  getRelatedProject(category) {
    if (category === '工作') return '前端开发项目';
    if (category === '学习') return '技能提升计划';
    if (category === '运动') return '健康管理';
    return null;
  }

  getRandomWeather() {
    const weathers = ['晴天', '多云', '小雨', '阴天'];
    return weathers[Math.floor(Math.random() * weathers.length)];
  }

  getRandomLocation() {
    const locations = ['家里', '办公室', '咖啡厅', '公园', '健身房'];
    return locations[Math.floor(Math.random() * locations.length)];
  }

  displayDataSummary() {
    console.log('\n📊 测试数据统计:');
    console.log(`📝 今日活动: ${this.testData.activities.length} 条`);
    console.log(`🎯 项目: ${this.testData.projects.length} 个`);
    console.log(`📖 日记: ${this.testData.diary.length} 篇`);
    console.log(`📋 备忘录: ${this.testData.memos.length} 条`);

    console.log('\n📈 今日活动分类统计:');
    const categoryStats = {};
    this.testData.activities.forEach(activity => {
      categoryStats[activity.category] = (categoryStats[activity.category] || 0) + 1;
    });
    Object.entries(categoryStats).forEach(([category, count]) => {
      console.log(`  ${category}: ${count} 次`);
    });

    console.log('\n⏱️ 今日总活动时间:');
    const totalMinutes = this.testData.activities.reduce((sum, activity) => sum + activity.duration, 0);
    const hours = Math.floor(totalMinutes / 60);
    const minutes = totalMinutes % 60;
    console.log(`  ${hours}小时${minutes}分钟`);
  }

  saveToLocalStorage() {
    if (typeof Storage !== 'undefined') {
      localStorage.setItem('activityTracker_activities', JSON.stringify(this.testData.activities));
      localStorage.setItem('activityTracker_projects', JSON.stringify(this.testData.projects));
      localStorage.setItem('activityTracker_diary', JSON.stringify(this.testData.diary));
      localStorage.setItem('activityTracker_memos', JSON.stringify(this.testData.memos));
      console.log('💾 测试数据已保存到LocalStorage');
    }
  }

  getTestData() {
    return this.testData;
  }
}

// 运行测试数据加载
if (typeof window !== 'undefined') {
  // 浏览器环境
  window.TestDataLoader = TestDataLoader;
  console.log('📊 测试数据加载器已加载，运行: new TestDataLoader()');
} else {
  // Node.js环境
  const loader = new TestDataLoader();
}
