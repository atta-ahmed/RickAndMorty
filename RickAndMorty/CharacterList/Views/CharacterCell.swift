//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 15/10/2024.
//

import SwiftUI
import UIKit

class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CharacterCell"

    private var hostingController: UIHostingController<CharacterCardView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHostingController()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHostingController()
    }

    private func setupHostingController() {
        // Create the hosting controller
        let characterCardView = CharacterCardView(character: Character())
        hostingController = UIHostingController(rootView: characterCardView)

        if let hostingController = hostingController {
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostingController.view)

            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }

    func configure(with character: Character) {
        hostingController?.rootView = CharacterCardView(character: character)
    }
}
