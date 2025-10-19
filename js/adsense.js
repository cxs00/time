// ==================== Google AdSense 广告管理模块 ====================

class AdSenseManager {
    constructor() {
        this.adClient = 'ca-pub-6680853179152933'; // AdSense客户端ID
        this.adSlots = {
            banner: '1459432262', // 横幅广告位ID ✅ 已配置
            sidebar: 'XXXXXXXXXX', // 侧边栏广告位ID（可选）
            inFeed: 'XXXXXXXXXX'  // 信息流广告位ID（可选）
        };
        this.adsEnabled = true;
        this.initialized = false;
    }

    // ==================== 初始化AdSense ====================
    
    init() {
        if (this.initialized) {
            console.log('AdSense已初始化');
            return;
        }

        // 检查用户设置
        const settings = storage.getSettings();
        this.adsEnabled = settings.adsEnabled !== false;

        if (!this.adsEnabled) {
            console.log('广告已被用户禁用');
            return;
        }

        // 加载AdSense脚本
        this.loadAdSenseScript();
        this.initialized = true;
    }

    // ==================== 加载AdSense脚本 ====================
    
    loadAdSenseScript() {
        const script = document.createElement('script');
        script.async = true;
        script.crossOrigin = 'anonymous';
        script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${this.adClient}`;
        
        script.onerror = () => {
            console.error('AdSense脚本加载失败');
        };
        
        document.head.appendChild(script);
    }

    // ==================== 创建广告单元 ====================
    
    createAdUnit(container, slotId, format = 'auto', style = {}) {
        if (!this.adsEnabled) return;

        const adContainer = document.getElementById(container);
        if (!adContainer) {
            console.error(`广告容器 ${container} 不存在`);
            return;
        }

        // 创建广告HTML
        const adHTML = `
            <ins class="adsbygoogle"
                 style="display:block; ${this.styleToString(style)}"
                 data-ad-client="${this.adClient}"
                 data-ad-slot="${slotId}"
                 data-ad-format="${format}"
                 data-full-width-responsive="true"></ins>
        `;

        adContainer.innerHTML = adHTML;

        // 推送广告
        try {
            (window.adsbygoogle = window.adsbygoogle || []).push({});
        } catch (e) {
            console.error('广告推送失败:', e);
        }
    }

    // ==================== 显示横幅广告 ====================
    
    showBannerAd() {
        // 如果未配置广告位ID，显示提示
        if (this.adSlots.banner === 'XXXXXXXXXX') {
            this.showSetupAd();
        } else {
            this.createAdUnit('banner-ad-container', this.adSlots.banner, 'horizontal', {
                'min-height': '50px'
            });
            
            // 延迟检查广告是否加载，如果没有则显示占位符
            setTimeout(() => {
                const adContainer = document.getElementById('banner-ad-container');
                const adIns = adContainer?.querySelector('ins.adsbygoogle');
                
                // 如果广告没有填充内容，显示占位广告
                if (adIns && (!adIns.getAttribute('data-ad-status') || 
                    adIns.getAttribute('data-ad-status') === 'unfilled')) {
                    this.showPlaceholderAd();
                }
            }, 3000); // 等待3秒检查
        }
    }
    
    // ==================== 显示占位广告 ====================
    
    showPlaceholderAd() {
        const adContainer = document.getElementById('banner-ad-container');
        if (!adContainer) return;
        
        adContainer.innerHTML = `
            <div style="
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 8px 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                min-height: 40px;
                border-radius: 4px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            ">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                    <polyline points="21 15 16 10 5 21"></polyline>
                </svg>
                <div style="flex: 1; line-height: 1.4;">
                    <div style="font-weight: 600; font-size: 12px;">🎯 广告位预留 · AdSense ID: 1459432262</div>
                    <div style="font-size: 10px; opacity: 0.9;">等待Google审核激活 | 真实广告即将展示</div>
                </div>
                <div style="
                    background: rgba(255,255,255,0.2);
                    padding: 5px 12px;
                    border-radius: 12px;
                    font-size: 10px;
                    font-weight: 600;
                    animation: pulse 2s infinite;
                ">
                    审核中
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
    }
    
    // ==================== 显示配置提示广告 ====================
    
    showSetupAd() {
        const adContainer = document.getElementById('banner-ad-container');
        if (!adContainer) return;
        
        adContainer.innerHTML = `
            <div style="
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                padding: 8px 12px;
                background: linear-gradient(135deg, #4CAF50 0%, #2E7D32 100%);
                color: white;
                font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                min-height: 50px;
                max-height: 50px;
            ">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                    <line x1="8" y1="21" x2="16" y2="21"></line>
                    <line x1="12" y1="17" x2="12" y2="21"></line>
                </svg>
                <div style="flex: 1; line-height: 1.3;">
                    <div style="font-weight: 600; font-size: 11px;">AdSense广告位 · 已配置</div>
                    <div style="font-size: 9px; opacity: 0.85;">等待激活中...</div>
                </div>
                <div style="
                    background: rgba(255,255,255,0.25);
                    padding: 4px 8px;
                    border-radius: 10px;
                    font-size: 9px;
                    font-weight: 600;
                ">
                    加载中
                </div>
            </div>
        `;
        adContainer.style.display = 'block';
    }

    // ==================== 显示侧边栏广告 ====================
    
    showSidebarAd() {
        this.createAdUnit('sidebar-ad-container', this.adSlots.sidebar, 'rectangle', {
            'width': '300px',
            'height': '250px'
        });
    }

    // ==================== 显示信息流广告 ====================
    
    showInFeedAd() {
        this.createAdUnit('infeed-ad-container', this.adSlots.inFeed, 'fluid', {
            'min-height': '100px'
        });
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
        const settings = storage.getSettings();
        settings.adsEnabled = enabled;
        storage.saveSettings(settings);

        if (enabled) {
            this.init();
            notificationManager.showToast('广告已启用');
        } else {
            this.hideAllAds();
            notificationManager.showToast('广告已禁用');
        }
    }

    // ==================== 隐藏所有广告 ====================
    
    hideAllAds() {
        const adContainers = [
            'banner-ad-container',
            'sidebar-ad-container',
            'infeed-ad-container'
        ];

        adContainers.forEach(id => {
            const container = document.getElementById(id);
            if (container) {
                container.innerHTML = '';
                container.style.display = 'none';
            }
        });
    }

    // ==================== 刷新广告 ====================
    
    refreshAds() {
        if (!this.adsEnabled) return;
        
        // 移除旧广告
        this.hideAllAds();
        
        // 重新加载广告
        setTimeout(() => {
            this.showBannerAd();
            this.showSidebarAd();
            this.showInFeedAd();
        }, 100);
    }
}

// 导出单例
const adSenseManager = new AdSenseManager();

