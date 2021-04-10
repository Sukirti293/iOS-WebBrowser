//
//  BookmarksTableViewController.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/19/21.
//
import UIKit
import RealmSwift

class BookmarksTableViewController: UITableViewController {
    
    var bookmarks  = [Bookmark]()
    var delegate: BrowserHomeViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bookmarks", for: indexPath) as! BookmarksTableViewCell

        let boohmark : Bookmark = bookmarks[indexPath.row]

        cell.title.text = boohmark.title
        cell.url.text = boohmark.url

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.loadWebSite(input: bookmarks[indexPath.row].url, isURLDomain: true, isURLProcessed: true)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteedBookmark : Bookmark = bookmarks.remove(at: indexPath.row)
            let realm = try! Realm()
            try! realm.write{
                realm.delete(deleteedBookmark)
            }
            delegate.loadBookMarks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}
