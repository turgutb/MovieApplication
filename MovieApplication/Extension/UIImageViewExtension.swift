//
//  GradientImageView.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation
import UIKit
import Kingfisher


@IBDesignable
class GradientImageView: UIImageView{
    
    @IBInspectable var startColor: UIColor? = UIColor(named: "GradientStart") {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor? = UIColor(named: "GradientEnd") {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var gradientAlpha: CGFloat = 0.4{
        didSet {
            updateGradient()
        }
    }
    
    private var gradientView: GradientView?
    
    override func layoutSubviews() {
        installGradient()
        updateGradient()
    }
    
    func installGradient(){
        if gradientView == nil{
            gradientView = GradientView(frame: self.bounds)
            addSubview(gradientView!)
            bringSubviewToFront(gradientView!)
        }
    }
    
    func updateGradient() {
        gradientView?.startColor = startColor
        gradientView?.endColor = endColor
        gradientView?.alpha = gradientAlpha
    }
    
}
