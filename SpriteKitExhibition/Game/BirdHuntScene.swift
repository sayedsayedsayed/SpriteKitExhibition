//
//  BirdHuntScene.swift
//  SpriteKitMania
//
//  Created by Sayed Zulfikar on 01/07/23.
//

import Foundation
import SpriteKit

enum Direction {
    case right
    case left
}

class BirdHuntScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    @Published var gameOver = false
    
    var timerLabel: SKLabelNode!
    var timer = Timer()
    var timeRemaining = 16 // Set the initial time remaining in seconds
    
    
    let background = SKSpriteNode(imageNamed: "birdHunt-BG")
    
    var cannon = SKSpriteNode()
    var ball = SKSpriteNode()
    var t1 = SKSpriteNode()
    var t2 = SKSpriteNode()
    var t3 = SKSpriteNode()
    var t4 = SKSpriteNode()
    var objCount = 1
    var previousPoint : CGPoint!
    
    var draggableNode: SKSpriteNode?
    private var initialPosition: CGPoint = .zero
    
    var hasShoot = false
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var scoreNameLabel = SKLabelNode()
    
    var targetLabel = SKLabelNode()
    var currentTarget = SKSpriteNode()
    
    var targetCBM = CBitMask.t1
    
    struct CBitMask {
        static let t1: UInt32 = 0b1 //1
        static let t2: UInt32 = 0b10 //2
        static let t3: UInt32 = 0b100 //4
        static let t4: UInt32 = 0b1000 //8
        static let ball: UInt32 = 0b10000 //16
        static let frame: UInt32 = 0b100000
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        background.zPosition = 1
        
        addChild(background)
        
        makeCannon()
        draggableNode = cannon
        makeTarget1()
        makeTarget2()
        makeTarget3()
        makeTarget4()
        makeLabel()
        makeCurrentTarget()
        
        let capsuleSize = CGSize(width: 60, height: 60)
        let cornerRadius: CGFloat = 25
        let capsulePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: capsuleSize), cornerRadius: cornerRadius)
        let capsuleNode = SKShapeNode(path: capsulePath.cgPath)

        capsuleNode.fillColor = .white
        capsuleNode.strokeColor = .black
        capsuleNode.lineWidth = 2.0
        capsuleNode.position = CGPoint(x: size.width * 0.5 - 31, y: size.height * 0.85 - 16)
        capsuleNode.zPosition = 10

        addChild(capsuleNode)
        timerLabel = SKLabelNode(fontNamed: "Helvetica")
        timerLabel.fontSize = 32
        timerLabel.fontColor = .red
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        timerLabel.zPosition = 11
        addChild(timerLabel)
        
        // Start the timer
        startTimer()
        
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
//        frame.friction = 0
        self.physicsBody = frame
        self.physicsBody?.categoryBitMask = CBitMask.frame
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timeRemaining -= 1
        
        // Update the timer label
        timerLabel.text = "\(timeRemaining)"
        
        if timeRemaining <= 0 {
            endGame()
        }
    }
    
    func endGame () {
//        SoundManager.instance.BirdHuntStopBGSound()
        hasShoot = true
        let delayAction = SKAction.wait(forDuration: 2.0)
        timer.invalidate()
        t1.removeAllActions()
        t2.removeAllActions()
        t3.removeAllActions()
        t4.removeAllActions()
        ball.removeAllActions()
        
        let move1 = SKAction.fadeOut(withDuration: 0.2)
        let move2 = SKAction.fadeIn(withDuration: 0.2)
        
        let action = SKAction.repeat(SKAction.sequence([move1, move2]), count: 2)
        
        let sequence = SKAction.sequence([action])
        
        t1.run(sequence)
        t2.run(sequence)
        t3.run(sequence)
        t4.run(sequence)
        
//        addChild(newFarmer)
        
        let updateAction = SKAction.run {
            // Update your variable here
            self.removeAllChildren()
            self.gameOver = true
        }
        
        let sequenceAction = SKAction.sequence([delayAction, updateAction])
        
        // Run the sequence action on a node
        let node = SKNode()
        node.run(sequenceAction)
        
        // Add the node to the scene
        addChild(node)
    }
    
    func makeLabel() {
        let capsuleSize = CGSize(width: 140, height: 50)
        let cornerRadius: CGFloat = 25
        let capsulePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: capsuleSize), cornerRadius: cornerRadius)
        let capsuleNode = SKShapeNode(path: capsulePath.cgPath)

        capsuleNode.fillColor = .white
        capsuleNode.strokeColor = .black
        capsuleNode.lineWidth = 2.0
        capsuleNode.position = CGPoint(x: 10, y: 50)
        capsuleNode.zPosition = 10

        addChild(capsuleNode)
        
        scoreNameLabel.text = "Scores:"
        scoreNameLabel.fontName = "Chalkduster"
        scoreNameLabel.fontSize = 12
        scoreNameLabel.fontColor = .black
        scoreNameLabel.position = CGPoint(x: 50, y: 70)
        
        scoreNameLabel.zPosition = 10

        addChild(scoreNameLabel)
        
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: 110, y: 60)
        
        addChild(scoreLabel)
        
        let capsuleSize2 = CGSize(width: 140, height: 80)
        let cornerRadius2: CGFloat = 25
        let capsulePath2 = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: capsuleSize2), cornerRadius: cornerRadius2)
        let capsuleNode2 = SKShapeNode(path: capsulePath2.cgPath)

        capsuleNode2.fillColor = .white
        capsuleNode2.strokeColor = .black
        capsuleNode2.lineWidth = 2.0
        capsuleNode2.position = CGPoint(x: size.width - 150, y: 40)
        capsuleNode2.zPosition = 10
        addChild(capsuleNode2)
        
        targetLabel.text = "Target:"
        targetLabel.fontName = "Chalkduster"
        targetLabel.fontSize = 12
        targetLabel.fontColor = .black
        targetLabel.zPosition = 10
        targetLabel.position = CGPoint(x: size.width - 120, y: 70)
        
        addChild(targetLabel)
        
        
    }
    
    func makeCurrentTarget() {
        
        var objName = "a"
        let rand = Int.random(in: 1...4)
        if rand == 2 {
            objName = "b"
        }
        else if rand == 3 {
            objName = "c"
        }
        else if rand == 4 {
            objName = "d"
        }
        
        currentTarget = .init(imageNamed: "\(objName)1")
        
        currentTarget.size = CGSize(width: 70, height: 70)
        
        currentTarget.position = CGPoint(x: size.width - 50, y: 80)
        currentTarget.zPosition = 10
        currentTarget.xScale = -1
        
        currentTarget.physicsBody = SKPhysicsBody(rectangleOf: currentTarget.size)
        currentTarget.physicsBody?.affectedByGravity = false
        currentTarget.physicsBody?.categoryBitMask = CBitMask.t1
        if rand == 2 {
            currentTarget.physicsBody?.categoryBitMask = CBitMask.t2
        }
        else if rand == 3 {
            currentTarget.physicsBody?.categoryBitMask = CBitMask.t3
        }
        else if rand == 4 {
            currentTarget.physicsBody?.categoryBitMask = CBitMask.t4
        }
        addChild(currentTarget)
    }
    
    func makeLostTarget(cbm: UInt32) {
        if cbm == CBitMask.t1 {
            makeTarget1()
        }
        else if cbm == CBitMask.t2 {
            makeTarget2()
        }
        else if cbm == CBitMask.t3 {
            makeTarget3()
        }
        else {
            makeTarget4()
        }
    }
    
    func updateScore(add: Bool) {
        if add && score < 10 {
            score += 1
        }
        else if !add {
            score -= 1
        }
        
        scoreLabel.text = "\(score)"
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
        
        
        //ball hit target
        if (contactA.categoryBitMask == CBitMask.t1 || contactA.categoryBitMask == CBitMask.t2 || contactA.categoryBitMask == CBitMask.t3 || contactA.categoryBitMask == CBitMask.t4) && contactB.categoryBitMask == CBitMask.ball{

            makeExplosion(contactA: contactA, contactB: contactB)
            
            contactA.node?.removeFromParent()
            contactB.node?.removeFromParent()
            
            hasShoot = false
            
            if contactA.categoryBitMask == currentTarget.physicsBody?.categoryBitMask {
                updateScore(add: true)
                
            }
            else {
                updateScore(add: false)
            }
            
            currentTarget.removeFromParent()
            makeCurrentTarget()
            makeLostTarget(cbm: contactA.categoryBitMask)
            
        }
        
        //ball hit border
        if contactA.categoryBitMask == CBitMask.ball && contactB.categoryBitMask == CBitMask.frame{
            makeExplosion(contactA: contactA, contactB: contactB)
            
            ball.removeFromParent() // Remove the ball from the scene
            hasShoot = false
            updateScore(add: false)
        }
        
    }
    
    func makeExplosion(contactA: SKPhysicsBody,contactB: SKPhysicsBody) {
        let explo = SKEmitterNode(fileNamed: "FireExplosion")
        explo?.position = contactA.node!.position
        explo?.zPosition = 5
        addChild(explo!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if a touch is on the draggable node
        if let touch = touches.first {
            previousPoint = touch.location(in: self)
            
            // Check if the touch is on the draggable node
            
        }
    }
    
    
    func makeCannon() {
        cannon = .init(imageNamed: "cannon-black")
        
        cannon.size = CGSize(width: 75, height: 150)
        
        cannon.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.1)
        
        cannon.zPosition = 10
        addChild(cannon)
    }
    
    func makeTarget1() {
        let objName = "a"
        t1 = .init(imageNamed: "\(objName)1")
        
        t1.size = CGSize(width: 75, height: 75)
        
        t1.zPosition = 10
        t1.physicsBody = SKPhysicsBody(rectangleOf: t1.size)
        t1.physicsBody?.affectedByGravity = false
        t1.physicsBody?.isDynamic = true
        t1.physicsBody?.categoryBitMask = CBitMask.t1
        t1.physicsBody?.contactTestBitMask = CBitMask.ball
        t1.physicsBody?.collisionBitMask = CBitMask.ball
        
        var startFrom: Direction = .left
        t1.position = CGPoint(x: 0.1, y: size.height/2)
        
        let rand = Int.random(in: 1...2)
        
        if rand == 1 {
            startFrom = .right
            t1.position = CGPoint(x: size.width, y: size.height/2)
        }
        
        addChild(t1)
        makeAnimation(obj: t1, objName: objName, objCount: 6)
        
        startRandomMovement(obj: t1, startFrom: startFrom)

    }
    
    func makeTarget2() {
        let objName = "b"
        t2 = .init(imageNamed: "\(objName)1")
        
        t2.size = CGSize(width: 75, height: 75)
        
        t2.zPosition = 10
        t2.physicsBody = SKPhysicsBody(rectangleOf: t2.size)
        t2.physicsBody?.affectedByGravity = false
        t2.physicsBody?.isDynamic = true
        t2.physicsBody?.categoryBitMask = CBitMask.t2
        t2.physicsBody?.contactTestBitMask = CBitMask.ball
        t2.physicsBody?.collisionBitMask = CBitMask.ball
        
        var startFrom: Direction = .left
        t2.position = CGPoint(x: 0.1, y: size.height/2)
        
        let rand = Int.random(in: 1...2)
        
        if rand == 1 {
            startFrom = .right
            t2.position = CGPoint(x: size.width, y: size.height/2)
        }
        
        addChild(t2)
        makeAnimation(obj: t2, objName: objName, objCount: 8)
        
        startRandomMovement(obj: t2, startFrom: startFrom)

    }
    
    func makeTarget3() {
        let objName = "c"
        t3 = .init(imageNamed: "\(objName)1")
        
        t3.size = CGSize(width: 75, height: 75)
        
        
        t3.zPosition = 10
        t3.physicsBody = SKPhysicsBody(rectangleOf: t3.size)
        t3.physicsBody?.affectedByGravity = false
        t3.physicsBody?.isDynamic = true
        t3.physicsBody?.categoryBitMask = CBitMask.t3
        t3.physicsBody?.contactTestBitMask = CBitMask.ball
        t3.physicsBody?.collisionBitMask = CBitMask.ball
        
        var startFrom: Direction = .left
        t3.position = CGPoint(x: 0.1, y: size.height/2)
        
        let rand = Int.random(in: 1...2)
        
        if rand == 1 {
            startFrom = .right
            t3.position = CGPoint(x: size.width, y: size.height/2)
        }
        
        addChild(t3)
        makeAnimation(obj: t3, objName: objName, objCount: 8)
        
        startRandomMovement(obj: t3, startFrom: startFrom)

    }
    
    func makeTarget4() {
        let objName = "d"
        t4 = .init(imageNamed: "\(objName)1")
        
        t4.size = CGSize(width: 75, height: 75)
        
        t4.zPosition = 10
        t4.physicsBody = SKPhysicsBody(rectangleOf: t4.size)
        t4.physicsBody?.affectedByGravity = false
        t4.physicsBody?.isDynamic = true
        t4.physicsBody?.categoryBitMask = CBitMask.t4
        t4.physicsBody?.contactTestBitMask = CBitMask.ball
        t4.physicsBody?.collisionBitMask = CBitMask.ball
        
        var startFrom: Direction = .left
        t4.position = CGPoint(x: 0.1, y: size.height/2)
        
        let rand = Int.random(in: 1...2)
        
        if rand == 1 {
            startFrom = .right
            t4.position = CGPoint(x: size.width, y: size.height/2)
        }
        
        addChild(t4)
        makeAnimation(obj: t4, objName: objName, objCount: 8)
        
        startRandomMovement(obj: t4, startFrom: startFrom)

    }
    
    private func startRandomMovement(obj: SKSpriteNode, startFrom: Direction) {
        let rand = Int.random(in: 1...5)
        let duration: TimeInterval = Double(rand) // Duration for each movement
        
        let flipHorizontalAction = SKAction.run {
            obj.xScale *= -1.0
        }
        // Create an action sequence to move the sprite randomly
        var moveAction = SKAction()
        if startFrom == .left {
            moveAction = SKAction.sequence([
                SKAction.run { [weak self] in
                    self?.moveSpriteToRandomRight(obj: obj, duration: duration)
                },
                SKAction.wait(forDuration: duration),
                flipHorizontalAction,
                SKAction.run { [weak self] in
                    self?.moveSpriteToRandomLeft(obj: obj, duration: duration)
                },
                SKAction.wait(forDuration: duration),
                flipHorizontalAction
            ])
        }
        else {
            moveAction = SKAction.sequence([
                flipHorizontalAction,
                SKAction.run { [weak self] in
                    self?.moveSpriteToRandomLeft(obj: obj, duration: duration)
                },
                SKAction.wait(forDuration: duration),
                flipHorizontalAction,
                SKAction.run { [weak self] in
                    self?.moveSpriteToRandomRight(obj: obj, duration: duration)
                },
                SKAction.wait(forDuration: duration)
            ])
        }
        
        // Repeat the action sequence forever
        let repeatAction = SKAction.repeatForever(moveAction)
        
        // Run the action on the sprite
        obj.run(repeatAction)
    }
    
    private func moveSpriteToRandomRight(obj: SKSpriteNode, duration: TimeInterval) {
        
        let minY: CGFloat = size.height/4
        let maxY: CGFloat = size.height
        
        // Generate random y coordinates within the specified range

        let randomY = CGFloat.random(in: minY...maxY)
        
        // Create an action to move the sprite to the random position
        let moveAction = SKAction.move(to: CGPoint(x: size.width, y: randomY), duration: duration)
        
        // Run the action on the sprite
        obj.run(moveAction)
    }
    
    private func moveSpriteToRandomLeft(obj: SKSpriteNode, duration: TimeInterval) {
        let minY: CGFloat = size.height/4
        let maxY: CGFloat = size.height
        
        // Generate random y coordinates within the specified range

        let randomY = CGFloat.random(in: minY...maxY)
        
        // Create an action to move the sprite to the random position
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: randomY), duration: duration)
        
        // Run the action on the sprite
        obj.run(moveAction)
    }
    
    func makeAnimation(obj: SKSpriteNode, objName: String, objCount: Int) {
        
        var objAnimation = SKAction()
        var textures:[SKTexture] = []
        for i in 1...objCount {
            textures.append(SKTexture(imageNamed: "\(objName)\(i)"))
        }
        objAnimation = SKAction.animate(with: textures, timePerFrame: 0.05)
        
        obj.run(SKAction.repeatForever(objAnimation))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = draggableNode {
            let currentPoint = touch.location(in: self)
            
            let touchLocation = touch.location(in: self)
            let distance = previousPoint.x - currentPoint.x
            
            previousPoint = currentPoint
            
            node.zRotation = node.zRotation + (distance/100.0)
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset the initial position when the touch ends
        initialPosition = .zero
        if !hasShoot {
            fireBall()
        }
    }
    
    private func fireBall() {
            
        ball = .init(imageNamed: "ball")
        ball.position = cannon.position
        ball.zPosition = 10
        ball.size = CGSize(width: 50, height: 50)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        
        ball.physicsBody?.categoryBitMask = CBitMask.ball
        ball.physicsBody?.contactTestBitMask = CBitMask.t1 | CBitMask.frame
        ball.physicsBody?.collisionBitMask = CBitMask.t1 | CBitMask.frame
        ball.zRotation = cannon.zRotation + 1.573
        
        let speed: CGFloat = 1400.0
        let dx = cos(ball.zRotation) * speed
        let dy = sin(ball.zRotation) * speed
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        
        addChild(ball)
        hasShoot = true
        
    }
}
