//
//  AppDelegate.swift
//  BonoEthSDK
//
//  Created by MinSoo Kang on 2022/08/23.
//

import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wv_web3: WKWebView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = WKWebViewConfiguration()
        self.wv_web3 = WKWebView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 1,
                                               height: 1 ),
                                 configuration: configuration)
        self.wv_web3?.navigationDelegate = self
        
        if let url = Bundle.main.url(forResource: "index",
                                     withExtension: "html") {

                
            self.wv_web3?.loadFileURL(url, allowingReadAccessTo: url)
        }
        
        return true
    }

}


extension AppDelegate: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
                
        //개발
        let endpoint = "dev"
        //라이브
//        let endpoint = "live"
        
        self.wv_web3?.evaluateJavaScript("setEndpoint(\"\(endpoint)\")",
                                         completionHandler: {
            result, error in
            print("evaluateJavaScript result : \(result)")
            print("evaluateJavaScript error : \(error)")
         })
        
    }
    
}
