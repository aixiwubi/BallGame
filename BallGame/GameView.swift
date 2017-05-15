//
//  GameView.swift
//  BallGame
//
//  Created by Wendong Yang on 5/13/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit
import CoreMotion
enum GameObjects : Int{
    case player
    case goodBox
    case badBox
}

class GameView: UIView ,UIDynamicAnimatorDelegate{
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    let motionManager = CMMotionManager()
    private lazy var animator : UIDynamicAnimator =  {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    
    
    func addCircle(){
        let xIn = arc4random_uniform(UInt32(self.frame.maxX)-20)+UInt32(self.frame.minX)+20
        let yIn = arc4random_uniform(UInt32(self.frame.maxY)-20)+UInt32(self.frame.minY)+20
        let rect = CGRect(x: CGFloat(xIn), y: CGFloat(yIn), width: 20, height: 20)
        let view = GameObjectView(frame: rect)
        let goodorBad = arc4random_uniform(100)
        if(goodorBad<75){
            view.objectType = GameObjects.goodBox
            view.backgroundColor = UIColor.blue

        }
        else{
            view.objectType = GameObjects.badBox
            view.backgroundColor = UIColor.red

        }
        
        addSubview(view)
        if let col = collision  {
            col.addItem(view)
        }
        
    }
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?
    var recView: GameObjectView?
    func cleanup(){
        for sub in subviews{
            if let sub = (sub as? GameObjectView){
                gravity?.removeItem(sub)
                collision?.removeItem(sub)
                sub.removeFromSuperview()
            }
        }
    }
    func setupEnvironment(){
        gravity = UIGravityBehavior()
        let vector = CGVector(dx: 0, dy: 0)
        gravity?.gravityDirection = vector
        collision = UICollisionBehavior()
        collision?.translatesReferenceBoundsIntoBoundary = true
    
    }
    func initGame() {
        
        let rect = CGRect(x: self.frame.midX, y: self.frame.midY, width: 20, height: 20)
        self.recView = GameObjectView(frame: rect)
        self.recView?.objectType = GameObjects.player
        self.recView?.backgroundColor = UIColor.red
        self.recView?.layer.cornerRadius = (self.recView?.frame.size.width)! / 2
        self.recView?.clipsToBounds = true
        gravity?.addItem(recView!)
        collision?.addItem(recView!)
        addSubview(recView!)
       
    }
    func startGame(){
        if let grav = gravity, let col = collision{
            animator.addBehavior(grav)
            animator.addBehavior(col)
            if motionManager.isAccelerometerAvailable {
                print("available")
                motionManager.accelerometerUpdateInterval = 1/10.0
                motionManager.startAccelerometerUpdates(to: .main) { data, error in
                    if let data = data {
                        let vector = CGVector(dx: data.acceleration.x, dy: -data.acceleration.y)
                        self.gravity!.gravityDirection = vector
                        
                    }
                }
            }
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 1/10.0
                motionManager.startDeviceMotionUpdates(to: .main) { data, error in
                    if let data = data {
                        let vector = CGVector(dx: 20*data.userAcceleration.x, dy: -data.userAcceleration.y*20)
                        self.gravity!.gravityDirection = vector
                    }
                }
            }
        }
    }
    func pause(){
        animator.removeAllBehaviors()
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
        
        
    }

  
}

