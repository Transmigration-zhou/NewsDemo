//
//  News.swift
//  NewsDemo
//
//  Created by ByteDance on 2022/5/7.
//

import UIKit

class News: NSObject {
    
    var title: String?
    var date: String?
    var thumbnail: String?
    var newSource: String
    
    init(_title: String, _date: String, _thumb: String, _source: String) {
        title = _title
        date = _date
        thumbnail = _thumb
        newSource = _source
    }
}
