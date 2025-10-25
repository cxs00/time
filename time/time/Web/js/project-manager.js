// ==================== 项目进度管理系统 ====================

class ProjectManager {
  constructor() {
    this.projects = this.loadProjects();
    this.init();
  }

  init() {
    console.log('🎯 项目管理系统初始化');
    this.setupEventListeners();
    this.updateUI();
  }

  setupEventListeners() {
    // 创建项目按钮
    const createBtn = document.getElementById('createProject');
    if (createBtn) {
      createBtn.addEventListener('click', () => this.showCreateProjectDialog());
    }
  }

  // 创建项目
  createProject(projectData) {
    const project = {
      id: Date.now().toString(),
      name: projectData.name,
      description: projectData.description || '',
      startDate: new Date(),
      targetDate: projectData.targetDate ? new Date(projectData.targetDate) : null,
      progress: 0,
      milestones: projectData.milestones || [],
      activities: [],
      status: 'active', // active, completed, paused
      priority: projectData.priority || 'medium',
      tags: projectData.tags || [],
      createdAt: new Date()
    };

    this.projects.push(project);
    this.saveProjects();
    this.updateUI();

    console.log('✅ 项目创建成功:', project);
    return project;
  }

  // 更新项目进度
  updateProjectProgress(projectId, activity) {
    const project = this.projects.find(p => p.id === projectId);
    if (!project) return;

    // 添加活动到项目
    project.activities.push(activity.id);

    // 计算进度增加
    const progressIncrease = this.calculateProgressIncrease(activity, project);
    project.progress = Math.min(100, project.progress + progressIncrease);

    // 更新里程碑
    this.updateMilestones(project);

    // 检查项目完成
    if (project.progress >= 100) {
      project.status = 'completed';
      this.notifyProjectCompletion(project);
    }

    this.saveProjects();
    this.updateUI();

    console.log(`📊 项目进度更新: ${project.name} - ${project.progress}%`);
  }

