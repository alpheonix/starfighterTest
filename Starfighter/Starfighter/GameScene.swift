//
//  GameScene.swift
//  Starfighter
//
//  Created by Arthur BLANC on 24/12/2019.
//  Copyright © 2019 Arthur BLANC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var lifePlayerLabel:SKLabelNode!
    var lifeAlienLabel:SKLabelNode!
    var win: SKLabelNode!
    var player:SKSpriteNode!
    var HealthBarPlayer: SKSpriteNode!
    var HealthBarEnemy: SKSpriteNode!
    var torpilleNode: SKSpriteNode!
    var alien: SKSpriteNode!
    var lifePlayer:Int = 500
    var lifeAlien:Int = 300
    var possibleAliens = ["tie","falcon","starDestroyer"]
    
    var gameTimer: Timer!
    let alienCategory:UInt32 = 0x1 << 1
    let torpilleCategory:UInt32 = 0x1 << 0
    let playerCategory:UInt32 = 0x1 << 2
    override func didMove(to view: SKView) {
        
    
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        let url = URL(string: "https://webstockreview.net/images1280_/falcon-clipart-millenium-falcon-11.png")
        let data = try! Data(contentsOf: url!)
        let image = UIImage(data: data)
        let Texture = SKTexture(image: image!)
        
        
        
        player = SKSpriteNode(texture: Texture)
        player.name = "player"
        
        player.position = CGPoint(x: 0, y: -450)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = torpilleCategory
        player.physicsBody?.collisionBitMask = 0
        
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        
        HealthBarPlayer = SKSpriteNode(color:SKColor .yellow, size: CGSize(width: lifePlayer, height: 30))
        HealthBarPlayer.position = CGPoint(x: self.frame.width / -4.2, y: self.frame.height / -2.5)
        HealthBarPlayer.zPosition = 1
        self.addChild(HealthBarPlayer)
        
        HealthBarEnemy = SKSpriteNode(color:SKColor .yellow, size: CGSize(width: lifeAlien, height: 30))
        HealthBarEnemy.position = CGPoint(x: self.frame.width / 4.2, y: self.frame.height/2.5)
        HealthBarEnemy.zPosition = 1
        self.addChild(HealthBarEnemy)
        
        addAlien()
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(enemyFire), userInfo: nil, repeats: true)
        
    
}
    
    @objc func enemyFire( ){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        torpilleNode = SKSpriteNode(imageNamed: "torpedo")
        torpilleNode.size = CGSize(width: torpilleNode.size.width/3, height: torpilleNode.size.width/3)
        torpilleNode.position = CGPoint(x: 0, y: alien.position.y - alien.size.height)
        torpilleNode.position.y += 5
        torpilleNode.physicsBody = SKPhysicsBody(rectangleOf: torpilleNode!.size)
        torpilleNode.physicsBody?.isDynamic = true
        torpilleNode.physicsBody?.categoryBitMask = torpilleCategory
        torpilleNode.physicsBody?.contactTestBitMask = playerCategory
        torpilleNode.physicsBody?.collisionBitMask = 0
        torpilleNode.physicsBody?.usesPreciseCollisionDetection = true

        self.addChild(torpilleNode)

        let animationDuration:TimeInterval = 1

        var actionArray = [SKAction]( )
        actionArray.append(SKAction.move(to: CGPoint(x: alien.position.x, y: player.position.y + 50), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpilleNode?.run(SKAction.sequence(actionArray))
        
        
    }
    
    func addAlien( ){
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        alien = SKSpriteNode(imageNamed: possibleAliens[0])
        alien.size = CGSize(width: alien.size.width/3, height: alien.size.width/3)
       
        alien.name = "alien"
        alien.position = CGPoint(x: 0, y: 500)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = torpilleCategory
        alien.physicsBody?.collisionBitMask = 0
        self.addChild(alien)
    
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpille()
    }
    
    func fireTorpille(){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        torpilleNode = SKSpriteNode(imageNamed: "laser")
        torpilleNode.size = CGSize(width: torpilleNode.size.width/3, height: torpilleNode.size.width/3)
        torpilleNode.position = CGPoint(x: 0, y: player.position.y + player.size.height)
        
        
        torpilleNode.physicsBody = SKPhysicsBody(rectangleOf: torpilleNode!.size)
        torpilleNode.physicsBody?.isDynamic = true
        torpilleNode.physicsBody?.categoryBitMask = torpilleCategory
        torpilleNode.physicsBody?.contactTestBitMask = alienCategory
        torpilleNode.physicsBody?.collisionBitMask = 0
        torpilleNode.physicsBody?.usesPreciseCollisionDetection = true

        self.addChild(torpilleNode)

        let animationDuration:TimeInterval = 1

        var actionArray = [SKAction]( )
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpilleNode?.run(SKAction.sequence(actionArray))
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & torpilleCategory) != 0 &&  (secondBody.categoryBitMask & alienCategory) != 0 {
            tropilleDidColide(torpille: firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        }
        
        if (firstBody.categoryBitMask & torpilleCategory) != 0 &&  (secondBody.categoryBitMask & playerCategory) != 0 {
            tropilleDidColide(torpille: firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        }

    }
   
    
    func tropilleDidColide(torpille:SKSpriteNode,alien:SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion!.position = alien.position
        self.addChild(explosion!)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpille.removeFromParent()
        self.run(SKAction.wait(forDuration: 2)) {
            explosion?.removeFromParent()
        }
        if(alien.name == "player" ){
            HealthBarPlayer.size = CGSize(width: lifePlayer, height: 30)
            lifePlayer -= 10
        }else{
            HealthBarEnemy.size = CGSize(width: lifeAlien, height: 30)
                lifeAlien -= 5
        }
        
        if(lifeAlien == 0){
            win = SKLabelNode(text: "WIN")
            win.position = CGPoint(x: 0, y: 0)
            win.fontName = "Zapfino"
            win.fontSize = 50
            win.color = UIColor.white
            addChild(win)
            self.scene?.view!.isPaused = true
            
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
