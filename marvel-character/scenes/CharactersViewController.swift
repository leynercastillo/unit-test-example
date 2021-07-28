//
//  ViewController.swift
//  marvel-character
//
//  Created by Leyner Castillo on 27/07/21.
//

import UIKit

protocol CharactersViewControllerDelegate: AnyObject {
    func displayError(message: String)
    func displayCharactersList()
}

class CharactersViewController: UIViewController {

    // MARK: - UI
    lazy private var charactersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CharacterCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .darkGray
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()


    // MARK: - Properties
    lazy var viewModel: CharactersPresenterDelegate = {
        let viewModel = CharactersPresenter()
        viewModel.viewController = self
        return viewModel
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupUI()
        activityIndicator.startAnimating()
        viewModel.fetchCharacters { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }

    private func setupUI() {
        setupLocalizedText()
        setupCollectionView()
    }

    private func setupCollectionView() {
        view.addSubview(charactersCollectionView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            charactersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            charactersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            charactersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            charactersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),

            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }

    private func setupLocalizedText() {
        navigationItem.title = "Marvel Characters"
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }

        let character = viewModel.characters[indexPath.item]
        cell.character = character
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - CharactersViewControllerDelegate
extension CharactersViewController: CharactersViewControllerDelegate {
    func displayCharactersList() {
        charactersCollectionView.reloadData()
    }

    func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
