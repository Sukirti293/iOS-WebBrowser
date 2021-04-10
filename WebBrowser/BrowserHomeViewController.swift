//
//  BrowserHomeViewController.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/19/21.
//

import UIKit
import WebKit
import RealmSwift

class BrowserHomeViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var currentWebView : WKWebView!
    var errorView: UIView = UIView();
    var errorLabel: UILabel = UILabel()
    var bookmarks = [Bookmark]()
    var tabs = [Tab]()
    var webView = [WKWebView]()
    var selectedTab: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBookMarks()
        loadTabs()
        
        searchBar.delegate = self
        
        configureError()
        loadWebView()
    }
    
    func configure() -> WKWebView {
        let webConfig = WKWebViewConfiguration()
        let frame = CGRect(x: 0.0, y: 0.0, width: homeView.frame.width, height: homeView.frame.height)
        let webView = WKWebView(frame: frame, configuration: webConfig)
        webView.navigationDelegate = self
        return webView
    }
    
    func configureError(){
        var frame = CGRect(x: 0.0, y: 0.0, width: homeView.frame.width, height: homeView.frame.height)
        errorView = UIView(frame: frame)
        errorView.backgroundColor = UIColor.white
        
        frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        errorLabel = UILabel(frame: frame)
        errorLabel.backgroundColor = UIColor.white
        errorLabel.textColor = UIColor.gray
        errorLabel.text = ""
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont(name: "Error in Loading", size: 25)
        errorLabel.numberOfLines = 0
    }
    
    func loadBookMarks(){
        let realm = try! Realm()
        let results = realm.objects(Bookmark.self)
        bookmarks.removeAll()
        
        for result in results{
            bookmarks.append(result)
        }
    }
    
    func loadTabs(){
        let realm = try! Realm()
        let results = realm.objects(Tab.self)
        
        for result in results{
            webView.append(configure())
            tabs.append(result)
        }
        
        selectedTab = 0
    }
    
    func loadWebView(){
        currentWebView?.removeFromSuperview()
        currentWebView = webView[selectedTab]
        homeView.addSubview(currentWebView)
        
        if(currentWebView.url == nil && !tabs[selectedTab].url.isEmpty){
            //add
            loadWebSite(input: tabs[selectedTab].url, isURLDomain: true, isURLProcessed: true)
        }else{
            searchBar.text = currentWebView.url?.absoluteString
        }
        
        updateNavigationToolbarButton()
    }
    
    func loadWebSite(input: String, isURLDomain: Bool, isURLProcessed: Bool){
        var encodedURL : String = input
        if(!isURLProcessed){
            if(isURLDomain){
                if(encodedURL.starts(with: "http://")){
                    encodedURL = String(encodedURL.dropFirst(7))
                }else if(encodedURL.starts(with: "https://")){
                    encodedURL = String(encodedURL.dropFirst(8))
                }
                encodedURL = "https://"+encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            }else{
                encodedURL = "https://www.google.com/search?q=" + encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            }
        }
        
        
        let url: URL = URL(string: encodedURL)!
        let request : URLRequest = URLRequest(url: url)
        currentWebView.load(request)
        hideWebViewError()
        searchBar.text = encodedURL.lowercased()
        let tab: Tab = tabs[selectedTab]
        let realm = try! Realm()
        try! realm.write{
            tab.initialUrl = encodedURL.lowercased()
        }
    }
    
    
    func displayWebViewError(info:  String){
        errorLabel.text = info
        homeView.addSubview(errorView)
        homeView.addSubview(errorLabel)
    }
    
    func hideWebViewError(){
        errorView.removeFromSuperview()
        errorLabel.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation){
        print("Committed")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation){
        print("Finished")
        updateNavigationToolbarButton()
        let tab = tabs[selectedTab]
        let realm = try! Realm()
        try! realm.write{
            tab.title = currentWebView.title!
            tab.url = currentWebView.url!.absoluteString
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation){
        print("Started Provisional Navigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        displayWebViewError(info: error.localizedDescription)
        updateNavigationToolbarButton()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    @IBAction func searchBarBookmarkButtonClicked(_ sender: UIButton) {
        if let url =  currentWebView.url?.absoluteString{
           let realm  = try! Realm()
           let newBookmark: Bookmark = Bookmark(value: ["url":url, "title":currentWebView.title])
           try! realm.write{
               realm.add(newBookmark, update: .all)
           }
           loadBookMarks()
        }
        NotificationBanner.show("Bookmarked successfully")
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let input : String = (searchBar.text?.trimmingCharacters(in: .whitespaces))!
        if(!input.isEmpty){
            if(input.hasSuffix(".com") || input.hasSuffix(".com/") || input.hasSuffix(".tv") || input.hasSuffix(".tv/")){
                loadWebSite(input: input, isURLDomain: true, isURLProcessed: false)
            }else{
                loadWebSite(input: input, isURLDomain: false, isURLProcessed: false)
            }
        }
    }
    
//    refresh action
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        currentWebView.reload()
    }
    
    
    //Go back action
    @IBAction func previous(_ sender: UIBarButtonItem) {
        if(errorView.isDescendant(of: homeView)){
            hideWebViewError()
        }else{
            currentWebView.goBack()
        }
        searchBar.text = currentWebView.url?.absoluteString
    }
    
    
    //Go next action
    @IBAction func next(_ sender: UIBarButtonItem) {
        currentWebView.goForward()
        hideWebViewError()
        searchBar.text = currentWebView.url?.absoluteString
        
    }
    
    func updateNavigationToolbarButton(){
        if(currentWebView.canGoForward){
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
        }
        
        if(currentWebView.canGoBack){
            previousButton.isEnabled = true
        }else{
            previousButton.isEnabled = false
        }
    }
    
    func addTab(_ tab: Tab){
        tabs.append(tab)
        selectedTab = tabs.count - 1
        webView.append(configure())
        loadWebView()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Tabs"){
            let tabsViewController = segue.destination as! TabsTableViewController
            tabsViewController.tabs = self.tabs
            tabsViewController.delegate = self
            tabsViewController.selectedTab = selectedTab
        }else{
            let bookmarksViewController = segue.destination as! BookmarksTableViewController
            
            bookmarksViewController.bookmarks = self.bookmarks
            bookmarksViewController.delegate = self
        }
    }
    
    func deleteTab(_ tab: Tab, _ tabIndex: Int) {
        let realm = try! Realm()
        try! realm.write{
            realm.delete(tab)
        }
        tabs.remove(at: tabIndex)
        webView.remove(at: tabIndex)
        
        if(selectedTab ==  tabIndex){
            selectedTab = tabIndex - 1
            loadWebView()
            navigationController?.popViewController(animated: true)
        }else if(selectedTab > tabIndex){
            selectedTab = selectedTab - 1
        }
    }
}

