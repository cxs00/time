// ==================== 通知管理模块 ====================

class NotificationManager {
    constructor() {
        this.permission = 'default';
        this.soundEnabled = true;
        this.notificationEnabled = true;
    }

    // ==================== 请求通知权限 ====================
    
    async requestPermission() {
        if (!('Notification' in window)) {
            console.log('浏览器不支持通知功能');
            return false;
        }

        try {
            this.permission = await Notification.requestPermission();
            return this.permission === 'granted';
        } catch (error) {
            console.error('请求通知权限失败:', error);
            return false;
        }
    }

    // ==================== 检查权限状态 ====================
    
    checkPermission() {
        if ('Notification' in window) {
            this.permission = Notification.permission;
            return this.permission === 'granted';
        }
        return false;
    }

    // ==================== 发送通知 ====================
    
    sendNotification(title, options = {}) {
        if (!this.notificationEnabled) {
            return;
        }

        // 检查权限
        if (!this.checkPermission()) {
            console.log('没有通知权限');
            return;
        }

        const defaultOptions = {
            icon: '🍅',
            badge: '🍅',
            vibrate: [200, 100, 200],
            requireInteraction: false,
            silent: false
        };

        const notificationOptions = { ...defaultOptions, ...options };

        try {
            const notification = new Notification(title, notificationOptions);
            
            // 播放音效
            if (this.soundEnabled) {
                this.playSound();
            }

            // 自动关闭
            setTimeout(() => {
                notification.close();
            }, 5000);

            // 点击通知时聚焦窗口
            notification.onclick = () => {
                window.focus();
                notification.close();
            };

            return notification;
        } catch (error) {
            console.error('发送通知失败:', error);
            return null;
        }
    }

    // ==================== 工作完成通知 ====================
    
    notifyWorkComplete() {
        this.sendNotification('工作时间结束！', {
            body: '太棒了！你完成了一个番茄时钟 🍅\n是时候休息一下了。',
            tag: 'work-complete'
        });
    }

    // ==================== 短休息完成通知 ====================
    
    notifyShortBreakComplete() {
        this.sendNotification('短休息结束', {
            body: '休息时间结束，准备好继续工作了吗？',
            tag: 'break-complete'
        });
    }

    // ==================== 长休息完成通知 ====================
    
    notifyLongBreakComplete() {
        this.sendNotification('长休息结束', {
            body: '长休息结束，恢复精力继续前进！💪',
            tag: 'break-complete'
        });
    }

    // ==================== 自定义通知 ====================
    
    notifyCustom(title, body) {
        this.sendNotification(title, {
            body: body,
            tag: 'custom'
        });
    }

    // ==================== 播放音效 ====================
    
    playSound(soundType = 'complete') {
        if (!this.soundEnabled) {
            return;
        }

        try {
            // 使用Web Audio API创建简单的提示音
            const audioContext = new (window.AudioContext || window.webkitAudioContext)();
            
            if (soundType === 'complete') {
                // 完成音效：三个递增的音符
                this.playTone(audioContext, 523.25, 0, 0.1); // C5
                this.playTone(audioContext, 659.25, 0.15, 0.1); // E5
                this.playTone(audioContext, 783.99, 0.3, 0.2); // G5
            } else if (soundType === 'tick') {
                // 滴答音效
                this.playTone(audioContext, 800, 0, 0.05);
            } else if (soundType === 'start') {
                // 开始音效
                this.playTone(audioContext, 440, 0, 0.1);
            }
        } catch (error) {
            console.error('播放音效失败:', error);
        }
    }

    // ==================== 播放单个音调 ====================
    
    playTone(audioContext, frequency, startTime, duration) {
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();
        
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        
        oscillator.frequency.value = frequency;
        oscillator.type = 'sine';
        
        gainNode.gain.setValueAtTime(0, audioContext.currentTime + startTime);
        gainNode.gain.linearRampToValueAtTime(0.3, audioContext.currentTime + startTime + 0.01);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + startTime + duration);
        
        oscillator.start(audioContext.currentTime + startTime);
        oscillator.stop(audioContext.currentTime + startTime + duration);
    }

    // ==================== 设置配置 ====================
    
    setNotificationEnabled(enabled) {
        this.notificationEnabled = enabled;
    }

    setSoundEnabled(enabled) {
        this.soundEnabled = enabled;
    }

    // ==================== 显示Toast提示 ====================
    
    showToast(message, duration = 3000) {
        const toast = document.getElementById('toast');
        const toastMessage = document.getElementById('toastMessage');
        
        if (toast && toastMessage) {
            toastMessage.textContent = message;
            toast.classList.remove('hidden');
            
            setTimeout(() => {
                toast.classList.add('hidden');
            }, duration);
        }
    }
}

// 导出单例
const notificationManager = new NotificationManager();

