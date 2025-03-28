//
//  GameScene.swift
//  twothree
//
//  Created by Sunil Kamat on 3/27/25.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    private var launcher: SKShapeNode!
    private var launcherPipe: SKShapeNode!
    private var motionManager: CMMotionManager!
    private var scoreLabel: SKLabelNode!
    private var score: Int = 0
    private var gameOverLabel: SKLabelNode?
    private var playAgainButton: SKLabelNode?
    private var nameInputField: UITextField?
    private var highScoresLabel: SKLabelNode?
    private var maxHeightLine: SKShapeNode!
    private var maxHeight: CGFloat = 0
    private var leftTouchIndicator: SKShapeNode!
    private var rightTouchIndicator: SKShapeNode!
    
    // Physics categories
    private let launcherCategory: UInt32 = 0x1 << 0
    private let numberBlockCategory: UInt32 = 0x1 << 1
    private let projectileCategory: UInt32 = 0x1 << 2
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupPhysicsWorld()
        setupMaxHeightLine()
        setupTouchIndicators()
        setupLauncher()
        setupScoreLabel()
        setupMotionManager()
        startSpawningNumberBlocks()
    }
    
    private func setupPhysicsWorld() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.05)
    }
    
    private func setupMaxHeightLine() {
        // Calculate max height (75% from bottom)
        maxHeight = frame.height * 0.75
        
        // Create the line
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: maxHeight))
        path.addLine(to: CGPoint(x: frame.width, y: maxHeight))
        
        maxHeightLine = SKShapeNode(path: path)
        maxHeightLine.strokeColor = .white
        maxHeightLine.lineWidth = 1
        maxHeightLine.alpha = 0.5  // Make it semi-transparent
        addChild(maxHeightLine)
    }
    
    private func setupTouchIndicators() {
        // Create left indicator (number 2)
        leftTouchIndicator = SKShapeNode(circleOfRadius: 40)
        leftTouchIndicator.fillColor = .white
        leftTouchIndicator.strokeColor = .white
        leftTouchIndicator.alpha = 0.2
        leftTouchIndicator.position = CGPoint(x: frame.width * 0.25, y: frame.height * 0.2)
        
        let leftLabel = SKLabelNode(fontNamed: "Arial")
        leftLabel.text = "2"
        leftLabel.fontSize = 48
        leftLabel.fontColor = .white
        leftLabel.alpha = 0.4
        leftLabel.verticalAlignmentMode = .center
        leftTouchIndicator.addChild(leftLabel)
        
        // Create right indicator (number 3)
        rightTouchIndicator = SKShapeNode(circleOfRadius: 40)
        rightTouchIndicator.fillColor = .white
        rightTouchIndicator.strokeColor = .white
        rightTouchIndicator.alpha = 0.2
        rightTouchIndicator.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.2)
        
        let rightLabel = SKLabelNode(fontNamed: "Arial")
        rightLabel.text = "3"
        rightLabel.fontSize = 48
        rightLabel.fontColor = .white
        rightLabel.alpha = 0.4
        rightLabel.verticalAlignmentMode = .center
        rightTouchIndicator.addChild(rightLabel)
        
        addChild(leftTouchIndicator)
        addChild(rightTouchIndicator)
    }
    
    private func setupLauncher() {
        // Create semi-circular base
        let baseRadius: CGFloat = 40
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: 0, y: 0),
                   radius: baseRadius,
                   startAngle: 0,
                   endAngle: CGFloat.pi,
                   clockwise: false)
        path.addLine(to: CGPoint(x: -baseRadius, y: 0))
        path.closeSubpath()
        
        launcher = SKShapeNode(path: path)
        launcher.fillColor = .blue
        launcher.strokeColor = .white
        launcher.lineWidth = 2
        launcher.position = CGPoint(x: frame.midX, y: 50)
        launcher.physicsBody = SKPhysicsBody(polygonFrom: path)
        launcher.physicsBody?.isDynamic = false
        launcher.physicsBody?.categoryBitMask = launcherCategory
        addChild(launcher)
        
        // Create launcher pipe (nozzle)
        launcherPipe = SKShapeNode(rectOf: CGSize(width: 10, height: 60))  // thin and long rectangle
        launcherPipe.fillColor = .blue
        launcherPipe.strokeColor = .white
        launcherPipe.lineWidth = 2
        launcherPipe.position = CGPoint(x: 0, y: 30)  // Position above the base center
        launcherPipe.zRotation = 0  // Start pointing straight up
        launcher.addChild(launcherPipe)
    }
    
    private func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 24
        scoreLabel.horizontalAlignmentMode = .right  // Align text to the right
        // Position in top right with padding for notch/pill
        scoreLabel.position = CGPoint(x: frame.maxX - 20, y: frame.maxY - 80)
        addChild(scoreLabel)
    }
    
    private func setupMotionManager() {
        motionManager = CMMotionManager()
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let motion = motion else { return }
                let rotation = motion.attitude.roll
                let degrees = rotation * 180 / CGFloat.pi
                // Clamp between -45 and 45 degrees from vertical
                let clampedDegrees = max(-45, min(45, -degrees))  // Added negative sign back
                self?.launcherPipe.zRotation = clampedDegrees * CGFloat.pi / 180  // Removed the 90-degree offset
            }
        }
    }
    
    // MARK: - Game Logic
    private func startSpawningNumberBlocks() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnNumberBlock()
        }
        let waitAction = SKAction.wait(forDuration: 5.0)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(sequence))
    }
    
    private func spawnNumberBlock() {
        let number = Int.random(in: 2...25)
        let shape: SKShapeNode
        let size: CGSize
        
        // Determine block size based on number
        switch number {
        case 2...9:
            size = CGSize(width: 30, height: 30)
        case 10...15:
            size = CGSize(width: 40, height: 40)
        case 16...20:
            size = CGSize(width: 50, height: 50)
        default: // 21...25
            size = CGSize(width: 60, height: 60)
        }
        
        if number < 10 {
            shape = SKShapeNode(rectOf: size)
        } else {
            shape = SKShapeNode(path: createPentagonPath(size: size))
        }
        
        shape.fillColor = .red
        shape.strokeColor = .red
        shape.position = CGPoint(x: CGFloat.random(in: 50...frame.maxX-50), y: frame.maxY)
        shape.name = "numberBlock"
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "\(number)"
        label.fontSize = size.width * 0.5 // Adjust font size based on block size
        label.verticalAlignmentMode = .center
        shape.addChild(label)
        
        shape.physicsBody = SKPhysicsBody(polygonFrom: shape.path!)
        shape.physicsBody?.categoryBitMask = numberBlockCategory
        shape.physicsBody?.contactTestBitMask = projectileCategory
        shape.physicsBody?.collisionBitMask = 0  // Add this to prevent collision physics
        shape.physicsBody?.allowsRotation = false  // Add this to prevent rotation
        
        addChild(shape)
    }
    
    private func createPentagonPath(size: CGSize) -> CGPath {
        let path = CGMutablePath()
        let radius = size.width / 2
        let center = CGPoint(x: 0, y: 0)
        
        for i in 0..<5 {
            let angle = CGFloat(i) * 2 * CGFloat.pi / 5
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }

    private func shootNumber(_ number: Int) {
        let projectile = SKShapeNode(circleOfRadius: 12)
        projectile.fillColor = .yellow
        projectile.strokeColor = .yellow
        projectile.name = "projectile"
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "\(number)"
        label.fontSize = 16
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        projectile.addChild(label)
        
        // Get the angle of the launcher pipe
        let angle = launcherPipe.zRotation
        
        // Calculate the position at the top end of the launcher pipe
        let pipeLength: CGFloat = 60  // Full length of the pipe
        let spawnX = launcher.position.x + sin(angle) * pipeLength
        let spawnY = launcher.position.y + cos(angle) * pipeLength
        projectile.position = CGPoint(x: spawnX, y: spawnY)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        projectile.physicsBody?.categoryBitMask = projectileCategory
        projectile.physicsBody?.contactTestBitMask = numberBlockCategory
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.isDynamic = true
        
        // Calculate velocity for shooting in the nozzle's direction
        let speed: CGFloat = 150
        let velocityX = sin(angle) * speed
        let velocityY = cos(angle) * speed
        projectile.physicsBody?.velocity = CGVector(dx: velocityX, dy: velocityY)
        
        addChild(projectile)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Remove projectiles that have gone off screen
        enumerateChildNodes(withName: "projectile") { node, _ in
            if !self.frame.intersects(node.frame) {
                node.removeFromParent()
            }
        }
        
        // Check for blocks that have passed the launcher
        enumerateChildNodes(withName: "numberBlock") { node, _ in
            if let block = node as? SKShapeNode,
               block.position.y < self.launcher.position.y {
                // Block has passed the launcher
                self.moveLauncherUp()
                block.removeFromParent()
            }
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if gameOverLabel != nil {
            handleGameOverTouch(at: location)
            return
        }
        
        if location.x < frame.midX {
            shootNumber(2)
        } else {
            shootNumber(3)
        }
    }
    
    private func handleGameOverTouch(at location: CGPoint) {
        if let playAgainButton = playAgainButton,
           playAgainButton.contains(location) {
            restartGame()
        }
    }
    
    // MARK: - Collision Handling
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (projectileCategory | numberBlockCategory) {
            let projectile = contact.bodyA.categoryBitMask == projectileCategory ? contact.bodyA.node : contact.bodyB.node
            let block = contact.bodyA.categoryBitMask == numberBlockCategory ? contact.bodyA.node : contact.bodyB.node
            
            if let projectile = projectile as? SKShapeNode,
               let block = block as? SKShapeNode,
               let projectileLabel = projectile.children.first as? SKLabelNode,
               let blockLabel = block.children.first as? SKLabelNode,
               let projectileNumber = Int(projectileLabel.text ?? ""),
               let blockNumber = Int(blockLabel.text ?? "") {
                
                let newNumber = blockNumber - projectileNumber
                
                // Add the subtracted value to the score
                score += projectileNumber
                
                if newNumber <= 0 {
                    // Add bonus points for perfect zero
                    if newNumber == 0 {
                        score += 10  // Bonus points for perfect zero
                    }
                    
                    block.removeFromParent()
                    
                    if newNumber < 0 {
                        moveLauncherUp()
                    }
                } else {
                    blockLabel.text = "\(newNumber)"
                    // Ensure block maintains its downward motion
                    block.physicsBody?.velocity = CGVector(dx: 0, dy: block.physicsBody?.velocity.dy ?? 0)
                }
                
                scoreLabel.text = "Score: \(score)"
                // Remove only the projectile
                projectile.removeFromParent()
            }
        }
    }
    
    private func moveLauncherUp() {
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        launcher.run(moveUp) {
            // Check if any part of the launcher (base + pipe) has reached the max height
            let baseHeight: CGFloat = 40  // Semi-circle radius
            let pipeHeight: CGFloat = 60  // Rectangle width (which is the height when rotated)
            let totalHeight = baseHeight + pipeHeight
            
            if self.launcher.position.y + totalHeight/2 >= self.maxHeight {
                self.gameOver()
            }
        }
    }
    
    // MARK: - Game Over
    private func gameOver() {
        isPaused = true
        
        gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameOverLabel?.text = "Game Over! Score: \(score)"
        gameOverLabel?.fontSize = 32
        gameOverLabel?.position = CGPoint(x: frame.midX, y: frame.maxY - 300)
        addChild(gameOverLabel!)
        
        playAgainButton = SKLabelNode(fontNamed: "Arial")
        playAgainButton?.text = "Play Again"
        playAgainButton?.fontSize = 24
        playAgainButton?.position = CGPoint(x: frame.midX, y: frame.maxY - 350)
        addChild(playAgainButton!)
        
        updateHighScores()
    }
    
    private func updateHighScores() {
        var highScores = UserDefaults.standard.array(forKey: "HighScores") as? [[String: Any]] ?? []
        highScores.append(["score": score, "name": "Player 1"])
        highScores.sort { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
        highScores = Array(highScores.prefix(5))
        UserDefaults.standard.set(highScores, forKey: "HighScores")
        
        displayHighScores(highScores)
    }
    
    private func displayHighScores(_ scores: [[String: Any]]) {
        highScoresLabel = SKLabelNode(fontNamed: "Arial")
        highScoresLabel?.text = "High Scores:\n" + scores.enumerated().map { index, score in
            let name = score["name"] as? String ?? "Player 1"
            let scoreValue = score["score"] as? Int ?? 0
            return "\(index + 1). \(name): \(scoreValue)"
        }.joined(separator: "\n")
        highScoresLabel?.fontSize = 20
        highScoresLabel?.position = CGPoint(x: frame.midX, y: frame.maxY - 550)
        highScoresLabel?.numberOfLines = 0
        addChild(highScoresLabel!)
    }
    
    private func restartGame() {
        // Remove all existing nodes
        removeAllChildren()
        
        // Reset game state
        score = 0
        isPaused = false
        
        // Reset all properties to nil
        launcher = nil
        launcherPipe = nil
        motionManager = nil
        scoreLabel = nil
        gameOverLabel = nil
        playAgainButton = nil
        nameInputField = nil
        highScoresLabel = nil
        maxHeightLine = nil
        leftTouchIndicator = nil
        rightTouchIndicator = nil
        
        // Reinitialize physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.05)
        
        // Recreate all game elements
        setupMaxHeightLine()
        setupTouchIndicators()
        setupLauncher()
        setupScoreLabel()
        setupMotionManager()
        
        // Start spawning blocks again
        startSpawningNumberBlocks()
    }
}
