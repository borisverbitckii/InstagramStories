//
//  PreferencesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol PreferencesViewProtocol: AnyObject {
    func showMenuItem(settings: [Setting])
    func showAlertController(title: String, message: String)
}

final class PreferencesViewController: CommonViewController {
    
    //MARK: - Private properties
    private let presenter: PreferencesPresenterProtocol
    private var settings: [Setting] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Init
    init(type: TabViewControllerType, presenter: PreferencesPresenterProtocol) {
        self.presenter = presenter
        self.settings = [Setting]()
        super.init(type: type)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .black
        
        //TODO: Change back bar button font
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension PreferencesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstantsForCommonViewController.reuseIdentifier, for: indexPath) as? SettingsCell else { return UITableViewCell() }
        let setting = settings[indexPath.row]
        cell.configure(setting: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - FavoritesViewProtocol
extension PreferencesViewController: PreferencesViewProtocol {
    func showMenuItem(settings: [Setting]) {
        self.settings = settings
    }
}
