// ==================== 统计数据管理模块 ====================

class StatisticsManager {
    constructor() {
        this.chartInstance = null;
    }

    // ==================== 更新今日统计 ====================
    
    updateTodayStats() {
        const stats = storage.getTodayStats();
        
        // 更新今日番茄数
        const todayPomodorosEl = document.getElementById('todayPomodoros');
        if (todayPomodorosEl) {
            todayPomodorosEl.textContent = stats.pomodoros;
        }
        
        // 更新今日工作时长
        const todayTimeEl = document.getElementById('todayTime');
        if (todayTimeEl) {
            todayTimeEl.textContent = Math.round(stats.workTime / 60);
        }
        
        // 更新今日休息时长
        const todayBreakTimeEl = document.getElementById('todayBreakTime');
        if (todayBreakTimeEl) {
            todayBreakTimeEl.textContent = Math.round(stats.breakTime / 60);
        }
    }

    // ==================== 更新本周统计 ====================
    
    updateWeekStats() {
        const stats = storage.getWeekStats();
        
        // 更新本周番茄数
        const weekPomodorosEl = document.getElementById('weekPomodoros');
        if (weekPomodorosEl) {
            weekPomodorosEl.textContent = stats.totalPomodoros;
        }
        
        // 更新日均番茄数
        const weekAvgEl = document.getElementById('weekAvg');
        if (weekAvgEl) {
            weekAvgEl.textContent = stats.avgPerDay;
        }
        
        // 绘制图表
        this.drawWeekChart(stats.dailyStats);
    }

    // ==================== 更新历史统计 ====================
    
    updateAllTimeStats() {
        const stats = storage.getAllTimeStats();
        
        // 更新总番茄数
        const totalPomodorosEl = document.getElementById('totalPomodoros');
        if (totalPomodorosEl) {
            totalPomodorosEl.textContent = stats.totalPomodoros;
        }
        
        // 更新使用天数
        const totalDaysEl = document.getElementById('totalDays');
        if (totalDaysEl) {
            totalDaysEl.textContent = stats.totalDays;
        }
        
        // 更新连续天数
        const streakEl = document.getElementById('streak');
        if (streakEl) {
            streakEl.textContent = stats.streak;
        }
    }

    // ==================== 更新最近记录 ====================
    
    updateRecentList() {
        const sessions = storage.getRecentSessions(10);
        const recentListEl = document.getElementById('recentList');
        
        if (!recentListEl) return;
        
        if (sessions.length === 0) {
            recentListEl.innerHTML = '<p style="text-align: center; color: #999; padding: 20px;">暂无记录</p>';
            return;
        }
        
        recentListEl.innerHTML = sessions.map(session => {
            const typeText = session.type === 'work' ? '工作' : 
                           session.type === 'shortBreak' ? '短休息' : '长休息';
            const typeClass = session.type === 'work' ? '' : 'break';
            const icon = session.completed ? '✓' : '✗';
            const statusText = session.completed ? '已完成' : '未完成';
            
            return `
                <div class="recent-item ${typeClass}">
                    <div class="recent-info">
                        <div class="recent-type">${icon} ${typeText} - ${statusText}</div>
                        <div class="recent-time">${storage.formatDate(session.startTime)} ${storage.formatTime(session.startTime)}</div>
                    </div>
                    <div class="recent-duration">${storage.formatDuration(session.duration)}</div>
                </div>
            `;
        }).join('');
    }

    // ==================== 绘制本周图表 ====================
    
    drawWeekChart(dailyStats) {
        const canvas = document.getElementById('weekChart');
        if (!canvas) return;
        
        const ctx = canvas.getContext('2d');
        const width = canvas.parentElement.clientWidth;
        const height = 200;
        
        canvas.width = width;
        canvas.height = height;
        
        // 清空画布
        ctx.clearRect(0, 0, width, height);
        
        // 准备数据
        const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
        const values = Object.values(dailyStats);
        const maxValue = Math.max(...values, 8); // 至少显示到8
        
        // 设置样式
        const barWidth = width / 7 - 10;
        const barSpacing = 10;
        const maxBarHeight = height - 40;
        
        // 绘制柱状图
        values.forEach((value, index) => {
            const barHeight = (value / maxValue) * maxBarHeight;
            const x = index * (barWidth + barSpacing) + 5;
            const y = height - barHeight - 20;
            
            // 绘制柱子
            const gradient = ctx.createLinearGradient(0, y, 0, height - 20);
            gradient.addColorStop(0, '#FF6B6B');
            gradient.addColorStop(1, '#E74C3C');
            
            ctx.fillStyle = gradient;
            ctx.fillRect(x, y, barWidth, barHeight);
            
            // 绘制数值
            ctx.fillStyle = '#E74C3C';
            ctx.font = 'bold 14px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(value, x + barWidth / 2, y - 5);
            
            // 绘制星期
            ctx.fillStyle = '#666';
            ctx.font = '12px sans-serif';
            ctx.fillText(days[index], x + barWidth / 2, height - 5);
        });
    }

    // ==================== 更新所有统计 ====================
    
    updateAllStats() {
        this.updateTodayStats();
        this.updateWeekStats();
        this.updateAllTimeStats();
        this.updateRecentList();
    }

    // ==================== 导出统计报告 ====================
    
    exportReport() {
        const todayStats = storage.getTodayStats();
        const weekStats = storage.getWeekStats();
        const allTimeStats = storage.getAllTimeStats();
        
        const report = `
番茄时钟统计报告
生成时间: ${new Date().toLocaleString('zh-CN')}

===================
今日统计
===================
完成番茄: ${todayStats.pomodoros} 个
工作时长: ${Math.round(todayStats.workTime / 60)} 分钟
休息时长: ${Math.round(todayStats.breakTime / 60)} 分钟

===================
本周统计
===================
总计番茄: ${weekStats.totalPomodoros} 个
日均番茄: ${weekStats.avgPerDay} 个

===================
历史统计
===================
总计番茄: ${allTimeStats.totalPomodoros} 个
使用天数: ${allTimeStats.totalDays} 天
连续天数: ${allTimeStats.streak} 天
总工作时长: ${Math.round(allTimeStats.totalWorkTime / 60)} 分钟

===================
        `.trim();
        
        const blob = new Blob([report], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = `pomodoro-report-${Date.now()}.txt`;
        link.click();
        URL.revokeObjectURL(url);
    }
}

// 导出单例
const statisticsManager = new StatisticsManager();

