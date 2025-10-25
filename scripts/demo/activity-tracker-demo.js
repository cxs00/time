// ==================== Activity Tracker 实际功能演示 ====================

class ActivityTrackerDemo {
  constructor() {
    this.demoData = this.generateDemoData();
    this.currentDemo = 0;
    this.isRunning = false;
  }

  // 生成演示数据
  generateDemoData() {
    return {
      activities: [
        {
          id: 1,
          text: '编写React组件',
          category: '工作',
          startTime: new Date(Date.now() - 2 * 60 * 60 * 1000), // 2小时前
          endTime: new Date(Date.now() - 1 * 60 * 60 * 1000), // 1小时前
          duration: 60,
          project: '前端开发项目'
        },
        {
          id: 2,
          text: '阅读技术文档',
          category: '学习',
          startTime: new Date(Date.now() - 3 * 60 * 60 * 1000), // 3小时前
          endTime: new Date(Date.now() - 2.5 * 60 * 60 * 1000), // 2.5小时前
          duration: 30,
          project: '技能提升'
        },
        {
          id: 3,
          text: '跑步锻炼',
          category: '运动',
          startTime: new Date(Date.now() - 4 * 60 * 60 * 1000), // 4小时前
          endTime: new Date(Date.now() - 3.5 * 60 * 60 * 1000), // 3.5小时前
          duration: 30,
          project: null
        },
        {
          id: 4,
          text: '看电影放松',
          category: '娱乐',
          startTime: new Date(Date.now() - 5 * 60 * 60 * 1000), // 5小时前
          endTime: new Date(Date.now() - 3.5 * 60 * 60 * 1000), // 3.5小时前
          duration: 90,
          project: null
        },
        {
          id: 5,
          text: '做饭吃饭',
          category: '生活',
          startTime: new Date(Date.now() - 6 * 60 * 60 * 1000), // 6小时前
          endTime: new Date(Date.now() - 5.5 * 60 * 60 * 1000), // 5.5小时前
          duration: 30,
          project: null
        }
      ],
      projects: [
        {
          id: 1,
          name: '前端开发项目',
          description: 'React应用开发',
          startDate: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 7天前
          targetDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000), // 14天后
          progress: 65,
          milestones: [
            { name: '需求分析', completed: true, date: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000) },
            { name: 'UI设计', completed: true, date: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000) },
            { name: '核心功能开发', completed: false, date: null },
            { name: '测试优化', completed: false, date: null }
          ]
        },
        {
          id: 2,
          name: '技能提升',
          description: '学习新技术',
          startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30天前
          targetDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30天后
          progress: 40,
          milestones: [
            { name: '基础知识学习', completed: true, date: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000) },
            { name: '实践项目', completed: false, date: null },
            { name: '总结分享', completed: false, date: null }
          ]
        }
      ],
      diary: [
        {
          id: 1,
          date: new Date(Date.now() - 24 * 60 * 60 * 1000), // 昨天
          mood: 'productive',
          content: '今天完成了React组件的开发，感觉很有成就感。学习了一些新的Hook用法，对函数式组件有了更深的理解。',
          tags: ['工作', '学习', '成就感']
        },
        {
          id: 2,
          date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000), // 前天
          mood: 'tired',
          content: '今天工作比较累，但是坚持完成了任务。晚上看了部电影放松一下，明天继续加油。',
          tags: ['工作', '娱乐', '坚持']
        }
      ],
      memos: [
        {
          id: 1,
          content: '完成项目文档编写',
          priority: 'high',
          completed: false,
          dueDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000), // 2天后
          created: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000) // 昨天创建
        },
        {
          id: 2,
          content: '学习TypeScript高级特性',
          priority: 'medium',
          completed: false,
          dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7天后
          created: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000) // 前天创建
        },
        {
          id: 3,
          content: '整理桌面文件',
          priority: 'low',
          completed: true,
          dueDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), // 昨天
          completedDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000)
        }
      ]
    };
  }

  // 开始演示
  async startDemo() {
    if (this.isRunning) {
      console.log('⚠️ 演示已在运行中');
      return;
    }

    this.isRunning = true;
    console.log('🎬 开始Activity Tracker功能演示');
    console.log('=====================================');

    try {
      // 1. 演示AI智能分类
      await this.demoAIClassification();

      // 2. 演示活动记录
      await this.demoActivityTracking();

      // 3. 演示项目管理
      await this.demoProjectManagement();

      // 4. 演示数据可视化
      await this.demoDataVisualization();

      // 5. 演示日记功能
      await this.demoDiaryMemo();

      // 6. 演示统计分析
      await this.demoAnalytics();

      console.log('🎉 演示完成！Activity Tracker功能展示完毕。');

    } catch (error) {
      console.error('❌ 演示过程中出现错误:', error);
    } finally {
      this.isRunning = false;
    }
  }

  // 演示AI智能分类
  async demoAIClassification() {
    console.log('\n🤖 演示AI智能分类功能');
    console.log('------------------------');

    const testActivities = [
      '编写React组件',
      '阅读技术文档',
      '跑步锻炼',
      '看电影放松',
      '做饭吃饭',
      '开会讨论需求',
      '练习钢琴',
      '购物买菜'
    ];

    for (const activity of testActivities) {
      const category = this.mockAIClassify(activity);
      console.log(`  📝 "${activity}" → 🎯 ${category}`);
      await this.delay(500);
    }
  }

  // 演示活动记录
  async demoActivityTracking() {
    console.log('\n📝 演示活动记录功能');
    console.log('------------------------');

    console.log('  📊 今日活动记录:');
    this.demoData.activities.forEach(activity => {
      const duration = this.formatDuration(activity.duration);
      const timeRange = this.formatTimeRange(activity.startTime, activity.endTime);
      console.log(`    • ${activity.text} (${activity.category}) - ${duration} - ${timeRange}`);
    });

    await this.delay(1000);

    // 演示实时活动记录
    console.log('  🔄 开始新的活动记录...');
    await this.delay(500);
    console.log('    ⏱️  活动: "调试代码问题"');
    console.log('    🎯 AI分类: 工作');
    console.log('    ⏰ 开始时间: ' + new Date().toLocaleTimeString());

    // 模拟活动进行中
    for (let i = 0; i < 3; i++) {
      await this.delay(1000);
      console.log(`    ⏱️  已进行: ${i + 1}分钟`);
    }

    console.log('    ✅ 活动结束，已保存记录');
  }

  // 演示项目管理
  async demoProjectManagement() {
    console.log('\n🎯 演示项目管理功能');
    console.log('------------------------');

    console.log('  📋 当前项目:');
    this.demoData.projects.forEach(project => {
      console.log(`    📁 ${project.name} (${project.progress}%)`);
      console.log(`      📅 开始: ${project.startDate.toLocaleDateString()}`);
      console.log(`      🎯 目标: ${project.targetDate.toLocaleDateString()}`);
      console.log(`      📊 里程碑:`);
      project.milestones.forEach(milestone => {
        const status = milestone.completed ? '✅' : '⏳';
        console.log(`        ${status} ${milestone.name}`);
      });
    });

    await this.delay(1000);

    // 演示进度更新
    console.log('  🔄 更新项目进度...');
    await this.delay(500);
    console.log('    📈 前端开发项目: 65% → 70%');
    console.log('    🎉 完成里程碑: 核心功能开发');
  }

  // 演示数据可视化
  async demoDataVisualization() {
    console.log('\n📊 演示数据可视化功能');
    console.log('------------------------');

    // 计算统计数据
    const stats = this.calculateStats();

    console.log('  📈 时间分布统计:');
    Object.entries(stats.categoryTime).forEach(([category, time]) => {
      const percentage = ((time / stats.totalTime) * 100).toFixed(1);
      console.log(`    ${category}: ${this.formatDuration(time)} (${percentage}%)`);
    });

    await this.delay(1000);

    console.log('  📊 效率分析:');
    console.log(`    最活跃时段: ${stats.mostActiveHour}:00`);
    console.log(`    平均活动时长: ${this.formatDuration(stats.avgDuration)}`);
    console.log(`    专注度评分: ${stats.focusScore}/10`);

    await this.delay(1000);

    console.log('  📋 生成可视化图表...');
    await this.delay(500);
    console.log('    ✅ 时间分布饼图');
    console.log('    ✅ 每日活动趋势图');
    console.log('    ✅ 项目进度甘特图');
    console.log('    ✅ 效率分析雷达图');
  }

  // 演示日记功能
  async demoDiaryMemo() {
    console.log('\n📖 演示日记和备忘录功能');
    console.log('------------------------');

    console.log('  📝 最近日记:');
    this.demoData.diary.forEach(entry => {
      const moodEmoji = this.getMoodEmoji(entry.mood);
      console.log(`    ${moodEmoji} ${entry.date.toLocaleDateString()}: ${entry.content.substring(0, 50)}...`);
      console.log(`      🏷️  标签: ${entry.tags.join(', ')}`);
    });

    await this.delay(1000);

    console.log('  📋 待办事项:');
    this.demoData.memos.forEach(memo => {
      const status = memo.completed ? '✅' : '⏳';
      const priority = this.getPriorityEmoji(memo.priority);
      console.log(`    ${status} ${priority} ${memo.content}`);
    });

    await this.delay(1000);

    console.log('  🔄 添加新的备忘录...');
    await this.delay(500);
    console.log('    📝 内容: "准备下周的会议材料"');
    console.log('    ⚡ 优先级: 高');
    console.log('    📅 截止日期: 3天后');
    console.log('    ✅ 已添加到备忘录');
  }

  // 演示统计分析
  async demoAnalytics() {
    console.log('\n📊 演示统计分析功能');
    console.log('------------------------');

    const stats = this.calculateStats();

    console.log('  📈 本周统计:');
    console.log(`    总活动时间: ${this.formatDuration(stats.totalTime)}`);
    console.log(`    活动次数: ${stats.activityCount}次`);
    console.log(`    平均每日: ${this.formatDuration(stats.dailyAverage)}`);

    await this.delay(1000);

    console.log('  🎯 项目统计:');
    console.log(`    活跃项目: ${stats.activeProjects}个`);
    console.log(`    完成里程碑: ${stats.completedMilestones}个`);
    console.log(`    平均进度: ${stats.avgProgress}%`);

    await this.delay(1000);

    console.log('  💡 智能建议:');
    console.log('    • 建议增加学习时间，当前占比偏低');
    console.log('    • 运动时间充足，保持良好习惯');
    console.log('    • 工作专注度较高，继续保持');
    console.log('    • 建议在晚上9-10点进行娱乐活动');
  }

  // 计算统计数据
  calculateStats() {
    const activities = this.demoData.activities;
    const projects = this.demoData.projects;

    const totalTime = activities.reduce((sum, activity) => sum + activity.duration, 0);
    const categoryTime = {};

    activities.forEach(activity => {
      categoryTime[activity.category] = (categoryTime[activity.category] || 0) + activity.duration;
    });

    const avgDuration = totalTime / activities.length;
    const activeProjects = projects.length;
    const completedMilestones = projects.reduce((sum, project) =>
      sum + project.milestones.filter(m => m.completed).length, 0);
    const avgProgress = projects.reduce((sum, project) => sum + project.progress, 0) / projects.length;

    return {
      totalTime,
      categoryTime,
      activityCount: activities.length,
      dailyAverage: totalTime / 7, // 假设是7天的数据
      mostActiveHour: 14, // 模拟最活跃时段
      avgDuration,
      focusScore: 8.5, // 模拟专注度评分
      activeProjects,
      completedMilestones,
      avgProgress
    };
  }

  // 模拟AI分类
  mockAIClassify(input) {
    const patterns = {
      '工作': ['编写', '开发', '调试', '开会', '代码', '编程', '设计', '测试'],
      '学习': ['阅读', '学习', '练习', '研究', '文档', '教程', '课程'],
      '运动': ['跑步', '锻炼', '健身', '游泳', '瑜伽', '骑行'],
      '娱乐': ['电影', '游戏', '音乐', '聊天', '放松', '看剧'],
      '生活': ['做饭', '吃饭', '购物', '买菜', '清洁', '休息']
    };

    const text = input.toLowerCase();

    for (const [category, keywords] of Object.entries(patterns)) {
      if (keywords.some(keyword => text.includes(keyword))) {
        return category;
      }
    }

    return '其他';
  }

  // 格式化时长
  formatDuration(minutes) {
    if (minutes < 60) {
      return `${minutes}分钟`;
    } else {
      const hours = Math.floor(minutes / 60);
      const mins = minutes % 60;
      return mins > 0 ? `${hours}小时${mins}分钟` : `${hours}小时`;
    }
  }

  // 格式化时间范围
  formatTimeRange(start, end) {
    return `${start.toLocaleTimeString()} - ${end.toLocaleTimeString()}`;
  }

  // 获取心情表情
  getMoodEmoji(mood) {
    const moodMap = {
      'productive': '😊',
      'tired': '😴',
      'happy': '😄',
      'focused': '🤔',
      'relaxed': '😌'
    };
    return moodMap[mood] || '😐';
  }

  // 获取优先级表情
  getPriorityEmoji(priority) {
    const priorityMap = {
      'high': '🔴',
      'medium': '🟡',
      'low': '🟢'
    };
    return priorityMap[priority] || '⚪';
  }

  // 延迟函数
  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// 运行演示
if (typeof window !== 'undefined') {
  // 浏览器环境
  window.ActivityTrackerDemo = ActivityTrackerDemo;
  console.log('🎬 Activity Tracker演示器已加载，运行: new ActivityTrackerDemo().startDemo()');
} else {
  // Node.js环境
  const demo = new ActivityTrackerDemo();
  demo.startDemo();
}
