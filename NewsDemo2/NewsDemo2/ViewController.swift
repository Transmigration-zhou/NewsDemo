//
//  ViewController.swift
//  NewsDemo2
//
//  Created by ByteDance on 2022/5/10.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var segmentView: TransitionSegmentView?
    
    var scrollContainer: UIScrollView?
    
    var navigationBar: UINavigationBar?
    
    var dataArray = [News]()
    var titles: [String] = []
    
    var collectionView: UICollectionView?
    
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
        titles = ["推荐","热点","社会","娱乐","科技","汽车","体育","财经","军事","国际","时尚"]
        
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
        // scrollview容器
        scrollContainer = UIScrollView.init(frame: CGRect(x: 0, y: 99, width: screenWidth, height: screenHeight-99))
        
        for i in 0...10 {
            dataArray.append(News(_title: String(i), _date: String(i) ,_thumb: String(i), _source: String(i)))
        }
        
        for index in 0...(titles.count) {
            setupCollectionView(index)
            scrollContainer?.addSubview(collectionView!)
        }
        
        //配置scrollview容器
        scrollContainer?.contentSize = CGSize(width: 10*screenWidth, height: 0)
        scrollContainer?.showsHorizontalScrollIndicator = false
        scrollContainer?.delegate = self
        scrollContainer?.isPagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(scrollContainer!)
        
    }
    
    func onMakeNavitem() -> UINavigationItem {
        let navigationItem = UINavigationItem()
        navigationItem.title = "今日头条"
        return navigationItem
    }
    
    private func setupCollectionView(_ index: Int){
        let rect = CGRect(x: CGFloat(index)*screenWidth, y: 0, width: (scrollContainer?.bounds.width)!, height: (scrollContainer?.bounds.height)!)
        collectionView = UICollectionView.init(frame: rect, collectionViewLayout: self.ctreateFlowLayout())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(NewsCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "swiftCell")
    }
    
    // UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let webView = MyWebViewController()
//        webView.setUrl(url: dataArray[indexPath.row].newSource)
//        self.navigationController?.pushViewController(webView, animated: false)
//    }
    
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "swiftCell", for: indexPath) as! NewsCollectionViewCell
        newsCell.titleLabel.text = dataArray[indexPath.row].title
        newsCell.dateLabel.text = dataArray[indexPath.row].date
//        newsCell.thumbImage.kf.setImage(with: URL(string: dataArray[indexPath.row].thumbnail!))

        return newsCell;
    }
    
    // TODO: 一般UICollectionViewFlowLayout 的创建
    func ctreateFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth - 11, height: 110)
        return layout
    }
    
}

extension ViewController: UIScrollViewDelegate {

    //scollview滑动代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == scrollContainer) {
            let point = scrollView.contentOffset
            segmentView?.segmentWillMove(point: point)
        }
    }
    
    //scollview开始减速代理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //scollview停止减速代理
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(scrollView == scrollContainer) {
            let point = scrollView.contentOffset
            segmentView?.segmentDidEndMove(point: point)
        }
    }
}
