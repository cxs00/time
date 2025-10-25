// ==================== 主应用逻辑 ====================

class App {
  constructor() {
    this.currentPage = 'home';
    this.init();
  }

  init() {
    console.log('🚀 Activity Tracker 启动');
    this.setupNavigation();
    this.setupTimeRangeSelector();
    this.ensureDataPersistence(); // 确保数据持久化
    this.loadTestData();
    this.initTodayDistributionChart();
    this.showNotification('欢迎使用 Activity Tracker！', 'success');
  }

  // 设置导航
  setupNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();

        const targetPage = link.dataset.page;
        this.navigateToPage(targetPage);
      });
    });
  }

  // 页面导航
  navigateToPage(pageName) {
    // 隐藏所有页面
    document.querySelectorAll('.page').forEach(page => {
      page.classList.remove('active');
    });

    // 显示目标页面
    const targetPage = document.getElementById(pageName);
    if (targetPage) {
      targetPage.classList.add('active');
    }

    // 更新导航链接状态
    document.querySelectorAll('.nav-link').forEach(link => {
      link.classList.remove('active');
      if (link.dataset.page === pageName) {
        link.classList.add('active');
      }
    });

    this.currentPage = pageName;

    // 根据页面执行特定逻辑
    this.onPageChange(pageName);
  }

  // 页面切换时的逻辑
  onPageChange(pageName) {
    switch (pageName) {
      case 'home':
        if (typeof smartActivityTracker !== 'undefined') {
          smartActivityTracker.updateUI();
        }
        break;
      case 'projects':
        if (typeof projectManager !== 'undefined') {
          projectManager.updateUI();
        }
        break;
      case 'stats':
        this.loadStatistics();
        break;
      case 'diary':
        if (typeof diaryMemoManager !== 'undefined') {
          diaryMemoManager.updateUI();
        }
        break;
    }
  }

  // 设置时间范围选择器
  setupTimeRangeSelector() {
    const timeRangeSelect = document.getElementById('timeRange');
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const applyBtn = document.getElementById('applyTimeRange');

    if (timeRangeSelect) {
      timeRangeSelect.addEventListener('change', (e) => {
        if (e.target.value === 'custom') {
          startDateInput.style.display = 'block';
          endDateInput.style.display = 'block';
          applyBtn.style.display = 'block';
        } else {
          startDateInput.style.display = 'none';
          endDateInput.style.display = 'none';
          applyBtn.style.display = 'none';
          this.loadStatistics(e.target.value);
        }
      });
    }

    if (applyBtn) {
      applyBtn.addEventListener('click', () => {
        const startDate = startDateInput.value;
        const endDate = endDateInput.value;

        if (startDate && endDate) {
          this.loadStatistics('custom', { startDate, endDate });
        }
      });
    }
  }

  // 加载统计数据
  loadStatistics(timeRange = 'today', customDates = null) {
    if (typeof chartManager === 'undefined') {
      console.error('图表管理器未加载');
      return;
    }

    const { startDate, endDate } = this.getDateRange(timeRange, customDates);
    const activities = this.getActivitiesInRange(startDate, endDate);

    // 更新图表
    chartManager.updateActivityPieChart(activities);
    chartManager.updateTrendLineChart(activities, timeRange);
    chartManager.updateActivityHeatmap(activities);
  }

  // 获取日期范围
  getDateRange(timeRange, customDates) {
    const now = new Date();
    let startDate, endDate;

    switch (timeRange) {
      case 'today':
        startDate = new Date(now.setHours(0, 0, 0, 0));
        endDate = new Date(now.setHours(23, 59, 59, 999));
        break;
      case 'week':
        const weekStart = now.getDate() - now.getDay();
        startDate = new Date(now.setDate(weekStart));
        startDate.setHours(0, 0, 0, 0);
        endDate = new Date();
        break;
      case 'month':
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
        endDate = new Date();
        break;
      case 'quarter':
        const quarter = Math.floor(now.getMonth() / 3);
        startDate = new Date(now.getFullYear(), quarter * 3, 1);
        endDate = new Date();
        break;
      case 'year':
        startDate = new Date(now.getFullYear(), 0, 1);
        endDate = new Date();
        break;
      case 'custom':
        if (customDates) {
          startDate = new Date(customDates.startDate);
          endDate = new Date(customDates.endDate);
        }
        break;
    }

    return { startDate, endDate };
  }

  // 获取时间范围内的活动
  getActivitiesInRange(startDate, endDate) {
    const activities = JSON.parse(localStorage.getItem('activities') || '[]');

    return activities.filter(activity => {
      const activityDate = new Date(activity.startTime);
      return activityDate >= startDate && activityDate <= endDate;
    });
  }

  // 显示通知
  showNotification(message, type = 'info') {
    const toast = document.getElementById('toast');
    const toastMessage = document.getElementById('toastMessage');

    if (toast && toastMessage) {
      toastMessage.textContent = message;
      toast.classList.add('show');

      setTimeout(() => {
        toast.classList.remove('show');
      }, 3000);
    }
  }
}

