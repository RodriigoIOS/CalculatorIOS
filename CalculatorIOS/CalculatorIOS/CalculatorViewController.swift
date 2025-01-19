//
//  ViewController.swift
//  CalculatorIOS
//
//  Created by Rodrigo on 06/01/25.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 40, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .black
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.layer.borderWidth = 0.5
        label.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    private let buttonTitles: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    private var currentDisplayValue: String = "0"
    private var previousValue: Double = 0
    private var currentOperator: String?
    private var isPerformingOperation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Layout setup
    private func setupLayout(){
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(displayLabel)
        
        for row in buttonTitles {
            mainStack.addArrangedSubview(createButtonRow(with: row))
        }
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    // MARK: - Helper Methods
    private func createButtonRow(with titles: [String]) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        rowStack.distribution = .fillEqually
        
        for title in titles {
            rowStack.addArrangedSubview(createButton(with: title))
        }
        
        return rowStack
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = title.isNumber ? .darkGray : .orange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Adicionando um target para o botao da calculadora
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton){
        guard let title = sender.currentTitle else { return }
        
        //Handle numeric input
        
        if title.isNumber || title == "." {
            handleNumericInput(title)
        } else if ["+", "-", "X", "÷"].contains(title) {
            handleOperatorInput(title)
        } else if title == "=" {
            handleEqualsInput()
        } else if title == "AC" {
            resetDisplay()
        } else if title == "+/-" {
            toggleSign()
        } else if title == "%" {
            calculatePercentage()
        }
    }
    
    
    // MARK: - Logic Methods
    
    func handleNumericInput(_ input: String) {
        
        if isPerformingOperation{
            currentDisplayValue = input == "." ? "0." : input
            isPerformingOperation = false
        } else {
            if input == "." && currentDisplayValue.contains(".") { return }
            currentDisplayValue = currentDisplayValue == "0" ? input : currentDisplayValue + input
        }
        updateDisplay()
    }
    
    
    func handleOperatorInput(_ operatorSymbol: String) {
        if let value = Double(currentDisplayValue) {
            previousValue = value
            currentOperator = operatorSymbol
            isPerformingOperation = true
        }
    }
    
    func handleEqualsInput(){
        guard let operatorSymbol = currentOperator, let value = Double(currentDisplayValue) else { return }
        var result: Double = 0
        
        switch operatorSymbol {
        case "+":
            result = previousValue + value
        case "-":
            result = previousValue - value
        case "X":
            result = previousValue * value
        case "÷":
            result = value == 0 ? 0 : previousValue / value
        default:
            break
        }
        
        currentDisplayValue = formatResult(result)
        previousValue = result
        currentOperator = nil
        updateDisplay()
    }
    
    func toggleSign() {
        if let value = Double(currentDisplayValue) {
            currentDisplayValue = formatResult(value * -1)
            updateDisplay()
        }
    }
    
    func calculatePercentage() {
        if let value = Double(currentDisplayValue) {
            currentDisplayValue = formatResult(value / 100)
            updateDisplay()
        }
    }
    
    func resetDisplay() {
        currentDisplayValue = "0"
        previousValue = 0
        currentOperator = nil
        isPerformingOperation = false
        updateDisplay()
    }
    
    func updateDisplay() {
        displayLabel.text = currentDisplayValue
    }
    
    func formatResult (_ value: Double) -> String {
        return floor(value) == value ? "\(Int(value))" : "\(value)"
    }
}

//MARK: - Extensions

private extension String {
    var isNumber: Bool {
        return Int(self) != nil
    }
}
