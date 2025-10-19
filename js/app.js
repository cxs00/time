// ==================== 主应用程序 ====================

let timer = null;

// ==================== 页面加载完成 ====================

document.addEventListener('DOMContentLoaded', () => {
    // 初始化计时器
    timer = new PomodoroTimer();
    
    // 初始化通知管理器
    initNotifications();
    
    // 初始化广告
    initAds();
    
    // 绑定事件监听器
    bindEventListeners();
    
    // 加载设置
    loadSettings();
    
    // 应用主题
    applyTheme();
    
    console.log('番茄时钟应用已启动 🍅');
});

// ==================== 初始化通知 ====================

function initNotifications() {
    const settings = storage.getSettings();
    notificationManager.setNotificationEnabled(settings.notificationEnabled);
    notificationManager.setSoundEnabled(settings.soundEnabled);
    
    // 如果启用通知，请求权限
    if (settings.notificationEnabled && !notificationManager.checkPermission()) {
        notificationManager.requestPermission();
    }
}

// ==================== 初始化广告 ====================

function initAds() {
    const settings = storage.getSettings();
    if (typeof adSenseManager !== 'undefined') {
        adSenseManager.adsEnabled = settings.adsEnabled !== false;
        if (adSenseManager.adsEnabled) {
            adSenseManager.init();
            // 延迟显示广告，确保页面加载完成
            setTimeout(() => {
                adSenseManager.showBannerAd();
            }, 1000);
        }
    }
}

// ==================== 绑定事件监听器 ====================

function bindEventListeners() {
    // ========== 计时器控制 ==========
    
    // 开始按钮
    document.getElementById('startBtn')?.addEventListener('click', () => {
        timer.start();
    });
    
    // 暂停按钮
    document.getElementById('pauseBtn')?.addEventListener('click', () => {
        timer.pause();
    });
    
    // 重置按钮
    document.getElementById('resetBtn')?.addEventListener('click', () => {
        timer.reset();
        notificationManager.showToast('计时器已重置');
    });
    
    // 跳过按钮
    document.getElementById('skipBtn')?.addEventListener('click', () => {
        timer.skip();
        notificationManager.showToast('已跳过当前阶段');
    });
    
    // ========== 模式切换 ==========
    
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const mode = btn.dataset.mode;
            if (!timer.isRunning) {
                timer.setMode(mode);
            } else {
                notificationManager.showToast('请先停止当前计时器');
            }
        });
    });
    
    // ========== 页面导航 ==========
    
    // 统计页面
    document.getElementById('statsBtn')?.addEventListener('click', () => {
        showPage('stats');
    });
    
    document.getElementById('statsBackBtn')?.addEventListener('click', () => {
        showPage('timer');
    });
    
    // 设置页面
    document.getElementById('settingsBtn')?.addEventListener('click', () => {
        showPage('settings');
    });
    
    document.getElementById('settingsBackBtn')?.addEventListener('click', () => {
        showPage('timer');
    });
    
    // ========== 设置管理 ==========
    
    // 保存设置
    document.getElementById('saveSettingsBtn')?.addEventListener('click', () => {
        saveSettings();
    });
    
    // 导出数据
    document.getElementById('exportDataBtn')?.addEventListener('click', () => {
        if (storage.exportData()) {
            notificationManager.showToast('数据导出成功！');
        } else {
            notificationManager.showToast('数据导出失败');
        }
    });
    
    // 清除数据
    document.getElementById('clearDataBtn')?.addEventListener('click', () => {
        // 使用双击确认代替confirm对话框
        const btn = document.getElementById('clearDataBtn');
        if (btn.dataset.confirmDelete === 'true') {
            if (storage.clearAllData()) {
                notificationManager.showToast('数据已清除');
                setTimeout(() => location.reload(), 1000);
            } else {
                notificationManager.showToast('清除数据失败');
            }
            btn.dataset.confirmDelete = 'false';
            btn.textContent = '清除所有数据';
        } else {
            btn.dataset.confirmDelete = 'true';
            btn.textContent = '再次点击确认清除';
            notificationManager.showToast('再次点击确认清除数据');
            setTimeout(() => {
                btn.dataset.confirmDelete = 'false';
                btn.textContent = '清除所有数据';
            }, 3000);
        }
    });
    
    // 通知权限切换
    document.getElementById('notificationEnabled')?.addEventListener('change', (e) => {
        if (e.target.checked) {
            notificationManager.requestPermission();
        }
    });
    
    // 广告开关
    document.getElementById('adsEnabled')?.addEventListener('change', (e) => {
        if (typeof adSenseManager !== 'undefined') {
            adSenseManager.setAdsEnabled(e.target.checked);
        }
    });
    
    // 主题切换
    document.getElementById('theme')?.addEventListener('change', (e) => {
        applyTheme(e.target.value);
    });
    
    // ========== 键盘快捷键 ==========
    
    document.addEventListener('keydown', (e) => {
        // 空格键：开始/暂停
        if (e.code === 'Space' && e.target.tagName !== 'INPUT') {
            e.preventDefault();
            if (timer.isRunning) {
                timer.pause();
            } else {
                timer.start();
            }
        }
        
        // R键：重置
        if (e.code === 'KeyR' && e.target.tagName !== 'INPUT') {
            timer.reset();
        }
        
        // S键：跳过
        if (e.code === 'KeyS' && e.target.tagName !== 'INPUT') {
            timer.skip();
        }
    });
}

