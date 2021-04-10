//
//  TabsTableViewController.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/19/21.
//

import UIKit
import RealmSwift


class TabsTableViewController: UITableViewController {
    
    var tabs = [Tab]()
    var delegate: BrowserHomeViewController!
    var selectedTab: Int!
    
    @IBOutlet var tabsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TabsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! TabsTableViewCell

        let tab: Tab = tabs[indexPath.row]
        if(tab.title.isEmpty){
            cell.title.text = "New Tab"
            cell.url.text = ""
        }else{
            cell.url.text = tab.url
            cell.title.text = tab.title
        }


        if(indexPath.row == selectedTab){
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.green.cgColor
        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != selectedTab){
            delegate.selectedTab = indexPath.row
            delegate.loadWebView()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addTabs(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let newTab: Tab = Tab()
        try! realm.write{
            realm.add(newTab)
        }
        
        tabs.append(newTab)
        selectedTab = tabs.count - 1
        tableView.reloadData()
        delegate.addTab(newTab)
        navigationController?.popViewController(animated: true)
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row > 0){
            return true
        }
        return false
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteTab : Tab = tabs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delegate.deleteTab(deleteTab, indexPath.row)
        }
    }


}
