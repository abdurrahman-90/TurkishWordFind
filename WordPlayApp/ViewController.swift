//
//  ViewController.swift
//  WordPlayApp
//
//  Created by Akdag on 22.02.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var allWords = [String]()
    var useWords = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWord()
        startGame()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
    }
    
    @objc func addAnswer(){
        let ac = UIAlertController(title: "Your Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "SUMMİT", style: .default, handler: { [weak self , weak ac] action  in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }))
        present(ac, animated: true)
      
    }
    func loadWord(){
        if let wordUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: wordUrl){
                allWords = startWord.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty{
            allWords = ["Word Play"]
        }
        
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        useWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    func submit(_ answer : String){
        let lowerAnswer = answer.lowercased()
        if isReal(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isOriginal(word: lowerAnswer){
                    useWords.insert(lowerAnswer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }else{
                    ShowError(title: "Word already used", message: "Be more original")
                }
            }else{
                ShowError(title: "Word not possible", message: "\(title!.lowercased())")
            }
        }else{
            ShowError(title: "Word not Recognized", message: "You need to input real word")
        }
    }
    func ShowError(title : String , message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    func isPossible(word : String)-> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
           
        }
        return true
    }
    func isOriginal(word : String)->Bool{
        return !useWords.contains(word) && word != title?.lowercased()
    }
    
    func isReal(word :String)-> Bool{
        if word.count >= 3{
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: true, language: "tr")
            return misspelledRange.location == NSNotFound
        }else{
            return false
        }
    }
 
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = useWords[indexPath.row]
        
        return cell
    }
    
    
}

