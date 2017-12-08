//
//  MemoryGameController.swift
//  Kids Joy Center
//
//  Created by Andrew Gilbert on 3/27/17.
//  Copyright © 2017 Andrew Gilbert. All rights reserved.
//

import UIKit
import AVFoundation

class MemoryGameController: UIViewController {
    let defaults = UserDefaults.standard
    var highScoreGame = [String]()
    var highScoreDifficulty = [String]()
    var highScoreScore = [Int]()
    
    var difficulty = 0
    var points = 0
    var times = 0
    var win = 0
    var right = 0
    var firstSelect = 0
    var secondSelect = 0
    var tempView = UIImageView()
    var prevTime = 0
    var interact = true
    var cheerPlayer = AVAudioPlayer()
    
    var TimeView = UIImageView()
    var TimeMinuteView = UIImageView()
    var TimeColon = UIImageView()
    var TimeFirstSecond = UIImageView()
    var TimeSecondSecond = UIImageView()
    
    var ScoreView = UIImageView()
    var ScoreFirst = UIImageView()
    var ScoreSecond = UIImageView()
    var ScoreThird = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUPViews()
        
        if(difficulty == 1) {
            EasyMode()
            win = 6
            times = 121
            prevTime = 120
        } else if(difficulty == 2) {
            MediumMode()
            win = 8
            times = 106
            prevTime = 105
        } else {
            HardMode()
            win = 10
            times = 91
            prevTime = 90
        }
        
        UpdateTime()
        
        let t = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
        
        let audioPath = Bundle.main.path(forResource: "cheer", ofType: "mp3")
        do {
            cheerPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setUPViews() {
        self.navigationItem.title = "MEMORY GAME"
        
        let image = #imageLiteral(resourceName: "background")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 64, width: 1024, height: 768))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        TimeView = UIImageView(frame: CGRect(x: 0, y: 72, width: 150, height: 40))
        TimeView.image = #imageLiteral(resourceName: "time")
        TimeView.backgroundColor = UIColor.white
        view.addSubview(TimeView)
        TimeMinuteView = UIImageView(frame: CGRect(x: 150, y: 72, width: 30, height: 40))
        TimeMinuteView.image = #imageLiteral(resourceName: "cartoon-number-0")
        TimeMinuteView.backgroundColor = UIColor.cyan
        view.addSubview(TimeMinuteView)
        TimeColon = UIImageView(frame: CGRect(x: 180, y: 72, width: 20, height: 40))
        TimeColon.image = #imageLiteral(resourceName: "Colon")
        TimeColon.backgroundColor = UIColor.cyan
        view.addSubview(TimeColon)
        TimeFirstSecond = UIImageView(frame: CGRect(x: 200, y: 72, width: 30, height: 40))
        TimeFirstSecond.image = #imageLiteral(resourceName: "cartoon-number-0")
        TimeFirstSecond.backgroundColor = UIColor.cyan
        view.addSubview(TimeFirstSecond)
        TimeSecondSecond = UIImageView(frame: CGRect(x: 230, y: 72, width: 30, height: 40))
        TimeSecondSecond.image = #imageLiteral(resourceName: "cartoon-number-0")
        TimeSecondSecond.backgroundColor = UIColor.cyan
        view.addSubview(TimeSecondSecond)
        
        
        ScoreView = UIImageView(frame: CGRect(x: 744, y: 72, width: 150, height: 40))
        ScoreView.image = #imageLiteral(resourceName: "score")
        ScoreView.backgroundColor = UIColor.white
        view.addSubview(ScoreView)
        ScoreFirst = UIImageView(frame: CGRect(x: 894, y: 72, width: 30, height: 40))
        ScoreFirst.image = #imageLiteral(resourceName: "cartoon-number-0")
        ScoreFirst.backgroundColor = UIColor.cyan
        view.addSubview(ScoreFirst)
        ScoreSecond = UIImageView(frame: CGRect(x: 924, y: 72, width: 30, height: 40))
        ScoreSecond.image = #imageLiteral(resourceName: "cartoon-number-0")
        ScoreSecond.backgroundColor = UIColor.cyan
        view.addSubview(ScoreSecond)
        ScoreThird = UIImageView(frame: CGRect(x: 954, y: 72, width: 30, height: 40))
        ScoreThird.image = #imageLiteral(resourceName: "cartoon-number-0")
        ScoreThird.backgroundColor = UIColor.cyan
        view.addSubview(ScoreThird)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        
        for i in 2...self.view.subviews.count {
            if self.view.subviews[i-1].layer.presentation()!.hitTest(touchLocation) != nil {
                if let temp:UIImageView = self.view.subviews[i-1] as? UIImageView {
                    if(!interact) {
                        return
                    }
                    
                    if(temp.image == #imageLiteral(resourceName: "question") && firstSelect == 0) {
                        self.tempView = temp
                        firstSelect = 1
                        exposeImage(temp: temp)
                        return
                    }
                    
                    if(temp.image == #imageLiteral(resourceName: "question") && firstSelect == 1) {
                        exposeImage(temp: temp)
                        firstSelect = 0
                        if(temp.tag == tempView.tag) {
                            if(cheerPlayer.isPlaying) {
                                cheerPlayer.stop()
                                cheerPlayer.currentTime = 0
                            }
                            
                            cheerPlayer.play()
                            temp.tag = 0
                            self.tempView.tag = 0
                            UpdateScore()
                        } else {
                            self.interact = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.interact = true
                                self.tempView.image = #imageLiteral(resourceName: "question")
                                temp.image = #imageLiteral(resourceName: "question")
                            }
                        }
                    }
                    
                }
                
            }
        }
    }
    
