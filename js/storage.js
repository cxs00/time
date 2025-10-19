// ==================== 数据存储管理模块 ====================

class StorageManager {
    constructor() {
        this.KEYS = {
            SETTINGS: 'pomodoro_settings',
            SESSIONS: 'pomodoro_sessions',
            STATS: 'pomodoro_stats'
        };
        
        // 默认设置
        this.defaultSettings = {
            workDuration: 25,
            shortBreakDuration: 5,
            longBreakDuration: 15,
            longBreakInterval: 4,
            notificationEnabled: true,
            soundEnabled: true,
            autoStartBreaks: false,
            autoStartPomodoros: false,
            theme: 'light',
            dailyGoal: 8
        };
    }

    // ==================== 设置管理 ====================
    
    getSettings() {
        try {
            const settings = localStorage.getItem(this.KEYS.SETTINGS);
            return settings ? { ...this.defaultSettings, ...JSON.parse(settings) } : this.defaultSettings;
        } catch (error) {
            console.error('读取设置失败:', error);
            return this.defaultSettings;
        }
    }

    saveSettings(settings) {
        try {
            localStorage.setItem(this.KEYS.SETTINGS, JSON.stringify(settings));
            return true;
        } catch (error) {
            console.error('保存设置失败:', error);
            return false;
        }
    }

    // ==================== 会话记录管理 ====================
    
    getSessions() {
        try {
            const sessions = localStorage.getItem(this.KEYS.SESSIONS);
            return sessions ? JSON.parse(sessions) : [];
        } catch (error) {
            console.error('读取会话记录失败:', error);
            return [];
        }
    }

    addSession(session) {
        try {
            const sessions = this.getSessions();
            const newSession = {
                id: Date.now().toString(),
                type: session.type, // 'work', 'shortBreak', 'longBreak'
                duration: session.duration,
                startTime: session.startTime,
                endTime: session.endTime,
                completed: session.completed,
                date: new Date(session.startTime).toDateString()
            };
            sessions.push(newSession);
            localStorage.setItem(this.KEYS.SESSIONS, JSON.stringify(sessions));
            return newSession;
        } catch (error) {
            console.error('添加会话记录失败:', error);
            return null;
        }
    }

    deleteSession(sessionId) {
        try {
            const sessions = this.getSessions();
            const filteredSessions = sessions.filter(s => s.id !== sessionId);
            localStorage.setItem(this.KEYS.SESSIONS, JSON.stringify(filteredSessions));
            return true;
        } catch (error) {
            console.error('删除会话记录失败:', error);
            return false;
        }
    }

    // ==================== 统计数据获取 ====================
    
    getTodayStats() {
        const sessions = this.getSessions();
        const today = new Date().toDateString();
        const todaySessions = sessions.filter(s => s.date === today && s.completed);
        
        const workSessions = todaySessions.filter(s => s.type === 'work');
        const breakSessions = todaySessions.filter(s => s.type === 'shortBreak' || s.type === 'longBreak');
        
        return {
            pomodoros: workSessions.length,
            workTime: workSessions.reduce((sum, s) => sum + s.duration, 0),
            breakTime: breakSessions.reduce((sum, s) => sum + s.duration, 0),
            sessions: todaySessions
        };
    }

    getWeekStats() {
        const sessions = this.getSessions();
        const today = new Date();
        const weekStart = new Date(today);
        weekStart.setDate(today.getDate() - today.getDay()); // 本周第一天
        weekStart.setHours(0, 0, 0, 0);
        
        const weekSessions = sessions.filter(s => {
            const sessionDate = new Date(s.startTime);
            return sessionDate >= weekStart && s.completed;
        });
        
        // 按日期分组
        const dailyStats = {};
        for (let i = 0; i < 7; i++) {
            const date = new Date(weekStart);
            date.setDate(weekStart.getDate() + i);
            const dateStr = date.toDateString();
            dailyStats[dateStr] = 0;
        }
        
        weekSessions.forEach(s => {
            if (s.type === 'work') {
                dailyStats[s.date] = (dailyStats[s.date] || 0) + 1;
            }
        });
        
        const workSessions = weekSessions.filter(s => s.type === 'work');
        const totalPomodoros = workSessions.length;
        const avgPerDay = totalPomodoros / 7;
        
        return {
            totalPomodoros,
            avgPerDay: Math.round(avgPerDay * 10) / 10,
            dailyStats,
            sessions: weekSessions
        };
    }

