//
//  ShineView.swift
//  Refresh
//
//  Created by lieon on 2017/3/7.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

class ShineView: UILabel {
    var shineText: String = "fuck me" {
        didSet {
            text = shineText
        }
    }
    var state: RefrehState = .normal {
        didSet {
            switch state {
            case .normal:
                stopAnimation()
                break
            case .pulling:
                isHidden = false
               break
            case .wilRefresh:
                doAnimation()
            }
        }
    }
    
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ UIColor.red.cgColor, UIColor(white: 255, alpha: 0.5), UIColor.red.cgColor]
        gradientLayer.locations = [NSNumber(integerLiteral: 0), NSNumber(integerLiteral: Int(0.05)), NSNumber(integerLiteral: Int(0.1))]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        text = shineText
        textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        textAlignment = .center
        createShieLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createShieLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

extension ShineView {
    fileprivate func createShieLayer() {
        layer.mask = gradientLayer
        doAnimation()
    }
    
    fileprivate func doAnimation() {
        isHidden = false
        gradientLayer.removeAnimation(forKey: "slide")
        let anima = CABasicAnimation(keyPath: "locations")
        anima.fromValue = [0, 0.05, 0.1]
        anima.toValue = [0.9, 0.95, 1]
        anima.fillMode = "forwards"
        anima.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        anima.duration = 1
        anima.delegate = self
        gradientLayer.add(anima, forKey: "slide")
    }
    
    fileprivate func stopAnimation() {
         gradientLayer.removeAnimation(forKey: "slide")
        isHidden = true
    }
}

extension ShineView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            doAnimation()
        }
    }
}
