//
//  ViewController.swift
//  Werdd
//
//  Created by Han Kim on 2/7/22.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    let appTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Werdd."
        label.font = UIFont(name: "Rubik-SemiBold", size: 32)
        return label
    }()

    lazy var randomWordView: RoundedViewWithColor = {
        let view = RoundedViewWithColor(color: UIColor(named: "WerddBlue")) { [weak self] in
            self?.refreshRandomWordLabels()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/2.2, height: view.frame.size.width/3.5)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var searchView: SearchView = {
        let searchView = SearchView(searchDefinitionsDelegate: self)
//      let searchView = SearchView(homeViewController: self)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.layer.cornerRadius = 20

        // Top right corner, Top left corner
        searchView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return searchView
    }()
    
    var words: [WordDetail]?
    var selectedWord: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Taupe")
        
        addSubviews()
        refreshRandomWordLabels()
    }
    
    // MARK: - UI Setup
    
    private func addSubviews() {
        view.addSubview(appTitleLabel)
        view.addSubview(randomWordView)
        view.addSubview(searchView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            
            randomWordView.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 30),
            randomWordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            randomWordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            randomWordView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),
            
            searchView.topAnchor.constraint(equalTo: randomWordView.bottomAnchor, constant: 35),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    private func refreshRandomWordLabels() {
        addSpinner()
        
        // Some networking code goes here...
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate Methods

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as? WordCollectionViewCell else {
            print("Expected WordTableViewCell but found nil")
            return UICollectionViewCell()
        }
                    
        cell.updateViews(words?[indexPath.row], word: selectedWord)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedWord = selectedWord,
              let selectedWordDetails = words?[indexPath.row] else {
            assertionFailure("Selected word unexpectedly found nil")
            return
        }
        
        navigationController?.pushViewController(DefinitionDetailsViewController(wordDetail: selectedWordDetails, selectedWord: selectedWord), animated: true)
    }
}

// MARK: - SearchDefinitionDelegate Methods

extension HomeViewController: SearchDefinitionsDelegate {
//extension HomeViewController {
    func searchDefinitions(forWord word: String?) {
        // Networking code goes here, also validation for missing word
    }
}