/**
 * ==================== PWA注册脚本 ====================
 * 功能：注册Service Worker，启用PWA功能
 * 版本：v1.0.0
 * ========================================================
 */

/**
 * 注册Service Worker
 */
async function registerServiceWorker() {
  if ('serviceWorker' in navigator) {
    try {
      const registration = await navigator.serviceWorker.register('/service-worker.js', {
        scope: '/'
      });

      console.log('✅ Service Worker 注册成功:', registration.scope);

      // 检查更新
      registration.addEventListener('updatefound', () => {
        const newWorker = registration.installing;
        console.log('🔄 发现新版本Service Worker');

        newWorker.addEventListener('statechange', () => {
          if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
            // 新版本可用，提示用户更新
            showUpdateNotification();
          }
        });
      });

      // 定期检查更新
      setInterval(() => {
        registration.update();
      }, 60 * 60 * 1000); // 每小时检查一次

      return registration;
    } catch (error) {
      console.error('❌ Service Worker 注册失败:', error);
    }
  } else {
    console.warn('⚠️  浏览器不支持Service Worker');
  }
}

/**
 * 显示更新通知
 */
function showUpdateNotification() {
  const updateBanner = document.createElement('div');
  updateBanner.className = 'pwa-update-banner';
  updateBanner.innerHTML = `
    <div class="update-content">
      <span>🎉 发现新版本！</span>
      <button id="pwa-reload-btn" class="update-btn">立即更新</button>
      <button id="pwa-dismiss-btn" class="dismiss-btn">稍后</button>
    </div>
  `;

  document.body.appendChild(updateBanner);

  // 添加样式
  const style = document.createElement('style');
  style.textContent = `
    .pwa-update-banner {
      position: fixed;
      bottom: 20px;
      left: 50%;
      transform: translateX(-50%);
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 16px 24px;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
      z-index: 10000;
      animation: slideUp 0.3s ease;
    }

    @keyframes slideUp {
      from {
        transform: translateX(-50%) translateY(100px);
        opacity: 0;
      }
      to {
        transform: translateX(-50%) translateY(0);
        opacity: 1;
      }
    }

    .update-content {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .update-btn, .dismiss-btn {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.2s;
    }

    .update-btn {
      background: white;
      color: #667eea;
    }

    .update-btn:hover {
      background: #f0f0f0;
      transform: scale(1.05);
    }

    .dismiss-btn {
      background: transparent;
      color: white;
      border: 1px solid rgba(255, 255, 255, 0.5);
    }

    .dismiss-btn:hover {
      background: rgba(255, 255, 255, 0.1);
    }
  `;
  document.head.appendChild(style);

  // 立即更新
  document.getElementById('pwa-reload-btn').addEventListener('click', () => {
    navigator.serviceWorker.controller.postMessage({ type: 'SKIP_WAITING' });
    window.location.reload();
  });

  // 稍后更新
  document.getElementById('pwa-dismiss-btn').addEventListener('click', () => {
    updateBanner.remove();
  });
}

/**
 * 检测PWA安装状态
 */
function checkPWAInstalled() {
  // iOS Safari
  if (window.navigator.standalone === true) {
    console.log('✅ PWA已安装（iOS）');
    return true;
  }

  // Android Chrome
  if (window.matchMedia('(display-mode: standalone)').matches) {
    console.log('✅ PWA已安装（Android）');
    return true;
  }

  console.log('ℹ️  PWA未安装，可添加到主屏幕');
  return false;
}

/**
 * 显示安装提示
 */
let deferredPrompt;

function setupInstallPrompt() {
  window.addEventListener('beforeinstallprompt', (e) => {
    // 阻止默认的安装提示
    e.preventDefault();
    deferredPrompt = e;

    // 显示自定义安装按钮
    showInstallButton();
  });

  // 监听安装完成
  window.addEventListener('appinstalled', () => {
    console.log('✅ PWA安装成功！');
    deferredPrompt = null;
    hideInstallButton();

    // 显示欢迎消息
    showWelcomeMessage();
  });
}

