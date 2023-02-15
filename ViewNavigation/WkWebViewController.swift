//
//  WkWebViewController.swift
//  ViewNavigation
//
//  Created by Admin on 12/07/22.
//

import UIKit
import WebKit

class WkWebViewController: UIViewController {

    private var webView:WKWebView?
    private var popupWebView: WKWebView?
    public var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        if #available(iOS 14.0, *) {
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            webConfiguration.defaultWebpagePreferences = preferences
        } else {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            preferences.javaScriptCanOpenWindowsAutomatically = true
            webConfiguration.preferences = preferences
        }
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        self.view = webView

        loadWebView()

    }
    func loadWebView() {
        guard let url = URL(string: url ?? "") else { return }
        let request = URLRequest(url: url)
        webView?.load(request)
    }
}
extension WkWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        popupWebView!.uiDelegate = self
        
        view.addSubview(popupWebView!)
        
        return popupWebView!
        
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        
        popupWebView?.removeFromSuperview()
        popupWebView = nil
        
    }
    
}
