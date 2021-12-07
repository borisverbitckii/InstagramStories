//
//  PreferencesViewController.swift
//  InstagramStorys
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

protocol PreferencesViewProtocol: AnyObject {
    
}

final class PreferencesViewController: CommonViewController {
    
    //MARK: - Private properties
    private let presenter: PreferencesPresenterProtocol
    private let settings = [Setting(name: "Общие"), Setting(name: "Настройка ленты постов")]
    
    //MARK: - Init
    init(type: TabViewControllerType, presenter: PreferencesPresenterProtocol) {
        self.presenter = presenter
        super.init(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

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
}

//MARK: - FavoritesViewProtocol
extension PreferencesViewController: PreferencesViewProtocol {
    
}