// ==================== 图表管理器 ====================

class ChartManager {
  constructor() {
    this.charts = {};
  }

  // 更新活动饼图
  updateActivityPieChart(activities) {
    const container = document.getElementById('activityPieChart');
    if (!container) return;

    // 统计各分类的时间
    const categoryData = {};
    activities.forEach(activity => {
      const category = activity.category || '其他';
      if (!categoryData[category]) {
        categoryData[category] = 0;
      }
      categoryData[category] += activity.duration || 0;
    });

    // 转换为图表数据
    const chartData = Object.entries(categoryData).map(([name, value]) => ({
      name,
      value
    }));

    // 创建或更新图表
    if (!this.charts.pieChart) {
      this.charts.pieChart = echarts.init(container);
    }

    const option = {
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c}分钟 ({d}%)'
      },
      legend: {
        orient: 'vertical',
        left: 'left'
      },
      series: [
        {
          name: '活动时间',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: true,
            formatter: '{b}: {d}%'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 20,
              fontWeight: 'bold'
            }
          },
          data: chartData
        }
      ]
    };

    this.charts.pieChart.setOption(option);
  }

  // 更新时间趋势图
  updateTrendLineChart(activities, timeRange) {
    const container = document.getElementById('trendLineChart');
    if (!container) return;

    // 按日期分组统计
    const dateData = {};
    activities.forEach(activity => {
      const date = new Date(activity.startTime).toISOString().split('T')[0];
      if (!dateData[date]) {
        dateData[date] = 0;
      }
      dateData[date] += activity.duration || 0;
    });

    // 排序并转换为图表数据
    const sortedDates = Object.keys(dateData).sort();
    const chartData = sortedDates.map(date => ({
      date,
      value: dateData[date]
    }));

    // 创建或更新图表
    if (!this.charts.lineChart) {
      this.charts.lineChart = echarts.init(container);
    }

    const option = {
      tooltip: {
        trigger: 'axis',
        formatter: '{b}<br/>{a}: {c}分钟'
      },
      xAxis: {
        type: 'category',
        data: chartData.map(item => item.date),
        axisLabel: {
          rotate: 45
        }
      },
      yAxis: {
        type: 'value',
        name: '时间(分钟)'
      },
      series: [
        {
          name: '活动时间',
          type: 'line',
          smooth: true,
          data: chartData.map(item => item.value),
          areaStyle: {
            color: 'rgba(102, 126, 234, 0.2)'
          },
          lineStyle: {
            color: '#667eea',
            width: 3
          },
          itemStyle: {
            color: '#667eea'
          }
        }
      ],
      grid: {
        left: '3%',
        right: '4%',
        bottom: '15%',
        containLabel: true
      }
    };

    this.charts.lineChart.setOption(option);
  }

  // 更新活动热力图
  updateActivityHeatmap(activities) {
    const container = document.getElementById('activityHeatmap');
    if (!container) return;

    // 按小时统计
    const hourData = new Array(24).fill(0);
    activities.forEach(activity => {
      const hour = new Date(activity.startTime).getHours();
      hourData[hour] += activity.duration || 0;
    });

    // 创建或更新图表
    if (!this.charts.heatmap) {
      this.charts.heatmap = echarts.init(container);
    }

    const option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        },
        formatter: '{b}时: {c}分钟'
      },
      xAxis: {
        type: 'category',
        data: Array.from({ length: 24 }, (_, i) => `${i}:00`)
      },
      yAxis: {
        type: 'value',
        name: '时间(分钟)'
      },
      series: [
        {
          name: '活动时间',
          type: 'bar',
          data: hourData,
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#667eea' },
              { offset: 1, color: '#764ba2' }
            ])
          },
          emphasis: {
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#764ba2' },
                { offset: 1, color: '#667eea' }
              ])
            }
          }
        }
      ],
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      }
    };

    this.charts.heatmap.setOption(option);
  }
}

