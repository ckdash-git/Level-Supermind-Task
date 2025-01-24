//
//  NewMusicVC.swift
//  levelsSuperMind
//
//  Created by Chandan Kumar Dash on 23/01/25.
//

import UIKit

class MusicViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let categoryStackView = UIStackView()
    private let continuePlayingCollectionView: UICollectionView
    private let recommendedCollectionView: UICollectionView
    
    // MARK: - Initialization
    init() {
        // Flow layout for "Continue Playing" section
        let continuePlayingLayout = UICollectionViewFlowLayout()
        continuePlayingLayout.scrollDirection = .horizontal
        continuePlayingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: continuePlayingLayout)
        
        // Flow layout for "Recommended for You" section
        let recommendedLayout = UICollectionViewFlowLayout()
        recommendedLayout.scrollDirection = .horizontal
        recommendedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recommendedLayout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchBar()
        setupCategoryTabs()
        setupContinuePlayingSection()
        setupRecommendedSection()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("← Music", for: .normal)
        backButton.tintColor = .white
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let heartButton = UIButton(type: .system)
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .white
        
        let downloadButton = UIButton(type: .system)
        downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        downloadButton.tintColor = .white
        
        let navStack = UIStackView(arrangedSubviews: [backButton, UIView(), heartButton, downloadButton])
        navStack.axis = .horizontal
        navStack.distribution = .equalSpacing
        navStack.spacing = 16
        
        navStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navStack)
        
        NSLayoutConstraint.activate([
            navStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            navStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search for music"
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCategoryTabs() {
        let categories = ["Free", "For Study", "For Work", "For Focus"]
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .darkGray
            button.layer.cornerRadius = 16
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            categoryStackView.addArrangedSubview(button)
        }
        
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 10
        categoryStackView.distribution = .fillEqually
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryStackView)
        
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupContinuePlayingSection() {
        let label = UILabel()
        label.text = "Continue Playing"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        continuePlayingCollectionView.backgroundColor = .black
        continuePlayingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continuePlayingCollectionView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            continuePlayingCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            continuePlayingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continuePlayingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            continuePlayingCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupRecommendedSection() {
        let label = UILabel()
        label.text = "Recommended for you"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        recommendedCollectionView.backgroundColor = .black
        recommendedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recommendedCollectionView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: continuePlayingCollectionView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            recommendedCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            recommendedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        // Handle back button action
    }
}
#Preview{
    MusicViewController()
}


