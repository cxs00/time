// ==================== 数据分析模块 ====================

class AnalyticsManager {
    constructor() {
        this.charts = {};
    }

    // ==================== 初始化所有图表 ====================
    initCharts() {
        this.renderDataCards();
        this.renderTrendChart();
        this.renderHeatmapChart();
        this.renderPieChart();
        this.renderComparisonChart();
    }

    // ==================== 数据卡片 ====================
    renderDataCards() {
        const stats = this.calculateStats();
        
        document.getElementById('totalTime').textContent = stats.totalTime;
        document.getElementById('avgPomodoros').textContent = stats.avgPomodoros;
        document.getElementById('maxPomodoros').textContent = stats.maxPomodoros;
        document.getElementById('streakDays').textContent = stats.streakDays;
    }

    // ==================== 计算统计数据 ====================
    calculateStats() {
        const stats = storage.getStatistics();
        const sessions = stats.sessions || [];
        
        // 计算总时长（小时）
        const totalMinutes = sessions
            .filter(s => s.type === 'work' && s.completed)
            .reduce((sum, s) => sum + s.duration, 0);
        const totalTime = Math.round(totalMinutes / 60 * 10) / 10;
        
        // 计算平均每日番茄数
        const dailyStats = {};
        sessions.forEach(s => {
            if (s.type === 'work' && s.completed) {
                const date = new Date(s.timestamp).toDateString();
                dailyStats[date] = (dailyStats[date] || 0) + 1;
            }
        });
        
        const days = Object.keys(dailyStats).length || 1;
        const totalPomodoros = Object.values(dailyStats).reduce((sum, count) => sum + count, 0);
        const avgPomodoros = Math.round(totalPomodoros / days * 10) / 10;
        
        // 最高记录
        const maxPomodoros = Math.max(...Object.values(dailyStats), 0);
        
        // 连续天数
        const streakDays = this.calculateStreak(dailyStats);
        
        return {
            totalTime: totalTime + 'h',
            avgPomodoros: avgPomodoros,
            maxPomodoros: maxPomodoros,
            streakDays: streakDays
        };
    }

    // ==================== 计算连续天数 ====================
    calculateStreak(dailyStats) {
        const dates = Object.keys(dailyStats).sort((a, b) => new Date(b) - new Date(a));
        if (dates.length === 0) return 0;
        
        let streak = 0;
        const today = new Date().setHours(0, 0, 0, 0);
        let checkDate = today;
        
        for (let i = 0; i < dates.length; i++) {
            const date = new Date(dates[i]).setHours(0, 0, 0, 0);
            const diff = Math.floor((checkDate - date) / (1000 * 60 * 60 * 24));
            
            if (diff === streak) {
                streak++;
            } else {
                break;
            }
        }
        
        return streak;
    }

