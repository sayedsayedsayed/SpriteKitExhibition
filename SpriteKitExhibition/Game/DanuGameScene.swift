//
//  DanuGameScene.swift
//  SpriteKitMania
//
//  Created by Mukhammad Miftakhul As'Adi on 01/07/23.
//

import SpriteKit
import SwiftUI
import GameController

class DanuGameScene : SKScene, SKPhysicsContactDelegate {
    
    var virtualController: GCVirtualController?
    var danuPosX : CGFloat = 0
    
    //variable char danu
    let charDanu = SKSpriteNode(imageNamed: "danu")
    
    
    //variable haptic
    var hapticGenerator: UIImpactFeedbackGenerator!
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        
        //initialize haptic
        hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        
        //initialize background
        moveBackGrounds(image: "ground_1", y: 0, z: -1, duration: 12, size: CGSize(width: size.width, height: 80))
        
        
        //initialize char danu
        charDanu.position = CGPoint(x: size.width - 150, y: size.height * 0.3)
        charDanu.zPosition = 5
        charDanu.size = CGSize(width: 150, height: 110)
        charDanu.physicsBody = SKPhysicsBody(rectangleOf: charDanu.size)
        charDanu.physicsBody?.friction = 0
        charDanu.physicsBody?.restitution = 1
        charDanu.physicsBody?.linearDamping = 0
        charDanu.physicsBody?.angularDamping = 0
        charDanu.physicsBody?.allowsRotation = true
        charDanu.physicsBody?.isDynamic = false
        addChild(charDanu)
        
        
        connectVirtualController()
        
        //initialize boundaries screen
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        self.physicsBody = frame
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
                                         GCInputButtonA,
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
        if danuPosX >= 0.5 {
            let nextPosX = charDanu.position.x + 5
                    if nextPosX + charDanu.size.width / 2 < self.size.width { // Check that Danu will be within the right bound
                        charDanu.position.x = nextPosX
                    }
            
//            charDanu.position.x += 5
        }
        
        if danuPosX <= -0.5 {
            let nextPosX = charDanu.position.x - 5
                    if nextPosX - charDanu.size.width / 2 > 0 { // Check that Danu will be within the left bound
                        charDanu.position.x = nextPosX
                    }
//            charDanu.position.x -= 5
        }
        
    }
    
}
