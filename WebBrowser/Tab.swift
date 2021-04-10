//
//  Tab.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/22/21.
//

import Foundation
import RealmSwift

class Tab: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var initialUrl: String = ""
    @objc dynamic var title: String = ""
    
    var tabDescription: String{
        let urlDescription = "URL: \(url)\n"
        let initialUrlDescription = "Initial URL: \(initialUrl)\n"
        let titleDescription = "Title: \(title)\n"
        return "Tab Information: \n \(urlDescription) \(initialUrlDescription) \(titleDescription)"
    }
}
