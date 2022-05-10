//
//  MyWebViewController.swift
//  NewsDemo
//
//  Created by ByteDance on 2022/5/7.
//

import UIKit

class MyWebViewController: UIViewController {

    var newsUrl: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(webView)
        let request = URLRequest(url: URL(string: newsUrl)!)
        webView.loadRequest(request)
    }
    
    // 懒加载，创建标题
    lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.frame = self.view.bounds
        
        return webView
    }()

    func setUrl(url:String) -> Void {
        newsUrl = url
    }

}
