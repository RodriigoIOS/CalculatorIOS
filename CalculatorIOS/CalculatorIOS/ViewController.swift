//
//  ViewController.swift
//  CalculatorIOS
//
//  Created by Rodrigo on 06/01/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let buttonTitles: [[String]] = [
        ["AC", "+/-", "%", "+"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout(){
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(displayLabel)
        
        for row in buttonTitles {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually
            
            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .systemGray
                button.layer.cornerRadius = 10
                rowStack.addArrangedSubview(button)
            }
            mainStack.addArrangedSubview(rowStack)
        }
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
}
