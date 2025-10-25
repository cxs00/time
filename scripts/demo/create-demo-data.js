// ==================== Activity Tracker 演示数据生成器 ====================

class DemoDataGenerator {
  constructor() {
    this.demoData = {
      activities: [],
      projects: [],
      diary: [],
      memos: []
    };
    this.generateDemoData();
  }

  generateDemoData() {
    console.log('🎬 生成Activity Tracker演示数据...');

    // 生成活动记录数据
    this.generateActivities();

    // 生成项目数据
    this.generateProjects();

    // 生成日记数据
    this.generateDiary();

    // 生成备忘录数据
    this.generateMemos();

    console.log('✅ 演示数据生成完成！');
    this.displayDataSummary();
  }

  generateActivities() {
    const activityTemplates = [
      { text: '编写React组件', category: '工作', duration: 120, project: '前端开发项目' },
      { text: '阅读技术文档', category: '学习', duration: 60, project: '技能提升' },
      { text: '跑步锻炼', category: '运动', duration: 45, project: null },
      { text: '看电影放松', category: '娱乐', duration: 90, project: null },
      { text: '做饭吃饭', category: '生活', duration: 30, project: null },
      { text: '开会讨论需求', category: '工作', duration: 90, project: '前端开发项目' },
      { text: '练习钢琴', category: '学习', duration: 60, project: '技能提升' },
      { text: '购物买菜', category: '生活', duration: 45, project: null },
      { text: '调试代码问题', category: '工作', duration: 75, project: '前端开发项目' },
      { text: '学习新框架', category: '学习', duration: 90, project: '技能提升' },
      { text: '瑜伽练习', category: '运动', duration: 30, project: null },
      { text: '听音乐', category: '娱乐', duration: 20, project: null },
      { text: '整理桌面', category: '生活', duration: 15, project: null },
      { text: '代码审查', category: '工作', duration: 60, project: '前端开发项目' },
      { text: '写技术博客', category: '学习', duration: 120, project: '技能提升' }
    ];

    // 生成过去7天的活动数据
    for (let day = 6; day >= 0; day--) {
      const date = new Date();
      date.setDate(date.getDate() - day);

      // 每天随机选择3-6个活动
      const dailyActivities = this.getRandomActivities(activityTemplates, 3 + Math.floor(Math.random() * 4));

      dailyActivities.forEach((template, index) => {
        const startTime = new Date(date);
        startTime.setHours(9 + index * 2 + Math.floor(Math.random() * 2), Math.floor(Math.random() * 60), 0);

        const endTime = new Date(startTime);
        endTime.setMinutes(endTime.getMinutes() + template.duration);

        this.demoData.activities.push({
          id: this.demoData.activities.length + 1,
          text: template.text,
          category: template.category,
          startTime: startTime,
          endTime: endTime,
          duration: template.duration,
          project: template.project,
          efficiency: 70 + Math.floor(Math.random() * 30), // 70-100%效率
          mood: this.getRandomMood(),
          tags: this.generateTags(template.category)
        });
      });
    }
  }

