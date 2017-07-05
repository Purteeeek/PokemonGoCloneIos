//
//  BattleScene.swift
//  PokeGo
//
//  Created by pratik on 06/04/17.
//  Copyright © 2017 Purteeek. All rights reserved.
//


// Lets start playing the game now
import SpriteKit
import UIKit

class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon : Pokemon!
    var pokemonSprite : SKSpriteNode!
    var pokeballSprite : SKSpriteNode!

    // create constants
    let kPokemonSize = CGSize(width: 120, height: 120)
    let kPokeballSize = CGSize(width: 70, height: 70)
    let kPokemonName = "pokemon"
    
    //bit categories
    let kPokemonCategory : UInt32 = 0x1 << 0
    let kPokeballCategory : UInt32 =  0x1 << 1
    let kEdgeCategory : UInt32 =  0x1 << 2
    
    //physics variable setup
    var velocity : CGPoint = CGPoint.zero
    var touchPoint : CGPoint = CGPoint()
    var canThroughPokeball : Bool = false
    
    // pokemon catching variable
    var startCount = false
    var maxTime = 30
    var myTime = 30
    var timeLabel = SKLabelNode(fontNamed: "arial")
    var pokemonCaught = false
    
    // it is like the viewdidLoad in the normal View Controller.
    override func didMove(to view: SKView) {
     //   print("Welcome bhaya")
        
    //adding a background image
        let battleBg = SKSpriteNode(imageNamed: "bggg")
        battleBg.size = self.size
        battleBg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        battleBg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battleBg.zPosition = -1
        self.addChild(battleBg)
        
        self.makeMessageWith(imageName: "battle")
    // adding pokemon setup
        self.perform(#selector(pokemonSetup), with: nil, afterDelay: 1.0)
        self.perform(#selector(pokeballSetup), with: nil, afterDelay: 1.0)
        
    // physics body setup
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kEdgeCategory
        
        self.physicsWorld.contactDelegate = self
        
    //placing label 
        self.timeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        self.addChild(timeLabel)
        
    self.startCount = true
    
    }
    
    func pokemonSetup() {
        
        self.pokemonSprite = SKSpriteNode(imageNamed: pokemon.imageFileName!)
        self.pokemonSprite.size = kPokemonSize
        self.pokemonSprite.name = kPokemonName
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.pokemonSprite.zPosition = 1
        
        // Pokemon Physics, Add after basic setup 
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        self.pokemonSprite.physicsBody?.isDynamic = false
        self.pokemonSprite.physicsBody?.affectedByGravity = false
        self.pokemonSprite.physicsBody?.mass = 1.0
        
        // pokemon bitmask 
        self.pokemonSprite.physicsBody?.categoryBitMask = kPokemonCategory
        self.pokemonSprite.physicsBody?.contactTestBitMask = kPokeballCategory
        self.pokemonSprite.physicsBody?.collisionBitMask = kEdgeCategory
        
        //movement action
        let moveRight = SKAction.moveBy(x: 100, y: 0, duration: 3.0)
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        self.pokemonSprite.run(SKAction.repeatForever(sequence))
        self.addChild(self.pokemonSprite)
    }
    
    func pokeballSetup(){
        
        self.pokeballSprite = SKSpriteNode(imageNamed: "pokeball")
        self.pokeballSprite.size = kPokeballSize
        self.pokeballSprite.position = CGPoint(x: self.size.width/2, y: 50)
        self.pokeballSprite.zPosition = 1
        
        //pokeball physics body 
        self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballSprite.frame.size.width/2)
        self.pokeballSprite.physicsBody?.isDynamic = true
        self.pokeballSprite.physicsBody?.affectedByGravity = true
        self.pokeballSprite.physicsBody?.mass = 0.1
        
        // pokeball bitmask 
        self.pokeballSprite.physicsBody?.categoryBitMask = kPokeballCategory
        self.pokeballSprite.physicsBody?.contactTestBitMask = kPokemonCategory
        self.pokeballSprite.physicsBody?.collisionBitMask = kPokemonCategory | kEdgeCategory
        self.addChild(self.pokeballSprite)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if self.pokeballSprite.frame.contains(location!) {
            self.canThroughPokeball = true
            self.touchPoint = location!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchPoint = location!
        if self.canThroughPokeball {
            throwPokeball()
        }
        

    }
    
    func throwPokeball() {
        self.canThroughPokeball = false
        
        let dt: CGFloat = 1.0/500
        let distance = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
        self.pokeballSprite.physicsBody?.velocity = velocity
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case kPokemonCategory | kPokeballCategory:
            print("Pokemon has been captured")
            self.pokemonCaught = true
            endGame()
            
        default:
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount {
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
        self.myTime = self.maxTime - Int(currentTime)
        self.timeLabel.text = "\(self.myTime)"
        if self.myTime <= 0 {
            endGame()
        }
    }
    func endGame() {
        
        self.pokemonSprite.removeFromParent()
       self.pokeballSprite.removeFromParent()
        
        if pokemonCaught {
            self.makeMessageWith(imageName: "gotcha")
            self.pokemon.timesCaught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            
        }else {
            self.makeMessageWith(imageName: "footprints")
        }
        
        self.perform(#selector(self.endBattle), with: nil, afterDelay: 3.0)
    }
    
    func endBattle() {
        NotificationCenter.default.post(name: NSNotification.Name("CloseBattle"), object: nil)
    }
    
    func makeMessageWith(imageName : String){
        let message = SKSpriteNode(imageNamed: imageName)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
        self.addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
    }
}


