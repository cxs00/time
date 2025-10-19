// ==================== 番茄时钟核心逻辑 ====================

class PomodoroTimer {
    constructor() {
        // 状态
        this.state = 'work'; // 'work', 'shortBreak', 'longBreak'
        this.isRunning = false;
        this.isPaused = false;
        
        // 时间（秒）
        this.timeRemaining = 0;
        this.totalTime = 0;
        
        // 番茄计数
        this.completedPomodoros = 0;
        this.sessionPomodoros = 0; // 当前会话中的番茄数
        
        // 会话信息
        this.currentSession = null;
        
        // 定时器
        this.intervalId = null;
        
        // 配置
        this.settings = storage.getSettings();
        
        // 进度环
        this.progressCircle = null;
        this.circumference = 0;
        
        this.init();
    }

    // ==================== 初始化 ====================
    
    init() {
        // 初始化进度环
        this.progressCircle = document.querySelector('.progress-ring__circle');
        if (this.progressCircle) {
            const radius = this.progressCircle.r.baseVal.value;
            this.circumference = radius * 2 * Math.PI;
            this.progressCircle.style.strokeDasharray = `${this.circumference} ${this.circumference}`;
            this.progressCircle.style.strokeDashoffset = this.circumference;
        }
        
        // 设置初始时间
        this.setMode('work');
        
        // 加载今日完成数
        const todayStats = storage.getTodayStats();
        this.completedPomodoros = todayStats.pomodoros;
        this.updateCounter();
    }

    // ==================== 设置模式 ====================
    
    setMode(mode) {
        this.state = mode;
        this.settings = storage.getSettings();
        
        // 根据模式设置时间
        switch (mode) {
            case 'work':
                this.totalTime = this.settings.workDuration * 60;
                break;
            case 'shortBreak':
                this.totalTime = this.settings.shortBreakDuration * 60;
                break;
            case 'longBreak':
                this.totalTime = this.settings.longBreakDuration * 60;
                break;
        }
        
        this.timeRemaining = this.totalTime;
        this.updateDisplay();
        this.updateModeUI();
    }

    // ==================== 开始计时 ====================
    
    start() {
        if (this.isRunning) return;
        
        this.isRunning = true;
        this.isPaused = false;
        
        // 创建新会话
        if (!this.currentSession) {
            this.currentSession = {
                type: this.state,
                duration: this.totalTime,
                startTime: Date.now(),
                endTime: null,
                completed: false
            };
        }
        
        // 播放开始音效
        if (this.settings.soundEnabled) {
            notificationManager.playSound('start');
        }
        
        // 开始倒计时
        this.intervalId = setInterval(() => {
            this.tick();
        }, 1000);
        
        this.updateControlButtons();
    }

    // ==================== 暂停 ====================
    
    pause() {
        if (!this.isRunning) return;
        
        this.isRunning = false;
        this.isPaused = true;
        
        clearInterval(this.intervalId);
        this.intervalId = null;
        
        this.updateControlButtons();
    }

    // ==================== 重置 ====================
    
    reset() {
        this.isRunning = false;
        this.isPaused = false;
        
        clearInterval(this.intervalId);
        this.intervalId = null;
        
        // 取消当前会话
        this.currentSession = null;
        
        // 重置时间
        this.timeRemaining = this.totalTime;
        
        this.updateDisplay();
        this.updateControlButtons();
    }

    // ==================== 跳过 ====================
    
    skip() {
        this.complete(false);
    }

    // ==================== 每秒更新 ====================
    
    tick() {
        if (this.timeRemaining > 0) {
            this.timeRemaining--;
            this.updateDisplay();
        } else {
            this.complete(true);
        }
    }

    // ==================== 完成 ====================
    
    complete(finished = true) {
        this.isRunning = false;
        clearInterval(this.intervalId);
        this.intervalId = null;
        
        // 保存会话记录
        if (this.currentSession && finished) {
            this.currentSession.endTime = Date.now();
            this.currentSession.completed = true;
            storage.addSession(this.currentSession);
            
            // 如果是工作模式，增加计数
            if (this.state === 'work') {
                this.completedPomodoros++;
                this.sessionPomodoros++;
                this.updateCounter();
            }
            
            // 发送通知
            this.sendCompletionNotification();
        }
        
        this.currentSession = null;
        
        // 自动切换到下一个状态
        this.switchToNextMode();
        
        this.updateControlButtons();
    }

    // ==================== 切换到下一个模式 ====================
    