    // ==================== 7日趋势图 ====================
    renderTrendChart() {
        const data = this.getLast7DaysData();
        const chartDom = document.getElementById('trendChart');
        if (!chartDom) return;
        
        const chart = echarts.init(chartDom);
        this.charts.trend = chart;
        
        const option = {
            title: {
                text: '专注趋势',
                textStyle: {
                    fontSize: 16,
                    fontWeight: 'bold'
                }
            },
            tooltip: {
                trigger: 'axis',
                formatter: '{b}<br/>完成番茄: {c}个'
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: data.dates,
                boundaryGap: false
            },
            yAxis: {
                type: 'value',
                minInterval: 1
            },
            series: [{
                name: '番茄数',
                type: 'line',
                data: data.counts,
                smooth: true,
                symbolSize: 8,
                areaStyle: {
                    color: {
                        type: 'linear',
                        x: 0,
                        y: 0,
                        x2: 0,
                        y2: 1,
                        colorStops: [{
                            offset: 0,
                            color: 'rgba(99, 102, 241, 0.5)'
                        }, {
                            offset: 1,
                            color: 'rgba(99, 102, 241, 0.1)'
                        }]
                    }
                },
                lineStyle: {
                    color: '#6366F1',
                    width: 3
                },
                itemStyle: {
                    color: '#6366F1'
                }
            }]
        };
        
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // ==================== 获取最近7天数据 ====================
    getLast7DaysData() {
        const stats = storage.getStatistics();
        const sessions = stats.sessions || [];
        
        const dates = [];
        const counts = [];
        const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
        
        for (let i = 6; i >= 0; i--) {
            const date = new Date();
            date.setDate(date.getDate() - i);
            date.setHours(0, 0, 0, 0);
            
            const dayOfWeek = weekDays[date.getDay()];
            const monthDay = (date.getMonth() + 1) + '/' + date.getDate();
            dates.push(dayOfWeek + '\n' + monthDay);
            
            const count = sessions.filter(s => {
                const sessionDate = new Date(s.timestamp);
                sessionDate.setHours(0, 0, 0, 0);
                return s.type === 'work' && s.completed && sessionDate.getTime() === date.getTime();
            }).length;
            
            counts.push(count);
        }
        
        return { dates, counts };
    }

    // ==================== 工作时段热力图 ====================
    renderHeatmapChart() {
        const data = this.getHeatmapData();
        const chartDom = document.getElementById('heatmapChart');
        if (!chartDom) return;
        
        const chart = echarts.init(chartDom);
        this.charts.heatmap = chart;
        
        const hours = [];
        for (let i = 0; i < 24; i++) {
            hours.push(i + '时');
        }
        
        const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
        
        const option = {
            title: {
                text: '工作时段分布',
                textStyle: {
                    fontSize: 16,
                    fontWeight: 'bold'
                }
            },
            tooltip: {
                position: 'top',
                formatter: function(params) {
                    return days[params.value[1]] + ' ' + hours[params.value[0]] + '<br/>专注次数: ' + params.value[2];
                }
            },
            grid: {
                height: '60%',
                top: '15%'
            },
            xAxis: {
                type: 'category',
                data: hours,
                splitArea: {
                    show: true
                }
            },
            yAxis: {
                type: 'category',
                data: days,
                splitArea: {
                    show: true
                }
            },
            visualMap: {
                min: 0,
                max: 10,
                calculable: true,
                orient: 'horizontal',
                left: 'center',
                bottom: '5%',
                inRange: {
                    color: ['#f0f0f0', '#6366F1']
                }
            },
            series: [{
                name: '专注次数',
                type: 'heatmap',
                data: data,
                label: {
                    show: false
                },
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }]
        };
        
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // ==================== 获取热力图数据 ====================
    getHeatmapData() {
        const stats = storage.getStatistics();
        const sessions = stats.sessions || [];
        
        const heatmapData = [];
        
        for (let day = 0; day < 7; day++) {
            for (let hour = 0; hour < 24; hour++) {
                const count = sessions.filter(s => {
                    const date = new Date(s.timestamp);
                    const dayOfWeek = (date.getDay() + 6) % 7; // 转换为周一=0
                    return s.type === 'work' && 
                           s.completed && 
                           dayOfWeek === day && 
                           date.getHours() === hour;
                }).length;
                
                heatmapData.push([hour, day, count]);
            }
        }
        
        return heatmapData;
    }

    // ==================== 类型分布饼图 ====================
    renderPieChart() {
        const data = this.getTypeDistribution();
        const chartDom = document.getElementById('pieChart');
        if (!chartDom) return;
        
        const chart = echarts.init(chartDom);
        this.charts.pie = chart;
        
        const option = {
            title: {
                text: '时间分配',
                textStyle: {
                    fontSize: 16,
                    fontWeight: 'bold'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c}分钟 ({d}%)'
            },
            legend: {
                orient: 'vertical',
                right: '10%',
                top: 'center'
            },
            series: [{
                name: '时长',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: 20,
                        fontWeight: 'bold'
                    }
                },
                labelLine: {
                    show: false
                },
                data: data
            }]
        };
        
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // ==================== 获取类型分布数据 ====================
    getTypeDistribution() {
        const stats = storage.getStatistics();
        const sessions = stats.sessions || [];
        
        const workTime = sessions
            .filter(s => s.type === 'work' && s.completed)
            .reduce((sum, s) => sum + s.duration, 0);
            
        const breakTime = sessions
            .filter(s => (s.type === 'shortBreak' || s.type === 'longBreak') && s.completed)
            .reduce((sum, s) => sum + s.duration, 0);
        
        return [
            { 
                value: workTime, 
                name: '工作时长',
                itemStyle: { color: '#6366F1' }
            },
            { 
                value: breakTime, 
                name: '休息时长',
                itemStyle: { color: '#10B981' }
            }
        ];
    }

    // ==================== 本周对比柱状图 ====================
    renderComparisonChart() {
        const data = this.getComparisonData();
        const chartDom = document.getElementById('comparisonChart');
        if (!chartDom) return;
        
        const chart = echarts.init(chartDom);
        this.charts.comparison = chart;
        
        const option = {
            title: {
                text: '本周 vs 上周',
                textStyle: {
                    fontSize: 16,
                    fontWeight: 'bold'
                }
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            legend: {
                data: ['上周', '本周'],
                top: 'bottom'
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '15%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
            },
            yAxis: {
                type: 'value',
                minInterval: 1
            },
            series: [
                {
                    name: '上周',
                    type: 'bar',
                    data: data.lastWeek,
                    itemStyle: { color: '#94a3b8' }
                },
                {
                    name: '本周',
                    type: 'bar',
                    data: data.thisWeek,
                    itemStyle: { color: '#6366F1' }
                }
            ]
        };
        
        chart.setOption(option);
        window.addEventListener('resize', () => chart.resize());
    }

    // ==================== 获取对比数据 ====================
    getComparisonData() {
        const stats = storage.getStatistics();
        const sessions = stats.sessions || [];
        
        const thisWeek = [];
        const lastWeek = [];
        
        for (let i = 0; i < 7; i++) {
            // 本周
            const thisWeekDate = new Date();
            const dayOfWeek = thisWeekDate.getDay();
            const daysFromMonday = (dayOfWeek + 6) % 7;
            thisWeekDate.setDate(thisWeekDate.getDate() - daysFromMonday + i);
            thisWeekDate.setHours(0, 0, 0, 0);
            
            const thisWeekCount = sessions.filter(s => {
                const sessionDate = new Date(s.timestamp);
                sessionDate.setHours(0, 0, 0, 0);
                return s.type === 'work' && s.completed && sessionDate.getTime() === thisWeekDate.getTime();
            }).length;
            thisWeek.push(thisWeekCount);
            
            // 上周
            const lastWeekDate = new Date(thisWeekDate);
            lastWeekDate.setDate(lastWeekDate.getDate() - 7);
            
            const lastWeekCount = sessions.filter(s => {
                const sessionDate = new Date(s.timestamp);
                sessionDate.setHours(0, 0, 0, 0);
                return s.type === 'work' && s.completed && sessionDate.getTime() === lastWeekDate.getTime();
            }).length;
            lastWeek.push(lastWeekCount);
        }
        
        return { thisWeek, lastWeek };
    }

    // ==================== 更新所有图表 ====================
    updateAllCharts() {
        this.renderDataCards();
        Object.values(this.charts).forEach(chart => {
            if (chart && chart.resize) {
                chart.resize();
            }
        });
    }

    // ==================== 销毁所有图表 ====================
    destroyAllCharts() {
        Object.values(this.charts).forEach(chart => {
            if (chart && chart.dispose) {
                chart.dispose();
            }
        });
        this.charts = {};
    }
}

// ==================== 导出全局实例 ====================
const analyticsManager = new AnalyticsManager();