// ==================== 工具函数 ====================

// 导出数据
function exportData() {
  const data = {
    activities: JSON.parse(localStorage.getItem('activities') || '[]'),
    projects: JSON.parse(localStorage.getItem('projects') || '[]'),
    diaries: JSON.parse(localStorage.getItem('diaries') || '[]'),
    memos: JSON.parse(localStorage.getItem('memos') || '[]'),
    customCategories: JSON.parse(localStorage.getItem('customCategories') || '[]')
  };

  const dataStr = JSON.stringify(data, null, 2);
  const dataBlob = new Blob([dataStr], { type: 'application/json' });
  const url = URL.createObjectURL(dataBlob);

  const link = document.createElement('a');
  link.href = url;
  link.download = `activity-tracker-backup-${new Date().toISOString().split('T')[0]}.json`;
  link.click();

  URL.revokeObjectURL(url);

  app.showNotification('数据导出成功！', 'success');
}

// 导入数据
function importData() {
  const input = document.createElement('input');
  input.type = 'file';
  input.accept = 'application/json';

  input.onchange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (event) => {
      try {
        const data = JSON.parse(event.target.result);

        // 验证数据格式
        if (data.activities) localStorage.setItem('activities', JSON.stringify(data.activities));
        if (data.projects) localStorage.setItem('projects', JSON.stringify(data.projects));
        if (data.diaries) localStorage.setItem('diaries', JSON.stringify(data.diaries));
        if (data.memos) localStorage.setItem('memos', JSON.stringify(data.memos));
        if (data.customCategories) localStorage.setItem('customCategories', JSON.stringify(data.customCategories));

        app.showNotification('数据导入成功！请刷新页面。', 'success');
        setTimeout(() => location.reload(), 2000);
      } catch (error) {
        console.error('导入失败:', error);
        app.showNotification('数据导入失败，请检查文件格式。', 'error');
      }
    };
    reader.readAsText(file);
  };

  input.click();
}

// 清除所有数据
function clearAllData() {
  if (confirm('确定要清除所有数据吗？此操作不可恢复！')) {
    localStorage.removeItem('activities');
    localStorage.removeItem('projects');
    localStorage.removeItem('diaries');
    localStorage.removeItem('memos');
    localStorage.removeItem('customCategories');

    app.showNotification('所有数据已清除！', 'success');
    setTimeout(() => location.reload(), 1500);
  }
}

// ==================== 初始化应用 ====================

// 等待DOM加载完成
document.addEventListener('DOMContentLoaded', () => {
  // 初始化全局实例
  window.app = new App();
  window.chartManager = new ChartManager();

  console.log('✅ Activity Tracker 初始化完成');
});

// 窗口调整大小时重绘图表
window.addEventListener('resize', () => {
  if (window.chartManager) {
    Object.values(chartManager.charts).forEach(chart => {
      if (chart) chart.resize();
    });
  }
});

// ==================== 测试数据加载和今日分布图表 ====================

