//
//  HollowMenuViewController.swift
//  HollowMenu
//
//  Created by takeo on 8/6/15.
//  Copyright (c) 2015 Pwater.org. All rights reserved.
//

import UIKit

open class HollowMenuViewController: UIViewController {
    
    // Menu
    private var menuVC: UIViewController?
    private var menuNC: UINavigationController?
    
    // Content
    private var contentVC: UIViewController?
    private var contentNC: UINavigationController?
    
    // iPad or iPhone
    private var padViewController: UISplitViewController?
    private var phoneViewcontroller: UIViewController?
    
    // Menu as table view
    private let tableViewCellReuseIdentifier = "4a2662aa-fae2-443d-bada-6cf45a5bf5d8"
    private var tableViewStyle: UITableView.Style?
    private var tableView: UITableView?
    
    // Initializer
    public init(tableViewStyle: UITableView.Style) {
        super.init(nibName: nil, bundle: nil)
        self.tableViewStyle = tableViewStyle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tableViewStyle = .grouped
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Menu
        self.menuVC = createMenuViewController()
        self.menuNC = UINavigationController(rootViewController: menuVC!)
        
        // Content
        self.contentVC = createContentViewController()
        self.contentNC = UINavigationController(rootViewController: contentVC!)
        
        // iPad or iPhone
        if isPad() {
            setupPad()
        } else if isPhone() {
            setupPhone()
        }
    }
    
    private func isPad() -> Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    private func isPhone() -> Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    
    public var sections: [Section]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    public var menuViewController: UIViewController? {
        get { return menuVC }
    }
    
    public var contentViewController: UIViewController? {
        get { return contentVC }
    }
    
    override public var title: String? {
        didSet {
            if isPad() { menuVC?.title = title }
        }
    }
    
    open var tableViewCellClass: AnyClass {
        get { return UITableViewCell.self }
    }
    
    // Menu title
    public var menuTitle: String = "Menu" {
        didSet {
            if isPad() {
                setMenuTitlePad(menuTitle)
            } else if isPhone() {
                setMenuTitlePhone(menuTitle)
            }
        }
    }
    
    public func selectMenu(indexPath: IndexPath) {
        if let menu = sections?[indexPath.section].menus?[indexPath.row] {
            menu.process?()
            contentVC?.title = menu.title
        }
    }
}

// MARK: -
// MARK: iPad
extension HollowMenuViewController {
    private func setupPad() {
        let vc = UISplitViewController()
        if let menuNC = menuNC, let contentNC = contentNC {
            vc.viewControllers = [menuNC, contentNC]
        }
        vc.delegate = self
        
        addChild(vc)
        view.addSubview(vc.view)
        self.padViewController = vc
    }
}

// MARK: UISplitViewControllerDelegate
extension HollowMenuViewController: UISplitViewControllerDelegate {
    public func splitViewController(_ svc: UISplitViewController, shouldHide vc: UIViewController, in orientation: UIInterfaceOrientation) -> Bool {
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return false
        case .portrait, .portraitUpsideDown:
            return true
        case .unknown:
            return true
        }
    }
    
    public func splitViewController(_ svc: UISplitViewController, willHide aViewController: UIViewController, with barButtonItem: UIBarButtonItem, for pc: UIPopoverController) {
        barButtonItem.title = menuTitle
        contentVC?.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    public func splitViewController(svc: UISplitViewController, willShowViewController aViewController: UIViewController, invalidatingBarButtonItem barButtonItem: UIBarButtonItem) {
        contentVC?.navigationItem.leftBarButtonItem = nil
    }
    
    private func setMenuTitlePad(_ title: String) {
        contentVC?.navigationItem.leftBarButtonItem?.title = title
    }
}

// MARK: -
// MARK: iPhone
extension HollowMenuViewController {
    private func setupPhone() {
        // Menu
        menuVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideMenuPhone))
        menuVC?.navigationItem.title = menuTitle
        
        // Content
        contentVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: menuTitle, style: .plain, target: self, action: #selector(showMenuPhone))
        if let nc = contentNC {
            addChild(nc)
            view.addSubview(nc.view)
        }
    }
    
    @objc func showMenuPhone() {
        if let vc = menuNC {
            contentVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func hideMenuPhone() {
        if let vc = menuNC {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setMenuTitlePhone(_ title: String) {
        menuVC?.navigationItem.title = title
        contentVC?.navigationItem.leftBarButtonItem?.title = title
    }
}

// MARK: -
// MARK: Menu
extension HollowMenuViewController {
    private func createMenuViewController() -> UIViewController {
        let vc = UIViewController()
        if let style = self.tableViewStyle {
            let view = UITableView(frame: self.view.bounds, style: style)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.dataSource = self
            view.delegate = self
            view.register(tableViewCellClass, forCellReuseIdentifier: tableViewCellReuseIdentifier)
            vc.view.addSubview(view)
        }
        if isPad() { vc.title = self.title }
        return vc
    }
}

// MARK: UITableViewDataSource
extension HollowMenuViewController: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[section].menus?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseIdentifier, for: indexPath)
        if let menu = sections?[indexPath.section].menus?[indexPath.row] {
            cell.textLabel?.text = menu.title
            cell.imageView?.image = menu.image
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension HollowMenuViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMenu(indexPath: indexPath)
        if isPhone() { hideMenuPhone() }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: -
// MARK: Content
extension HollowMenuViewController {
    private func createContentViewController() -> UIViewController {
        return UIViewController()
    }
}

// MARK: -
// MARK: Section
extension HollowMenuViewController {
    public struct Section {
        fileprivate let title: String?
        fileprivate(set) var menus: [Menu]?
        
        public init(_ title: String?, _ menus: [Menu]?) {
            self.title = title
            self.menus = menus
        }
    }
}

// MARK: -
// MARK: Menu
extension HollowMenuViewController {
    public struct Menu {
        public typealias Process = () -> Void
        
        fileprivate let title: String?
        fileprivate let process: Process?
        fileprivate(set) var image: UIImage?
        
        public init(_ title: String?, _ process: Process?) {
            self.title = title
            self.process = process
        }
        
        public init(_ title: String?, _ process: Process?, _ image: UIImage?) {
            self.title = title
            self.process = process
            self.image = image
        }
    }
}
