//
//  AchievementCircularProgressView.swift
//  govegan
//
//  Created by Mosma on 28/05/2021.
//

import UIKit

class AchievementCircularProgressView: UIView {

    // MARK: - Internal methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    // MARK: - Internal properties
    var progressLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    
    var progressColor = #colorLiteral(red: 0.1472980082, green: 0.8754438758, blue: 0.4968790412, alpha: 1) {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    var trackColor = #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 1) {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    // MARK: - Internal functions
    func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 20, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.opacity = 0.4
        trackLayer.lineWidth = 10.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0.1
        layer.addSublayer(progressLayer)
    }
}
