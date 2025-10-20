//
//  PomodoroWebView.swift
//  time
//
//  番茄时钟 WebView 封装
//

import SwiftUI
import WebKit

#if os(iOS)
struct PomodoroWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        // 创建配置
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        configuration.preferences = preferences
        
        // 允许本地文件访问
        configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        
        // 创建WebView
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        
        // 尝试加载本地HTML文件（文件在Bundle根目录）
        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
            let fileURL = URL(fileURLWithPath: htmlPath)
            
            // 使用loadFileURL方法（更稳定）
            if #available(iOS 9.0, *) {
                let webDirectory = fileURL.deletingLastPathComponent()
                webView.loadFileURL(fileURL, allowingReadAccessTo: webDirectory)
                print("✅ iOS - 正在加载本地HTML文件")
                print("   文件路径: \(htmlPath)")
                print("   Web目录: \(webDirectory.path)")
                
                // 启用开发者工具便于调试
                webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
            }
        } else {
            print("❌ 未找到index.html文件")
            // 显示简单的错误页面
            let errorHTML = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    * { margin: 0; padding: 0; box-sizing: border-box; }
                    body { 
                        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: 100vh;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        text-align: center;
                        padding: 20px;
                    }
                    .container { max-width: 400px; }
                    h1 { font-size: 48px; margin-bottom: 20px; }
                    h2 { font-size: 24px; margin-bottom: 15px; font-weight: 600; }
                    p { font-size: 14px; line-height: 1.6; opacity: 0.9; margin-bottom: 10px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>⚠️</h1>
                    <h2>资源加载失败</h2>
                    <p>Web资源文件未找到</p>
                    <p>请在Xcode中确认Web文件夹资源已正确添加到项目</p>
                </div>
            </body>
            </html>
            """
            webView.loadHTMLString(errorHTML, baseURL: nil)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
#elseif os(macOS)
struct PomodoroWebView: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        // 创建配置 - macOS专用优化
        let configuration = WKWebViewConfiguration()
        
        // 配置preferences
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        // 允许本地文件访问（macOS关键配置）
        configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        // 创建WebView
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        // macOS Resources目录在Contents/Resources下（文件在Bundle根目录）
        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
            let fileURL = URL(fileURLWithPath: htmlPath)
            
            // macOS使用整个Web目录作为读取权限（重要！）
            let webDirectory = fileURL.deletingLastPathComponent()
            
            print("🖥️ macOS版本 - 正在加载HTML文件")
            print("   HTML路径: \(htmlPath)")
            print("   Web目录: \(webDirectory.path)")
            print("   Bundle资源路径: \(Bundle.main.resourcePath ?? "未知")")
            
            // 使用loadFileURL方法，允许访问Web目录下的所有资源
            webView.loadFileURL(fileURL, allowingReadAccessTo: webDirectory)
            
            // 额外配置确保资源加载
            webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
            
            // 设置背景色避免黑屏
            webView.setValue(false, forKey: "drawsBackground")
            
        } else {
            print("❌ macOS: 未找到index.html文件")
            
            // 显示友好的错误页面
            let errorHTML = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    * { margin: 0; padding: 0; box-sizing: border-box; }
                    body { 
                        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: 100vh;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        text-align: center;
                        padding: 40px;
                    }
                    .container { max-width: 500px; }
                    h1 { font-size: 64px; margin-bottom: 20px; }
                    h2 { font-size: 28px; margin-bottom: 20px; font-weight: 600; }
                    p { font-size: 16px; line-height: 1.8; opacity: 0.95; margin-bottom: 12px; }
                    .code { 
                        background: rgba(0,0,0,0.2); 
                        padding: 15px; 
                        border-radius: 8px; 
                        font-family: 'SF Mono', Monaco, monospace;
                        font-size: 14px;
                        margin-top: 20px;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>⚠️</h1>
                    <h2>资源加载失败</h2>
                    <p>Web资源文件未找到</p>
                    <p>请在Xcode中确认Web文件夹已正确添加到项目</p>
                    <div class="code">
                        检查: Web资源 → Target Membership → ✓ time
                    </div>
                </div>
            </body>
            </html>
            """
            webView.loadHTMLString(errorHTML, baseURL: nil)
        }
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
    }
}
#endif

#Preview {
    PomodoroWebView()
}
