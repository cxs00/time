// ==================== 安全配置模块 ====================

class SecurityManager {
  constructor() {
    this.rateLimit = new Map();
    this.blockedIPs = new Set();
    this.suspiciousPatterns = [
      /<script[^>]*>.*?<\/script>/gi,
      /javascript:/gi,
      /on\w+\s*=/gi,
      /eval\s*\(/gi,
      /expression\s*\(/gi
    ];
    this.maxRequestsPerMinute = 60;
    this.maxRequestsPerHour = 1000;
  }

  // ==================== 速率限制 ====================

  checkRateLimit(ip) {
    const now = Date.now();
    const minute = Math.floor(now / 60000);
    const hour = Math.floor(now / 3600000);

    if (!this.rateLimit.has(ip)) {
      this.rateLimit.set(ip, {
        minute: { count: 0, timestamp: minute },
        hour: { count: 0, timestamp: hour }
      });
    }

    const data = this.rateLimit.get(ip);

    // 重置分钟计数器
    if (data.minute.timestamp !== minute) {
      data.minute = { count: 0, timestamp: minute };
    }

    // 重置小时计数器
    if (data.hour.timestamp !== hour) {
      data.hour = { count: 0, timestamp: hour };
    }

    data.minute.count++;
    data.hour.count++;

    // 检查限制
    if (data.minute.count > this.maxRequestsPerMinute) {
      console.warn(`🚨 速率限制: IP ${ip} 每分钟请求过多`);
      return false;
    }

    if (data.hour.count > this.maxRequestsPerHour) {
      console.warn(`🚨 速率限制: IP ${ip} 每小时请求过多`);
      this.blockedIPs.add(ip);
      return false;
    }

    return true;
  }

  // ==================== 输入验证 ====================

  sanitizeInput(input) {
    if (typeof input !== 'string') {
      return '';
    }

    // 移除危险字符
    let sanitized = input
      .replace(/[<>]/g, '') // 移除HTML标签
      .replace(/['"]/g, '') // 移除引号
      .replace(/[()]/g, '') // 移除括号
      .replace(/[;]/g, '') // 移除分号
      .trim();

    // 检查可疑模式
    for (const pattern of this.suspiciousPatterns) {
      if (pattern.test(sanitized)) {
        console.warn('🚨 检测到可疑输入:', sanitized);
        return '';
      }
    }

    return sanitized;
  }

  // ==================== XSS防护 ====================

  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // ==================== CSRF防护 ====================

  generateCSRFToken() {
    const array = new Uint8Array(32);
    crypto.getRandomValues(array);
    return Array.from(array, byte => byte.toString(16).padStart(2, '0')).join('');
  }

  validateCSRFToken(token) {
    const storedToken = localStorage.getItem('csrf_token');
    return storedToken && storedToken === token;
  }

  // ==================== 内容安全策略 ====================

  enforceCSP() {
    const csp = [
      "default-src 'self'",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://pagead2.googlesyndication.com https://www.googletagmanager.com",
      "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
      "font-src 'self' https://fonts.gstatic.com",
      "img-src 'self' data: https:",
      "connect-src 'self' https:",
      "frame-src 'self' https://googleads.g.doubleclick.net",
      "object-src 'none'",
      "base-uri 'self'",
      "form-action 'self'"
    ].join('; ');

    const meta = document.createElement('meta');
    meta.httpEquiv = 'Content-Security-Policy';
    meta.content = csp;
    document.head.appendChild(meta);

    console.log('🛡️ 内容安全策略已启用');
  }

  // ==================== 安全头部 ====================

  setSecurityHeaders() {
    // 这些头部在服务器端设置，这里只是记录
    const headers = {
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Referrer-Policy': 'strict-origin-when-cross-origin',
      'Permissions-Policy': 'camera=(), microphone=(), geolocation=()'
    };

    console.log('🛡️ 安全头部配置:', headers);
  }

  // ==================== 初始化安全系统 ====================

  init() {
    console.log('🛡️ 安全系统初始化...');

    // 启用CSP
    this.enforceCSP();

    // 设置安全头部
    this.setSecurityHeaders();

    // 生成CSRF令牌
    const token = this.generateCSRFToken();
    localStorage.setItem('csrf_token', token);

    // 监听可疑活动
    this.monitorSuspiciousActivity();

    console.log('✅ 安全系统已启用');
  }

  // ==================== 监控可疑活动 ====================

  monitorSuspiciousActivity() {
    // 监控控制台错误
    window.addEventListener('error', (event) => {
      if (event.message.includes('script') ||
        event.message.includes('eval') ||
        event.message.includes('Function')) {
        console.warn('🚨 检测到可疑脚本错误:', event.message);
      }
    });

    // 监控网络请求
    const originalFetch = window.fetch;
    window.fetch = (...args) => {
      const url = args[0];
      if (typeof url === 'string' &&
        (url.includes('javascript:') || url.includes('data:text/html'))) {
        console.warn('🚨 检测到可疑网络请求:', url);
        return Promise.reject('Blocked suspicious request');
      }
      return originalFetch.apply(this, args);
    };
  }

  // ==================== 获取客户端IP ====================

  getClientIP() {
    // 在实际应用中，这应该从服务器端获取
    // 这里使用一个简单的标识符
    return 'client_' + Math.random().toString(36).substr(2, 9);
  }

  // ==================== 安全检查 ====================

  performSecurityCheck() {
    const ip = this.getClientIP();

    // 检查速率限制
    if (!this.checkRateLimit(ip)) {
      console.warn('🚨 请求被速率限制阻止');
      return false;
    }

    // 检查IP是否被阻止
    if (this.blockedIPs.has(ip)) {
      console.warn('🚨 请求来自被阻止的IP');
      return false;
    }

    return true;
  }
}

// 创建全局安全管理器实例
window.securityManager = new SecurityManager();

// 自动初始化
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    window.securityManager.init();
  });
} else {
  window.securityManager.init();
}

console.log('🛡️ 安全配置模块已加载');
