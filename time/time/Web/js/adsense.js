// ==================== Google AdSense 广告管理模块 ====================
// Activity Tracker - 方案1: 底部固定横幅广告

class AdSenseManager {
    constructor() {
        this.adClient = 'ca-pub-6680853179152933'; // AdSense客户端ID
        this.adSlots = {
            banner: '1459432262', // 横幅广告位ID ✅ 已配置
        };
        this.adsEnabled = true;
        this.initialized = false;

        console.log('🎯 AdSense管理器初始化 - Activity Tracker');
        console.log(`📊 客户端ID: ${this.adClient}`);
        console.log(`📱 横幅广告位ID: ${this.adSlots.banner}`);
        console.log(`📍 布局方案: 底部固定横幅（方案1）`);
    }

    // ==================== 初始化AdSense ====================

    init() {
        if (this.initialized) {
            console.log('AdSense已初始化');
            return;
        }

        // 检查用户设置
        const settings = this.getSettings();
        this.adsEnabled = settings.adsEnabled !== false;

        if (!this.adsEnabled) {
            console.log('广告已被用户禁用');
            return;
        }

        // 加载AdSense脚本
        this.loadAdSenseScript();
        this.initialized = true;

        console.log('✅ AdSense初始化完成');
    }

    // ==================== 加载AdSense脚本 ====================

