//
//  GameViewController.swift
//  twothree
//
//  Created by Sunil Kamat on 3/27/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private var launchScreenView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create launch screen
        createLaunchScreen()
        
        if let view = self.view as! SKView? {
            // Create and configure the scene
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            // Present the scene immediately
            view.presentScene(scene)
            
            // Add a delay before starting the game and removing launch screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Start the game
                scene.startGame()
                // Remove launch screen with animation
                UIView.animate(withDuration: 0.5, animations: {
                    self.launchScreenView?.alpha = 0
                }) { _ in
                    self.launchScreenView?.removeFromSuperview()
                    self.launchScreenView = nil
                }
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    private func createLaunchScreen() {
        // Create launch screen view
        let launchScreen = UIView(frame: view.bounds)
        launchScreen.backgroundColor = .black
        
        // Add background image
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "LaunchScreen")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        launchScreen.addSubview(backgroundImage)
        
        // Add a semi-transparent overlay to ensure text readability
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        launchScreen.addSubview(overlay)
        
        // Create title label
        let titleLabel = UILabel()
        titleLabel.text = "TwoThree"
        titleLabel.font = .systemFont(ofSize: 60, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        launchScreen.addSubview(titleLabel)
        
        // Create subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "A Mathematical Adventure"
        subtitleLabel.font = .systemFont(ofSize: 18)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        launchScreen.addSubview(subtitleLabel)
        
        // Create credits label
        let creditsLabel = UILabel()
        creditsLabel.text = "Game by: Sunil, Narain and Mira"
        creditsLabel.font = .systemFont(ofSize: 12)
        creditsLabel.textColor = .lightGray
        creditsLabel.textAlignment = .center
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        launchScreen.addSubview(creditsLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: launchScreen.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: launchScreen.centerYAnchor, constant: -250),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: launchScreen.centerXAnchor),
            
            creditsLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            creditsLabel.centerXAnchor.constraint(equalTo: launchScreen.centerXAnchor)
        ])
        
        // Add launch screen to view
        view.addSubview(launchScreen)
        launchScreenView = launchScreen
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
