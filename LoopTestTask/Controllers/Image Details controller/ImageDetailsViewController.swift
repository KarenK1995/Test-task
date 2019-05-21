//
//  ImageDetailsViewController.swift
//  LoopTestTask
//
//  Created by Karen Karapetyan on 5/9/19.
//  Copyright © 2019 Karen Karapetyan. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    let minPanDistance: CGFloat = 90.0
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    var imageFrame: CGRect!
    
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: Methods
    private func initialSetup() {
        imageView.image = image
        imageView.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
        view.addGestureRecognizer(pan)
        
        imageViewHeightConstraint.constant = view.bounds.width * imageFrame.height / imageFrame.width
    }
    
    @objc func tapGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureRecognizer(_ panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: view)
        if panGesture.state == .changed {
            let translation = panGesture.translation(in: view)
            if view.center.y + translation.y > view.frame.height/2  && isVelocityDirectedVertical(velocity) {
                
                view.center.y += translation.y
                let diference = abs(view.frame.height/2 - view.center.y)
                view.alpha = 1.05 - diference/view.frame.height/2
                
//                UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
            }
        }
        else if panGesture.state == .ended {
            let diference = abs(view.frame.height/2 - view.center.y)
            if diference >= minPanDistance {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.center.y = self.view.frame.height/2 // return to initial position
                    self.view.alpha = 1
                })
//                animateCloseButton(top: false)
//                UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.slide)
            }
        }
        panGesture.setTranslation(.zero, in: view)
    }
    
    func isVelocityDirectedVertical(_ velocity: CGPoint) -> Bool {
        if abs(velocity.y) > abs(velocity.x) {
            return true
        }
        return false
    }

}
