# iOS Web Browser

It is a web browser application that allows users to perform multiple browsing operations along
with several other features.

![](ios_webBrowser_walkthrough.gif)

### Features:
1. Visiting the previous tab
2. Visiting the next tab
3. Refresh the web page
4. Add different tabs
5. View other tabs and can delete tabs
6. Bookmark a webpage
7. Delete a bookmark


### Requirements:
* Xcode - 11.3 or higher
* iOS device - 9 or higher
* macOS - 10.9 or higher

### Library Information:
* CocoaPods:
I have used Realm Library as a local database that can be installed via Cocoapod.
* Realm pod is already mentioned in the podfile:
pod 'RealmSwift'

Other imports:
* import UIKit
* import RealmSwift
* import Foundation


#### Few Application Features:
1. The default tab is ``` www.apple.com ```
2. User can search for any web site in the search box
3. User can click on the tab and see the green highlighted as the current tab and can also add other tabs by clicking "+"
4. User can click on the tab and the application will navigate to that particular website
5. User can delete a tab by swiping left
6. User can also add a website as a bookmark after clicking the bookmark icon present on the search bar
7. Can view and add multiple web sites as a bookmark
8. Bookmarks can also be deleted by swiping left
9. Users can refresh, go to the previous page and next page by the bar buttons.
