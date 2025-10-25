// ==================== AI智能分类器 ====================

class AIClassifier {
  constructor() {
    this.history = [];
    this.patterns = this.loadPatterns();
    this.init();
  }

  init() {
    console.log('🤖 AI智能分类器初始化');
    this.loadHistory();
  }

  // 智能分类（升级版）
  classifyActivity(activityText, context = {}) {
    const text = activityText.toLowerCase();

    // 1. 基于关键词的分类（基础层）
    const keywordCategory = this.classifyByKeywords(text);

    // 2. 基于历史模式的分类（学习层）
    const historyCategory = this.classifyByHistory(text);

    // 3. 基于时间的分类（上下文层）
    const timeCategory = this.classifyByTime(context.currentTime);

    // 4. 基于项目的分类（关联层）
    const projectCategory = this.classifyByProject(context.relatedProject);

    // 综合评分
    const categories = [
      { category: keywordCategory, weight: 0.4 },
      { category: historyCategory, weight: 0.3 },
      { category: timeCategory, weight: 0.2 },
      { category: projectCategory, weight: 0.1 }
    ].filter(item => item.category);

    if (categories.length === 0) {
      return '其他';
    }

    // 加权投票
    const votes = {};
    categories.forEach(({ category, weight }) => {
      votes[category] = (votes[category] || 0) + weight;
    });

    // 返回得票最高的分类
    const bestCategory = Object.entries(votes)
      .sort((a, b) => b[1] - a[1])[0][0];

    // 记录分类结果用于学习
    this.recordClassification(activityText, bestCategory);

    console.log(`🎯 AI分类结果: ${activityText} → ${bestCategory}`);
    return bestCategory;
  }

  // 基于关键词分类
  classifyByKeywords(text) {
    const categoryPatterns = {
      '工作': {
        keywords: ['编程', '开发', '设计', '会议', '文档', '测试', '部署', '代码', '项目', '任务', 'bug', '修复', '优化', '前端', '后端', 'api', 'debug', '上线', '需求', '评审'],
        weight: 1.0
      },
      '学习': {
        keywords: ['看书', '教程', '课程', '研究', '练习', '复习', '学', '读', '阅读', '笔记', '记忆', '考试', '作业', '论文', '视频', '培训', '讲座'],
        weight: 1.0
      },
      '运动': {
        keywords: ['跑步', '健身', '游泳', '瑜伽', '骑行', '散步', '锻炼', '球', '运动', '训练', '拉伸', '有氧', '力量'],
        weight: 1.0
      },
      '娱乐': {
        keywords: ['游戏', '电影', '音乐', '社交', '旅行', '玩', '聊天', '刷', '看剧', '综艺', '直播', '短视频', '逛街'],
        weight: 1.0
      },
      '生活': {
        keywords: ['做饭', '购物', '清洁', '休息', '睡觉', '洗漱', '吃', '买', '打扫', '整理', '洗衣', '收拾'],
        weight: 1.0
      }
    };

    let maxScore = 0;
    let bestCategory = null;

    for (const [category, { keywords, weight }] of Object.entries(categoryPatterns)) {
      const matchCount = keywords.filter(keyword => text.includes(keyword)).length;
      const score = matchCount * weight;

      if (score > maxScore) {
        maxScore = score;
        bestCategory = category;
      }
    }

    return bestCategory;
  }

  // 基于历史模式分类
  classifyByHistory(text) {
    if (this.history.length === 0) {
      return null;
    }

    // 查找最相似的历史活动
    let maxSimilarity = 0;
    let bestMatch = null;

    this.history.forEach(record => {
      const similarity = this.calculateSimilarity(text, record.activity.toLowerCase());
      if (similarity > maxSimilarity && similarity > 0.5) {
        maxSimilarity = similarity;
        bestMatch = record;
      }
    });

    return bestMatch?.category;
  }

  // 基于时间分类
  classifyByTime(currentTime) {
    if (!currentTime) {
      currentTime = new Date();
    }

    const hour = currentTime.getHours();

    // 时间模式
    if (hour >= 9 && hour < 12) {
      return '工作'; // 上午工作时间
    } else if (hour >= 14 && hour < 18) {
      return '工作'; // 下午工作时间
    } else if (hour >= 19 && hour < 21) {
      return '学习'; // 晚上学习时间
    } else if (hour >= 21 && hour < 23) {
      return '娱乐'; // 晚上娱乐时间
    } else if (hour >= 6 && hour < 9) {
      return '生活'; // 早上生活时间
    } else if (hour >= 12 && hour < 14) {
      return '生活'; // 午餐时间
    }

    return null;
  }

  // 基于项目分类
  classifyByProject(projectId) {
    if (!projectId) {
      return null;
    }

    const projects = JSON.parse(localStorage.getItem('projects') || '[]');
    const project = projects.find(p => p.id === projectId);

    // 根据项目标签推断分类
    if (project?.tags) {
      const tags = project.tags.map(tag => tag.toLowerCase());

      if (tags.some(tag => ['开发', '编程', '项目'].includes(tag))) {
        return '工作';
      } else if (tags.some(tag => ['学习', '课程', '研究'].includes(tag))) {
        return '学习';
      }
    }

    return null;
  }

  // 计算文本相似度（简单版）
  calculateSimilarity(text1, text2) {
    const words1 = new Set(text1.split(/\s+/));
    const words2 = new Set(text2.split(/\s+/));

    let intersection = 0;
    words1.forEach(word => {
      if (words2.has(word)) {
        intersection++;
      }
    });

    const union = words1.size + words2.size - intersection;
    return union === 0 ? 0 : intersection / union;
  }

