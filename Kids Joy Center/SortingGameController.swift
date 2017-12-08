//
//  SortingGameController.swift
//  Kids Joy Center
//
//  Created by Andrew Gilbert on 3/27/17.
//  Copyright © 2017 Andrew Gilbert. All rights reserved.
//

import UIKit
import AVFoundation

class SortingGameController: UIViewController {
    let defaults = UserDefaults.standard
    var highScoreGame = [String]()
    var highScoreDifficulty = [String]()
    var highScoreScore = [Int]()
    
    var difficulty = 0
    var points = 0
    var win = 8
    var right = 0
    var times = 120
    var prevTime = 0
    var cheerPlayer = AVAudioPlayer()
    var selected = UIImageView()
    var original = CGPoint()
    
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
        
        SetUpViews()
        
        if(difficulty == 1) {
            EasyMode()
            win = 8
            times = 61
            prevTime = 60
        } else if(difficulty == 2) {
            MediumMode()
            win = 10
            times = 46
            prevTime = 45
        } else {
            HardMode()
            win = 12
            times = 31
            prevTime = 30
        }
        
        UpdateTime()
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
        
        let audioPath = Bundle.main.path(forResource: "cheer", ofType: "mp3")
        do {
            cheerPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func SetUpViews() {
        self.navigationItem.title = "SORTING GAME"
        
        let banner = UIImageView(frame: CGRect(x: 0, y: 64, width: 1024, height: 100))
        banner.backgroundColor = UIColor.cyan
        view.addSubview(banner)
        self.view.sendSubview(toBack: banner)
        
        let image = #imageLiteral(resourceName: "air-land-water")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 164, width: 1024, height: 604))
        imageView.contentMode = UIViewContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = image
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        
        TimeView = UIImageView(frame: CGRect(x: 0, y: 718, width: 150, height: 40))
        TimeView.image = #imageLiteral(resourceName: "time")
        TimeView.backgroundColor = UIColor.white
        view.addSubview(TimeView)
        TimeMinuteView = UIImageView(frame: CGRect(x: 150, y: 718, width: 30, height: 40))
        TimeMinuteView.image = #imageLiteral(resourceName: "cartoon-number-0")
        TimeMinuteView.backgroundColor = UIColor.cyan
        view.addSubview(TimeMinuteView)
        TimeColon = UIImageView(frame: CGRect(x: 180, y: 718, width: 20, height: 40))
        TimeColon.image = #imageLiteral(resourceName: "Colon")
        TimeColon.backgroundColor = UIColor.cyan
        view.addSubview(TimeColon)
        TimeFirstSecond = UIImageView(frame: CGRect(x: 200, y: 718, width: 30, height: 40))
        TimeFirstSecond.image = #imageLiteral(resourceName: "cartoon-number-0")
        TimeFirstSecond.backgroundColor = UIColor.cyan
        view.addSubview(TimeFirstSecond)
        TimeSecondSecond = UIImageView(frame: CGRect(x: 230, y: 718, width: 30, height: 40))
        TimeSecondSecond.image = #imageLiteral(resourceName: "cartoon-number-0")
        TimeSecondSecond.backgroundColor = UIColor.cyan
        view.addSubview(TimeSecondSecond)
        
        
        ScoreView = UIImageView(frame: CGRect(x: 644, y: 718, width: 150, height: 40))
        ScoreView.image = #imageLiteral(resourceName: "score")
        ScoreView.backgroundColor = UIColor.white
        view.addSubview(ScoreView)
        ScoreFirst = UIImageView(frame: CGRect(x: 794, y: 718, width: 30, height: 40))
        ScoreFirst.image = #imageLiteral(resourceName: "cartoon-number-0")
        ScoreFirst.backgroundColor = UIColor.cyan
        view.addSubview(ScoreFirst)
        ScoreSecond = UIImageView(frame: CGRect(x: 824, y: 718, width: 30, height: 40))
        ScoreSecond.image = #imageLiteral(resourceName: "cartoon-number-0")
        ScoreSecond.backgroundColor = UIColor.cyan
        view.addSubview(ScoreSecond)
        ScoreThird = UIImageView(frame: CGRect(x: 854, y: 718, width: 30, height: 40))
        ScoreThird.image = #imageLiteral(resourceName: "cartoon-number-0")
        ScoreThird.backgroundColor = UIColor.cyan
        view.addSubview(ScoreThird)
        
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
    
    func GetImage(num: Int) -> UIImage {
        let image: UIImage
        
        if(num == 11) {
            image = UIImage(named: "1-1")!
        } else if(num == 12) {
            image = UIImage(named: "1-2")!
        } else if(num == 13) {
            image = UIImage(named: "1-3")!
        } else if(num == 14) {
            image = UIImage(named: "1-4")!
        } else if(num == 15) {
            image = UIImage(named: "1-5")!
        } else if(num == 21) {
            image = UIImage(named: "2-1")!
        } else if(num == 22) {
            image = UIImage(named: "2-2")!
        } else if(num == 23) {
            image = UIImage(named: "2-3")!
        } else if(num == 24) {
            image = UIImage(named: "2-4")!
        } else if(num == 25) {
            image = UIImage(named: "2-5")!
        } else if(num == 31) {
            image = UIImage(named: "3-1")!
        } else if(num == 32) {
            image = UIImage(named: "3-2")!
        } else if(num == 33) {
            image = UIImage(named: "3-3")!
        } else if(num == 34) {
            image = UIImage(named: "3-4")!
        } else {
            image = UIImage(named: "3-5")!
        }
        
        return image
        
    }
    
    func EasyMode() {
        var fill: [Int] = [237, 307, 377, 447, 517, 587, 657, 727]
        var pics: [Int] = [11, 12, 13, 14, 15, 21, 22, 23, 24, 25,
                              31, 32, 33, 34, 35]
        for i in 1...8 {
            let picSelect = Int(arc4random_uniform(UInt32(pics.count)))
            var pic = pics[picSelect]
            pics.remove(at: picSelect)
            let image = GetImage(num: pic)
            
            if(pic < 20) {
                pic = 1
            } else if(pic < 30) {
                pic = 2
            } else {
                pic = 3
            }
            
            
            let selected = i-1
            let x = fill[selected]
            let y = 84
            
            
            let imageView1 = UIImageView(image: image)
            imageView1.frame = CGRect(x: x, y: y, width: 60, height: 60)
            imageView1.tag = pic
            view.addSubview(imageView1)
            
        }
        
        
    }
    
    func MediumMode() {
        var fill: [Int] = [167, 237, 307, 377, 447, 517, 587, 657, 727, 797]
        var pics: [Int] = [11, 12, 13, 14, 15, 21, 22, 23, 24, 25,
                           31, 32, 33, 34, 35]
        for i in 1...10 {
            let picSelect = Int(arc4random_uniform(UInt32(pics.count)))
            var pic = pics[picSelect]
            pics.remove(at: picSelect)
            let image = GetImage(num: pic)
            
            if(pic < 20) {
                pic = 1
            } else if(pic < 30) {
                pic = 2
            } else {
                pic = 3
            }
            
            
            let selected = i-1
            let x = fill[selected]
            let y = 84
            
            
            let imageView1 = UIImageView(image: image)
            imageView1.frame = CGRect(x: x, y: y, width: 60, height: 60)
            imageView1.tag = pic
            view.addSubview(imageView1)
            
        }
        
        
    }
    
    func HardMode() {
        var fill: [Int] = [97, 167, 237, 307, 377, 447, 517, 587, 657, 727, 797, 867]
        var pics: [Int] = [11, 12, 13, 14, 15, 21, 22, 23, 24, 25,
                           31, 32, 33, 34, 35]
        for i in 1...12 {
            let picSelect = Int(arc4random_uniform(UInt32(pics.count)))
            var pic = pics[picSelect]
            pics.remove(at: picSelect)
            let image = GetImage(num: pic)
            
            if(pic < 20) {
                pic = 1
            } else if(pic < 30) {
                pic = 2
            } else {
                pic = 3
            }
            
            
            let selected = i-1
            let x = fill[selected]
            let y = 84
            
            
            let imageView1 = UIImageView(image: image)
            imageView1.frame = CGRect(x: x, y: y, width: 60, height: 60)
            imageView1.tag = pic
            view.addSubview(imageView1)
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        for i in 12...self.view.subviews.count {
            if self.view.subviews[i-1].layer.presentation()!.hitTest(touchLocation) != nil {
                if let temp:UIImageView = self.view.subviews[i-1] as? UIImageView {
                    selected = temp
                    selected.tag = temp.tag
                    original = temp.center
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if(selected.tag > 0) {
            selected.center = (touch?.location(in: self.view))!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Test()
        selected = UIImageView()
        if(right >= win) {
            EndGame()
        }
    }
    
    func Test() {
        
        if(selected.tag == 1 && selected.center.y > 164 && selected.center.y <= 500) {
            UpdateScore()
            selected.tag = -1
            PlayAudio()
        } else if(selected.tag == 2 && selected.center.x <= 740 && selected.center.y > 500 && selected.center.y <= 640) {
            UpdateScore()
            selected.tag = -1
            PlayAudio()
        } else if(selected.tag == 2 && selected.center.x <= 520 && selected.center.y > 640) {
            UpdateScore()
            selected.tag = -1
            PlayAudio()
        } else if(selected.tag == 3 && selected.center.x > 740 && selected.center.y > 500) {
            UpdateScore()
            selected.tag = -1
            PlayAudio()
        } else if(selected.tag == 3 && selected.center.x > 520 && selected.center.y > 640) {
            UpdateScore()
            selected.tag = -1
            PlayAudio()
        } else {
            UIView.animate(withDuration: 2.0, animations: {
                self.selected.center = self.original
            })
        }
        
    }
    
    func PlayAudio() {
        if(cheerPlayer.isPlaying) {
            cheerPlayer.stop()
            cheerPlayer.currentTime = 0
        }
        cheerPlayer.prepareToPlay()
        cheerPlayer.play()

    }
    
    func UpdateScore() {
        if(right >= win) {
            return
        }
        
        let speed = prevTime - times
        if(speed <= 2) {
            self.points = self.points + 5
        } else if(speed <= 4) {
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
            self.performSegue(withIdentifier: "unwindToMain2", sender: self)
            
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
        
        self.SetUpViews()
        
        if(difficulty == 1) {
            EasyMode()
            win = 8
            times = 61
            prevTime = 60
        } else if(difficulty == 2) {
            MediumMode()
            win = 10
            times = 46
            prevTime = 45
        } else {
            HardMode()
            win = 12
            times = 31
            prevTime = 30
        }
        
        UpdateTime()
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
        highScoreGame.insert("Sorting", at: num)
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
