//
//  ViewController.swift
//  NewsDemo
//
//  Created by ByteDance on 2022/5/6.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segmentView: TransitionSegmentView?
    
    var scrollContainer: UIScrollView?
    
    var navigationBar: UINavigationBar?
    
    var dataArray = [News]()
    var titles: [String] = []
    
    var tableView: UITableView?
    
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
        
//        for i in 0...100 {
//            dataArray.append(News(_title: String(i), _date: String(i) ,_thumb: String(i), _source: String(i)))
//        }
        
        requestNewsAPI()
        
        for index in 0...titles.count {
            setupTableView(index)
            scrollContainer?.addSubview(tableView!)
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
    
    //请求新闻数据
    func requestNewsAPI() {
        let url = "http://v.juhe.cn/toutiao/index?type=top&key=92d7759f604c067117f975624fdd5185"
        weak var weakSelf = self
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                
                if let json = response.result.value {
                    let dict = JSON(json)
                    let data =  dict["result"]["data"].arrayValue
        
                    weakSelf?.paraseNewsInfo(data)
                }
        }
    }
    
    //解析新闻数据
    func paraseNewsInfo(_ dateArray: [JSON]) {
        print(dateArray)
        for item in dateArray {
            let title = item["title"].stringValue
            let date = item["date"].stringValue
            let thumbnail = item["thumbnail_pic_s"].stringValue
            let source = item["url"].stringValue
            
            let newsItem = News(_title: title, _date: date, _thumb: thumbnail, _source:source)
            dataArray.append(newsItem)
        }
        
        tableView?.reloadData()
    }

    private func setupTableView(_ index: Int){
        tableView = UITableView.init()
        tableView?.frame = CGRect(x: CGFloat(index)*screenWidth, y: 0, width: (scrollContainer?.bounds.width)!, height: (scrollContainer?.bounds.height)!)
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(NewsTableViewCell.classForCoder(), forCellReuseIdentifier: "swiftCell")
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webView = MyWebViewController()
        webView.setUrl(url: dataArray[indexPath.row].newSource)
        self.navigationController?.pushViewController(webView, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "swiftCell") as! NewsTableViewCell

        newsCell.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
        newsCell.titleLabel.text = dataArray[indexPath.row].title
        newsCell.dateLabel.text = dataArray[indexPath.row].date
        newsCell.thumbImage.kf.setImage(with: URL(string: dataArray[indexPath.row].thumbnail!))

        return newsCell;
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
