//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 16/10/2024.
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
            statusLabel.text = character.status ?? "Unknown"
            speciesLabel.text = character.species ?? "Unknown"
            genderLabel.text = character.gender
            locationLabel.text = character.location?.name ?? "Unknown"
            print("---in CharacterDetails----", character)
        }
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            // Fetch the image data from the URL
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Set the image to the UIImageView on the main thread
                    self?.image = image
                }
            }
        }
    }
}
