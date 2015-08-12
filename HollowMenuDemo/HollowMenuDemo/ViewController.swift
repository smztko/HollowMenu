//
//  ViewController.swift
//  HollowMenuDemo
//
//  Created by takeo on 8/13/15.
//  Copyright (c) 2015 Pwater.org. All rights reserved.
//

import UIKit
import HollowMenu

class ViewController: UIViewController {
    
    var vc: MyHollowMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hollo menu view controller
        vc = MyHollowMenuViewController(tableViewStyle: .Grouped)
        vc!.title = "Hollow Demo"
        addChildViewController(vc!)
        view.addSubview(vc!.view)
        
        // Create menus
        typealias Hollow = HollowMenuViewController
        let menuR = Hollow.Menu("Red",   { [weak vc] in vc?.contentViewController?.view.backgroundColor = UIColor.redColor() })
        let menuG = Hollow.Menu("Green", { [weak vc] in vc?.contentViewController?.view.backgroundColor = UIColor.greenColor() })
        let menuB = Hollow.Menu("Blue",  { [weak vc] in vc?.contentViewController?.view.backgroundColor = UIColor.blueColor() })
        
        let section = Hollow.Section("RGB Colors", [menuR, menuG, menuB])
        
        vc!.sections = [section]
        
        // Do first process
        vc!.selectMenu(NSIndexPath(forRow: 0, inSection: 0))
    }
}

// Inherit HollowMenuViewController to customize
class MyHollowMenuViewController: HollowMenuViewController {
    
    override init(tableViewStyle: UITableViewStyle) {
        super.init(tableViewStyle: tableViewStyle)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if let cell = cell as? MyTableViewCell {
            cell.detailTextLabel?.text = "detail"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    class MyTableViewCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        }
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    override var tableViewCellClass: AnyClass {
        get { return MyTableViewCell.self }
    }
}
