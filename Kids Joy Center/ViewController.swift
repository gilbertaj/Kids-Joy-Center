//
//  ViewController.swift
//  Kids Joy Center
//
//  Created by Andrew Gilbert on 3/27/17.
//  Copyright © 2017 Andrew Gilbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    var highScoreGame = [String]()
    var highScoreDifficulty = [String]()
    var highScoreScore = [Int]()
    
    let myVC = UIViewController()
    var score1 = UILabel()
    var score2 = UILabel()
    var score3 = UILabel()
    var score4 = UILabel()
    var score5 = UILabel()
    
    var gameType = 0
    var difficulty = 0
    var destinationDifficulty = 0
    
    @IBOutlet weak var MemoryButton: UIButton!
    @IBOutlet weak var SortingButton: UIButton!
    @IBOutlet weak var BalloonButton: UIButton!
    @IBOutlet weak var EasyDifficulty: UIButton!
    @IBOutlet weak var MediumDifficulty: UIButton!
    @IBOutlet weak var HardDifficulty: UIButton!
    var HighScoreButton = UIBarButtonItem()
    

    override func viewDidLoad() {
        highScoreGame = defaults.object(forKey: "GameArray") as? [String] ?? [String]()
        highScoreDifficulty = defaults.object(forKey: "DifficultyArray") as? [String] ?? [String]()
        highScoreScore = defaults.object(forKey: "ScoreArray") as? [Int] ?? [Int]()
        
        CreateVC()
        
        HighScoreButton = UIBarButtonItem(title: "HIGH SCORES", style: .plain, target: self, action: #selector(HighScore))
        self.navigationItem.rightBarButtonItem = HighScoreButton
        
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "back-main")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 64, width: 1024, height: 768))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        imageView.alpha = 0.3
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DeSelectGame()
        DeSelectDifficulty()
        self.gameType = 0
        self.difficulty = 0
    }
    
    @IBAction func MemorySelect(_ sender: Any) {
        if(gameType != 0) {
            DeSelectGame()
        }
        gameType = 1
        MemoryButton.alpha = 0.5
    }
    
    @IBAction func SortingSelect(_ sender: Any) {
        if(gameType != 0) {
            DeSelectGame()
        }
        gameType = 2
        SortingButton.alpha = 0.5
    }
    
    @IBAction func BalloonSelect(_ sender: Any) {
        if(gameType != 0) {
            DeSelectGame()
        }
        gameType = 3
        BalloonButton.alpha = 0.5
    }
    
    @IBAction func EasySelect(_ sender: Any) {
        if(difficulty != 0) {
            DeSelectDifficulty()
        }
        difficulty = 1
        EasyDifficulty.alpha = 0.5
    }
    
    @IBAction func MediumSelect(_ sender: Any) {
        if(difficulty != 0) {
            DeSelectDifficulty()
        }
        difficulty = 2
        MediumDifficulty.alpha = 0.5
    }
    
    @IBAction func HardSelect(_ sender: Any) {
        if(difficulty != 0) {
            DeSelectDifficulty()
        }
        difficulty = 3
        HardDifficulty.alpha = 0.5
    }
    
    @IBAction func Play(_ sender: Any) {
        if(gameType != 0 && difficulty != 0) {
            if(gameType == 1) {
                self.performSegue(withIdentifier: "MemorySegue", sender: self)
////                self.destinationDifficulty = difficulty
//                DeSelectGame()
//                DeSelectDifficulty()
//                self.gameType = 0
//                self.difficulty = 0
            } else if(gameType == 2) {
                self.performSegue(withIdentifier: "SortingSegue", sender: self)
////                self.destinationDifficulty = difficulty
//                DeSelectGame()
//                DeSelectDifficulty()
//                self.gameType = 0
//                self.difficulty = 0
            } else {
                self.performSegue(withIdentifier: "BalloonSegue", sender: self)
////                self.destinationDifficulty = difficulty
//                DeSelectGame()
//                DeSelectDifficulty()
//                self.gameType = 0
//                self.difficulty = 0
            }
        }
    }
    
    func DeSelectGame(){
        if(gameType == 1) {
            MemoryButton.alpha = 1
        } else if(gameType == 2) {
            SortingButton.alpha = 1
        } else {
            BalloonButton.alpha = 1
        }
    }
    
    func DeSelectDifficulty(){
        if(difficulty == 1) {
            EasyDifficulty.alpha = 1
        } else if(difficulty == 2) {
            MediumDifficulty.alpha = 1
        } else {
            HardDifficulty.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MemorySegue") {
            if let vc = segue.destination as? MemoryGameController {
                vc.difficulty = self.difficulty
            }
        }
        if(segue.identifier == "SortingSegue") {
            if let vc = segue.destination as? SortingGameController {
                vc.difficulty = self.difficulty
            }
        }
        if(segue.identifier == "BalloonSegue") {
            if let vc = segue.destination as? BalloonGameController {
                vc.difficulty = self.difficulty
            }
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    func CreateVC() {
        myVC.view.backgroundColor = UIColor.blue
        
        myVC.modalPresentationStyle = .popover
        myVC.modalTransitionStyle = .coverVertical
        
        myVC.preferredContentSize = CGSize(width: 800, height: 540)
        
        score1 = UILabel(frame: CGRect(x: 25, y: 30, width: 750, height: 80))
        score2 = UILabel(frame: CGRect(x: 25, y: 120, width: 750, height: 80))
        score3 = UILabel(frame: CGRect(x: 25, y: 210, width: 750, height: 80))
        score4 = UILabel(frame: CGRect(x: 25, y: 300, width: 750, height: 80))
        score5 = UILabel(frame: CGRect(x: 25, y: 390, width: 750, height: 80))
        score1.font = UIFont.boldSystemFont(ofSize: 30)
        score1.textAlignment = .center
        score1.text = ""
        score2.font = UIFont.boldSystemFont(ofSize: 30)
        score2.textAlignment = .center
        score2.text = ""
        score3.font = UIFont.boldSystemFont(ofSize: 30)
        score3.textAlignment = .center
        score3.text = ""
        score4.font = UIFont.boldSystemFont(ofSize: 30)
        score4.textAlignment = .center
        score4.text = ""
        score5.font = UIFont.boldSystemFont(ofSize: 30)
        score5.textAlignment = .center
        score5.text = ""
        
        myVC.view.addSubview(score1)
        myVC.view.addSubview(score2)
        myVC.view.addSubview(score3)
        myVC.view.addSubview(score4)
        myVC.view.addSubview(score5)
        
        let cancelButton = UIButton(frame: CGRect(x: 335, y: 490, width: 130, height: 40))
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        cancelButton.backgroundColor = UIColor.darkGray
        cancelButton.addTarget(self, action: #selector(Cancel), for: .touchUpInside)
        
        myVC.view.addSubview(cancelButton)
        
    }
    
    func HighScore() {
        highScoreGame = defaults.object(forKey: "GameArray") as? [String] ?? [String]()
        highScoreDifficulty = defaults.object(forKey: "DifficultyArray") as? [String] ?? [String]()
        highScoreScore = defaults.object(forKey: "ScoreArray") as? [Int] ?? [Int]()
        
        
        if(highScoreGame.count != 0) {
            score1.text = "1. Game: \(highScoreGame[0])  Level: \(highScoreDifficulty[0])  Score: \(highScoreScore[0])"
            if(highScoreGame.count > 1) {
                score2.text = "2. Game: \(highScoreGame[1])  Level: \(highScoreDifficulty[1])  Score: \(highScoreScore[1])"
            }
            if(highScoreGame.count > 2) {
                score3.text = "3. Game: \(highScoreGame[2])  Level: \(highScoreDifficulty[2])  Score: \(highScoreScore[2])"
            }
            if(highScoreGame.count > 3) {
                score4.text = "4. Game: \(highScoreGame[3])  Level: \(highScoreDifficulty[3])  Score: \(highScoreScore[3])"
            }
            if(highScoreGame.count > 4) {
                score5.text = "5. Game: \(highScoreGame[4])  Level: \(highScoreDifficulty[4])  Score: \(highScoreScore[4])"
            }
            
        }
        
        
        let fr = CGRect(x: 112, y: 384, width: 0, height: 0)
        let midView = UIView(frame: fr)
        self.view.addSubview(midView)
        
        let pop = myVC.popoverPresentationController
        pop?.sourceView = midView
        
        self.present(myVC, animated: true, completion: {
            _ in self.myVC.removeFromParentViewController()
            midView.removeFromSuperview()
        })
    }
    
    func Cancel() {
        self.myVC.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    

}

