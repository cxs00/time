/**
 * ==================== Service Worker ====================
 * 功能：PWA离线支持、缓存管理、后台同步
 * 版本：v1.0.0
 * 日期：2025-10-26
 * ========================================================
 */

const CACHE_NAME = 'activity-tracker-v1.0.0';
const RUNTIME_CACHE = 'activity-tracker-runtime';

// 需要缓存的核心资源
const CORE_ASSETS = [
  '/',
  '/index.html',
  '/time/time/Web/activity-tracker.html',
  '/time/time/Web/css/activity-tracker.css',
  '/time/time/Web/js/app-main.js',
  '/time/time/Web/js/activity-tracker.js',
  '/time/time/Web/js/project-manager.js',
  '/time/time/Web/js/diary-memo.js',
  '/time/time/Web/js/ai-classifier.js',
  '/time/time/Web/js/analytics.js',
  '/time/time/Web/js/theme-switcher.js',
  '/time/time/Web/js/size-switcher.js',
  '/manifest.json',
  // 字体和图标
  '/assets/icons/icon-192x192.png',
  '/assets/icons/icon-512x512.png'
];

// 需要网络优先的资源（ECharts等CDN资源）
const NETWORK_FIRST_URLS = [
  'https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js'
];

/**
 * 安装事件 - 预缓存核心资源
 */
self.addEventListener('install', (event) => {
  console.log('[Service Worker] 安装中...', CACHE_NAME);

  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[Service Worker] 缓存核心资源');
        return cache.addAll(CORE_ASSETS);
      })
      .then(() => {
        console.log('[Service Worker] 安装完成');
        // 跳过等待，立即激活
        return self.skipWaiting();
      })
      .catch((error) => {
        console.error('[Service Worker] 安装失败:', error);
      })
  );
});

/**
 * 激活事件 - 清理旧缓存
 */
self.addEventListener('activate', (event) => {
  console.log('[Service Worker] 激活中...', CACHE_NAME);

  event.waitUntil(
    caches.keys()
      .then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => {
            // 删除旧版本缓存
            if (cacheName !== CACHE_NAME && cacheName !== RUNTIME_CACHE) {
              console.log('[Service Worker] 删除旧缓存:', cacheName);
              return caches.delete(cacheName);
            }
          })
        );
      })
      .then(() => {
        console.log('[Service Worker] 激活完成');
        // 立即控制所有客户端
        return self.clients.claim();
      })
  );
});

/**
 * 请求拦截 - 缓存策略
 */
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // 只处理HTTP(S)请求
  if (!request.url.startsWith('http')) {
    return;
  }

  // 跳过Chrome扩展请求
  if (url.protocol === 'chrome-extension:') {
    return;
  }

  // 对于核心资源，使用缓存优先策略
  if (CORE_ASSETS.includes(url.pathname)) {
    event.respondWith(cacheFirst(request));
    return;
  }

  // 对于外部CDN资源，使用网络优先策略
  if (NETWORK_FIRST_URLS.some(netUrl => request.url.includes(netUrl))) {
    event.respondWith(networkFirst(request));
    return;
  }

  // 对于API请求，使用网络优先策略
  if (url.pathname.startsWith('/api/')) {
    event.respondWith(networkFirst(request));
    return;
  }

  // 对于图片资源，使用缓存优先策略
  if (request.destination === 'image') {
    event.respondWith(cacheFirst(request));
    return;
  }

  // 默认策略：Stale-While-Revalidate
  event.respondWith(staleWhileRevalidate(request));
});

/**
 * 缓存优先策略（Cache First）
 * 适用于：核心HTML/CSS/JS文件、图片等静态资源
 */
async function cacheFirst(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);

  if (cached) {
    console.log('[SW] 从缓存返回:', request.url);
    return cached;
  }

  try {
    const response = await fetch(request);
    // 只缓存成功的响应
    if (response.ok) {
      cache.put(request, response.clone());
    }
    return response;
  } catch (error) {
    console.error('[SW] 请求失败:', request.url, error);
    // 返回离线页面
    return caches.match('/offline.html');
  }
}

