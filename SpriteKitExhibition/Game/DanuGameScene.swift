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

class DanuGameScene : SKScene, SKPhysicsContactDelegate {
    
    var virtualController: GCVirtualController?
    
    
    var danuPosX : CGFloat = 0
    
    
    //initialize node
    let charDanu = SKSpriteNode(imageNamed: "danu")
    let background1 = SKSpriteNode(imageNamed: "bgDanuGame")
    let background2 = SKSpriteNode(imageNamed: "bgDanuGame")
    let background3 = SKSpriteNode(imageNamed: "bgDanuGame")
    let finish = SKSpriteNode(imageNamed: "finish")
    
    //initialize camera moving
    var cam: SKCameraNode!
    
    
    struct CBitMask {
        static let finishGame: UInt32 = 0b1 //1
        static let danu: UInt32 = 0b10 //2
//        static let frame: UInt32 = 0b100 //4
    }
    
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
//        physicsWorld.gravity = .zero
        physicsWorld.gravity = CGVector(dx: 0, dy: -9)
        physicsWorld.contactDelegate = self
        
        
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
        
        //initialize char danu
//        finish.anchorPoint = CGPoint.zero
        
        finish.position.y = 95
        finish.position.x = (background1.size.width * 3) - 120
        finish.zPosition = 1
        finish.size = CGSize(width: 150, height: 110)
        finish.physicsBody = SKPhysicsBody(rectangleOf: finish.size)
        finish.physicsBody?.isDynamic = false
        finish.physicsBody?.categoryBitMask = CBitMask.finishGame
        finish.physicsBody?.contactTestBitMask = CBitMask.danu
        finish.physicsBody?.collisionBitMask = CBitMask.danu
        addChild(finish)
        
        
        //initialize char danu
        charDanu.position.y = 95
        charDanu.position.x = (size.width / 2) - 40
        charDanu.zPosition = 5
        charDanu.size = CGSize(width: 150, height: 110)
        charDanu.physicsBody = SKPhysicsBody(rectangleOf: charDanu.size)
        charDanu.physicsBody?.categoryBitMask = 1
        charDanu.physicsBody?.isDynamic = true
        charDanu.physicsBody?.allowsRotation = false
        charDanu.physicsBody?.affectedByGravity = true
        charDanu.physicsBody?.categoryBitMask = CBitMask.danu
        charDanu.physicsBody?.contactTestBitMask = CBitMask.finishGame
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
        
        
        //danu hit finish
        if (contactA.categoryBitMask == CBitMask.finishGame ) && contactB.categoryBitMask == CBitMask.danu{

            finishGame(contactA: contactA, contactB: contactB)
            
            contactA.node?.removeFromParent()
            contactB.node?.removeFromParent()
            
        }
        
    }
    
    
    func finishGame(contactA: SKPhysicsBody,contactB: SKPhysicsBody) {
        let explo = SKEmitterNode(fileNamed: "FireExplosion")
        explo?.position = contactA.node!.position
        explo?.zPosition = 5
        addChild(explo!)
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
                                         //                                         GCInputButtonA,
                                         GCInputButtonB]
        
        // Create virtual game controller
        let controller = GCVirtualController(configuration: virtualConfiguration)
        
        // Connect virtual game controller
        controller.connect()
        
        //initialize virtual controller
        virtualController = controller
    }//end of virtualcontroller
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        danuPosX = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
//        danuPosY = CGFloat((virtualController?.controller?.extendedGamepad?.buttonB.pressedChangedHandler)!)
        
        
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
                    charDanu.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 75))
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