    func exposeImage(temp: UIImageView) {
        if(temp.tag == 1) {
            temp.image = UIImage(named: "1")
        }
        if(temp.tag == 2) {
            temp.image = UIImage(named: "2")
        }
        if(temp.tag == 3) {
            temp.image = UIImage(named: "3")
        }
        if(temp.tag == 4) {
            temp.image = UIImage(named: "4")
        }
        if(temp.tag == 5) {
            temp.image = UIImage(named: "5")
        }
        if(temp.tag == 6) {
            temp.image = UIImage(named: "6")
        }
        if(temp.tag == 7) {
            temp.image = UIImage(named: "7")
        }
        if(temp.tag == 8) {
            temp.image = UIImage(named: "8")
        }
        if(temp.tag == 9) {
            temp.image = UIImage(named: "9")
        }
        if(temp.tag == 10) {
            temp.image = UIImage(named: "10")
        }
    }
    
    func UpdateTime() {
        if(times <= 0 || right >= win) {
            return
        }
        
        times = times - 1
        let minutes = Int(times/60)
        let seconds = Int(times - (minutes * 60))
        let tens = Int(seconds/10)
        let ones = Int(seconds - (tens * 10))
        TimeMinuteView.image = ReturnNumber(num: minutes)
        TimeFirstSecond.image = ReturnNumber(num: tens)
        TimeSecondSecond.image = ReturnNumber(num: ones)
        
        if(times <= 0) {
            EndGame()
        }
        
    }
    
    func UpdateScore() {
        if(right >= win) {
            return
        }
        
        let speed = prevTime - times
        if(speed < 4) {
            self.points = self.points + 5
        } else if(speed < 8) {
            self.points = self.points + 4
        } else {
            self.points = self.points + 3
        }
        prevTime = times
        right = right + 1
        
        let hundreds = Int(points/100)
        let temp = Int(points - (hundreds * 100))
        let tens = Int(temp/10)
        let ones = Int(temp - (tens * 10))
        ScoreFirst.image = ReturnNumber(num: hundreds)
        ScoreSecond.image = ReturnNumber(num: tens)
        ScoreThird.image = ReturnNumber(num: ones)
        
        if(right >= win) {
            EndGame()
        }
        
    }
    