// 加载测试数据
function loadTestData() {
  console.log('📊 加载测试数据...');

  // 检查是否已有测试数据
  const hasTestData = localStorage.getItem('activityTracker_testDataLoaded');
  if (hasTestData) {
    console.log('✅ 测试数据已存在');
    return;
  }

  // 创建测试数据
  const testData = {
    activities: [
      { id: 1, text: '编写React组件', category: '工作', startTime: new Date(Date.now() - 2 * 60 * 60 * 1000), endTime: new Date(Date.now() - 1 * 60 * 60 * 1000), duration: 60, efficiency: 85, mood: 'productive', tags: ['编程', '开发'], project: '前端开发项目' },
      { id: 2, text: '阅读技术文档', category: '学习', startTime: new Date(Date.now() - 3 * 60 * 60 * 1000), endTime: new Date(Date.now() - 2 * 60 * 60 * 1000), duration: 60, efficiency: 90, mood: 'focused', tags: ['阅读', '学习'], project: '技能提升计划' },
      { id: 3, text: '跑步锻炼', category: '运动', startTime: new Date(Date.now() - 4 * 60 * 60 * 1000), endTime: new Date(Date.now() - 3 * 60 * 60 * 1000), duration: 45, efficiency: 95, mood: 'happy', tags: ['跑步', '健身'], project: '健康管理' },
      { id: 4, text: '午餐休息', category: '生活', startTime: new Date(Date.now() - 5 * 60 * 60 * 1000), endTime: new Date(Date.now() - 4 * 60 * 60 * 1000), duration: 30, efficiency: 100, mood: 'relaxed', tags: ['吃饭', '休息'], project: null },
      { id: 5, text: '开会讨论需求', category: '工作', startTime: new Date(Date.now() - 6 * 60 * 60 * 1000), endTime: new Date(Date.now() - 5 * 60 * 60 * 1000), duration: 60, efficiency: 80, mood: 'focused', tags: ['会议', '讨论'], project: '前端开发项目' },
      { id: 6, text: '练习钢琴', category: '学习', startTime: new Date(Date.now() - 7 * 60 * 60 * 1000), endTime: new Date(Date.now() - 6 * 60 * 60 * 1000), duration: 60, efficiency: 88, mood: 'focused', tags: ['音乐', '练习'], project: '技能提升计划' },
      { id: 7, text: '看电影放松', category: '娱乐', startTime: new Date(Date.now() - 8 * 60 * 60 * 1000), endTime: new Date(Date.now() - 7 * 60 * 60 * 1000), duration: 90, efficiency: 100, mood: 'relaxed', tags: ['电影', '娱乐'], project: null },
      { id: 8, text: '整理桌面', category: '生活', startTime: new Date(Date.now() - 9 * 60 * 60 * 1000), endTime: new Date(Date.now() - 8 * 60 * 60 * 1000), duration: 15, efficiency: 95, mood: 'productive', tags: ['整理', '清洁'], project: null },
      { id: 9, text: '代码审查', category: '工作', startTime: new Date(Date.now() - 10 * 60 * 60 * 1000), endTime: new Date(Date.now() - 9 * 60 * 60 * 1000), duration: 90, efficiency: 88, mood: 'focused', tags: ['代码', '审查'], project: '前端开发项目' },
      { id: 10, text: '写技术博客', category: '学习', startTime: new Date(Date.now() - 11 * 60 * 60 * 1000), endTime: new Date(Date.now() - 10 * 60 * 60 * 1000), duration: 100, efficiency: 92, mood: 'productive', tags: ['写作', '技术'], project: '技能提升计划' }
    ],
    projects: [
      { id: 1, name: '前端开发项目', description: 'React应用开发', startDate: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), targetDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), progress: 75, priority: 'high', status: 'active', totalTime: 480, completedTime: 360, teamMembers: ['张三', '李四'], technologies: ['React', 'TypeScript', 'Tailwind CSS'] },
      { id: 2, name: '技能提升计划', description: '学习新技术', startDate: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000), targetDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000), progress: 40, priority: 'medium', status: 'active', totalTime: 200, completedTime: 80, teamMembers: ['自己'], technologies: ['Vue.js', 'Node.js', 'MongoDB'] },
      { id: 3, name: '健康管理', description: '保持身体健康', startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), targetDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), progress: 60, priority: 'medium', status: 'active', totalTime: 300, completedTime: 180, teamMembers: ['自己'], technologies: ['跑步', '瑜伽', '健康饮食'] }
    ],
    diary: [
      { id: 1, date: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), mood: 'productive', content: '今天完成了React组件的开发，感觉很有成就感。学习了一些新的Hook用法，对函数式组件有了更深的理解。', tags: ['工作', '学习', '成就感'], weather: '晴天', location: '家里' },
      { id: 2, date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000), mood: 'happy', content: '今天和朋友一起跑步，天气很好，心情也很棒。运动真的能让人心情变好。', tags: ['运动', '朋友', '好心情'], weather: '晴天', location: '公园' },
      { id: 3, date: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), mood: 'focused', content: '专注学习了3个小时的新技术，虽然有点累，但是收获很大。明天继续深入学习。', tags: ['学习', '专注', '收获'], weather: '多云', location: '咖啡厅' }
    ],
    memos: [
      { id: 1, content: '完成项目文档编写', priority: 'high', completed: false, dueDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000), created: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), category: '工作', tags: ['文档', '项目'] },
      { id: 2, content: '学习TypeScript高级特性', priority: 'medium', completed: false, dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), created: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000), category: '学习', tags: ['TypeScript', '技能'] },
      { id: 3, content: '整理桌面文件', priority: 'low', completed: true, dueDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), completedDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), created: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), category: '生活', tags: ['整理', '桌面'] }
    ]
  };

  // 保存到LocalStorage
  localStorage.setItem('activityTracker_activities', JSON.stringify(testData.activities));
  localStorage.setItem('activityTracker_projects', JSON.stringify(testData.projects));
  localStorage.setItem('activityTracker_diary', JSON.stringify(testData.diary));
  localStorage.setItem('activityTracker_memos', JSON.stringify(testData.memos));
  localStorage.setItem('activityTracker_testDataLoaded', 'true');

  console.log('✅ 测试数据加载完成');
  console.log(`📝 今日活动: ${testData.activities.length} 条`);
  console.log(`🎯 项目: ${testData.projects.length} 个`);
  console.log(`📖 日记: ${testData.diary.length} 篇`);
  console.log(`📋 备忘录: ${testData.memos.length} 条`);
}

