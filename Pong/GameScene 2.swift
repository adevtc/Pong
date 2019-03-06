//
//  GameScene.swift
//  Pong
//
//  Created by Jon on 1/25/19.
//  Copyright © 2019 addevtec. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    

    
    var score = [Int]()
    
    override func didMove(to view: SKView) {
 
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode

    
        
        print(self.view?.bounds.height as Any)
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 50
        
        let border  = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
        
    }
    
    func startGame() {
        score = [0,0]
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.ball.physicsBody?.applyImpulse(CGVector(dx: 10 , dy: 10))
        }
    }
    

    func addScore(playerWhoWon : SKSpriteNode){
        
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == main {
            score[0] += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            }
            
        }
        else if playerWhoWon == enemy {
            score[1] += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
            }
        }
        
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    
                }
                
            }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }

            
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    
                }

            }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            
        }
    }
    


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        switch currentGameType {
        case .easy:
            topLbl.isHidden = true
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.3))
            if score == [2] {
                startGame() // Add a restart game func
            }
            break
        case .medium:
            topLbl.isHidden = true
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
            break
        case .hard:
            topLbl.isHidden = true
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.7))
            break
        case .player2:
            topLbl.isHidden = false
            break
        }
        
        
        
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        }
        else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        }
    }
}







