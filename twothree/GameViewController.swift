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
        
        // Create title label with gradient effect
        let titleLabel = UILabel()
        titleLabel.text = "TwoThree"
        titleLabel.font = .systemFont(ofSize: 48, weight: .heavy)
        titleLabel.textColor = .systemYellow
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.5
        launchScreen.addSubview(titleLabel)
        
        // Create subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "A Mathematical Adventure"
        subtitleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        subtitleLabel.textColor = .systemOrange
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.layer.shadowColor = UIColor.white.cgColor
        subtitleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        subtitleLabel.layer.shadowRadius = 2
        subtitleLabel.layer.shadowOpacity = 0.3
        launchScreen.addSubview(subtitleLabel)
        
        // Create credits label
        let creditsLabel = UILabel()
        creditsLabel.text = "Game by: Sunil, Narain and Mira"
        creditsLabel.font = .systemFont(ofSize: 18, weight: .regular)
        creditsLabel.textColor = .systemGreen
        creditsLabel.textAlignment = .center
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        creditsLabel.layer.shadowColor = UIColor.white.cgColor
        creditsLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        creditsLabel.layer.shadowRadius = 2
        creditsLabel.layer.shadowOpacity = 0.3
        launchScreen.addSubview(creditsLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: launchScreen.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: launchScreen.centerYAnchor, constant: -50),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.centerXAnchor.constraint(equalTo: launchScreen.centerXAnchor),
            
            creditsLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
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