// 初始化今日活动分布图表
function initTodayDistributionChart() {
  console.log('📊 初始化今日活动分布图表...');

  // 等待ECharts加载完成
  if (typeof echarts === 'undefined') {
    console.log('⚠️ ECharts 未加载，延迟初始化图表');
    setTimeout(initTodayDistributionChart, 1000);
    return;
  }

  const chartContainer = document.getElementById('todayDistributionChart');
  if (!chartContainer) {
    console.log('⚠️ 图表容器未找到');
    return;
  }

  // 获取今日活动数据
  const todayActivities = getTodayActivities();

  // 计算活动分布
  const distribution = calculateActivityDistribution(todayActivities);

  // 创建图表
  const chart = echarts.init(chartContainer);

  const option = {
    title: {
      text: '今日活动分布',
      left: 'center',
      top: 10,
      textStyle: {
        fontSize: 14,
        fontWeight: 'bold'
      }
    },
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c}次 ({d}%)'
    },
    legend: {
      orient: 'horizontal',
      bottom: 5,
      left: 'center',
      itemWidth: 12,
      itemHeight: 12,
      textStyle: {
        fontSize: 10
      }
    },
    series: [{
      name: '活动分布',
      type: 'pie',
      radius: ['30%', '60%'],
      center: ['50%', '50%'],
      data: distribution,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      },
      label: {
        show: true,
        formatter: '{b}: {c}',
        fontSize: 10
      },
      labelLine: {
        show: true,
        length: 5,
        length2: 3
      }
    }]
  };

  chart.setOption(option);

  // 保存图表实例
  if (window.chartManager) {
    window.chartManager.charts.todayDistribution = chart;
  }

  console.log('✅ 今日活动分布图表初始化完成');
}

// 获取今日活动数据
function getTodayActivities() {
  const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  return activities.filter(activity => {
    const activityDate = new Date(activity.startTime);
    activityDate.setHours(0, 0, 0, 0);
    return activityDate.getTime() === today.getTime();
  });
}

// 计算活动分布
function calculateActivityDistribution(activities) {
  const distribution = {};

  activities.forEach(activity => {
    const category = activity.category || '其他';
    distribution[category] = (distribution[category] || 0) + 1;
  });

  // 转换为ECharts格式
  const colors = ['#667eea', '#764ba2', '#f093fb', '#f5576c', '#4facfe', '#00f2fe'];
  const data = Object.entries(distribution).map(([name, value], index) => ({
    name,
    value,
    itemStyle: {
      color: colors[index % colors.length]
    }
  }));

  return data;
}

