//
//  BalloonGameController.swift
//  Kids Joy Center
//
//  Created by Andrew Gilbert on 3/27/17.
//  Copyright © 2017 Andrew Gilbert. All rights reserved.
//

import UIKit
import AVFoundation

class BalloonGameController: UIViewController {
    let defaults = UserDefaults.standard
    var highScoreGame = [String]()
    var highScoreDifficulty = [String]()
    var highScoreScore = [Int]()
    
    var difficulty = 0
    var points = 0
    var times = 0
    var speed = 0
    var prevTime = 0
    var addAmount = 0
    var maxNumber = 0
    var win = true
    var bonus = 0
    var killer = 0
    var popPlayer = AVAudioPlayer()

    
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
            addAmount = 1
            maxNumber = 9
            speed = 6
            times = 61
            prevTime = 60
        } else if(difficulty == 2) {
            addAmount = 2
            maxNumber = 7
            speed = 5
            times = 46
            prevTime = 45
        } else {
            addAmount = 3
            maxNumber = 5
            speed = 4
            times = 31
            prevTime = 30
        }
        
        UpdateTime()
        
        bonus = times - Int(arc4random_uniform(6) + 20)
        killer = times - Int(arc4random_uniform(6) + 20)
        
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CallTimerFunc), userInfo: nil, repeats: true)
        
        let audioPath = Bundle.main.path(forResource: "BalloonPopping", ofType: "mp3")
        do {
            popPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setUPViews() {
        self.navigationItem.title = "BALLOON GAME"
        
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
    
    func CallTimerFunc() {
        if(times <= 0 || win == false) {
            return
        }
        
        UpdateTime()
        AddBalloons()
    }
    
    func UpdateTime() {
        if(times <= 0 || win == false) {
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
        
        if(prevTime - times >= 10) {
            win = false
            EndGame()
        }
    }
    
    func UpdateScore(temp: Int) {
        if(win == false || times <= 0) {
            return
        }
        
        if(temp > 10) {
            return
        }
        
        self.points = self.points + temp
        prevTime = times
        
        let hundreds = Int(points/100)
        let temp = Int(points - (hundreds * 100))
        let tens = Int(temp/10)
        let ones = Int(temp - (tens * 10))
        ScoreFirst.image = ReturnNumber(num: hundreds)
        ScoreSecond.image = ReturnNumber(num: tens)
        ScoreThird.image = ReturnNumber(num: ones)
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
        } else if(num == 9) {
            image = #imageLiteral(resourceName: "cartoon-number-9")
        } else if(num == 20) {
            image = #imageLiteral(resourceName: "star")
        } else {
            image = #imageLiteral(resourceName: "skull")
        }
        
        return image
    }
    
    func AddBalloons() {
        
        if(win == false || times <= 0) {
            return
        }
        
        let amount = Int(arc4random_uniform(UInt32(addAmount)) + 1)
        var locations: [Int] = [50, 146, 242, 338, 434, 530, 626, 722, 818, 914]
        var mySpeed = speed
        
        for _ in 1...amount {
            mySpeed = speed
            var balloonNum = Int(arc4random_uniform(UInt32(maxNumber)) + 1)
            let balloonColor = Int(arc4random_uniform(10) + 1)
            
            balloonNum = IsSpecial(num: balloonNum)
            
            let balloon = ReturnBalloonImage(num: balloonColor)
            let number = ReturnNumber(num: balloonNum)
            
            let balloonSize = CGSize(width: 60, height: 60)
            
            UIGraphicsBeginImageContextWithOptions(balloonSize, false, 0.0)
            balloon.draw(in: CGRect(x: 0, y: 0, width: 60, height: 60))
            number.draw(in: CGRect(x: 15, y: 15, width: 30, height: 30))
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            
            let x = Int(arc4random_uniform(UInt32(locations.count)))
            let fr = CGRect(x: CGFloat(locations[x]), y: CGFloat(700), width: CGFloat(60), height: CGFloat(60))
            locations.remove(at: x)
            let a = UIImageView(frame: fr)
            a.image = image
            a.tag = balloonNum
            self.view.addSubview(a)
            
            if(balloonNum == 20){
                mySpeed = speed - 2
            } else if(balloonNum == 30) {
                mySpeed = speed + 2
            }
            
            
            
            UIView.animate(withDuration: TimeInterval(mySpeed), delay: 0, options: .allowUserInteraction, animations: {
                a.frame.origin.y = 0
            }, completion: { _ in self.End(temp: a)})
            
        }
    }
    
    func End(temp: UIView) {
        if(temp.tag > 0) {
            temp.removeFromSuperview()
        }
    }
    
    func ReturnBalloonImage(num: Int) -> UIImage {
        let image: UIImage
        
        if(num == 1) {
            image = #imageLiteral(resourceName: "color1")
        } else if(num == 2) {
            image = #imageLiteral(resourceName: "color2")
        } else if(num == 3) {
            image = #imageLiteral(resourceName: "color3")
        } else if(num == 4) {
            image = #imageLiteral(resourceName: "color4")
        } else if(num == 5) {
            image = #imageLiteral(resourceName: "color5")
        } else if(num == 6) {
            image = #imageLiteral(resourceName: "color6")
        } else if(num == 7) {
            image = #imageLiteral(resourceName: "color7")
        } else if(num == 8) {
            image = #imageLiteral(resourceName: "color8")
        } else if(num == 9) {
            image = #imageLiteral(resourceName: "color9")
        } else {
            image = #imageLiteral(resourceName: "color10")
        }
        
        return image
    }
    
    func IsSpecial(num: Int) -> Int{
        var result = num
        
        if(times <= bonus) {
            result = 20
            self.bonus = times - Int(arc4random_uniform(6) + 20)
        }
        if(times <= bonus && times <= killer) {
            self.killer = killer - 1
        }
        if(times <= killer) {
            result = 30
            self.killer = times - Int(arc4random_uniform(6) + 20)
        }
        
        return result
    }
    
    func EndGame() {
        var title = ""
        if(win) {
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
            self.performSegue(withIdentifier: "unwindToMain3", sender: self)
            
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
        self.win = true
        self.points = 0
        
        self.setUPViews()
        
        if(difficulty == 1) {
            addAmount = 1
            maxNumber = 9
            speed = 6
            times = 61
            prevTime = 60
        } else if(difficulty == 2) {
            addAmount = 2
            maxNumber = 7
            speed = 5
            times = 46
            prevTime = 45
        } else {
            addAmount = 3
            maxNumber = 5
            speed = 4
            times = 31
            prevTime = 30
        }
        
        UpdateTime()
        
        bonus = times - Int(arc4random_uniform(6) + 20)
        killer = times - Int(arc4random_uniform(6) + 20)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        
        for i in 2...self.view.subviews.count {
            if self.view.subviews[i-1].layer.presentation()!.hitTest(touchLocation) != nil {
                if let temp:UIImageView = self.view.subviews[i-1] as? UIImageView {
                    if(temp.tag > 0){
                        if(temp.tag == 20 || temp.tag == 30) {
                            HandleSpecial(temp: temp)
                        }
                        UpdateScore(temp: temp.tag)
                        Burst(temp: temp)
                        
                        if(popPlayer.isPlaying) {
                            popPlayer.stop()
                            popPlayer.currentTime = 0
                        }
                        popPlayer.prepareToPlay()
                        popPlayer.play()
                    }
                }
            }
        }
        
        
        
    }
    
    func Burst(temp: UIImageView) {
        let locate = temp.layer.presentation()?.frame.origin
        temp.tag = -1
        temp.layer.removeAllAnimations()
        temp.frame.origin.y = locate!.y - 10
        
        temp.image = #imageLiteral(resourceName: "explosion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            temp.removeFromSuperview()
        }
        
    }
    
    func HandleSpecial(temp: UIImageView) {
        if(temp.tag == 20) {
            let fillIn = self.speed
            self.speed = Int(speed*2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.speed = fillIn
            }
        } else {
            win = false
            EndGame()
        }
    }
    
    func HighScore() -> Bool{
        highScoreGame = defaults.object(forKey: "GameArray") as? [String] ?? [String]()
        highScoreDifficulty = defaults.object(forKey: "DifficultyArray") as? [String] ?? [String]()
        highScoreScore = defaults.object(forKey: "ScoreArray") as? [Int] ?? [Int]()
        
        if(win == false) {
            return false
        }
        
        if(highScoreGame.count == 0) {
            Save(num: 0)
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
        highScoreGame.insert("Balloon", at: num)
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
