//
//  CommonViewController.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit

enum TabViewControllerType {
    case search
    case favorites
    case preferences
}

///  Only for inheritance
class CommonViewController: UIViewController {
    
    //MARK: - Public properties
    var type: TabViewControllerType
    let tableView : UITableView = {
        $0.contentInset = ConstantsForCommonViewController.tableViewContentInsets
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        return $0
    }(UITableView())
    
    //MARK: - Init
    init(type: TabViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupGestureViewControllerTransition()
        registerTableViewCell()
        addSubviews()
        layout()
        view.backgroundColor = .white
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.navBarSettingsButton.getImage(), style: .done, target: nil, action: nil)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.font: Fonts.navBarLargeTitle.getFont()]
        navBarAppearance.titleTextAttributes = [.font: Fonts.navBarLittleTitle.getFont()]
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        switch type{
        case .search:
            navigationItem.title = Text.navTitle(.search).getText()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(presentPreferences))
        case .favorites:
            navigationItem.title = Text.navTitle(.favorites).getText()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(presentPreferences))
        case .preferences:
            navigationItem.title = Text.navTitle(.preferences).getText()
        }
    
        if let layer = navigationController?.navigationBar.layer {
            Utils.addShadow(for: .navBar, layer: layer)
        }
    }
    
    private func setupGestureViewControllerTransition() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.pin
            .top()
            .bottom()
            .left()
            .right()
    }
    
    private func registerTableViewCell() {
        switch type{
            
        case .search, .favorites:
            tableView.register(InstagramUserCell.self,
                               forCellReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        case .preferences:
            tableView.register(SettingsCell.self,
                               forCellReuseIdentifier: ConstantsForCommonViewController.reuseIdentifier)
        }
    }
    
    //MARK: - OBJC methods
    @objc func presentPreferences() {
        let preferencesViewController = PreferencesBuilder().build()
        navigationController?.pushViewController(preferencesViewController, animated: true)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController!.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController!.selectedIndex -= 1
        }
    }
}

enum ConstantsForCommonViewController {
    static let tableViewContentInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    static let reuseIdentifier  = "reuseIdentifier"
    static let cellHeight: CGFloat = 70
}