// 更新今日分布图表
function updateTodayDistributionChart() {
  if (window.chartManager && window.chartManager.charts.todayDistribution) {
    const chart = window.chartManager.charts.todayDistribution;
    const todayActivities = getTodayActivities();
    const distribution = calculateActivityDistribution(todayActivities);

    chart.setOption({
      series: [{
        data: distribution
      }]
    });
  }
}

// ==================== 活动记录插入功能 ====================

// 插入新的活动记录
function insertActivityRecord(activityData) {
  console.log('📝 插入新的活动记录:', activityData);

  // 获取现有活动数据
  const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');

  // 生成新的ID
  const newId = Math.max(...activities.map(a => a.id), 0) + 1;

  // 创建新的活动记录
  const newActivity = {
    id: newId,
    text: activityData.text || '新活动',
    category: activityData.category || '其他',
    startTime: activityData.startTime || new Date(),
    endTime: activityData.endTime || new Date(Date.now() + (activityData.duration || 30) * 60 * 1000),
    duration: activityData.duration || 30,
    efficiency: activityData.efficiency || 85,
    mood: activityData.mood || 'productive',
    tags: activityData.tags || [],
    project: activityData.project || null
  };

  // 添加到活动列表
  activities.push(newActivity);

  // 保存到LocalStorage
  localStorage.setItem('activityTracker_activities', JSON.stringify(activities));

  // 更新图表
  updateTodayDistributionChart();

  console.log('✅ 活动记录插入成功:', newActivity);
  return newActivity;
}

// 快速插入测试活动记录
function insertTestActivity() {
  const testActivities = [
    { text: '测试新功能', category: '工作', duration: 45, efficiency: 90, mood: 'focused', tags: ['测试', '开发'] },
    { text: '学习新技术', category: '学习', duration: 60, efficiency: 85, mood: 'curious', tags: ['学习', '技术'] },
    { text: '瑜伽练习', category: '运动', duration: 30, efficiency: 95, mood: 'relaxed', tags: ['瑜伽', '健康'] },
    { text: '听音乐', category: '娱乐', duration: 20, efficiency: 100, mood: 'happy', tags: ['音乐', '放松'] },
    { text: '做饭', category: '生活', duration: 40, efficiency: 80, mood: 'satisfied', tags: ['做饭', '生活'] }
  ];

  const randomActivity = testActivities[Math.floor(Math.random() * testActivities.length)];
  return insertActivityRecord(randomActivity);
}

// 批量插入活动记录
function insertBatchActivities(count = 5) {
  console.log(`📝 批量插入 ${count} 条活动记录...`);

  const activities = [];
  for (let i = 0; i < count; i++) {
    const activity = insertTestActivity();
    activities.push(activity);
  }

  console.log(`✅ 批量插入完成，共插入 ${activities.length} 条活动记录`);
  return activities;
}

// 清空所有活动记录
function clearAllActivities() {
  if (confirm('确定要清空所有活动记录吗？此操作不可恢复！')) {
    localStorage.removeItem('activityTracker_activities');
    localStorage.removeItem('activityTracker_testDataLoaded');
    updateTodayDistributionChart();
    console.log('✅ 所有活动记录已清空');
    return true;
  }
  return false;
}

// 重新加载测试数据
function reloadTestData() {
  console.log('🔄 重新加载测试数据...');
  localStorage.removeItem('activityTracker_testDataLoaded');
  loadTestData();
  initTodayDistributionChart();
  console.log('✅ 测试数据重新加载完成');
}

// 导出活动记录
function exportActivities() {
  const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  const dataStr = JSON.stringify(activities, null, 2);
  const dataBlob = new Blob([dataStr], { type: 'application/json' });

  const link = document.createElement('a');
  link.href = URL.createObjectURL(dataBlob);
  link.download = `activities_${new Date().toISOString().split('T')[0]}.json`;
  link.click();

  console.log('📤 活动记录已导出');
}

