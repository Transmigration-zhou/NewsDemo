//
//  ViewController.swift
//  NewsDemo
//
//  Created by ByteDance on 2022/5/6.
//

import UIKit

class ViewController: UIViewController {

    var segmentView: TransitionSegmentView?
    
    var scrollContainer: UIScrollView?
    
    var navigationBar: UINavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configNavi()
        self.configSegment()
        self.configScrollView()
    }
    
    func configNavi() {
        navigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 20, width: screenWidth, height: 44))
        self.view.addSubview(navigationBar!)
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
        navigationBar?.barTintColor = UIColor.red
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func configSegment() {
        let titles: [String] = ["推荐","热点","社会","娱乐","科技","汽车","体育","财经","军事","国际","时尚"]
        
        let rect = CGRect(x: 0, y: 64, width: screenWidth, height: 35)
        
        let configure = SegmentConfigure(textSelColor: UIColor.white, highlightColor: UIColor.red, titles: titles)
        
        segmentView = TransitionSegmentView.init(frame: rect, configure: configure)
        
        segmentView?.setScrollClosure(tempClosure: { (index) in
            let point = CGPoint(x: CGFloat(index)*screenWidth, y: 0)
            self.scrollContainer?.setContentOffset(point, animated: true)
        })
        
        self.view.addSubview(segmentView!)
    }
    
    func configScrollView() {
        
    }
    
    func onMakeNavitem() -> UINavigationItem {
        let navigationItem = UINavigationItem()
        navigationItem.title = "今日头条"
        return navigationItem
    }
    
}

extension ViewController: UIScrollViewDelegate {

    //scollview滑动代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        segmentView?.segmentWillMove(point: point)
    }
    
    //scollview开始减速代理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //scollview停止减速代理
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        segmentView?.segmentDidEndMove(point: point)
    }
    
}




