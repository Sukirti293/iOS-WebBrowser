//
//  Bookmark.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/22/21.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String{
        return "url"
    }
    
    var bookmarkDescription: String{
        let urlDescription = "URL: \(url)\n"
        let titleDescription = "Title: \(title)\n"
        return "Bookmark Information: \n \(urlDescription) \(titleDescription)"
    }
    
}
