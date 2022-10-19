//
//  ViewController.swift
//  Werdd
//
//  Created by Adriana Belinski on 10/9/22.
//

import UIKit


class HomeViewController: UIViewController {
  // UIViewController class part of uikit framework. Anything that beguns with ui is part of uikit
  
  // MARK: - Properties
  
  func setUpNavigationTitle() {
    title = "Werdd"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(named: "Navy")
    view.layer.cornerRadius = 20
    return view
  }()
  
  let wordTitleLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont(name: "Rubik-Bold", size: 24)
      return label
  }()
  
  let partsOfSpeechLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont(name: "Rubik-Italic", size: 14)
      return label
  }()
  
  let wordDefinitionLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont(name: "Rubik-Light", size: 18)
      label.lineBreakMode = .byWordWrapping
      label.numberOfLines = 0
      return label
  }()
  
  let randomButton: UIButton = {
      let largeConfig = UIImage.SymbolConfiguration(
      pointSize: 140,
      weight: .regular,
      scale: .large
    )
    
      let image = UIImage(
      systemName: "arrow.clockwise.circle",
      withConfiguration: largeConfig
    )?.withTintColor(.white, renderingMode: .alwaysTemplate)
    
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(image, for: .normal)
      button.tintColor = .white
      return button
  }()
  
  let dictionaryTableView: UITableView = {
    let dictionaryTableView = UITableView()
    dictionaryTableView.translatesAutoresizingMaskIntoConstraints = false
    return dictionaryTableView
  }()
  
  
  let padding: CGFloat = 20

  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dictionaryTableView.dataSource = self //self describes ViewController which our UITAbleViewSource delegrates work out to.
    
    dictionaryTableView.delegate = self
    
   // view.addSubview(allDictionaryWords)
    
    view.backgroundColor = UIColor(named: "Taupe")

    setUpNavigationTitle()
    setUpUI()
    
    if let word = Dictionary.allWords.first {
    updateViews(withWord: word)
    }
  }
  
  // MARK: - UI Setup

  func setUpUI() { //view is an aspect of UIView controller
    setUpContainerView()
    setUpWordTitle()
    setUpPartsOfSpeech()
    setUpDefinition()
    setUpRandomButton()
    setUpDictionaryTableView()
  }

  func setUpContainerView() {
      view.addSubview(containerView)
      
      NSLayoutConstraint.activate([
          containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
          containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
          containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
          containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
      ])
  }
  
  func setUpWordTitle() {
      containerView.addSubview(wordTitleLabel)
      
      NSLayoutConstraint.activate([
          wordTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
          wordTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
      ])
  }
  
  func setUpPartsOfSpeech() {
      containerView.addSubview(partsOfSpeechLabel)
      
      NSLayoutConstraint.activate([
          partsOfSpeechLabel.bottomAnchor.constraint(equalTo: wordTitleLabel.bottomAnchor, constant: -4),
          partsOfSpeechLabel.leadingAnchor.constraint(equalTo: wordTitleLabel.trailingAnchor, constant: 5),
          partsOfSpeechLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor)
      ])
  }
  
  func setUpDefinition() {
      containerView.addSubview(wordDefinitionLabel)
      
      NSLayoutConstraint.activate([
          wordDefinitionLabel.topAnchor.constraint(equalTo: partsOfSpeechLabel.bottomAnchor, constant: 20),
          wordDefinitionLabel.leadingAnchor.constraint(equalTo: wordTitleLabel.leadingAnchor),
          wordDefinitionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
      ])
  }
  
    func setUpRandomButton() {
      containerView.addSubview(randomButton)
    
      randomButton.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
      
      NSLayoutConstraint.activate([
        randomButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
        randomButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        randomButton.heightAnchor.constraint(equalToConstant: 50),
        randomButton.widthAnchor.constraint(equalToConstant: 50),
        ])
  }
  
  func setUpDictionaryTableView() {
    containerView.addSubview(dictionaryTableView)

    NSLayoutConstraint.activate([
      dictionaryTableView.topAnchor.constraint(equalTo: view.topAnchor),
      dictionaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dictionaryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      dictionaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  @objc func randomButtonPressed() {
    
    if let randomWord = randomizedWord() {
      updateViews(withWord: randomWord)
    }
    
  }
  
  func randomizedWord() -> Entry? {
    return Dictionary.allWords.randomElement()
  }
  
  func updateViews(withWord word: Entry) {
      wordTitleLabel.text = word.wordTitle
      partsOfSpeechLabel.text = word.partsOfSpeech
      wordDefinitionLabel.text = word.wordDefinition
  }
}




extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   // return 10
    return Dictionary.allWords.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell() //creating cell objects because that's what ViewController wants returned above.
    var content = cell.defaultContentConfiguration()
    
    content.text = Dictionary.allWords[indexPath.row].wordTitle
    content.secondaryText = Dictionary.allWords[indexPath.row].wordDefinition

    cell.contentConfiguration = content
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("\(Dictionary.allWords[indexPath.row].wordTitle)")
  }
}
