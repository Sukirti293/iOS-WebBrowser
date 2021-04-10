//
//  PopulationFunctions.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/23/21.
//

import Foundation
import RealmSwift

func isRealmPopulatedWithDefaultTab() -> Bool{
    let realm = try! Realm()
    if(realm.objects(Tab.self).count > 0){
        return true
    }
    
    return false
}

func populateRealmWithDefaultTab(){
    let realm = try! Realm()
    let defaultTab: Tab = Tab(value: ["url":"https://www.apple.com", "initialUrl":"https://www.apple.com", "title":"Default - Apple"])
    
    try! realm.write{
        realm.add(defaultTab)
    }
    
    
}