/**
 * 网络优先策略（Network First）
 * 适用于：API请求、CDN资源
 */
async function networkFirst(request) {
  const cache = await caches.open(RUNTIME_CACHE);

  try {
    const response = await fetch(request);
    // 缓存成功的响应
    if (response.ok) {
      cache.put(request, response.clone());
    }
    return response;
  } catch (error) {
    console.error('[SW] 网络请求失败，尝试缓存:', request.url);
    const cached = await cache.match(request);
    if (cached) {
      return cached;
    }
    throw error;
  }
}

/**
 * Stale-While-Revalidate 策略
 * 适用于：一般资源，既要快速响应，又要保持更新
 */
async function staleWhileRevalidate(request) {
  const cache = await caches.open(RUNTIME_CACHE);
  const cached = await cache.match(request);

  // 后台更新缓存
  const fetchPromise = fetch(request).then((response) => {
    if (response.ok) {
      cache.put(request, response.clone());
    }
    return response;
  });

  // 如果有缓存，立即返回，否则等待网络响应
  return cached || fetchPromise;
}

/**
 * 消息处理 - 与主线程通信
 */
self.addEventListener('message', (event) => {
  console.log('[Service Worker] 收到消息:', event.data);

  if (event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }

  if (event.data.type === 'CLEAR_CACHE') {
    event.waitUntil(
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => caches.delete(cacheName))
        );
      }).then(() => {
        event.ports[0].postMessage({ success: true });
      })
    );
  }

  if (event.data.type === 'GET_VERSION') {
    event.ports[0].postMessage({ version: CACHE_NAME });
  }
});

/**
 * 后台同步 - 同步数据到云端
 */
self.addEventListener('sync', (event) => {
  console.log('[Service Worker] 后台同步:', event.tag);

  if (event.tag === 'sync-activities') {
    event.waitUntil(syncActivities());
  }

  if (event.tag === 'sync-projects') {
    event.waitUntil(syncProjects());
  }
});

/**
 * 推送通知
 */
self.addEventListener('push', (event) => {
  console.log('[Service Worker] 收到推送:', event);

  const options = {
    body: event.data ? event.data.text() : '您有新的活动提醒',
    icon: '/assets/icons/icon-192x192.png',
    badge: '/assets/icons/badge-72x72.png',
    vibrate: [200, 100, 200],
    tag: 'activity-notification',
    requireInteraction: false,
    actions: [
      { action: 'view', title: '查看详情' },
      { action: 'dismiss', title: '关闭' }
    ]
  };

  event.waitUntil(
    self.registration.showNotification('Activity Tracker', options)
  );
});

/**
 * 通知点击处理
 */
self.addEventListener('notificationclick', (event) => {
  console.log('[Service Worker] 通知点击:', event.action);

  event.notification.close();

  if (event.action === 'view') {
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});

/**
 * 同步活动数据到云端（待实现）
 */
async function syncActivities() {
  try {
    // TODO: 实现云端同步逻辑
    console.log('[Service Worker] 同步活动数据');
    return Promise.resolve();
  } catch (error) {
    console.error('[Service Worker] 同步失败:', error);
    throw error;
  }
}

/**
 * 同步项目数据到云端（待实现）
 */
async function syncProjects() {
  try {
    // TODO: 实现云端同步逻辑
    console.log('[Service Worker] 同步项目数据');
    return Promise.resolve();
  } catch (error) {
    console.error('[Service Worker] 同步失败:', error);
    throw error;
  }
}

/**
 * 错误处理
 */
self.addEventListener('error', (event) => {
  console.error('[Service Worker] 错误:', event.error);
});

self.addEventListener('unhandledrejection', (event) => {
  console.error('[Service Worker] 未处理的Promise拒绝:', event.reason);
});

console.log('[Service Worker] 已加载，版本:', CACHE_NAME);

