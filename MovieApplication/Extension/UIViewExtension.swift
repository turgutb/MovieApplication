//
//  UIViewExtension.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    private var gradient: CAGradientLayer?
    
    override func layoutSubviews() {
        installGradient()
        updateGradient()
    }
    
    private func installGradient() {
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }
    
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
    }
    
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        print(gradient.frame)
        return gradient
    }
    
}
