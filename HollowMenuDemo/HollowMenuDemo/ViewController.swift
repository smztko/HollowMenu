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
        vc = MyHollowMenuViewController(tableViewStyle: .grouped)
        vc!.title = "Hollow Demo"
        addChild(vc!)
        view.addSubview(vc!.view)
        
        // Create menus
        typealias Hollow = HollowMenuViewController
        let menuR = Hollow.Menu("Red",   { [weak vc] in vc?.contentViewController?.view.backgroundColor = UIColor.red })
        let menuG = Hollow.Menu("Green", { [weak vc] in vc?.contentViewController?.view.backgroundColor = UIColor.green })
        let menuB = Hollow.Menu("Blue",  { [weak vc] in vc?.contentViewController?.view.backgroundColor = UIColor.blue })
        
        let section = Hollow.Section("RGB Colors", [menuR, menuG, menuB])
        
        vc!.sections = [section]
        
        // Do first process
        vc!.selectMenu(indexPath: IndexPath(row: 0, section: 0))
    }
}

// Inherit HollowMenuViewController to customize
class MyHollowMenuViewController: HollowMenuViewController {
    
    override init(tableViewStyle: UITableView.Style) {
        super.init(tableViewStyle: tableViewStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? MyTableViewCell {
            cell.detailTextLabel?.text = "detail"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    class MyTableViewCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    override var tableViewCellClass: AnyClass {
        get { return MyTableViewCell.self }
    }
}
