//
//  ViewController.swift
//  100 Days Of Swift-Project 8
//
//  Created by Arda Büyükhatipoğlu on 28.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "CLUES"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.textAlignment = .right
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.text = "ANSWERS"
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 45)
        view.addSubview(currentAnswer)
        
        let submit = UIButton()
        submit.setTitle("SUBMIT", for: .normal)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitleColor(.black, for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton()
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.setTitleColor(.black, for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            cluesLabel.heightAnchor.constraint(equalTo: answersLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80
        
        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton()
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("www", for: .normal)
                letterButton.setTitleColor(.black, for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
    }
    
    @objc func submitTapped(_ sender: UIButton) {
    }
    
    @objc func clearTapped(_ sender: UIButton) {
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContent = try? String(contentsOf: levelFileURL) {
                var lines = levelContent.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ":")
                    let clue = parts[1]
                    let answer = parts[0]
                    
                    //Set the clue string
                    clueString += "\(index). \(clue)\n"
                    
                    //set the solutions string
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    //set letterbits array:
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    
}