    getAllTimeStats() {
        const sessions = this.getSessions();
        const completedSessions = sessions.filter(s => s.completed);
        const workSessions = completedSessions.filter(s => s.type === 'work');
        
        // 计算使用天数
        const uniqueDates = [...new Set(completedSessions.map(s => s.date))];
        const totalDays = uniqueDates.length;
        
        // 计算连续天数
        const sortedDates = uniqueDates
            .map(d => new Date(d))
            .sort((a, b) => b - a);
        
        let streak = 0;
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        for (let i = 0; i < sortedDates.length; i++) {
            const checkDate = new Date(today);
            checkDate.setDate(today.getDate() - i);
            checkDate.setHours(0, 0, 0, 0);
            
            const hasSession = sortedDates.some(d => {
                d.setHours(0, 0, 0, 0);
                return d.getTime() === checkDate.getTime();
            });
            
            if (hasSession) {
                streak++;
            } else if (i > 0) {
                break;
            }
        }
        
        return {
            totalPomodoros: workSessions.length,
            totalDays,
            streak,
            totalWorkTime: workSessions.reduce((sum, s) => sum + s.duration, 0),
            totalSessions: completedSessions.length
        };
    }

    getRecentSessions(limit = 10) {
        const sessions = this.getSessions();
        return sessions
            .sort((a, b) => b.startTime - a.startTime)
            .slice(0, limit);
    }

    // ==================== 数据导出导入 ====================
    
    exportData() {
        try {
            const data = {
                settings: this.getSettings(),
                sessions: this.getSessions(),
                exportDate: new Date().toISOString(),
                version: '1.0'
            };
            
            const dataStr = JSON.stringify(data, null, 2);
            const dataBlob = new Blob([dataStr], { type: 'application/json' });
            const url = URL.createObjectURL(dataBlob);
            
            const link = document.createElement('a');
            link.href = url;
            link.download = `pomodoro-data-${Date.now()}.json`;
            link.click();
            
            URL.revokeObjectURL(url);
            return true;
        } catch (error) {
            console.error('导出数据失败:', error);
            return false;
        }
    }

    importData(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            
            reader.onload = (e) => {
                try {
                    const data = JSON.parse(e.target.result);
                    
                    if (data.settings) {
                        this.saveSettings(data.settings);
                    }
                    
                    if (data.sessions) {
                        localStorage.setItem(this.KEYS.SESSIONS, JSON.stringify(data.sessions));
                    }
                    
                    resolve(true);
                } catch (error) {
                    reject(error);
                }
            };
            
            reader.onerror = () => reject(new Error('文件读取失败'));
            reader.readAsText(file);
        });
    }

    clearAllData() {
        try {
            localStorage.removeItem(this.KEYS.SETTINGS);
            localStorage.removeItem(this.KEYS.SESSIONS);
            localStorage.removeItem(this.KEYS.STATS);
            return true;
        } catch (error) {
            console.error('清除数据失败:', error);
            return false;
        }
    }

    // ==================== 工具方法 ====================
    
    formatDuration(seconds) {
        const minutes = Math.floor(seconds / 60);
        return `${minutes}分钟`;
    }

    formatTime(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleTimeString('zh-CN', { 
            hour: '2-digit', 
            minute: '2-digit' 
        });
    }

    formatDate(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleDateString('zh-CN', { 
            year: 'numeric',
            month: 'long', 
            day: 'numeric' 
        });
    }
}

// 导出单例
const storage = new StorageManager();