// ==================== 页面切换 ====================

function showPage(pageName) {
    // 隐藏所有页面
    document.getElementById('timerPage')?.classList.add('hidden');
    document.getElementById('statsPage')?.classList.add('hidden');
    document.getElementById('settingsPage')?.classList.add('hidden');
    
    // 显示目标页面
    switch (pageName) {
        case 'timer':
            document.getElementById('timerPage')?.classList.remove('hidden');
            break;
        case 'stats':
            document.getElementById('statsPage')?.classList.remove('hidden');
            statisticsManager.updateAllStats();
            break;
        case 'settings':
            document.getElementById('settingsPage')?.classList.remove('hidden');
            loadSettings();
            break;
    }
}

// ==================== 加载设置 ====================

function loadSettings() {
    const settings = storage.getSettings();
    
    // 加载时间设置
    document.getElementById('workDuration').value = settings.workDuration;
    document.getElementById('shortBreakDuration').value = settings.shortBreakDuration;
    document.getElementById('longBreakDuration').value = settings.longBreakDuration;
    document.getElementById('longBreakInterval').value = settings.longBreakInterval;
    
    // 加载功能设置
    document.getElementById('notificationEnabled').checked = settings.notificationEnabled;
    document.getElementById('soundEnabled').checked = settings.soundEnabled;
    document.getElementById('autoStartBreaks').checked = settings.autoStartBreaks;
    document.getElementById('autoStartPomodoros').checked = settings.autoStartPomodoros;
    document.getElementById('adsEnabled').checked = settings.adsEnabled !== false;
    
    // 加载主题设置
    document.getElementById('theme').value = settings.theme;
}

// ==================== 保存设置 ====================

function saveSettings() {
    const settings = {
        workDuration: parseInt(document.getElementById('workDuration').value),
        shortBreakDuration: parseInt(document.getElementById('shortBreakDuration').value),
        longBreakDuration: parseInt(document.getElementById('longBreakDuration').value),
        longBreakInterval: parseInt(document.getElementById('longBreakInterval').value),
        notificationEnabled: document.getElementById('notificationEnabled').checked,
        soundEnabled: document.getElementById('soundEnabled').checked,
        autoStartBreaks: document.getElementById('autoStartBreaks').checked,
        autoStartPomodoros: document.getElementById('autoStartPomodoros').checked,
        adsEnabled: document.getElementById('adsEnabled').checked,
        theme: document.getElementById('theme').value,
        dailyGoal: 8
    };
    
    // 验证输入
    if (settings.workDuration < 1 || settings.workDuration > 60) {
        notificationManager.showToast('工作时长必须在1-60分钟之间');
        return;
    }
    
    if (settings.shortBreakDuration < 1 || settings.shortBreakDuration > 30) {
        notificationManager.showToast('短休息时长必须在1-30分钟之间');
        return;
    }
    
    if (settings.longBreakDuration < 1 || settings.longBreakDuration > 60) {
        notificationManager.showToast('长休息时长必须在1-60分钟之间');
        return;
    }
    
    // 保存设置
    if (storage.saveSettings(settings)) {
        notificationManager.showToast('设置已保存！');
        
        // 更新通知管理器
        notificationManager.setNotificationEnabled(settings.notificationEnabled);
        notificationManager.setSoundEnabled(settings.soundEnabled);
        
        // 重新加载计时器设置
        timer.reloadSettings();
        
        // 应用主题
        applyTheme(settings.theme);
    } else {
        notificationManager.showToast('设置保存失败');
    }
}

// ==================== 应用主题 ====================

function applyTheme(theme) {
    if (!theme) {
        const settings = storage.getSettings();
        theme = settings.theme;
    }
    
    document.body.setAttribute('data-theme', theme);
    
    // 如果是自动模式，检查系统主题
    if (theme === 'auto') {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        document.body.setAttribute('data-theme', prefersDark ? 'dark' : 'light');
    }
}

// ==================== 监听系统主题变化 ====================

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
    const settings = storage.getSettings();
    if (settings.theme === 'auto') {
        applyTheme('auto');
    }
});

// ==================== 页面可见性变化处理 ====================

document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        // 页面隐藏时的处理
        console.log('页面已隐藏');
    } else {
        // 页面显示时的处理
        console.log('页面已显示');
        // 更新显示
        timer.updateDisplay();
        timer.updateCounter();
    }
});

// ==================== 工具函数 ====================

// 格式化时间
function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

// 显示确认对话框
function showConfirm(message) {
    return confirm(message);
}

// ==================== 全局错误处理 ====================

window.addEventListener('error', (event) => {
    console.error('全局错误:', event.error);
});

window.addEventListener('unhandledrejection', (event) => {
    console.error('未处理的Promise拒绝:', event.reason);
});

// ==================== 导出全局对象供调试使用 ====================

window.pomodoroApp = {
    timer,
    storage,
    notificationManager,
    statisticsManager
};

console.log('提示：可以通过 window.pomodoroApp 访问应用对象进行调试');
console.log('快捷键：空格 = 开始/暂停, R = 重置, S = 跳过');