  // 记录分类结果
  recordClassification(activity, category) {
    this.history.push({
      activity: activity.toLowerCase(),
      category,
      timestamp: new Date()
    });

    // 只保留最近1000条记录
    if (this.history.length > 1000) {
      this.history = this.history.slice(-1000);
    }

    this.saveHistory();
  }

  // 智能项目关联（升级版）
  findRelatedProject(activityText, currentProjects) {
    const text = activityText.toLowerCase();
    let bestMatch = null;
    let maxScore = 0;

    currentProjects.forEach(project => {
      let score = 0;

      // 1. 项目名称匹配
      if (text.includes(project.name.toLowerCase())) {
        score += 5;
      }

      // 2. 项目标签匹配
      if (project.tags) {
        project.tags.forEach(tag => {
          if (text.includes(tag.toLowerCase())) {
            score += 3;
          }
        });
      }

      // 3. 项目描述匹配
      if (project.description) {
        const descWords = project.description.toLowerCase().split(/\s+/);
        descWords.forEach(word => {
          if (text.includes(word)) {
            score += 1;
          }
        });
      }

      // 4. 历史关联（如果之前做过类似活动）
      const relatedActivities = this.history.filter(h =>
        h.projectId === project.id &&
        this.calculateSimilarity(text, h.activity) > 0.3
      );
      score += relatedActivities.length * 2;

      if (score > maxScore) {
        maxScore = score;
        bestMatch = project;
      }
    });

    // 只有当匹配度足够高时才返回
    return maxScore > 3 ? bestMatch?.id : null;
  }

  // 智能进度计算（升级版）
  calculateSmartProgress(activity, project) {
    // 基础进度
    let progress = 1;

    // 1. 基于时长的进度
    const durationFactor = Math.min(2, activity.duration / 30); // 30分钟为基准
    progress *= durationFactor;

    // 2. 基于活动类型的系数
    const categoryMultiplier = {
      '工作': 1.5,
      '学习': 1.3,
      '其他': 1.0
    }[activity.category] || 1.0;
    progress *= categoryMultiplier;

    // 3. 基于项目优先级的系数
    const priorityMultiplier = {
      'high': 1.5,
      'medium': 1.0,
      'low': 0.7
    }[project.priority] || 1.0;
    progress *= priorityMultiplier;

    // 4. 基于活动质量的评估（通过关键词）
    const qualityKeywords = ['完成', '实现', '解决', '优化', '改进', '成功'];
    const hasQualityKeyword = qualityKeywords.some(keyword =>
      activity.activity.toLowerCase().includes(keyword)
    );
    if (hasQualityKeyword) {
      progress *= 1.2;
    }

    // 5. 时间衰减（避免短时间内进度增长过快）
    const recentActivities = project.activities?.slice(-5) || [];
    const recentDuration = recentActivities.reduce((sum, actId) => {
      const act = this.history.find(h => h.id === actId);
      return sum + (act?.duration || 0);
    }, 0);

    if (recentDuration > 120) { // 如果最近2小时已经有很多活动
      progress *= 0.8;
    }

    return Math.min(5, Math.max(0.1, progress)); // 限制在0.1-5%之间
  }

  // 智能建议
  suggestNextActivity(currentContext) {
    const hour = new Date().getHours();
    const recentActivities = this.history.slice(-10);

    const suggestions = [];

    // 基于时间的建议
    if (hour >= 9 && hour < 12) {
      suggestions.push('处理重要工作任务');
    } else if (hour >= 14 && hour < 16) {
      suggestions.push('继续项目开发');
    } else if (hour >= 19 && hour < 21) {
      suggestions.push('学习新技能');
    }

    // 基于历史模式的建议
    const frequentActivities = this.getFrequentActivities();
    suggestions.push(...frequentActivities.slice(0, 3));

    // 基于项目进度的建议
    const projects = JSON.parse(localStorage.getItem('projects') || '[]');
    const activeProjects = projects
      .filter(p => p.status === 'active' && p.progress < 100)
      .sort((a, b) => {
        // 优先级高的、进度低的优先
        const priorityScore = { high: 3, medium: 2, low: 1 };
        return (priorityScore[b.priority] * (100 - b.progress)) -
          (priorityScore[a.priority] * (100 - a.progress));
      });

    if (activeProjects.length > 0) {
      suggestions.push(`继续项目：${activeProjects[0].name}`);
    }

    return suggestions.filter((v, i, a) => a.indexOf(v) === i).slice(0, 5);
  }

  // 获取高频活动
  getFrequentActivities() {
    const activityCounts = {};

    this.history.forEach(record => {
      const activity = record.activity;
      activityCounts[activity] = (activityCounts[activity] || 0) + 1;
    });

    return Object.entries(activityCounts)
      .sort((a, b) => b[1] - a[1])
      .map(([activity]) => activity)
      .slice(0, 5);
  }

  // 数据持久化
  loadHistory() {
    try {
      const data = localStorage.getItem('classificationHistory');
      this.history = data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('加载分类历史失败:', error);
      this.history = [];
    }
  }

  saveHistory() {
    try {
      localStorage.setItem('classificationHistory', JSON.stringify(this.history));
    } catch (error) {
      console.error('保存分类历史失败:', error);
    }
  }

  loadPatterns() {
    try {
      const data = localStorage.getItem('classificationPatterns');
      return data ? JSON.parse(data) : {};
    } catch (error) {
      console.error('加载分类模式失败:', error);
      return {};
    }
  }

  savePatterns() {
    try {
      localStorage.setItem('classificationPatterns', JSON.stringify(this.patterns));
    } catch (error) {
      console.error('保存分类模式失败:', error);
    }
  }
}

// 导出单例
const aiClassifier = new AIClassifier();