    switchToNextMode() {
        if (this.state === 'work') {
            // 工作结束，检查是否该长休息
            if (this.sessionPomodoros % this.settings.longBreakInterval === 0) {
                this.setMode('longBreak');
            } else {
                this.setMode('shortBreak');
            }
            
            // 如果设置了自动开始休息
            if (this.settings.autoStartBreaks) {
                setTimeout(() => this.start(), 1000);
            }
        } else {
            // 休息结束，回到工作
            this.setMode('work');
            
            // 如果设置了自动开始工作
            if (this.settings.autoStartPomodoros) {
                setTimeout(() => this.start(), 1000);
            }
        }
    }

    // ==================== 发送完成通知 ====================
    
    sendCompletionNotification() {
        if (!this.settings.notificationEnabled) return;
        
        switch (this.state) {
            case 'work':
                notificationManager.notifyWorkComplete();
                break;
            case 'shortBreak':
                notificationManager.notifyShortBreakComplete();
                break;
            case 'longBreak':
                notificationManager.notifyLongBreakComplete();
                break;
        }
        
        if (this.settings.soundEnabled) {
            notificationManager.playSound('complete');
        }
    }

    // ==================== 更新显示 ====================
    
    updateDisplay() {
        // 更新时间显示
        const minutes = Math.floor(this.timeRemaining / 60);
        const seconds = this.timeRemaining % 60;
        const timeText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        
        const timeDisplay = document.getElementById('timeDisplay');
        if (timeDisplay) {
            timeDisplay.textContent = timeText;
        }
        
        // 更新页面标题
        document.title = `${timeText} - 番茄时钟`;
        
        // 更新进度环
        this.updateProgress();
    }

    // ==================== 更新进度环 ====================
    
    updateProgress() {
        if (!this.progressCircle) return;
        
        const progress = (this.totalTime - this.timeRemaining) / this.totalTime;
        const offset = this.circumference - (progress * this.circumference);
        this.progressCircle.style.strokeDashoffset = offset;
    }

    // ==================== 更新模式UI ====================
    
    updateModeUI() {
        // 更新模式标签
        const modeLabel = document.getElementById('modeLabel');
        if (modeLabel) {
            switch (this.state) {
                case 'work':
                    modeLabel.textContent = '工作时间';
                    break;
                case 'shortBreak':
                    modeLabel.textContent = '短休息';
                    break;
                case 'longBreak':
                    modeLabel.textContent = '长休息';
                    break;
            }
        }
        
        // 更新背景颜色
        document.body.className = '';
        if (this.state === 'shortBreak') {
            document.body.classList.add('short-break-mode');
        } else if (this.state === 'longBreak') {
            document.body.classList.add('long-break-mode');
        }
        
        // 更新标签按钮
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.dataset.mode === this.state) {
                btn.classList.add('active');
            }
        });
        
        // 更新渐变色
        this.updateGradient();
    }

    // ==================== 更新渐变色 ====================
    
    updateGradient() {
        const gradient = document.getElementById('gradient');
        if (!gradient) return;
        
        const stops = gradient.querySelectorAll('stop');
        
        switch (this.state) {
            case 'work':
                stops[0].style.stopColor = '#FF6B6B';
                stops[1].style.stopColor = '#E74C3C';
                break;
            case 'shortBreak':
                stops[0].style.stopColor = '#5DADE2';
                stops[1].style.stopColor = '#3498DB';
                break;
            case 'longBreak':
                stops[0].style.stopColor = '#58D68D';
                stops[1].style.stopColor = '#2ECC71';
                break;
        }
    }

    // ==================== 更新控制按钮 ====================
    
    updateControlButtons() {
        const startBtn = document.getElementById('startBtn');
        const pauseBtn = document.getElementById('pauseBtn');
        
        if (this.isRunning) {
            startBtn?.classList.add('hidden');
            pauseBtn?.classList.remove('hidden');
        } else {
            startBtn?.classList.remove('hidden');
            pauseBtn?.classList.add('hidden');
        }
    }

    // ==================== 更新番茄计数 ====================
    
    updateCounter() {
        const tomatoIcons = document.getElementById('tomatoIcons');
        const counterText = document.getElementById('counterText');
        const dailyGoal = this.settings.dailyGoal || 8;
        
        if (tomatoIcons) {
            const icons = '🍅'.repeat(Math.min(this.completedPomodoros, dailyGoal));
            tomatoIcons.textContent = icons;
        }
        
        if (counterText) {
            counterText.textContent = `${this.completedPomodoros}/${dailyGoal}`;
        }
    }

    // ==================== 重新加载设置 ====================
    
    reloadSettings() {
        this.settings = storage.getSettings();
        
        // 如果当前没有运行，更新时间
        if (!this.isRunning) {
            this.setMode(this.state);
        }
    }
}

// 导出（将在 app.js 中初始化）

