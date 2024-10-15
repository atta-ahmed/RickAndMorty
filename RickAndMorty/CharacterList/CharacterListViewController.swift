//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 15/10/2024.
//

import UIKit

class CharacterListViewController: UIViewController {

    @IBOutlet weak var charactersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello from charactersTable")
        charactersTable.delegate = self
        charactersTable.dataSource = self
    }

}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
