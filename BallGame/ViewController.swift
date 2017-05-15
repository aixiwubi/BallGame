//
//  ViewController.swift
//  BallGame
//
//  Created by Wendong Yang on 5/8/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UICollisionBehaviorDelegate{
    
    @IBOutlet var myView: GameView!
    
    var scoreInt = 0
    var lifeInt = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.setupEnvironment()
        self.myView.collision?.collisionDelegate = self
        
    }
    var playing = false
    var pause = false
    @IBOutlet weak var life: UILabel!
    @IBOutlet weak var score: UILabel!
    
    @IBAction func addSquare(_ sender: UIButton) {
        self.myView.addCircle()
        
    }
    @IBAction func startGame(_ sender: UIButton) {
        if(!playing){
            if(pause){
                pause = false
                playing = true
                self.myView.startGame()
                let queue = DispatchQueue.global(qos: .userInitiated)
                queue.async {
                    while(self.lifeInt>=0&&self.playing){
                        DispatchQueue.main.async {
                            self.myView.addCircle()
                        }
                        usleep(500000)
                    }
                    if(self.lifeInt<0){
                        self.playing = false
                        
                        DispatchQueue.main.async {
                            self.myView.pause()
                            self.myView.cleanup()
                            let alert = UIAlertController(title: "Game Over", message: "You used up all your lifes", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            else{
                playing = true
                scoreInt = 0
                lifeInt = 5
                life.text = String(lifeInt)
                score.text = String(scoreInt)
                self.myView.initGame()
                self.myView.startGame()
                let queue = DispatchQueue.global(qos: .userInitiated)
                queue.async {
                    while(self.lifeInt>=0&&self.playing){
                        DispatchQueue.main.async {
                            self.myView.addCircle()
                        }
                        usleep(500000)
                    }
                    if(self.lifeInt<0){
                        self.playing = false
                        
                        DispatchQueue.main.async {
                            self.myView.pause()
                            self.myView.cleanup()
                            let alert = UIAlertController(title: "Game Over", message: "You used up all your lifes", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func pause(_ sender: UIButton) {
        if(playing){
            self.playing = false
            self.pause = true
            self.myView.pause()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print("something collide")
        if(playing){
            if (item1 as? GameObjectView)?.objectType == GameObjects.player || (item2 as? GameObjectView)?.objectType == GameObjects.player{
                
                if(item1 as? GameObjectView)?.objectType == GameObjects.goodBox{
                    print("hit good box")
                    let block = item1 as! UIView
                    block.removeFromSuperview()
                    myView.collision?.removeItem(item1)
                    scoreInt+=1
                    score.text = String(scoreInt)
                    
                }
                else if((item2 as? GameObjectView)?.objectType == GameObjects.goodBox){
                    print("hit good box")
                    let block = item2 as! UIView
                    block.removeFromSuperview()
                    myView.collision?.removeItem(item2)
                    scoreInt+=1
                    score.text = String(scoreInt)
                    
                }
                else if((item1 as? GameObjectView)?.objectType == GameObjects.badBox){
                    print("hit bad box")
                    let block = item2 as! UIView
                    block.removeFromSuperview()
                    myView.collision?.removeItem(item2)
                    scoreInt-=1
                    score.text = String(scoreInt)
                    lifeInt-=1
                    life.text = String(lifeInt)
                    
                    
                }
                else if((item2 as? GameObjectView)?.objectType == GameObjects.badBox){
                    print("hit bad box")
                    let block = item2 as! UIView
                    block.removeFromSuperview()
                    myView.collision?.removeItem(item2)
                    scoreInt-=1
                    score.text = String(scoreInt)
                    lifeInt-=1
                    life.text = String(lifeInt)
                }
                
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
}