  generateProjects() {
    this.demoData.projects = [
      {
        id: 1,
        name: '前端开发项目',
        description: 'React应用开发',
        startDate: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000), // 14天前
        targetDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7天后
        progress: 75,
        priority: 'high',
        status: 'active',
        milestones: [
          { name: '需求分析', completed: true, date: new Date(Date.now() - 12 * 24 * 60 * 60 * 1000) },
          { name: 'UI设计', completed: true, date: new Date(Date.now() - 8 * 24 * 60 * 60 * 1000) },
          { name: '核心功能开发', completed: false, date: null },
          { name: '测试优化', completed: false, date: null }
        ],
        totalTime: 480, // 8小时
        completedTime: 360, // 6小时
        teamMembers: ['张三', '李四'],
        technologies: ['React', 'TypeScript', 'Tailwind CSS']
      },
      {
        id: 2,
        name: '技能提升',
        description: '学习新技术',
        startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30天前
        targetDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30天后
        progress: 40,
        priority: 'medium',
        status: 'active',
        milestones: [
          { name: '基础知识学习', completed: true, date: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000) },
          { name: '实践项目', completed: false, date: null },
          { name: '总结分享', completed: false, date: null }
        ],
        totalTime: 200, // 3.3小时
        completedTime: 80, // 1.3小时
        teamMembers: ['自己'],
        technologies: ['Vue.js', 'Node.js', 'MongoDB']
      },
      {
        id: 3,
        name: '健康管理',
        description: '保持身体健康',
        startDate: new Date(Date.now() - 60 * 24 * 60 * 60 * 1000), // 60天前
        targetDate: new Date(Date.now() + 60 * 24 * 60 * 60 * 1000), // 60天后
        progress: 60,
        priority: 'medium',
        status: 'active',
        milestones: [
          { name: '建立运动习惯', completed: true, date: new Date(Date.now() - 45 * 24 * 60 * 60 * 1000) },
          { name: '改善饮食', completed: true, date: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) },
          { name: '保持规律作息', completed: false, date: null }
        ],
        totalTime: 300, // 5小时
        completedTime: 180, // 3小时
        teamMembers: ['自己'],
        technologies: ['跑步', '瑜伽', '健康饮食']
      }
    ];
  }

  generateDiary() {
    const diaryTemplates = [
      {
        mood: 'productive',
        content: '今天完成了React组件的开发，感觉很有成就感。学习了一些新的Hook用法，对函数式组件有了更深的理解。',
        tags: ['工作', '学习', '成就感']
      },
      {
        mood: 'tired',
        content: '今天工作比较累，但是坚持完成了任务。晚上看了部电影放松一下，明天继续加油。',
        tags: ['工作', '娱乐', '坚持']
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
      },
      {
        mood: 'relaxed',
        content: '周末在家休息，看了几部好电影，还做了一顿美味的晚餐。生活需要这样的放松时光。',
        tags: ['休息', '电影', '美食']
      }
    ];

    // 生成过去5天的日记
    for (let day = 4; day >= 0; day--) {
      const date = new Date();
      date.setDate(date.getDate() - day);

      const template = diaryTemplates[Math.floor(Math.random() * diaryTemplates.length)];

      this.demoData.diary.push({
        id: this.demoData.diary.length + 1,
        date: date,
        mood: template.mood,
        content: template.content,
        tags: template.tags,
        weather: this.getRandomWeather(),
        location: this.getRandomLocation()
      });
    }
  }

  generateMemos() {
    this.demoData.memos = [
      {
        id: 1,
        content: '完成项目文档编写',
        priority: 'high',
        completed: false,
        dueDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000), // 2天后
        created: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), // 昨天创建
        category: '工作',
        tags: ['文档', '项目']
      },
      {
        id: 2,
        content: '学习TypeScript高级特性',
        priority: 'medium',
        completed: false,
        dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7天后
        created: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000), // 前天创建
        category: '学习',
        tags: ['TypeScript', '技能']
      },
      {
        id: 3,
        content: '整理桌面文件',
        priority: 'low',
        completed: true,
        dueDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), // 昨天
        completedDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
        created: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), // 3天前创建
        category: '生活',
        tags: ['整理', '桌面']
      },
      {
        id: 4,
        content: '准备下周的会议材料',
        priority: 'high',
        completed: false,
        dueDate: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000), // 3天后
        created: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), // 昨天创建
        category: '工作',
        tags: ['会议', '准备']
      },
      {
        id: 5,
        content: '购买运动装备',
        priority: 'medium',
        completed: false,
        dueDate: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000), // 5天后
        created: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000), // 前天创建
        category: '生活',
        tags: ['购物', '运动']
      }
    ];
  }

  getRandomActivities(templates, count) {
    const shuffled = [...templates].sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
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

  getRandomWeather() {
    const weathers = ['晴天', '多云', '小雨', '阴天'];
    return weathers[Math.floor(Math.random() * weathers.length)];
  }

  getRandomLocation() {
    const locations = ['家里', '办公室', '咖啡厅', '公园', '健身房'];
    return locations[Math.floor(Math.random() * locations.length)];
  }

  displayDataSummary() {
    console.log('\n📊 演示数据统计:');
    console.log(`📝 活动记录: ${this.demoData.activities.length} 条`);
    console.log(`🎯 项目: ${this.demoData.projects.length} 个`);
    console.log(`📖 日记: ${this.demoData.diary.length} 篇`);
    console.log(`📋 备忘录: ${this.demoData.memos.length} 条`);

    console.log('\n📈 活动分类统计:');
    const categoryStats = {};
    this.demoData.activities.forEach(activity => {
      categoryStats[activity.category] = (categoryStats[activity.category] || 0) + 1;
    });
    Object.entries(categoryStats).forEach(([category, count]) => {
      console.log(`  ${category}: ${count} 次`);
    });

    console.log('\n⏱️ 总活动时间:');
    const totalMinutes = this.demoData.activities.reduce((sum, activity) => sum + activity.duration, 0);
    const hours = Math.floor(totalMinutes / 60);
    const minutes = totalMinutes % 60;
    console.log(`  ${hours}小时${minutes}分钟`);
  }

  // 获取演示数据
  getDemoData() {
    return this.demoData;
  }

  // 保存到LocalStorage
  saveToLocalStorage() {
    if (typeof Storage !== 'undefined') {
      localStorage.setItem('activityTracker_demoData', JSON.stringify(this.demoData));
      console.log('💾 演示数据已保存到LocalStorage');
    }
  }

  // 从LocalStorage加载
  loadFromLocalStorage() {
    if (typeof Storage !== 'undefined') {
      const saved = localStorage.getItem('activityTracker_demoData');
      if (saved) {
        this.demoData = JSON.parse(saved);
        console.log('📂 演示数据已从LocalStorage加载');
        return true;
      }
    }
    return false;
  }
}

// 运行演示数据生成
if (typeof window !== 'undefined') {
  // 浏览器环境
  window.DemoDataGenerator = DemoDataGenerator;
  console.log('🎬 演示数据生成器已加载，运行: new DemoDataGenerator()');
} else {
  // Node.js环境
  const generator = new DemoDataGenerator();
  generator.saveToLocalStorage();
}