  // 智能进度计算
  calculateProgressIncrease(activity, project) {
    const baseIncrease = 1; // 基础进度 1%

    // 类别系数
    const categoryMultiplier = {
      '工作': 1.5,
      '学习': 1.2,
      '其他': 1.0
    }[activity.category] || 1.0;

    // 时间系数（每60分钟系数为1）
    const timeMultiplier = Math.min(2, activity.duration / 60);

    // 优先级系数
    const priorityMultiplier = {
      'high': 1.5,
      'medium': 1.0,
      'low': 0.8
    }[project.priority] || 1.0;

    const increase = baseIncrease * categoryMultiplier * timeMultiplier * priorityMultiplier;
    return Math.round(increase * 10) / 10; // 保留一位小数
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

  // 通知项目完成
  notifyProjectCompletion(project) {
    console.log(`🎉 项目完成: ${project.name}`);

    if (typeof notificationManager !== 'undefined') {
      notificationManager.showToast(`🎉 恭喜！项目"${project.name}"已完成！`);
    }
  }

  // 显示创建项目对话框
  showCreateProjectDialog() {
    const dialog = `
            <div class="modal" id="createProjectModal">
                <div class="modal-content">
                    <h3>创建新项目</h3>
                    <form id="createProjectForm">
                        <div class="form-group">
                            <label>项目名称</label>
                            <input type="text" id="projectName" required>
                        </div>
                        <div class="form-group">
                            <label>项目描述</label>
                            <textarea id="projectDescription"></textarea>
                        </div>
                        <div class="form-group">
                            <label>目标日期</label>
                            <input type="date" id="projectTargetDate">
                        </div>
                        <div class="form-group">
                            <label>优先级</label>
                            <select id="projectPriority">
                                <option value="high">高</option>
                                <option value="medium" selected>中</option>
                                <option value="low">低</option>
                            </select>
                        </div>
                        <div class="form-actions">
                            <button type="submit">创建</button>
                            <button type="button" onclick="document.getElementById('createProjectModal').remove()">取消</button>
                        </div>
                    </form>
                </div>
            </div>
        `;

    document.body.insertAdjacentHTML('beforeend', dialog);

    const form = document.getElementById('createProjectForm');
    form.addEventListener('submit', (e) => {
      e.preventDefault();

      const projectData = {
        name: document.getElementById('projectName').value,
        description: document.getElementById('projectDescription').value,
        targetDate: document.getElementById('projectTargetDate').value,
        priority: document.getElementById('projectPriority').value,
        milestones: []
      };

      this.createProject(projectData);
      document.getElementById('createProjectModal').remove();
    });
  }

  // 更新UI
  updateUI() {
    this.renderProjectsList();
    this.updateProjectSelector();
  }

  // 渲染项目列表
  renderProjectsList() {
    const container = document.getElementById('projectsGrid');
    console.log('🔍 查找projectsGrid容器:', container ? '找到' : '未找到');

    if (!container) {
      console.warn('⚠️ projectsGrid容器不存在，跳过渲染');
      return;
    }

    console.log(`📊 准备渲染 ${this.projects.length} 个项目`);

    if (this.projects.length === 0) {
      container.innerHTML = '<p class="no-projects">还没有创建任何项目</p>';
      console.log('📝 显示空项目提示');
      return;
    }

    container.innerHTML = this.projects
      .map(project => this.renderProjectCard(project))
      .join('');

    console.log(`✅ 已渲染 ${this.projects.length} 个项目卡片`);
  }

  // 渲染项目卡片
  renderProjectCard(project) {
    console.log(`🎯 渲染项目卡片: ${project.name}, 进度: ${project.progress}%`);

    const statusClass = {
      'active': 'active',
      'completed': 'completed',
      'paused': 'paused'
    }[project.status];

    const statusText = {
      'active': '进行中',
      'completed': '已完成',
      'paused': '已暂停'
    }[project.status];

    return `
            <div class="project-card ${statusClass}" data-project-id="${project.id}">
                <div class="project-header">
                    <h3 class="project-name">${project.name}</h3>
                    <span class="project-status ${statusClass}">${statusText}</span>
                </div>
                <div class="project-progress">
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${project.progress}%; background: linear-gradient(90deg, #667eea, #764ba2);"></div>
                    </div>
                    <span class="progress-text">${Math.round(project.progress)}%</span>
                </div>
                ${project.milestones && project.milestones.length > 0 ? `
                    <div class="project-milestones">
                        ${project.milestones.map(milestone => `
                            <div class="milestone ${milestone.status}">
                                ${milestone.status === 'completed' ? '✅' : milestone.status === 'active' ? '🔄' : '⏳'}
                                ${milestone.name}
                            </div>
                        `).join('')}
                    </div>
                ` : ''}
                <div class="project-actions">
                    <button class="btn-edit" onclick="projectManager.editProject('${project.id}')">编辑</button>
                    <button class="btn-pause" onclick="projectManager.toggleProjectStatus('${project.id}')">
                        ${project.status === 'paused' ? '继续' : '暂停'}
                    </button>
                </div>
            </div>
        `;
  }

  // 更新项目选择器
  updateProjectSelector() {
    const selector = document.getElementById('projectSelect');
    if (!selector) return;

    const activeProjects = this.projects.filter(p => p.status === 'active');

    selector.innerHTML = '<option value="">自动关联</option>' +
      activeProjects.map(project =>
        `<option value="${project.id}">${project.name}</option>`
      ).join('');
  }

  // 切换项目状态
  toggleProjectStatus(projectId) {
    const project = this.projects.find(p => p.id === projectId);
    if (!project) return;

    if (project.status === 'active') {
      project.status = 'paused';
    } else if (project.status === 'paused') {
      project.status = 'active';
    }

    this.saveProjects();
    this.updateUI();
  }

  // 编辑项目
  editProject(projectId) {
    const project = this.projects.find(p => p.id === projectId);
    if (!project) return;

    console.log('编辑项目:', project);
    // TODO: 实现编辑对话框
  }

  // 数据持久化
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
}

// 导出单例
const projectManager = new ProjectManager();

