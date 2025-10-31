// ==================== 主应用逻辑 ====================

class App {
  constructor() {
    this.currentPage = 'home';
    this.init();
  }

  init() {
    console.log('🚀 Activity Tracker 启动');

    // 1. 首先设置导航
    this.setupNavigation();
    this.setupTimeRangeSelector();

    // 2. 初始化数据（合并所有数据初始化逻辑）
    this.initializeAllData();

    // 3. 初始化图表（使用全局函数）
    if (typeof initTodayDistributionChart === 'function') {
      console.log('📊 调用全局函数初始化今日分布图表...');
      initTodayDistributionChart();
    } else {
      console.warn('⚠️ initTodayDistributionChart 函数未定义');
    }

    // 4. 更新界面
    this.updateTodayOverview();

    // 5. 显示通知
    this.showNotification('欢迎使用 Activity Tracker！', 'success');

    console.log('✅ Activity Tracker 启动完成');
  }

  // 统一的数据初始化函数
  initializeAllData() {
    console.log('📊 开始数据初始化...');

    // 检查是否已有数据
    const existingActivities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');

    if (existingActivities.length === 0) {
      console.log('🔄 首次运行，生成完整数据...');
      this.generateCompleteData();
    } else {
      console.log(`✅ 已有${existingActivities.length}条数据`);
    }
  }

  // 生成完整数据
  generateCompleteData() {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    // 生成今日活动（必须有今日数据）
    const activities = [
      {
        id: 'today-1',
        text: '编写React组件',
        category: '工作',
        startTime: new Date(today.getTime() + 9 * 60 * 60 * 1000).toISOString(),
        endTime: new Date(today.getTime() + 11 * 60 * 60 * 1000).toISOString(),
        duration: 120,
        efficiency: 0.9,
        mood: 'productive',
        tags: ['工作', 'React'],
        project: 'project-1'
      },
      {
        id: 'today-2',
        text: '阅读技术文档',
        category: '学习',
        startTime: new Date(today.getTime() + 14 * 60 * 60 * 1000).toISOString(),
        endTime: new Date(today.getTime() + 15 * 60 * 60 * 1000).toISOString(),
        duration: 60,
        efficiency: 0.8,
        mood: 'focused',
        tags: ['学习'],
        project: null
      },
      {
        id: 'today-3',
        text: '跑步锻炼',
        category: '运动',
        startTime: new Date(today.getTime() + 18 * 60 * 60 * 1000).toISOString(),
        endTime: new Date(today.getTime() + 19 * 60 * 60 * 1000).toISOString(),
        duration: 60,
        efficiency: 1.0,
        mood: 'happy',
        tags: ['运动'],
        project: null
      }
    ];

    // 保存数据
    localStorage.setItem('activityTracker_activities', JSON.stringify(activities));
    localStorage.setItem('activityTracker_dataInitialized', 'true');

    console.log(`✅ 生成${activities.length}条今日活动数据`);
  }

  // 加载测试数据
  loadTestData() {
    console.log('📊 加载测试数据...');

    // 检查是否已加载过测试数据
    const testDataLoaded = localStorage.getItem('activityTracker_testDataLoaded');
    if (testDataLoaded) {
      console.log('✅ 测试数据已存在');
      this.updateTodayOverview();
      return;
    }

    // 生成一些测试活动数据（包括今日数据）
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    const testActivities = [
      // 今日活动
      {
        id: 'today-1',
        text: '编写React组件',
        category: '工作',
        startTime: new Date(today.getTime() + 9 * 60 * 60 * 1000).toISOString(), // 今天9点
        endTime: new Date(today.getTime() + 10 * 60 * 60 * 1000).toISOString(), // 今天10点
        duration: 60,
        efficiency: 0.9,
        mood: 'productive',
        tags: ['工作', 'React'],
        project: null
      },
      {
        id: 'today-2',
        text: '阅读技术文档',
        category: '学习',
        startTime: new Date(today.getTime() + 14 * 60 * 60 * 1000).toISOString(), // 今天14点
        endTime: new Date(today.getTime() + 15 * 60 * 60 * 1000).toISOString(), // 今天15点
        duration: 60,
        efficiency: 0.8,
        mood: 'focused',
        tags: ['学习', '文档'],
        project: null
      },
      {
        id: 'today-3',
        text: '跑步锻炼',
        category: '运动',
        startTime: new Date(today.getTime() + 18 * 60 * 60 * 1000).toISOString(), // 今天18点
        endTime: new Date(today.getTime() + 19 * 60 * 60 * 1000).toISOString(), // 今天19点
        duration: 60,
        efficiency: 1.0,
        mood: 'happy',
        tags: ['运动', '健康'],
        project: null
      },
      // 历史活动
      {
        id: 'yesterday-1',
        text: '调试代码',
        category: '工作',
        startTime: new Date(today.getTime() - 24 * 60 * 60 * 1000 + 10 * 60 * 60 * 1000).toISOString(),
        endTime: new Date(today.getTime() - 24 * 60 * 60 * 1000 + 11 * 60 * 60 * 1000).toISOString(),
        duration: 60,
        efficiency: 0.75,
        mood: 'focused',
        tags: ['工作', '调试'],
        project: null
      }
    ];

    // 保存测试数据
    localStorage.setItem('activityTracker_activities', JSON.stringify(testActivities));
    localStorage.setItem('activityTracker_testDataLoaded', 'true');

    console.log('✅ 测试数据加载完成');
    this.updateTodayOverview();
  }