    loadAdSenseScript() {
        console.log('🔧 开始加载AdSense脚本...');

        // 检查是否已经加载
        if (window.adsbygoogle) {
            console.log('✅ AdSense脚本已存在');
            return;
        }

        console.log(`📡 加载AdSense脚本: https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${this.adClient}`);

        const script = document.createElement('script');
        script.async = true;
        script.crossOrigin = 'anonymous';
        script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${this.adClient}`;

        script.onload = () => {
            console.log('✅ AdSense脚本加载成功');
            // 确保adsbygoogle数组存在
            window.adsbygoogle = window.adsbygoogle || [];
            console.log(`📊 adsbygoogle数组长度: ${window.adsbygoogle.length}`);
        };

        script.onerror = (error) => {
            console.error('❌ AdSense脚本加载失败:', error);
            console.log('🔄 尝试显示占位广告...');
            this.showPlaceholderAd();
        };

        document.head.appendChild(script);
        console.log('📤 AdSense脚本已添加到页面');
    }

    // ==================== 创建广告单元 ====================

    createAdUnit(container, slotId, format = 'auto', style = {}) {
        console.log(`🎯 创建广告单元: ${container}, 广告位ID: ${slotId}`);

        if (!this.adsEnabled) {
            console.log('⚠️ 广告已被禁用');
            return;
        }

        const adContainer = document.getElementById(container);
        if (!adContainer) {
            console.error(`❌ 广告容器 ${container} 不存在`);
            return;
        }

        console.log(`📦 找到广告容器: ${container}`);

        // 创建广告HTML
        const adHTML = `
            <ins class="adsbygoogle"
                 style="display:block; ${this.styleToString(style)}"
                 data-ad-client="${this.adClient}"
                 data-ad-slot="${slotId}"
                 data-ad-format="${format}"
                 data-full-width-responsive="true"></ins>
        `;

        console.log(`📝 设置广告HTML`);
        adContainer.innerHTML = adHTML;

        // 推送广告
        try {
            if (window.adsbygoogle) {
                console.log('🚀 推送广告到AdSense...');
                window.adsbygoogle.push({});
                console.log('✅ AdSense广告已推送，广告位ID:', slotId);
            } else {
                console.error('❌ AdSense脚本未加载，无法推送广告');
                console.log('🔄 显示占位广告...');
                this.showPlaceholderAd();
            }
        } catch (e) {
            console.error('❌ 广告推送失败:', e);
            console.log('🔄 显示占位广告...');
            this.showPlaceholderAd();
        }
    }

    // ==================== 显示底部固定横幅广告（方案1）====================

    showBannerAd() {
        console.log('🎯 显示底部固定横幅广告（方案1）');

        this.createAdUnit('fixed-banner-ad-container', this.adSlots.banner, 'horizontal', {
            'min-height': '50px'
        });

        // 延迟检查广告是否加载，给AdSense更多时间
        setTimeout(() => {
            const adContainer = document.getElementById('fixed-banner-ad-container');
            const adIns = adContainer?.querySelector('ins.adsbygoogle');

            // 检查广告状态
            if (adIns) {
                const adStatus = adIns.getAttribute('data-ad-status');
                console.log('AdSense广告状态:', adStatus);

                // 只有在明确失败时才显示占位广告
                if (adStatus === 'error' || adStatus === 'blocked') {
                    console.log('AdSense广告加载失败，显示占位广告');
                    this.showPlaceholderAd();
                } else if (!adStatus || adStatus === 'unfilled') {
                    // 如果还没有状态，再等待一段时间
                    console.log('AdSense广告仍在加载中...');
                    setTimeout(() => {
                        const finalStatus = adIns.getAttribute('data-ad-status');
                        if (finalStatus === 'error' || finalStatus === 'blocked') {
                            this.showPlaceholderAd();
                        }
                    }, 10000); // 再等待10秒
                }
            }
        }, 5000); // 延长到5秒检查
    }

    // ==================== 显示占位广告 ====================

    showPlaceholderAd() {
        const adContainer = document.getElementById('fixed-banner-ad-container');
        if (!adContainer) return;

        adContainer.innerHTML = `
            <div style="
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 10px 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                min-height: 50px;
            ">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                    <polyline points="21 15 16 10 5 21"></polyline>
                </svg>
                <div style="flex: 1; line-height: 1.4;">
                    <div style="font-weight: 600; font-size: 13px;">🎯 广告位 · Activity Tracker</div>
                    <div style="font-size: 11px; opacity: 0.9;">AdSense ID: ${this.adSlots.banner} · 加载中...</div>
                </div>
                <div style="
                    background: rgba(255,255,255,0.2);
                    padding: 6px 14px;
                    border-radius: 12px;
                    font-size: 11px;
                    font-weight: 600;
                    animation: pulse 2s infinite;
                ">
                    加载中
                </div>
            </div>
            <style>
                @keyframes pulse {
                    0%, 100% { opacity: 1; }
                    50% { opacity: 0.6; }
                }
            </style>
        `;
        adContainer.style.display = 'flex';
        console.log('✅ 占位广告已显示');
    }

    // ==================== 工具方法 ====================

    styleToString(styleObj) {
        return Object.entries(styleObj)
            .map(([key, value]) => `${key}:${value}`)
            .join(';');
    }

    // ==================== 启用/禁用广告 ====================

    setAdsEnabled(enabled) {
        this.adsEnabled = enabled;
        const settings = this.getSettings();
        settings.adsEnabled = enabled;
        this.saveSettings(settings);

        if (enabled) {
            const adContainer = document.getElementById('fixed-banner-ad-container');

            // 🔧 智能显示：如果广告已存在，直接显示；否则重新加载
            if (adContainer && adContainer.querySelector('ins.adsbygoogle')) {
                console.log('📺 检测到已有广告，直接显示');
                adContainer.style.display = 'flex';
                this.showToast('广告已启用');
            } else {
                console.log('🔄 未检测到广告，重新加载');
                this.init();
                this.showToast('广告已启用，正在加载...');
                setTimeout(() => {
                    this.showBannerAd();
                    console.log('✅ 广告重新加载完成');
                }, 1000);  // 延迟 1 秒
            }
        } else {
            this.hideAllAds();
            this.showToast('广告已禁用');
        }
    }

    // ==================== 隐藏所有广告 ====================

    hideAllAds() {
        const adContainer = document.getElementById('fixed-banner-ad-container');
        if (adContainer) {
            // 🔧 修复：保留广告内容，只隐藏容器（避免重新创建时的延迟）
            adContainer.style.display = 'none';
            console.log('✅ 广告容器已隐藏（内容保留）');
        }
        console.log('✅ 所有广告已隐藏');
    }

    // ==================== 刷新广告 ====================

    refreshAds() {
        if (!this.adsEnabled) return;

        console.log('🔄 刷新广告...');
        // 移除旧广告
        this.hideAllAds();

        // 重新加载广告
        setTimeout(() => {
            const adContainer = document.getElementById('fixed-banner-ad-container');
            if (adContainer) {
                adContainer.style.display = 'block';
            }
            this.showBannerAd();
        }, 100);
    }

    // ==================== 设置管理 ====================

    getSettings() {
        try {
            const settings = localStorage.getItem('activityTracker_settings');
            return settings ? JSON.parse(settings) : { adsEnabled: true };
        } catch (e) {
            console.error('读取设置失败:', e);
            return { adsEnabled: true };
        }
    }

    saveSettings(settings) {
        try {
            localStorage.setItem('activityTracker_settings', JSON.stringify(settings));
            console.log('✅ 设置已保存');
        } catch (e) {
            console.error('保存设置失败:', e);
        }
    }

    showToast(message) {
        // 简单的提示实现
        console.log(`📢 Toast: ${message}`);
        // 如果有通知管理器，可以调用
        if (window.notificationManager) {
            window.notificationManager.showToast(message);
        }
    }
}

// 导出单例
if (typeof window !== 'undefined') {
    window.AdSenseManager = AdSenseManager;
    window.adSenseManager = new AdSenseManager();
    console.log('✅ AdSense管理器已挂载到window对象');
}