    func ReturnNumber(num: Int) -> UIImage {
        let image: UIImage
        
        if(num == 0) {
            image = #imageLiteral(resourceName: "cartoon-number-0")
        } else if(num == 1) {
            image = #imageLiteral(resourceName: "cartoon-number-1")
        } else if(num == 2) {
            image = #imageLiteral(resourceName: "cartoon-number-2")
        } else if(num == 3) {
            image = #imageLiteral(resourceName: "cartoon-number-3")
        } else if(num == 4) {
            image = #imageLiteral(resourceName: "cartoon-number-4")
        } else if(num == 5) {
            image = #imageLiteral(resourceName: "cartoon-number-5")
        } else if(num == 6) {
            image = #imageLiteral(resourceName: "cartoon-number-6")
        } else if(num == 7) {
            image = #imageLiteral(resourceName: "cartoon-number-7")
        } else if(num == 8) {
            image = #imageLiteral(resourceName: "cartoon-number-8")
        } else {
            image = #imageLiteral(resourceName: "cartoon-number-9")
        }
        
        return image
    }
    
    func EndGame() {
        var title = ""
        if(right >= win) {
            title = "YOU WIN!"
        } else {
            title = "GAME OVER"
        }
        
        var message = ""
        if(HighScore()) {
            message = "YOU GOT A HIGH SCORE!\nPlay Again? "
        } else {
            message = "Play Again"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(action) in
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            self.Reset()
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func Reset() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.right = 0
        self.points = 0
        
        self.setUPViews()
        
        if(difficulty == 1) {
            EasyMode()
            win = 6
            times = 121
            prevTime = 120
        } else if(difficulty == 2) {
            MediumMode()
            win = 8
            times = 106
            prevTime = 105
        } else {
            HardMode()
            win = 10
            times = 91
            prevTime = 90
        }
        
        UpdateTime()
    }
    
    func EasyMode() {
        var fill: [(x: Int, y: Int)] = [(352, 205), (462, 205), (572, 205), (352, 315), (462, 315), (572, 315), (352, 425),
                                        (462, 425), (572, 425), (352, 535), (462, 535), (572, 535)]
        var pics: [Int] = [1,2,3,4,5,6,7,8,9,10]
        for _ in 1...6 {
            let picSelect = Int(arc4random_uniform(UInt32(pics.count)))
            let pic = pics[picSelect]
            pics.remove(at: picSelect)
            let image = #imageLiteral(resourceName: "question")
            
            
            var selected = Int(arc4random_uniform(UInt32(fill.count)))
            let x = fill[selected].x
            let y = fill[selected].y
            fill.remove(at: selected)
            
            selected = Int(arc4random_uniform(UInt32(fill.count)))
            let x2 = fill[selected].x
            let y2 = fill[selected].y
            fill.remove(at: selected)
            
            
            let imageView1 = UIImageView(image: image)
            imageView1.frame = CGRect(x: x, y: y, width: 100, height: 100)
            imageView1.tag = pic
            view.addSubview(imageView1)
            
            let imageView2 = UIImageView(image: image)
            imageView2.frame = CGRect(x: x2, y: y2, width: 100, height: 100)
            imageView2.tag = pic
            view.addSubview(imageView2)
            
        }
        
        
    }
    
    func MediumMode() {
        var fill: [(x: Int, y: Int)] = [(297, 205), (407, 205), (517, 205), (627, 205), (297, 315), (407, 315), (517, 315),
                                        (627, 315), (297, 425), (407, 425), (517, 425), (627, 425), (297, 535), (407, 535),
                                        (517, 535), (627, 535)]
        var pics: [Int] = [1,2,3,4,5,6,7,8,9,10]
        for _ in 1...8 {
            let picSelect = Int(arc4random_uniform(UInt32(pics.count)))
            let pic = pics[picSelect]
            pics.remove(at: picSelect)
            let image = #imageLiteral(resourceName: "question")
            
            
            var selected = Int(arc4random_uniform(UInt32(fill.count)))
            let x = fill[selected].x
            let y = fill[selected].y
            fill.remove(at: selected)
            
            selected = Int(arc4random_uniform(UInt32(fill.count)))
            let x2 = fill[selected].x
            let y2 = fill[selected].y
            fill.remove(at: selected)
            
            
            let imageView1 = UIImageView(image: image)
            imageView1.frame = CGRect(x: x, y: y, width: 100, height: 100)
            imageView1.tag = pic
            view.addSubview(imageView1)
            
            let imageView2 = UIImageView(image: image)
            imageView2.frame = CGRect(x: x2, y: y2, width: 100, height: 100)
            imageView2.tag = pic
            view.addSubview(imageView2)
            
        }
        
        
    }
    
    func HardMode() {
        var fill: [(x: Int, y: Int)] = [(242, 205), (352, 205), (462, 205), (572, 205), (682, 205), (242, 315), (352, 315),
                                        (462, 315), (572, 315), (682, 315), (242, 425), (352, 425), (462, 425), (572, 425),
                                        (682, 425), (242, 535), (352, 535), (462, 535), (572, 535), (682, 535)]
        var pics: [Int] = [1,2,3,4,5,6,7,8,9,10]
        for _ in 1...10 {
            let picSelect = Int(arc4random_uniform(UInt32(pics.count)))
            let pic = pics[picSelect]
            pics.remove(at: picSelect)
            let image = #imageLiteral(resourceName: "question")
            
            
            var selected = Int(arc4random_uniform(UInt32(fill.count)))
            let x = fill[selected].x
            let y = fill[selected].y
            fill.remove(at: selected)
            
            selected = Int(arc4random_uniform(UInt32(fill.count)))
            let x2 = fill[selected].x
            let y2 = fill[selected].y
            fill.remove(at: selected)
            
            
            let imageView1 = UIImageView(image: image)
            imageView1.frame = CGRect(x: x, y: y, width: 100, height: 100)
            imageView1.tag = pic
            view.addSubview(imageView1)
            
            let imageView2 = UIImageView(image: image)
            imageView2.frame = CGRect(x: x2, y: y2, width: 100, height: 100)
            imageView2.tag = pic
            view.addSubview(imageView2)
            
        }
        
        
    }
    
    func HighScore() -> Bool{
        highScoreGame = defaults.object(forKey: "GameArray") as? [String] ?? [String]()
        highScoreDifficulty = defaults.object(forKey: "DifficultyArray") as? [String] ?? [String]()
        highScoreScore = defaults.object(forKey: "ScoreArray") as? [Int] ?? [Int]()
        
        if(right < win) {
            return false
        }
        
        if(highScoreGame.count == 0) {
            Save(num: 0)
            return true
        }
        if(points < highScoreScore[highScoreScore.count - 1]) {
            return false
        }
        
        for i in 0...highScoreGame.count - 1 {
            if(points > highScoreScore[i]) {
                Save(num: i)
                return true
            }
        }
        
        
        
        
        
        
        return false
    }
    
    func Save(num: Int) {
        highScoreGame.insert("Memory", at: num)
        if(difficulty == 1) {
            highScoreDifficulty.insert("Easy", at: num)
        } else if(difficulty == 2) {
            highScoreDifficulty.insert("Medium", at: num)
        } else {
            highScoreDifficulty.insert("Hard", at: num)
        }
        highScoreScore.insert(points, at: num)
        
        if(highScoreGame.count > 5) {
            highScoreGame.removeLast()
            highScoreDifficulty.removeLast()
            highScoreScore.removeLast()
        }
        
        defaults.set(highScoreGame, forKey: "GameArray")
        defaults.set(highScoreDifficulty, forKey: "DifficultyArray")
        defaults.set(highScoreScore, forKey: "ScoreArray")
        
    }
    
    
    
    
    
    
    
    
    
    
}
