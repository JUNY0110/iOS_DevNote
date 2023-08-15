//
//  ViewController.swift
//  LottiePractice
//
//  Created by 지준용 on 2023/08/15.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    let animationView = LottieAnimationView(name: "MoveBean")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        self.view.addSubview(animationView)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addGesture))
        animationView.addGestureRecognizer(gestureRecognizer)

        animationView.frame = self.view.bounds
        animationView.backgroundColor = .blue
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: .repeat(3)) { finish in
            self.animationView.removeFromSuperview()
        }
    }
    
    @objc func addGesture() {
        animationView.removeFromSuperview()
    }
}

