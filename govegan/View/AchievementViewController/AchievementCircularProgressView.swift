//
//  AchievementCircularProgressView.swift
//  govegan
//
//  Created by Mosma on 28/05/2021.
//

import UIKit

class AchievementCircularProgressView: UIView {
    
    // MARK: - Internal properties
    var progressLayer = CAShapeLayer()
    
    // MARK: - Internal methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    // MARK: - Private methods
    
    /// Performs the initial configuration of the layer
    private func setupLayer(layer: CAShapeLayer, _ circlePath: UIBezierPath, strokeColor: CGColor, opacity: Float, strokeEnd: CGFloat) {
        layer.actions = ["strokeEnd" : NSNull()]
        layer.path = circlePath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokeColor
        layer.opacity = opacity
        layer.lineWidth = 10.0
        layer.strokeEnd = strokeEnd
        self.layer.addSublayer(layer)
    }
    
    /// Create the circle path
    private func createCircularPath() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = frame.size.width / 2
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 20, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        setupLayer(layer: trackLayer, circlePath, strokeColor: #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 1), opacity: 0.4, strokeEnd: 1.0)
        setupLayer(layer: progressLayer, circlePath, strokeColor: #colorLiteral(red: 0.1472980082, green: 0.8754438758, blue: 0.4968790412, alpha: 1), opacity: 1.0, strokeEnd: 0.1)
    }
    
    // MARK: - Private properties
    private var trackLayer = CAShapeLayer()
}
