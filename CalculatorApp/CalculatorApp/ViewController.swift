//
//  ViewController.swift
//  CalculatorApp
//
//  Created by user on 2021/03/16.
//

import UIKit

class ViewController: UIViewController {
    
    enum CalculateStatus {
        case none, plus, minus, multiplication, division
    }
    
    var firstNumber = ""
    var secondNumber = ""
    var calculaterStatus: CalculateStatus = .none
    
    let numbers = [
        ["C","%","$","/"],
        ["7","8","9","*"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="],
    ]
    
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorHeightConstract: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: "cellId")
        calculatorHeightConstract.constant = view.frame.width * 1.4
        calculatorCollectionView.backgroundColor = .clear
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        
        numberLabel.text = "0"
        
        view.backgroundColor = .black
    }
    
    func clear() {
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculaterStatus = .none
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5 ) / 4
        let height = width
        
        if indexPath.section == 4 && indexPath.row == 0 {
            width = width * 2 + 14 + 16
        }
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        
        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            if "0"..."9" ~= numberString || numberString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "%" || numberString == "$" {
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculaterStatus {
        case .none:
            switch number {
            case "0"..."9":
                firstNumber += number
                numberLabel.text = firstNumber
                
                if firstNumber.hasPrefix("0") {
                    firstNumber = ""
                }
                
            case ".":
                if !confirmincludeDecimalPoint(numberString: firstNumber) {
                    firstNumber += number
                    numberLabel.text = firstNumber
                }
            case "+":
                calculaterStatus = .plus
            case "-":
                calculaterStatus = .minus
            case "*":
                calculaterStatus = .multiplication
            case "/":
                calculaterStatus = .division
            case "C":
                clear()
            default:
                break
            }
        case .plus, .minus, .multiplication, .division:
            switch number {
            case "0"..."9":
                secondNumber += number
                numberLabel.text = secondNumber
                
                if secondNumber.hasPrefix("0") {
                    secondNumber = ""
                }
                
            case ".":
                if !confirmincludeDecimalPoint(numberString: secondNumber) {
                    secondNumber += number
                    numberLabel.text = secondNumber
                }
                
            case "=":
                
                let firstNum = Double(firstNumber) ?? 0
                let secondNum = Double(secondNumber) ?? 0
                
                var resultString: String?
                
                switch calculaterStatus {
                case .plus:
                    resultString = String(firstNum + secondNum)
                case .minus:
                    resultString = String(firstNum - secondNum)
                case .multiplication:
                    resultString = String(firstNum * secondNum)
                case .division:
                    resultString = String(firstNum / secondNum)
                default:
                    break
                }
                
                if let result = resultString, result.hasSuffix(".0") {
                    resultString = result.replacingOccurrences(of: ".0", with: "")
                }
                
                numberLabel.text = resultString
                firstNumber = ""
                secondNumber = ""
                
                firstNumber += resultString ?? ""
                calculaterStatus = .none
                
            case "C":
                clear()
            default:
                break
            }
        }
    }
    private func confirmincludeDecimalPoint(numberString: String) -> Bool {
        if numberString.range(of: ".") != nil || numberString.count == 0 {
            return true
        } else {
            return false
        }
    }
}

class CalculatorViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.numberLabel.alpha = 0.3
            } else {
                self.numberLabel.alpha = 1
            }
        }
    }
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 32)
        label.clipsToBounds = true
        label.backgroundColor = .orange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberLabel)
        
        numberLabel.frame.size = self.frame.size
        numberLabel.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

