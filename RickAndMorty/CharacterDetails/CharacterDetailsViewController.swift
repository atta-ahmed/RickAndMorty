//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 16/10/2024.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    var character: Character? // This will hold the character details

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var speciesLabel: UILabel!
    // Other outlets for your UI components

    @IBOutlet weak var genderLabel: UILabel!
    // Use init to load the view from XIB
    @IBOutlet weak var locationLabel: UILabel!
    init() {
        super.init(nibName: "CharacterDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 24
    }
    
    private func configureUI() {
        if let character = character {
            if let url = URL(string: character.image ?? "") {
                imageView.loadImage(from: url)
                imageView.contentMode = .scaleAspectFill
            }
            nameLabel.text = character.name ?? "Unknown"
            statusLabel.text = character.status?.rawValue ?? "Unknown"
            speciesLabel.text = (character.species ?? "Unknown") + " • "
            genderLabel.text = character.gender
            locationLabel.text = character.location?.name ?? "Unknown"
            print("---in CharacterDetails----", character)
        }
    }
}