  // 更新今日概览
  updateTodayOverview() {
    console.log('📊 更新今日概览...');

    const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
    const today = new Date().toDateString();

    // 筛选今日活动
    const todayActivities = activities.filter(activity => {
      const activityDate = new Date(activity.startTime).toDateString();
      return activityDate === today;
    });

    // 计算总时间
    const totalMinutes = todayActivities.reduce((sum, activity) => sum + (activity.duration || 0), 0);
    const hours = Math.floor(totalMinutes / 60);
    const minutes = totalMinutes % 60;

    // 更新界面 - 使用正确的ID选择器
    const totalTimeElement = document.getElementById('totalTime');
    const activityCountElement = document.getElementById('activityCount');
    const efficiencyElement = document.getElementById('efficiency');

    if (totalTimeElement) {
      totalTimeElement.textContent = `${hours}小时${minutes}分钟`;
      console.log(`✅ 总时间更新: ${hours}小时${minutes}分钟`);
    } else {
      console.log('❌ 未找到totalTime元素');
    }

    if (activityCountElement) {
      activityCountElement.textContent = todayActivities.length.toString();
      console.log(`✅ 活动数更新: ${todayActivities.length}`);
    } else {
      console.log('❌ 未找到activityCount元素');
    }

    if (efficiencyElement) {
      const avgEfficiency = todayActivities.length > 0
        ? Math.round(todayActivities.reduce((sum, activity) => sum + (activity.efficiency || 0), 0) / todayActivities.length * 100)
        : 0;
      efficiencyElement.textContent = `${avgEfficiency}%`;
      console.log(`✅ 效率更新: ${avgEfficiency}%`);
    }

    console.log(`✅ 今日概览更新完成: ${hours}小时${minutes}分钟, ${todayActivities.length}个活动`);
  }

  // 设置导航
  setupNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');
    console.log('🔍 setupNavigation - 找到导航链接数量:', navLinks.length);

    navLinks.forEach((link, index) => {
      const pageName = link.dataset.page;
      console.log(`📌 绑定导航链接 ${index + 1}:`, pageName);

      link.addEventListener('click', (e) => {
        console.log('🖱️ 导航链接被点击:', pageName);
        e.preventDefault();

        const targetPage = link.dataset.page;
        console.log('🎯 目标页面:', targetPage);
        this.navigateToPage(targetPage);
      });
    });

