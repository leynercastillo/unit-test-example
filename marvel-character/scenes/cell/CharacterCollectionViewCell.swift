//
//  CharacterCollectionViewCell.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import UIKit
import Kingfisher

struct DisplayableCharacter {
    var name: String
    var description: String
    var photoURL: String
    var photoExtension: String
}

class CharacterCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet private(set) weak var characterImageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!

    static let identifier = String(describing: CharacterCollectionViewCell.self)

    // MARK: - Properties
    var character: DisplayableCharacter? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Helpers
    private func updateCell() {
        titleLabel.text = character?.name
        descriptionLabel.text = character?.description

        guard let character = character, var photoURL = URL(string: character.photoURL) else {
            return
        }

        photoURL.appendPathComponent("portrait_xlarge." + character.photoExtension)
        characterImageView.kf.setImage(with: photoURL)
    }
}