/**
 * 显示安装按钮
 */
function showInstallButton() {
  const installBtn = document.createElement('button');
  installBtn.id = 'pwa-install-btn';
  installBtn.className = 'pwa-install-button';
  installBtn.innerHTML = `
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
      <polyline points="7 10 12 15 17 10"></polyline>
      <line x1="12" y1="15" x2="12" y2="3"></line>
    </svg>
    <span>安装应用</span>
  `;

  // 添加样式
  const style = document.createElement('style');
  style.textContent = `
    .pwa-install-button {
      position: fixed;
      bottom: 80px;
      right: 20px;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 20px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 25px;
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      z-index: 9999;
      transition: all 0.3s ease;
      animation: bounce 2s infinite;
    }

    .pwa-install-button:hover {
      transform: scale(1.05);
      box-shadow: 0 6px 16px rgba(102, 126, 234, 0.5);
    }

    @keyframes bounce {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-5px); }
    }
  `;
  document.head.appendChild(style);

  installBtn.addEventListener('click', async () => {
    if (!deferredPrompt) return;

    // 显示安装提示
    deferredPrompt.prompt();

    // 等待用户响应
    const { outcome } = await deferredPrompt.userChoice;
    console.log(`用户选择: ${outcome}`);

    deferredPrompt = null;
    installBtn.remove();
  });

  document.body.appendChild(installBtn);
}

/**
 * 隐藏安装按钮
 */
function hideInstallButton() {
  const installBtn = document.getElementById('pwa-install-btn');
  if (installBtn) {
    installBtn.remove();
  }
}

/**
 * 显示欢迎消息
 */
function showWelcomeMessage() {
  const welcome = document.createElement('div');
  welcome.className = 'pwa-welcome-message';
  welcome.innerHTML = `
    <div class="welcome-content">
      <h3>🎉 欢迎使用Activity Tracker！</h3>
      <p>应用已成功安装到您的设备</p>
    </div>
  `;

  const style = document.createElement('style');
  style.textContent = `
    .pwa-welcome-message {
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      background: white;
      padding: 20px 30px;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
      z-index: 10000;
      animation: fadeIn 0.3s ease, fadeOut 0.3s ease 2.7s;
    }

    .welcome-content h3 {
      margin: 0 0 8px 0;
      color: #667eea;
      font-size: 18px;
    }

    .welcome-content p {
      margin: 0;
      color: #666;
      font-size: 14px;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateX(-50%) translateY(-20px); }
      to { opacity: 1; transform: translateX(-50%) translateY(0); }
    }

    @keyframes fadeOut {
      from { opacity: 1; }
      to { opacity: 0; }
    }
  `;
  document.head.appendChild(style);

  document.body.appendChild(welcome);

  // 3秒后自动移除
  setTimeout(() => {
    welcome.remove();
  }, 3000);
}

/**
 * 请求通知权限
 */
async function requestNotificationPermission() {
  if ('Notification' in window && Notification.permission === 'default') {
    const permission = await Notification.requestPermission();
    console.log('通知权限:', permission);
    return permission === 'granted';
  }
  return Notification.permission === 'granted';
}

/**
 * 初始化PWA功能
 */
async function initPWA() {
  console.log('🚀 初始化PWA功能...');

  // 注册Service Worker
  await registerServiceWorker();

  // 检查安装状态
  checkPWAInstalled();

  // 设置安装提示
  setupInstallPrompt();

  // 请求通知权限
  await requestNotificationPermission();

  console.log('✅ PWA功能初始化完成');
}

// 页面加载完成后初始化
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initPWA);
} else {
  initPWA();
}

// 导出函数供外部使用
window.PWA = {
  register: registerServiceWorker,
  checkInstalled: checkPWAInstalled,
  requestNotification: requestNotificationPermission
};