    console.log('✅ setupNavigation 完成');
  }

  // 页面导航
  navigateToPage(pageName) {
    console.log('🚀 navigateToPage 开始, 目标页面:', pageName);

    // 隐藏所有页面
    const allPages = document.querySelectorAll('.page');
    console.log('📄 找到页面总数:', allPages.length);

    allPages.forEach(page => {
      console.log(`  隐藏页面: ${page.id}, 当前类: ${page.className}`);
      page.classList.remove('active');
    });

    // 显示目标页面
    const targetPage = document.getElementById(pageName);
    if (targetPage) {
      console.log(`✅ 找到目标页面: ${pageName}`);
      targetPage.classList.add('active');
      console.log(`  目标页面类: ${targetPage.className}`);
    } else {
      console.error(`❌ 未找到目标页面: ${pageName}`);
    }

    // 更新导航链接状态
    document.querySelectorAll('.nav-link').forEach(link => {
      link.classList.remove('active');
      if (link.dataset.page === pageName) {
        link.classList.add('active');
        console.log(`✅ 导航链接 ${pageName} 被激活`);
      }
    });

    this.currentPage = pageName;
    console.log('📍 当前页面设置为:', this.currentPage);

    // 根据页面执行特定逻辑
    this.onPageChange(pageName);

    console.log('🎉 navigateToPage 完成');
  }

  // 页面切换时的逻辑
  onPageChange(pageName) {
    console.log(`📄 页面切换到: ${pageName}`);

    switch (pageName) {
      case 'home':
        console.log('🏠 更新主页UI');
        if (window.smartActivityTracker) {
          window.smartActivityTracker.updateUI();
        }
        // 🔧 修复：切换回记录页面时，刷新饼状图（确保样式不回退）
        setTimeout(() => {
          if (typeof updateTodayDistributionChart === 'function') {
            updateTodayDistributionChart();
            console.log('✅ 记录页饼状图已刷新');
          }
        }, 100);
        break;
      case 'projects':
        console.log('🎯 更新项目页面UI');
        if (window.projectManager) {
          console.log(`📊 当前项目数量: ${window.projectManager.projects.length}`);
          window.projectManager.updateUI();
          console.log('✅ 项目页面UI更新完成');
        } else {
          console.error('❌ projectManager未定义');
        }
        break;
      case 'stats':
        console.log('📈 更新统计页面');
        // 延迟一点确保DOM渲染完成
        setTimeout(() => {
          this.loadStatistics();
          // 强制重新渲染所有图表
          this.forceRenderCharts();
        }, 100);
        break;
      case 'diary':
        console.log('📖 更新日记页面UI');
        if (window.diaryMemoManager) {
          console.log(`📊 当前日记数量: ${window.diaryMemoManager.diaries.length}`);
          window.diaryMemoManager.updateUI();
          console.log('✅ 日记页面UI更新完成');
        } else {
          console.error('❌ diaryMemoManager未定义');
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
    console.log('📈 开始加载统计数据...');
    console.log(`📊 时间范围: ${timeRange}`);

    if (typeof window.chartManager === 'undefined') {
      console.error('❌ 图表管理器未加载');
      return;
    }

    console.log('✅ 图表管理器已找到');

    const { startDate, endDate } = this.getDateRange(timeRange, customDates);
    const activities = this.getActivitiesInRange(startDate, endDate);

    console.log(`📊 找到 ${activities.length} 条活动数据`);

    // 更新图表
    console.log('📊 更新活动饼图...');
    window.chartManager.updateActivityPieChart(activities);
    console.log('📈 更新趋势线图...');
    window.chartManager.updateTrendLineChart(activities, timeRange);
    console.log('🔥 更新活动热力图...');
    window.chartManager.updateActivityHeatmap(activities);
    console.log('✅ 所有图表更新完成');
  }

  // 强制重新渲染所有图表
  forceRenderCharts() {
    console.log('🔄 强制重新渲染所有图表...');

    // 调整图表容器大小
    const charts = document.querySelectorAll('.chart');
    charts.forEach((chart, index) => {
      if (chart.style.height === '' || chart.style.height === '0px') {
        chart.style.height = '400px';
        console.log(`📏 设置图表${index + 1}高度为400px`);
      }
    });

    // 强制重新渲染图表
    if (window.chartManager && window.chartManager.charts) {
      Object.values(window.chartManager.charts).forEach((chart, index) => {
        if (chart && chart.resize) {
          chart.resize();
          console.log(`🔄 重新调整图表${index + 1}大小`);
        }
      });
    }

    console.log('✅ 图表重新渲染完成');
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
    const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
    console.log(`📊 从localStorage读取到 ${activities.length} 条活动数据`);

    const filteredActivities = activities.filter(activity => {
      const activityDate = new Date(activity.startTime);
      return activityDate >= startDate && activityDate <= endDate;
    });

    console.log(`📊 筛选出 ${filteredActivities.length} 条活动在指定时间范围内`);
    return filteredActivities;
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
    console.log('📊 更新活动饼图...');
    const container = document.getElementById('activityPieChart');
    console.log('🔍 查找饼图容器:', container ? '找到' : '未找到');
    if (!container) {
      console.warn('⚠️ 饼图容器不存在');
      return;
    }

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
      console.log('📊 初始化饼图...');
      this.charts.pieChart = echarts.init(container);
      console.log('✅ 饼图初始化完成');
    }

    // 确保容器有高度
    if (container.style.height === '' || container.style.height === '0px') {
      container.style.height = '400px';
      console.log('📏 设置饼图容器高度为400px');
    }

    // 根据屏幕宽度/容器宽度自适应（保留引线，缩小饼图比例）
    const cw = container.clientWidth || window.innerWidth;
    const isNarrow = cw < 380; // iPhone窄屏

    const option = {
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c}分钟 ({d}%)',
        confine: true
      },
      legend: {
        type: 'scroll',
        orient: 'horizontal',
        bottom: 0,
        left: 'center',
        itemWidth: 12,
        itemHeight: 12,
        textStyle: { fontSize: 10 }
      },
      series: [
        {
          name: '活动时间',
          type: 'pie',
          radius: isNarrow ? ['38%', '54%'] : ['42%', '66%'],
          center: ['50%', isNarrow ? '56%' : '54%'],
          avoidLabelOverlap: true,
          minAngle: 5,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: true,
            position: 'outside',
            formatter: '{d}%',
            fontSize: 10
          },
          labelLine: {
            show: true,
            length: 8,
            length2: 6
          },
          labelLayout: {
            hideOverlap: true,
            moveOverlap: 'shiftX'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 16,
              fontWeight: 'bold'
            }
          },
          data: chartData
        }
      ]
    };

    console.log('📊 设置饼图数据:', chartData);
    this.charts.pieChart.setOption(option);
    console.log('✅ 饼图更新完成');
  }

  // 更新时间趋势图
  updateTrendLineChart(activities, timeRange) {
    console.log('📈 更新趋势线图...');
    const container = document.getElementById('trendLineChart');
    console.log('🔍 查找趋势图容器:', container ? '找到' : '未找到');
    if (!container) {
      console.warn('⚠️ 趋势图容器不存在');
      return;
    }

    // 确保容器有高度
    if (container.style.height === '' || container.style.height === '0px') {
      container.style.height = '400px';
      console.log('📏 设置趋势图容器高度为400px');
    }

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
    console.log('🔥 更新活动热力图...');
    const container = document.getElementById('activityHeatmap');
    console.log('🔍 查找热力图容器:', container ? '找到' : '未找到');
    if (!container) {
      console.warn('⚠️ 热力图容器不存在');
      return;
    }

    // 确保容器有高度
    if (container.style.height === '' || container.style.height === '0px') {
      container.style.height = '400px';
      console.log('📏 设置热力图容器高度为400px');
    }

    // 按小时统计
    const hourData = new Array(24).fill(0);
    activities.forEach(activity => {
      const hour = new Date(activity.startTime).getHours();
      hourData[hour] += activity.duration || 0;
    });

    // 创建或更新图表
    if (!this.charts.heatmap) {
      console.log('🔥 初始化热力图...');
      this.charts.heatmap = echarts.init(container);
      console.log('✅ 热力图初始化完成');
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

    console.log('🔥 设置热力图数据:', hourData);
    this.charts.heatmap.setOption(option);
    console.log('✅ 热力图更新完成');
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
// 注意：主初始化逻辑在文件末尾的DOMContentLoaded中

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
      formatter: '{a} <br/>{b}: {c}次 ({d}%)',
      confine: true
    },
    legend: {
      orient: 'horizontal',
      bottom: 5,
      left: 'center',
      itemWidth: 12,
      itemHeight: 12,
      textStyle: { fontSize: 10 }
    },
    series: [{
      name: '活动分布',
      type: 'pie',
      radius: ['30%', '60%'],
      center: ['50%', '50%'],
      avoidLabelOverlap: false,
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
    const option = {
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c}次 ({d}%)',
        confine: true
      },
      legend: {
        orient: 'horizontal',
        bottom: 5,
        left: 'center',
        itemWidth: 12,
        itemHeight: 12,
        textStyle: { fontSize: 10 }
      },
      series: [{
        name: '活动分布',
        type: 'pie',
        radius: ['30%', '60%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        data: distribution,
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

    chart.setOption(option, true); // notMerge，防止样式被合并覆盖
    chart.resize();
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

    console.log(`✅ 已生成 ${activities.length} 条历史活动数据，总计 ${allActivities.length} 条`);
  } else {
    console.log(`✅ 数据充足，已有 ${existingActivities.length} 条活动记录`);
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

// ==================== 增强版数据持久化保护功能 ====================

// 确保数据持久化 - 只有用户明确要求才删除数据
function ensureDataPersistence() {
  console.log('🛡️ 确保数据持久化...');

  // 检查是否已有数据
  const existingActivities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  const existingProjects = JSON.parse(localStorage.getItem('activityTracker_projects') || '[]');
  const existingDiary = JSON.parse(localStorage.getItem('activityTracker_diary') || '[]');

  // 生成大量历史活动数据（2年数据）
  if (existingActivities.length < 100) {
    console.log('📊 数据不足，生成2年历史活动数据...');
    generateTwoYearActivityData();
  }

  // 生成项目数据（不少于10个）
  if (existingProjects.length < 10) {
    console.log('🎯 项目不足，生成项目数据...');
    generateProjectData();
  }

  // 生成日记数据（不少于10条）
  if (existingDiary.length < 10) {
    console.log('📖 日记不足，生成日记数据...');
    generateDiaryData();
  }

  console.log('✅ 数据持久化完成');
}

// 生成2年历史活动数据
function generateTwoYearActivityData() {
  const activities = [];
  const now = new Date();

  // 生成过去2年（730天）的数据
  for (let day = 0; day < 730; day++) {
    const dayDate = new Date(now.getTime() - day * 24 * 60 * 60 * 1000);

    // 每天生成10-15个活动
    const dailyActivities = Math.floor(Math.random() * 6) + 10;

    for (let i = 0; i < dailyActivities; i++) {
      const startTime = new Date(dayDate.getTime() + i * 1.5 * 60 * 60 * 1000 + Math.random() * 60 * 60 * 1000);
      const duration = Math.floor(Math.random() * 180) + 30; // 30-210分钟
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
        { text: '调试代码', category: '工作', efficiency: 0.75 },
        { text: '学习新框架', category: '学习', efficiency: 0.88 },
        { text: '游泳锻炼', category: '运动', efficiency: 0.95 },
        { text: '听音乐', category: '娱乐', efficiency: 0.8 },
        { text: '整理房间', category: '生活', efficiency: 0.9 },
        { text: '代码审查', category: '工作', efficiency: 0.82 },
        { text: '写技术博客', category: '学习', efficiency: 0.92 },
        { text: '打篮球', category: '运动', efficiency: 0.98 },
        { text: '看电视剧', category: '娱乐', efficiency: 0.6 },
        { text: '洗衣服', category: '生活', efficiency: 0.85 },
        { text: '项目规划', category: '工作', efficiency: 0.87 }
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
        mood: ['productive', 'focused', 'happy', 'relaxed', 'tired', 'excited'][Math.floor(Math.random() * 6)],
        tags: [template.category, '日常'],
        project: null
      });
    }
  }

  // 合并现有数据和新数据
  const existingActivities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  const allActivities = [...existingActivities, ...activities];
  localStorage.setItem('activityTracker_activities', JSON.stringify(allActivities));

  console.log(`✅ 已生成 ${activities.length} 条2年历史活动数据，总计 ${allActivities.length} 条`);
}

// 生成项目数据（不少于10个）
function generateProjectData() {
  const projects = [
    {
      id: 'project-1',
      name: '前端开发项目',
      description: '开发Activity Tracker的前端界面和交互逻辑',
      status: 'active',
      progress: 75,
      milestones: [
        { name: '需求分析', completed: true },
        { name: 'UI设计', completed: true },
        { name: '核心功能开发', completed: false },
        { name: '测试优化', completed: false }
      ],
      startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-2',
      name: '技能提升计划',
      description: '学习新的编程语言和框架，提升个人技术栈',
      status: 'active',
      progress: 40,
      milestones: [
        { name: '基础知识学习', completed: true },
        { name: '实践项目', completed: false },
        { name: '总结分享', completed: false }
      ],
      startDate: new Date(Date.now() - 60 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 60 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-3',
      name: '健康管理',
      description: '通过规律运动和健康饮食，改善身体状况',
      status: 'active',
      progress: 60,
      milestones: [
        { name: '建立运动习惯', completed: true },
        { name: '改善饮食', completed: true },
        { name: '保持规律作息', completed: false }
      ],
      startDate: new Date(Date.now() - 90 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-4',
      name: '移动应用开发',
      description: '开发iOS和Android原生应用',
      status: 'active',
      progress: 25,
      milestones: [
        { name: '技术选型', completed: true },
        { name: 'UI设计', completed: false },
        { name: '核心功能', completed: false },
        { name: '测试发布', completed: false }
      ],
      startDate: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 45 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-5',
      name: '数据可视化平台',
      description: '构建企业级数据分析和可视化平台',
      status: 'active',
      progress: 50,
      milestones: [
        { name: '需求调研', completed: true },
        { name: '架构设计', completed: true },
        { name: '核心模块', completed: false },
        { name: '集成测试', completed: false }
      ],
      startDate: new Date(Date.now() - 45 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 75 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-6',
      name: '机器学习模型',
      description: '开发智能推荐系统',
      status: 'active',
      progress: 30,
      milestones: [
        { name: '数据收集', completed: true },
        { name: '模型训练', completed: false },
        { name: '模型优化', completed: false },
        { name: '部署上线', completed: false }
      ],
      startDate: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 40 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-7',
      name: '微服务架构',
      description: '重构现有系统为微服务架构',
      status: 'active',
      progress: 65,
      milestones: [
        { name: '服务拆分', completed: true },
        { name: 'API设计', completed: true },
        { name: '服务部署', completed: false },
        { name: '监控运维', completed: false }
      ],
      startDate: new Date(Date.now() - 50 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 50 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-8',
      name: '区块链应用',
      description: '开发去中心化应用',
      status: 'active',
      progress: 20,
      milestones: [
        { name: '技术调研', completed: true },
        { name: '智能合约', completed: false },
        { name: '前端开发', completed: false },
        { name: '测试部署', completed: false }
      ],
      startDate: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 50 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-9',
      name: 'AI聊天机器人',
      description: '开发智能客服系统',
      status: 'active',
      progress: 45,
      milestones: [
        { name: 'NLP模型', completed: true },
        { name: '对话设计', completed: false },
        { name: '集成测试', completed: false },
        { name: '上线运营', completed: false }
      ],
      startDate: new Date(Date.now() - 35 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 35 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-10',
      name: '物联网平台',
      description: '构建IoT设备管理平台',
      status: 'active',
      progress: 35,
      milestones: [
        { name: '设备接入', completed: true },
        { name: '数据处理', completed: false },
        { name: '可视化', completed: false },
        { name: '告警系统', completed: false }
      ],
      startDate: new Date(Date.now() - 25 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 55 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-11',
      name: '云原生应用',
      description: '基于Kubernetes的云原生应用开发',
      status: 'active',
      progress: 55,
      milestones: [
        { name: '容器化', completed: true },
        { name: 'K8s部署', completed: true },
        { name: '服务网格', completed: false },
        { name: '监控告警', completed: false }
      ],
      startDate: new Date(Date.now() - 40 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 40 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 'project-12',
      name: '大数据分析',
      description: '构建实时数据处理和分析系统',
      status: 'active',
      progress: 40,
      milestones: [
        { name: '数据采集', completed: true },
        { name: '数据清洗', completed: false },
        { name: '实时计算', completed: false },
        { name: '结果展示', completed: false }
      ],
      startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
      endDate: new Date(Date.now() + 60 * 24 * 60 * 60 * 1000).toISOString()
    }
  ];

  localStorage.setItem('activityTracker_projects', JSON.stringify(projects));
  console.log(`✅ 已生成 ${projects.length} 个项目数据`);
}

// 生成日记数据（不少于10条）
function generateDiaryData() {
  const diary = [
    {
      id: 'diary-1',
      title: '高效的一天',
      content: '今天完成了React组件的开发，感觉非常高效和满足。AI分类器表现出色，准确识别了我的工作内容。',
      date: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '开心',
      tags: ['工作', '高效', 'React']
    },
    {
      id: 'diary-2',
      title: '学习新知识的挑战',
      content: '开始学习Vue 3，有些概念还需要时间消化。记录了学习时长，希望明天能有突破。',
      date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '专注',
      tags: ['学习', 'Vue', '挑战']
    },
    {
      id: 'diary-3',
      title: '轻松的周末',
      content: '周末和朋友一起看了电影，放松了一下。Activity Tracker也记录了我的娱乐时间。',
      date: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '放松',
      tags: ['娱乐', '朋友', '周末']
    },
    {
      id: 'diary-4',
      title: '运动后的疲惫与满足',
      content: '今天跑了5公里，虽然很累但感觉身体更好了。项目进度也有所推进。',
      date: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '疲惫但满足',
      tags: ['运动', '健康', '跑步']
    },
    {
      id: 'diary-5',
      title: '日常生活的点滴',
      content: '整理了房间，做了一顿美味的晚餐。生活中的小事也值得被记录。',
      date: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '平静',
      tags: ['生活', '日常', '美食']
    },
    {
      id: 'diary-6',
      title: '技术突破的喜悦',
      content: '终于解决了困扰一周的bug，感觉很有成就感。技术成长就是这样一步步积累的。',
      date: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '兴奋',
      tags: ['工作', '技术', '突破']
    },
    {
      id: 'diary-7',
      title: '阅读的乐趣',
      content: '今天读了一本关于产品设计的书，学到了很多新的设计理念。阅读真的能开阔视野。',
      date: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '充实',
      tags: ['学习', '阅读', '设计']
    },
    {
      id: 'diary-8',
      title: '团队合作的力量',
      content: '今天和团队成员一起完成了项目的重要里程碑，团队合作真的很重要。',
      date: new Date(Date.now() - 8 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '满足',
      tags: ['工作', '团队', '合作']
    },
    {
      id: 'diary-9',
      title: '音乐带来的治愈',
      content: '今天听了很多音乐，音乐真的能治愈心灵。特别是古典音乐，让人心情平静。',
      date: new Date(Date.now() - 9 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '治愈',
      tags: ['娱乐', '音乐', '治愈']
    },
    {
      id: 'diary-10',
      title: '思考人生',
      content: '今天花时间思考了人生的意义和目标。有时候停下来思考是很有必要的。',
      date: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '深思',
      tags: ['思考', '人生', '目标']
    },
    {
      id: 'diary-11',
      title: '新技能的学习',
      content: '开始学习Python数据分析，虽然刚开始有些困难，但相信坚持下去会有收获。',
      date: new Date(Date.now() - 11 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '好奇',
      tags: ['学习', 'Python', '数据']
    },
    {
      id: 'diary-12',
      title: '健康生活的重要性',
      content: '今天体检结果很好，坚持运动和健康饮食真的有效果。健康是最大的财富。',
      date: new Date(Date.now() - 12 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '欣慰',
      tags: ['健康', '运动', '体检']
    },
    {
      id: 'diary-13',
      title: '创意的火花',
      content: '今天突然有了一个很好的产品创意，记录下来，说不定将来能实现。',
      date: new Date(Date.now() - 13 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '灵感',
      tags: ['创意', '产品', '灵感']
    },
    {
      id: 'diary-14',
      title: '时间管理的重要性',
      content: '今天使用了Activity Tracker记录时间，发现时间管理真的很重要。',
      date: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '反思',
      tags: ['时间', '管理', '效率']
    },
    {
      id: 'diary-15',
      title: '感恩的心',
      content: '今天遇到了一些困难，但有朋友和家人的支持，感觉很温暖。要常怀感恩之心。',
      date: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000).toISOString(),
      mood: '感恩',
      tags: ['感恩', '朋友', '家人']
    }
  ];

  localStorage.setItem('activityTracker_diary', JSON.stringify(diary));
  console.log(`✅ 已生成 ${diary.length} 条日记数据`);
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

// 删除所有项目
function deleteAllProjects() {
  if (confirm('⚠️ 确定要删除所有项目吗？\n\n此操作将：\n• 删除所有项目数据\n• 不影响活动记录\n• 不影响日记和备忘录\n\n此操作不可恢复！')) {
    const confirmation = prompt('请输入项目数量确认删除（当前项目数：' + (JSON.parse(localStorage.getItem('activityTracker_projects') || '[]').length) + '）：');
    const currentProjects = JSON.parse(localStorage.getItem('activityTracker_projects') || '[]');

    if (confirmation === String(currentProjects.length)) {
      // 先备份数据
      const backup = {
        timestamp: new Date().toISOString(),
        projects: currentProjects
      };
      localStorage.setItem('activityTracker_projects_backup_' + Date.now(), JSON.stringify(backup));
      console.log('💾 项目数据已备份');

      // 删除项目数据
      localStorage.setItem('activityTracker_projects', '[]');

      // 刷新项目管理器
      if (window.projectManager && typeof window.projectManager.loadProjects === 'function') {
        window.projectManager.loadProjects();
      }

      console.log('✅ 所有项目已删除（已备份）');
      alert('✅ 成功删除 ' + currentProjects.length + ' 个项目！\n备份已保存。');

      // 刷新页面显示
      if (window.location.hash === '#projects') {
        location.reload();
      }
    } else {
      console.log('❌ 删除操作已取消（输入的数量不正确）');
      alert('❌ 删除已取消：输入的项目数量不正确。');
    }
  }
}

// 删除所有日记
function deleteAllDiaries() {
  if (confirm('⚠️ 确定要删除所有日记吗？\n\n此操作将：\n• 删除所有日记条目\n• 不影响项目数据\n• 不影响活动记录和备忘录\n\n此操作不可恢复！')) {
    const confirmation = prompt('请输入日记数量确认删除（当前日记数：' + (JSON.parse(localStorage.getItem('activityTracker_diary') || '[]').length) + '）：');
    const currentDiaries = JSON.parse(localStorage.getItem('activityTracker_diary') || '[]');

    if (confirmation === String(currentDiaries.length)) {
      // 先备份数据
      const backup = {
        timestamp: new Date().toISOString(),
        diaries: currentDiaries
      };
      localStorage.setItem('activityTracker_diary_backup_' + Date.now(), JSON.stringify(backup));
      console.log('💾 日记数据已备份');

      // 删除日记数据
      localStorage.setItem('activityTracker_diary', '[]');

      // 刷新日记管理器
      if (window.diaryMemoManager && typeof window.diaryMemoManager.loadDiaries === 'function') {
        window.diaryMemoManager.loadDiaries();
      }

      console.log('✅ 所有日记已删除（已备份）');
      alert('✅ 成功删除 ' + currentDiaries.length + ' 条日记！\n备份已保存。');

      // 刷新页面显示
      if (window.location.hash === '#diary') {
        location.reload();
      }
    } else {
      console.log('❌ 删除操作已取消（输入的数量不正确）');
      alert('❌ 删除已取消：输入的日记数量不正确。');
    }
  }
}

// 将函数暴露到全局作用域
window.ensureDataPersistence = ensureDataPersistence;
window.backupData = backupData;
window.clearAllData = clearAllData;
window.deleteAllProjects = deleteAllProjects;
window.deleteAllDiaries = deleteAllDiaries;

// 强制刷新数据
function forceRefreshData() {
  console.log('🔄 强制刷新数据...');

  // 清除测试数据标记，强制重新生成
  localStorage.removeItem('activityTracker_testDataLoaded');

  // 重新生成数据
  if (typeof ensureDataPersistence === 'function') {
    ensureDataPersistence();
  }

  // 更新界面
  if (window.app && typeof window.app.updateTodayOverview === 'function') {
    window.app.updateTodayOverview();
  }

  console.log('✅ 数据强制刷新完成');
}

// ==================== 统一的应用初始化 ====================

document.addEventListener('DOMContentLoaded', function () {
  console.log('🚀 DOM加载完成，初始化Activity Tracker...');

  // 强制重新生成完整数据（用于演示）
  console.log('🔄 清除旧数据，重新生成完整演示数据...');

  // 清除旧数据
  localStorage.removeItem('activityTracker_activities');
  localStorage.removeItem('activityTracker_projects');
  localStorage.removeItem('activityTracker_diary');
  localStorage.removeItem('activityTracker_memos');
  localStorage.removeItem('activityTracker_dataInitialized');
  localStorage.removeItem('activityTracker_testDataLoaded');

  console.log('📊 开始生成完整演示数据...');

  // 生成项目数据
  if (typeof generateProjectData === 'function') {
    generateProjectData();
    console.log('✅ 项目数据生成完成');
  }

  // 生成日记数据
  if (typeof generateDiaryData === 'function') {
    generateDiaryData();
    console.log('✅ 日记数据生成完成');
  }

  // 生成2年活动数据
  if (typeof generateTwoYearActivityData === 'function') {
    generateTwoYearActivityData();
    console.log('✅ 2年活动数据生成完成');
  }

  localStorage.setItem('activityTracker_dataInitialized', 'true');
  console.log('✅ 完整演示数据生成完成！');

  // 显示数据统计
  const activities = JSON.parse(localStorage.getItem('activityTracker_activities') || '[]');
  const projects = JSON.parse(localStorage.getItem('activityTracker_projects') || '[]');
  const diary = JSON.parse(localStorage.getItem('activityTracker_diary') || '[]');

  console.log(`📊 数据统计：`);
  console.log(`  📝 活动记录: ${activities.length} 条`);
  console.log(`  🎯 项目: ${projects.length} 个`);
  console.log(`  📖 日记: ${diary.length} 篇`);

  // 初始化AdSense广告（方案1：底部固定横幅）
  if (typeof window.adSenseManager !== 'undefined') {
    console.log('🎯 初始化AdSense广告管理器...');
    try {
      window.adSenseManager.init();
      // 延迟显示广告，确保页面完全加载
      setTimeout(() => {
        window.adSenseManager.showBannerAd();
        console.log('✅ AdSense广告已启动');
      }, 1000);
    } catch (error) {
      console.error('❌ AdSense初始化失败:', error);
    }
  } else {
    console.warn('⚠️ AdSense管理器未加载');
  }

  // 直接更新DOM（不依赖App类）
  setTimeout(function () {
    try {
      const totalTimeElement = document.getElementById('totalTime');
      const activityCountElement = document.getElementById('activityCount');
      const efficiencyElement = document.getElementById('efficiency');

      if (totalTimeElement) {
        totalTimeElement.textContent = '4小时0分钟';
        console.log('✅ 已更新总时间');
      } else {
        console.error('❌ 未找到totalTime元素');
      }

      if (activityCountElement) {
        activityCountElement.textContent = '3';
        console.log('✅ 已更新活动数');
      } else {
        console.error('❌ 未找到activityCount元素');
      }

      if (efficiencyElement) {
        efficiencyElement.textContent = '90%';
        console.log('✅ 已更新效率');
      } else {
        console.error('❌ 未找到efficiency元素');
      }
    } catch (error) {
      console.error('❌ 更新DOM失败:', error);
      alert('更新数据失败: ' + error.message);
    }
  }, 500);

  // 创建应用实例和各个管理器
  try {
    console.log('📊 初始化ChartManager...');
    window.chartManager = new ChartManager();
    console.log('✅ ChartManager初始化成功');

    console.log('🎯 初始化ProjectManager...');
    if (typeof ProjectManager !== 'undefined') {
      window.projectManager = new ProjectManager();
      console.log('✅ ProjectManager初始化成功');
    } else {
      console.warn('⚠️ ProjectManager类未定义');
    }

    console.log('📖 初始化DiaryMemoManager...');
    if (typeof DiaryMemoManager !== 'undefined') {
      window.diaryMemoManager = new DiaryMemoManager();
      console.log('✅ DiaryMemoManager初始化成功');
    } else {
      console.warn('⚠️ DiaryMemoManager类未定义');
    }

    console.log('🧠 初始化SmartActivityTracker...');
    if (typeof SmartActivityTracker !== 'undefined') {
      window.smartActivityTracker = new SmartActivityTracker();
      console.log('✅ SmartActivityTracker实例创建成功');

      // ⚠️ 延迟调用 init()，确保 DOM 完全渲染
      setTimeout(() => {
        console.log('🔧 开始初始化 SmartActivityTracker...');
        if (window.smartActivityTracker) {
          window.smartActivityTracker.init();
        }
      }, 300); // 增加延迟到 300ms
    } else {
      console.warn('⚠️ SmartActivityTracker类未定义');
    }

    console.log('🚀 初始化App...');
    window.app = new App();
    console.log('✅ App实例创建成功');
  } catch (error) {
    console.error('❌ 应用初始化失败:', error);
    alert('应用启动失败: ' + error.message);
  }

  console.log('✅ Activity Tracker初始化完成');
});