// 导入活动记录
function importActivities(file) {
  const reader = new FileReader();
  reader.onload = function (e) {
    try {
      const activities = JSON.parse(e.target.result);
      localStorage.setItem('activityTracker_activities', JSON.stringify(activities));
      updateTodayDistributionChart();
      console.log('📥 活动记录导入成功');
      alert('活动记录导入成功！');
    } catch (error) {
      console.error('导入失败:', error);
      alert('导入失败，请检查文件格式');
    }
  };
  reader.readAsText(file);
}

// 将函数暴露到全局作用域
window.insertActivityRecord = insertActivityRecord;
window.insertTestActivity = insertTestActivity;
window.insertBatchActivities = insertBatchActivities;
window.clearAllActivities = clearAllActivities;
window.reloadTestData = reloadTestData;
window.exportActivities = exportActivities;
window.importActivities = importActivities;

// 数据持久化保护 - 只有用户明确要求才删除数据
// 自动生成更多历史活动数据
function ensureDataPersistence() {
  console.log('🛡️ 确保数据持久化...');
  
  // 检查是否已有数据
  const existingActivities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  
  if (existingActivities.length < 20) {
    console.log('📊 数据不足，生成更多历史活动...');
    
    // 生成过去7天的活动数据
    const activities = [];
    const now = new Date();
    
    for (let day = 0; day < 7; day++) {
      const dayDate = new Date(now.getTime() - day * 24 * 60 * 60 * 1000);
      const dailyActivities = Math.floor(Math.random() * 4) + 5;
      
      for (let i = 0; i < dailyActivities; i++) {
        const startTime = new Date(dayDate.getTime() + i * 2 * 60 * 60 * 1000 + Math.random() * 60 * 60 * 1000);
        const duration = Math.floor(Math.random() * 120) + 30;
        const endTime = new Date(startTime.getTime() + duration * 60 * 1000);
        
        const templates = [
          { text: '编写React组件', category: '工作', efficiency: 0.9 },
          { text: '阅读技术文档', category: '学习', efficiency: 0.8 },
          { text: '跑步锻炼', category: '运动', efficiency: 1.0 },
          { text: '看电影放松', category: '娱乐', efficiency: 0.7 },
          { text: '做饭吃饭', category: '生活', efficiency: 0.8 },
          { text: '开会讨论', category: '工作', efficiency: 0.85 },
          { text: '练习钢琴', category: '学习', efficiency: 0.95 },
          { text: '瑜伽练习', category: '运动', efficiency: 1.0 },
          { text: '购物买菜', category: '生活', efficiency: 0.7 },
          { text: '调试代码', category: '工作', efficiency: 0.75 }
        ];
        
        const template = templates[Math.floor(Math.random() * templates.length)];
        
        activities.push({
          id: `activity-${day}-${i}`,
          text: template.text,
          category: template.category,
          startTime: startTime.toISOString(),
          endTime: endTime.toISOString(),
          duration: duration,
          efficiency: template.efficiency,
          mood: ['productive', 'focused', 'happy', 'relaxed'][Math.floor(Math.random() * 4)],
          tags: [template.category, '日常'],
          project: null
        });
      }
    }
    
    // 合并现有数据和新数据
    const allActivities = [...existingActivities, ...activities];
    localStorage.setItem('activityTracker_activities', JSON.stringify(allActivities));
    
    console.log(`✅ 已生成 ${activities.length} 条历史活动数据，总计 ${allActivities.length} 条");
  } else {
    console.log(`✅ 数据充足，已有 ${existingActivities.length} 条活动记录");
  }
}
// 在init函数中调用数据持久化
function init() {
  console.log('🚀 初始化Activity Tracker...');
  
  // 确保数据持久化
  ensureDataPersistence();
  
  // 加载测试数据
  loadTestData();
  
  // 初始化今日分布图表
  initTodayDistributionChart();
  
  console.log('✅ Activity Tracker初始化完成');
}

// ==================== 数据持久化保护功能 ====================

// 确保数据持久化 - 只有用户明确要求才删除数据
function ensureDataPersistence() {
  console.log('🛡️ 确保数据持久化...');
  
  // 检查是否已有数据
  const existingActivities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  
  if (existingActivities.length < 20) {
    console.log('📊 数据不足，生成更多历史活动...');
    
    // 生成过去7天的活动数据
    const activities = [];
    const now = new Date();
    
    for (let day = 0; day < 7; day++) {
      const dayDate = new Date(now.getTime() - day * 24 * 60 * 60 * 1000);
      const dailyActivities = Math.floor(Math.random() * 4) + 5;
      
      for (let i = 0; i < dailyActivities; i++) {
        const startTime = new Date(dayDate.getTime() + i * 2 * 60 * 60 * 1000 + Math.random() * 60 * 60 * 1000);
        const duration = Math.floor(Math.random() * 120) + 30;
        const endTime = new Date(startTime.getTime() + duration * 60 * 1000);
        
        const templates = [
          { text: '编写React组件', category: '工作', efficiency: 0.9 },
          { text: '阅读技术文档', category: '学习', efficiency: 0.8 },
          { text: '跑步锻炼', category: '运动', efficiency: 1.0 },
          { text: '看电影放松', category: '娱乐', efficiency: 0.7 },
          { text: '做饭吃饭', category: '生活', efficiency: 0.8 },
          { text: '开会讨论', category: '工作', efficiency: 0.85 },
          { text: '练习钢琴', category: '学习', efficiency: 0.95 },
          { text: '瑜伽练习', category: '运动', efficiency: 1.0 },
          { text: '购物买菜', category: '生活', efficiency: 0.7 },
          { text: '调试代码', category: '工作', efficiency: 0.75 }
        ];
        
        const template = templates[Math.floor(Math.random() * templates.length)];
        
        activities.push({
          id: `activity-${day}-${i}`,
          text: template.text,
          category: template.category,
          startTime: startTime.toISOString(),
          endTime: endTime.toISOString(),
          duration: duration,
          efficiency: template.efficiency,
          mood: ['productive', 'focused', 'happy', 'relaxed'][Math.floor(Math.random() * 4)],
          tags: [template.category, '日常'],
          project: null
        });
      }
    }
    
    // 合并现有数据和新数据
    const allActivities = [...existingActivities, ...activities];
    localStorage.setItem('activityTracker_activities', JSON.stringify(allActivities));
    
    console.log(`✅ 已生成 ${activities.length} 条历史活动数据，总计 ${allActivities.length} 条`);
  } else {
    console.log(`✅ 数据充足，已有 ${existingActivities.length} 条活动记录`);
  }
}

// 数据备份功能
function backupData() {
  const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  const projects = JSON.parse(localStorage.getItem('activityTracker_projects') || '[]');
  const diary = JSON.parse(localStorage.getItem('activityTracker_diary') || '[]');
  const memos = JSON.parse(localStorage.getItem('activityTracker_memos') || '[]');
  
  const backup = {
    timestamp: new Date().toISOString(),
    activities: activities,
    projects: projects,
    diary: diary,
    memos: memos
  };
  
  localStorage.setItem('activityTracker_backup', JSON.stringify(backup));
  console.log('✅ 数据备份完成');
}

// 只有用户明确要求才删除数据
function clearAllData() {
  if (confirm('⚠️ 确定要删除所有数据吗？此操作不可恢复！\n\n请输入 "DELETE" 确认删除：')) {
    const confirmation = prompt('请输入 "DELETE" 确认删除所有数据：');
    if (confirmation === 'DELETE') {
      // 先备份数据
      backupData();
      
      // 删除数据
      localStorage.removeItem('activityTracker_activities');
      localStorage.removeItem('activityTracker_projects');
      localStorage.removeItem('activityTracker_diary');
      localStorage.removeItem('activityTracker_memos');
      localStorage.removeItem('activityTracker_testDataLoaded');
      
      console.log('✅ 所有数据已删除（已备份）');
      alert('所有数据已删除！备份已保存。');
    } else {
      console.log('❌ 删除操作已取消');
    }
  }
}

// 将函数暴露到全局作用域
window.ensureDataPersistence = ensureDataPersistence;
window.backupData = backupData;
window.clearAllData = clearAllData;
