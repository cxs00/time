/**
 * ==================== 高级图表模块 ====================
 * 功能：提供更多类型的数据可视化图表
 * 版本：v1.0.0
 * 日期：2025-10-26
 * 
 * 包含图表类型：
 * 1. 雷达图 - 能力分析
 * 2. 日历热力图 - 活动频率
 * 3. 桑基图 - 时间流向
 * 4. 树图 - 项目层级
 * 5. 漏斗图 - 任务转化
 * 6. 关系图 - 项目关联
 * ====================================================
 */

class AdvancedCharts {
  /**
   * 构造函数
   */
  constructor() {
    this.charts = {}; // 存储图表实例
    console.log('✅ 高级图表模块已初始化');
  }

  /**
   * 1. 雷达图 - 显示多维度能力分析
   * 用于展示用户在不同活动类型上的时间分配
   * 
   * @param {string} containerId - 容器ID
   * @param {Array} activities - 活动数据
   * @returns {Object} 图表实例
   */
  renderRadarChart(containerId, activities) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error(`容器不存在: ${containerId}`);
      return null;
    }

    // 销毁已存在的图表
    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
    }

    // 计算各分类的时间占比
    const categoryStats = this.calculateCategoryStats(activities);
    
    // 准备雷达图数据
    const categories = Object.keys(categoryStats);
    const values = Object.values(categoryStats);
    
    // 标准化数据（转换为0-100的百分比）
    const maxValue = Math.max(...values);
    const normalizedValues = values.map(v => (v / maxValue * 100).toFixed(1));

    const option = {
      title: {
        text: '能力雷达图',
        subtext: '各分类时间投入分析',
        left: 'center',
        textStyle: {
          color: '#333',
          fontSize: 18,
          fontWeight: 'bold'
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: (params) => {
          const index = params.dataIndex;
          return `${categories[index]}<br/>时间：${this.formatDuration(values[index])}<br/>占比：${normalizedValues[index]}%`;
        }
      },
      legend: {
        data: ['时间投入'],
        bottom: 10
      },
      radar: {
        indicator: categories.map((cat, index) => ({
          name: cat,
          max: 100,
          color: '#666'
        })),
        shape: 'polygon',
        splitNumber: 5,
        name: {
          textStyle: {
            color: '#333',
            fontSize: 12
          }
        },
        splitLine: {
          lineStyle: {
            color: ['#ddd', '#eee', '#eee', '#eee', '#eee']
          }
        },
        splitArea: {
          areaStyle: {
            color: ['rgba(102, 126, 234, 0.05)', 'transparent']
          }
        },
        axisLine: {
          lineStyle: {
            color: '#ddd'
          }
        }
      },
      series: [{
        name: '时间投入',
        type: 'radar',
        data: [{
          value: normalizedValues,
          name: '时间分布',
          areaStyle: {
            color: 'rgba(102, 126, 234, 0.2)'
          },
          lineStyle: {
            color: '#667eea',
            width: 2
          },
          itemStyle: {
            color: '#667eea',
            borderWidth: 2
          }
        }],
        emphasis: {
          lineStyle: {
            width: 4
          }
        }
      }]
    };

    const chart = echarts.init(container);
    chart.setOption(option);
    this.charts[containerId] = chart;

    // 响应式
    window.addEventListener('resize', () => chart.resize());

    return chart;
  }

  /**
   * 2. 日历热力图 - 显示活动频率
   * 用于展示每天的活动数量和时长
   * 
   * @param {string} containerId - 容器ID
   * @param {Array} activities - 活动数据
   * @param {number} days - 显示天数（默认90天）
   * @returns {Object} 图表实例
   */
  renderCalendarHeatmap(containerId, activities, days = 90) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error(`容器不存在: ${containerId}`);
      return null;
    }

    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
    }

    // 准备日历数据
    const heatmapData = this.prepareHeatmapData(activities, days);
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const option = {
      title: {
        text: '活动日历热力图',
        subtext: `最近${days}天活动分布`,
        left: 'center',
        textStyle: {
          color: '#333',
          fontSize: 18,
          fontWeight: 'bold'
        }
      },
      tooltip: {
        position: 'top',
        formatter: (params) => {
          const date = params.data[0];
          const value = params.data[1];
          return `${date}<br/>活动：${value}个<br/>时长：${this.formatDuration(value * 30)}`;
        }
      },
      visualMap: {
        min: 0,
        max: Math.max(...heatmapData.map(d => d[1]), 10),
        calculable: true,
        orient: 'horizontal',
        left: 'center',
        bottom: 10,
        inRange: {
          color: ['#ebedf0', '#c6e48b', '#7bc96f', '#239a3b', '#196127']
        },
        text: ['高', '低']
      },
      calendar: [{
        range: [
          startDate.toISOString().split('T')[0],
          new Date().toISOString().split('T')[0]
        ],
        cellSize: ['auto', 20],
        splitLine: {
          show: true,
          lineStyle: {
            color: '#fff',
            width: 2
          }
        },
        yearLabel: {
          show: false
        },
        monthLabel: {
          nameMap: 'cn',
          fontSize: 12
        },
        dayLabel: {
          nameMap: 'cn',
          fontSize: 11
        },
        itemStyle: {
          borderWidth: 0.5,
          borderColor: '#fff'
        }
      }],
      series: [{
        type: 'heatmap',
        coordinateSystem: 'calendar',
        data: heatmapData
      }]
    };

    const chart = echarts.init(container);
    chart.setOption(option);
    this.charts[containerId] = chart;

    window.addEventListener('resize', () => chart.resize());

    return chart;
  }

  /**
   * 3. 桑基图 - 显示时间流向
   * 用于展示从活动类型到项目的时间流动
   * 
   * @param {string} containerId - 容器ID
   * @param {Array} activities - 活动数据
   * @param {Array} projects - 项目数据
   * @returns {Object} 图表实例
   */
  renderSankeyDiagram(containerId, activities, projects) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error(`容器不存在: ${containerId}`);
      return null;
    }

    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
    }

    // 准备桑基图数据
    const { nodes, links } = this.prepareSankeyData(activities, projects);

    const option = {
      title: {
        text: '时间流向分析',
        subtext: '从活动分类到项目的时间流动',
        left: 'center',
        textStyle: {
          color: '#333',
          fontSize: 18,
          fontWeight: 'bold'
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: (params) => {
          if (params.dataType === 'edge') {
            return `${params.data.source} → ${params.data.target}<br/>时长：${this.formatDuration(params.data.value)}`;
          }
          return `${params.name}<br/>总时长：${this.formatDuration(params.value)}`;
        }
      },
      series: [{
        type: 'sankey',
        layout: 'none',
        emphasis: {
          focus: 'adjacency'
        },
        data: nodes,
        links: links,
        lineStyle: {
          color: 'gradient',
          curveness: 0.5
        },
        label: {
          fontSize: 12,
          color: '#333'
        },
        itemStyle: {
          borderWidth: 1,
          borderColor: '#fff'
        }
      }]
    };

    const chart = echarts.init(container);
    chart.setOption(option);
    this.charts[containerId] = chart;

    window.addEventListener('resize', () => chart.resize());

    return chart;
  }

  /**
   * 4. 树图 - 显示项目层级结构
   * 用于展示项目和子任务的层级关系
   * 
   * @param {string} containerId - 容器ID
   * @param {Array} projects - 项目数据
   * @param {Array} activities - 活动数据
   * @returns {Object} 图表实例
   */
  renderTreeMap(containerId, projects, activities) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error(`容器不存在: ${containerId}`);
      return null;
    }

    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
    }

    // 准备树图数据
    const treeData = this.prepareTreeData(projects, activities);

    const option = {
      title: {
        text: '项目时间分布树图',
        subtext: '各项目及活动的时间占比',
        left: 'center',
        textStyle: {
          color: '#333',
          fontSize: 18,
          fontWeight: 'bold'
        }
      },
      tooltip: {
        formatter: (params) => {
          return `${params.name}<br/>时长：${this.formatDuration(params.value)}<br/>占比：${params.treePathInfo[params.treePathInfo.length - 1].value}%`;
        }
      },
      series: [{
        type: 'treemap',
        data: treeData,
        width: '95%',
        height: '80%',
        top: '15%',
        roam: false,
        nodeClick: false,
        breadcrumb: {
          show: true,
          height: 22,
          bottom: 0
        },
        label: {
          show: true,
          formatter: '{b}\n{c}分钟',
          fontSize: 12
        },
        itemStyle: {
          borderColor: '#fff',
          borderWidth: 2,
          gapWidth: 2
        },
        levels: [
          {
            itemStyle: {
              borderColor: '#777',
              borderWidth: 2,
              gapWidth: 2
            }
          },
          {
            colorSaturation: [0.35, 0.5],
            itemStyle: {
              gapWidth: 1,
              borderColorSaturation: 0.6
            }
          }
        ]
      }]
    };

    const chart = echarts.init(container);
    chart.setOption(option);
    this.charts[containerId] = chart;

    window.addEventListener('resize', () => chart.resize());

    return chart;
  }

  /**
   * 5. 漏斗图 - 显示任务转化
   * 用于展示从开始到完成的任务流程
   * 
   * @param {string} containerId - 容器ID
   * @param {Object} conversionData - 转化数据
   * @returns {Object} 图表实例
   */
  renderFunnelChart(containerId, conversionData) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error(`容器不存在: ${containerId}`);
      return null;
    }

    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
    }

    // 默认转化数据
    const defaultData = [
      { value: 100, name: '计划任务' },
      { value: 80, name: '已开始' },
      { value: 60, name: '进行中' },
      { value: 40, name: '接近完成' },
      { value: 30, name: '已完成' }
    ];

    const data = conversionData || defaultData;

    const option = {
      title: {
        text: '任务转化漏斗图',
        subtext: '从计划到完成的转化率',
        left: 'center',
        textStyle: {
          color: '#333',
          fontSize: 18,
          fontWeight: 'bold'
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: '{b}: {c}个 ({d}%)'
      },
      legend: {
        data: data.map(d => d.name),
        bottom: 10
      },
      series: [{
        name: '任务转化',
        type: 'funnel',
        left: '10%',
        top: 60,
        bottom: 60,
        width: '80%',
        min: 0,
        max: 100,
        minSize: '0%',
        maxSize: '100%',
        sort: 'descending',
        gap: 2,
        label: {
          show: true,
          position: 'inside',
          formatter: '{b}: {c}',
          fontSize: 14
        },
        labelLine: {
          length: 10,
          lineStyle: {
            width: 1,
            type: 'solid'
          }
        },
        itemStyle: {
          borderColor: '#fff',
          borderWidth: 1
        },
        emphasis: {
          label: {
            fontSize: 16
          }
        },
        data: data.map((item, index) => ({
          ...item,
          itemStyle: {
            color: this.getFunnelColor(index, data.length)
          }
        }))
      }]
    };

    const chart = echarts.init(container);
    chart.setOption(option);
    this.charts[containerId] = chart;

    window.addEventListener('resize', () => chart.resize());

    return chart;
  }

  /**
   * 6. 关系图 - 显示项目和活动的关联关系
   * 
   * @param {string} containerId - 容器ID
   * @param {Array} projects - 项目数据
   * @param {Array} activities - 活动数据
   * @returns {Object} 图表实例
   */
  renderRelationGraph(containerId, projects, activities) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error(`容器不存在: ${containerId}`);
      return null;
    }

    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
    }

    // 准备关系图数据
    const { nodes, links } = this.prepareRelationData(projects, activities);

    const option = {
      title: {
        text: '项目关联关系图',
        subtext: '项目与活动的关联网络',
        left: 'center',
        textStyle: {
          color: '#333',
          fontSize: 18,
          fontWeight: 'bold'
        }
      },
      tooltip: {
        formatter: (params) => {
          if (params.dataType === 'edge') {
            return `${params.data.source} ↔ ${params.data.target}<br/>关联度：${params.data.value}`;
          }
          return `${params.name}<br/>类型：${params.data.category}<br/>数量：${params.data.value}`;
        }
      },
      legend: [{
        data: ['项目', '活动'],
        bottom: 10
      }],
      series: [{
        type: 'graph',
        layout: 'force',
        data: nodes,
        links: links,
        categories: [
          { name: '项目' },
          { name: '活动' }
        ],
        roam: true,
        label: {
          show: true,
          position: 'right',
          formatter: '{b}',
          fontSize: 12
        },
        labelLayout: {
          hideOverlap: true
        },
        scaleLimit: {
          min: 0.4,
          max: 2
        },
        lineStyle: {
          color: 'source',
          curveness: 0.3
        },
        emphasis: {
          focus: 'adjacency',
          lineStyle: {
            width: 3
          }
        },
        force: {
          repulsion: 2500,
          edgeLength: [100, 200],
          gravity: 0.1
        }
      }]
    };

    const chart = echarts.init(container);
    chart.setOption(option);
    this.charts[containerId] = chart;

    window.addEventListener('resize', () => chart.resize());

    return chart;
  }

  // ==================== 辅助方法 ====================

  /**
   * 计算各分类的统计数据
   */
  calculateCategoryStats(activities) {
    const stats = {};
    activities.forEach(activity => {
      const category = activity.category || '未分类';
      const duration = activity.duration || 0;
      stats[category] = (stats[category] || 0) + duration;
    });
    return stats;
  }

  /**
   * 准备热力图数据
   */
  prepareHeatmapData(activities, days) {
    const data = [];
    const today = new Date();
    
    for (let i = days; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      
      // 计算当天的活动数量
      const count = activities.filter(a => {
        const actDate = new Date(a.startTime).toISOString().split('T')[0];
        return actDate === dateStr;
      }).length;
      
      data.push([dateStr, count]);
    }
    
    return data;
  }

  /**
   * 准备桑基图数据
   */
  prepareSankeyData(activities, projects) {
    const nodes = [];
    const links = [];
    const nodeMap = new Map();
    
    // 添加分类节点
    const categories = [...new Set(activities.map(a => a.category || '未分类'))];
    categories.forEach(cat => {
      nodes.push({ name: cat });
      nodeMap.set(cat, 0);
    });
    
    // 添加项目节点
    projects.forEach(proj => {
      nodes.push({ name: proj.name });
      nodeMap.set(proj.name, 0);
    });
    
    // 创建链接
    activities.forEach(activity => {
      const source = activity.category || '未分类';
      const target = activity.project || '其他';
      const value = activity.duration || 30;
      
      // 查找或创建链接
      let link = links.find(l => l.source === source && l.target === target);
      if (link) {
        link.value += value;
      } else {
        links.push({ source, target, value });
      }
    });
    
    return { nodes, links };
  }

  /**
   * 准备树图数据
   */
  prepareTreeData(projects, activities) {
    const treeData = projects.map(project => {
      // 找到属于这个项目的所有活动
      const projectActivities = activities.filter(a => a.project === project.name);
      
      // 按分类分组
      const categoryGroups = {};
      projectActivities.forEach(activity => {
        const category = activity.category || '未分类';
        if (!categoryGroups[category]) {
          categoryGroups[category] = [];
        }
        categoryGroups[category].push(activity);
      });
      
      // 创建子节点
      const children = Object.keys(categoryGroups).map(category => ({
        name: category,
        value: categoryGroups[category].reduce((sum, a) => sum + (a.duration || 0), 0)
      }));
      
      return {
        name: project.name,
        value: projectActivities.reduce((sum, a) => sum + (a.duration || 0), 0),
        children: children.length > 0 ? children : undefined
      };
    });
    
    return treeData;
  }

  /**
   * 准备关系图数据
   */
  prepareRelationData(projects, activities) {
    const nodes = [];
    const links = [];
    
    // 添加项目节点
    projects.forEach((project, index) => {
      nodes.push({
        id: `proj_${project.id}`,
        name: project.name,
        symbolSize: 50,
        category: 0,
        value: activities.filter(a => a.project === project.name).length
      });
    });
    
    // 添加活动分类节点
    const categories = [...new Set(activities.map(a => a.category || '未分类'))];
    categories.forEach((cat, index) => {
      nodes.push({
        id: `cat_${index}`,
        name: cat,
        symbolSize: 30,
        category: 1,
        value: activities.filter(a => a.category === cat).length
      });
    });
    
    // 创建链接
    activities.forEach(activity => {
      const projectNode = nodes.find(n => n.name === activity.project);
      const categoryNode = nodes.find(n => n.name === activity.category);
      
      if (projectNode && categoryNode) {
        const existingLink = links.find(l => 
          l.source === projectNode.id && l.target === categoryNode.id
        );
        
        if (existingLink) {
          existingLink.value += 1;
        } else {
          links.push({
            source: projectNode.id,
            target: categoryNode.id,
            value: 1
          });
        }
      }
    });
    
    return { nodes, links };
  }

  /**
   * 获取漏斗图颜色
   */
  getFunnelColor(index, total) {
    const colors = [
      '#667eea',
      '#764ba2',
      '#f093fb',
      '#4facfe',
      '#00f2fe'
    ];
    return colors[index % colors.length];
  }

  /**
   * 格式化时长
   */
  formatDuration(minutes) {
    if (minutes < 60) {
      return `${Math.round(minutes)}分钟`;
    }
    const hours = Math.floor(minutes / 60);
    const mins = Math.round(minutes % 60);
    return mins > 0 ? `${hours}小时${mins}分钟` : `${hours}小时`;
  }

  /**
   * 销毁所有图表
   */
  dispose() {
    Object.values(this.charts).forEach(chart => {
      if (chart) {
        chart.dispose();
      }
    });
    this.charts = {};
    console.log('✅ 所有高级图表已销毁');
  }

  /**
   * 销毁指定图表
   */
  disposeChart(containerId) {
    if (this.charts[containerId]) {
      this.charts[containerId].dispose();
      delete this.charts[containerId];
      console.log(`✅ 图表已销毁: ${containerId}`);
    }
  }
}

// 导出到全局
if (typeof window !== 'undefined') {
  window.AdvancedCharts = AdvancedCharts;
}

console.log('📊 高级图表模块已加载');

