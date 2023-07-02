//
//  DanuGameScene.swift
//  SpriteKitMania
//
//  Created by Mukhammad Miftakhul As'Adi on 01/07/23.
//

import SpriteKit
import SwiftUI
import GameController
import GameKit
import AVFoundation

class DanuGameScene : SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    @Published var isFinish = false
    var virtualController: GCVirtualController?
    var coinSound: AVAudioPlayer?
    var ranjauSound: AVAudioPlayer?
    
    @Published var score = 0
    @Published var life = 3
    
    var danuPosX : CGFloat = 0
    
    
    //initialize node
    let charDanu = SKSpriteNode(imageNamed: "danu")
    let background1 = SKSpriteNode(imageNamed: "bgDanuGame")
    let background2 = SKSpriteNode(imageNamed: "bgDanuGame")
    let background3 = SKSpriteNode(imageNamed: "bgDanuGame")
    let finish = SKSpriteNode(imageNamed: "finish")
    var golem1 = SKSpriteNode()
    var golem2 = SKSpriteNode()
    var golem3 = SKSpriteNode()
    var coin = SKSpriteNode()
    
    //initialize camera moving
    var cam: SKCameraNode!
    
    
    struct CBitMask {
        static let coin: UInt32 = 0b1
        static let golem1: UInt32 = 0b10
        static let golem2: UInt32 = 0b100
        static let golem3: UInt32 = 0b1000
        static let finishGame: UInt32 = 0b10000
        static let danu: UInt32 = 0b100000
    }
    
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
//        physicsWorld.gravity = .zero
        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        physicsWorld.contactDelegate = self
        
        //initialize music
        if let soundCoin = Bundle.main.url(forResource: "coin", withExtension: "mp3") {
            do {
                coinSound = try AVAudioPlayer(contentsOf: soundCoin)
                coinSound?.prepareToPlay()
            } catch {
                print("Error loading coin sound: \(error)")
            }
        }
        if let soundRanjau = Bundle.main.url(forResource: "ranjau", withExtension: "mp3") {
            do {
                ranjauSound = try AVAudioPlayer(contentsOf: soundRanjau)
                ranjauSound?.prepareToPlay()
            } catch {
                print("Error loading ranjau sound: \(error)")
            }
        }
        
        //initialize background
        //        moveBackGrounds(image: "ground_1", y: 0, z: -1, duration: 12, size: CGSize(width: size.width, height: 80))
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint.zero
        background1.size = self.size
        background1.zPosition = 1
        addChild(background1)
        
        background2.anchorPoint = CGPoint.zero
        background2.position.y = 0
        background2.position.x = background1.size.width - 5
        background2.size = self.size
        background2.zPosition = 1
        addChild(background2)
        
        background3.anchorPoint = CGPoint.zero
        background3.position.y = 0
        background3.position.x = (background1.size.width * 2) - 5
        background3.size = self.size
        background3.zPosition = 1
        addChild(background3)
        
        
        
        finish.position.y = 95
        finish.position.x = (background1.size.width * 3) - 120
        finish.zPosition = 1
        finish.size = CGSize(width: 150, height: 110)
        finish.physicsBody = SKPhysicsBody(rectangleOf: finish.size)
        finish.physicsBody?.isDynamic = false
        finish.physicsBody?.categoryBitMask = CBitMask.finishGame
        finish.physicsBody?.contactTestBitMask = CBitMask.danu
        addChild(finish)
        
        golems1()
        golems2()
        golems3()
        coins(total: 50)
        
        //initialize char danu
        charDanu.position.y = 95
        charDanu.position.x = (size.width / 2) - 40
        charDanu.zPosition = 5
        charDanu.size = CGSize(width: 70, height: 55)
        charDanu.physicsBody = SKPhysicsBody(rectangleOf: charDanu.size)
        charDanu.physicsBody?.categoryBitMask = 1
        charDanu.physicsBody?.isDynamic = true
        charDanu.physicsBody?.allowsRotation = false
        charDanu.physicsBody?.affectedByGravity = true
        charDanu.physicsBody?.categoryBitMask = CBitMask.danu
        charDanu.physicsBody?.contactTestBitMask = CBitMask.finishGame | CBitMask.coin
        charDanu.physicsBody?.collisionBitMask = CBitMask.finishGame
        addChild(charDanu)
        
        cam = SKCameraNode()
        cam.zPosition = 10
        cam.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(cam)
        camera = cam
        
        connectVirtualController()
        
        //initialize boundaries screen
        
        let extendedScreenBounds = CGRect(x: -size.width, y: -size.height, width: size.width * 4, height: size.height )
        let frame = SKPhysicsBody(edgeLoopFrom: extendedScreenBounds)
        frame.friction = 0
        self.physicsBody = frame
    }
    
    func makeAnimation(obj: SKSpriteNode, objName: String, objCount: Int) {
        
        var objAnimation = SKAction()
        var textures:[SKTexture] = []
        for i in 1...objCount {
            textures.append(SKTexture(imageNamed: "\(objName)\(i)"))
        }
        objAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
        
        obj.run(SKAction.repeatForever(objAnimation))
    }
    
    func coins(total: Int) {
        let objName = "coin"
        
        for _ in 0 ..< total {
            coin = .init(imageNamed: "\(objName)1")
            
            coin.size = CGSize(width: 40, height: 40)
            
            coin.zPosition = 10
            coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
            coin.physicsBody?.affectedByGravity = false
            coin.physicsBody?.isDynamic = true
            coin.physicsBody?.categoryBitMask = CBitMask.coin
            coin.physicsBody?.contactTestBitMask = CBitMask.danu
            coin.physicsBody?.collisionBitMask = 0
            
            let randomX = CGFloat.random(in: 0 ..< (size.width * 3))
            let randomY = CGFloat.random(in: 0 ..< (size.height * 0.8) )
            coin.position = CGPoint(x: randomX, y: randomY)
            
            
            addChild(coin)
            makeAnimation(obj: coin, objName: objName, objCount: 7)
        }
    }
    
    func golems1() {
        let objName = "golem"
        golem1 = .init(imageNamed: "\(objName)1")
        
        golem1.size = CGSize(width: 140, height: 140)
        
        golem1.zPosition = 10
        golem1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: golem1.size.width / 2, height: golem1.size.height / 2))
        golem1.physicsBody?.affectedByGravity = false
        golem1.physicsBody?.isDynamic = true
        golem1.physicsBody?.categoryBitMask = CBitMask.golem1
        golem1.physicsBody?.contactTestBitMask = CBitMask.danu
        golem1.physicsBody?.collisionBitMask = 0
        
        golem1.position = CGPoint(x: (background1.size.width ) - 120, y: 45)
        
        
        addChild(golem1)
        makeAnimation(obj: golem1, objName: objName, objCount: 7)
        
    }
    
    func golems2() {
        let objName = "golem"
        golem2 = .init(imageNamed: "\(objName)1")
        
        golem2.size = CGSize(width: 175, height: 175)
        
        golem2.zPosition = 10
        golem2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: golem2.size.width / 2, height: golem2.size.height / 2))
        golem2.physicsBody?.affectedByGravity = false
        golem2.physicsBody?.isDynamic = true
        golem2.physicsBody?.categoryBitMask = CBitMask.golem2
        golem2.physicsBody?.contactTestBitMask = CBitMask.danu
        golem2.physicsBody?.collisionBitMask = 0
        
        golem2.position = CGPoint(x: (background1.size.width * 1) + 420, y: 45)
        
        
        addChild(golem2)
        makeAnimation(obj: golem2, objName: objName, objCount: 7)
        
    }
    
    func golems3() {
        let objName = "golem"
        golem3 = .init(imageNamed: "\(objName)1")
        
        golem3.size = CGSize(width: 220, height: 220)
        
        golem3.zPosition = 10
        golem3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: golem3.size.width / 2, height: golem3.size.height / 2))
        golem3.physicsBody?.affectedByGravity = false
        golem3.physicsBody?.isDynamic = true
        golem3.physicsBody?.categoryBitMask = CBitMask.golem3
        golem3.physicsBody?.contactTestBitMask = CBitMask.danu
        golem3.physicsBody?.collisionBitMask = 0
        
        golem3.position = CGPoint(x: (background1.size.width * 2) + 220, y: 45)
        
        
        addChild(golem3)
        makeAnimation(obj: golem3, objName: objName, objCount: 7)
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA : SKPhysicsBody
        let contactB : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
            
        }
        else{
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        //danu hit coin
        if (contactA.categoryBitMask == CBitMask.coin ) && contactB.categoryBitMask == CBitMask.danu{

            
            coinSound?.play()
            contactA.node?.removeFromParent()
            score += 1
        }
        
        //danu hit ranjau
        if (contactA.categoryBitMask == CBitMask.golem1 || contactA.categoryBitMask == CBitMask.golem2 || contactA.categoryBitMask == CBitMask.golem3 ) && contactB.categoryBitMask == CBitMask.danu{

            
            ranjauSound?.play()
//            contactA.node?.removeFromParent()
            life -= 1
            
            if life == 0 {
                reset()
                isFinish = true
            }
        }
        
        //danu hit finish
        if (contactA.categoryBitMask == CBitMask.finishGame ) && contactB.categoryBitMask == CBitMask.danu{

            finishGame(contactA: contactA, contactB: contactB)
            
            contactA.node?.removeFromParent()
            contactB.node?.removeFromParent()
            reset()
            isFinish = true
        }
        
    }
    
    
    func finishGame(contactA: SKPhysicsBody,contactB: SKPhysicsBody) {
        let explo = SKEmitterNode(fileNamed: "FireExplosion")
        explo?.position = contactA.node!.position
        explo?.zPosition = 5
        addChild(explo!)
        
    }
    
    func reset() {
            // Reset the game state
            isFinish = false

            // Disconnect and destroy the old controller
            virtualController?.disconnect()
            virtualController = nil

            // Clear out all nodes
            removeAllChildren()
            removeAllActions()

            // Reinitialize everything as necessary
            didMove(to: view!)
            connectVirtualController()
        }
    
    //function to create infinite background
    func moveBackGrounds(image: String, y: CGFloat, z: CGFloat, duration: Double, size: CGSize) {
        for i in 0...1 {
            //initialize image
            let node = SKSpriteNode(imageNamed: image)
            
            node.anchorPoint = .zero
            node.position = CGPoint(x: size.width * CGFloat(i), y: y)
            node.size = size
            node.zPosition = z
            
            //initialize animation
            let move = SKAction.moveBy(x: -node.size.width, y: 0, duration: duration)
            let wrap = SKAction.moveBy(x: node.size.width, y: 0, duration: 0)
            let sequence = SKAction.sequence([move, wrap])
            let immer = SKAction.repeatForever(sequence)
            node.run(immer)
            addChild(node)
        }
    }//end of moveBackground
    
    //connecting to virtualcontroller
    func connectVirtualController() {
        // Create virtual game controller configuration
        let virtualConfiguration = GCVirtualController.Configuration()
        virtualConfiguration.elements = [GCInputLeftThumbstick,
                                         GCInputButtonB]
        
        // Create virtual game controller
        let controller = GCVirtualController(configuration: virtualConfiguration)
        
        // Connect virtual game controller
        controller.connect()
        
        //initialize virtual controller
        virtualController = controller
    }//end of virtualcontroller
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        danuPosX = CGFloat(virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0)
        
        if danuPosX >= 0.5 {
            let nextPosX = charDanu.position.x + 5
            if nextPosX + charDanu.size.width / 2 < (background1.size.width * 3) { // Check that Danu will be within the right bound
                charDanu.position.x = nextPosX
                print("x: \(charDanu.position.x)")
                print("y: \(charDanu.position.y)")
            }
            //            charDanu.position.x += 5
        }
        
        if danuPosX <= -0.5 {
            let nextPosX = charDanu.position.x - 5
            if nextPosX - charDanu.size.width / 2 > 0 { // Check that Danu will be within the left bound
                charDanu.position.x = nextPosX
                print("x: \(charDanu.position.x)")
                print("y: \(charDanu.position.y)")
            }
            //            charDanu.position.x -= 5
        }
        
        // Make Danu jump if B button is pressed
        if charDanu.position.y <= 105 {
        if let buttonB = virtualController?.controller?.extendedGamepad?.buttonB {
                if buttonB.isPressed && charDanu.action(forKey: "jump") == nil {
                    // Apply upward impulse for jumping
                    charDanu.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
                }
            }
        }
       
        
        // Calculate the minimum and maximum allowed position for the camera
        let minCameraPos = self.size.width / 2
        let maxCameraPos = (background1.size.width * 3) - (self.size.width / 2)
        
        // Set the camera's position to track charDanu, but constrain it within the min and max range
        cam.position.x = min(max(charDanu.position.x, minCameraPos), maxCameraPos)
        

    }//end of update func
    
    
    
}
