//
//  CardView.swift
//
//
//  Created by ジョナサン on 10/17/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView {
    //attributes
    var pickCount = 0
    var origIndex = Int()
    
    var shape: Card.Shapes = Card.Shapes.squiggle {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var shade: Card.Shades = Card.Shades.striped {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var color: Card.Colors = Card.Colors.purple {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var count: Int = 3 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable var isFaceUp: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable var isDeselected: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable var isMatched: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable var isMisMatched: Bool = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private func drawSquiggle() -> UIBezierPath {
        let squiggle = UIBezierPath()
        squiggle.move(to: squiggleBottomLeft)
        squiggle.addCurve(to: squiggleTopLeft, controlPoint1: squiggleControlLeftOne, controlPoint2: squiggleControlLeftTwo)
        squiggle.addArc(withCenter: squiggleTopCenter, radius: squiggleTopRadius, startAngle: CGFloat.pi, endAngle: 0.0, clockwise: true)
        squiggle.addCurve(to: squiggleBottomRight, controlPoint1: squiggleControlRightOne, controlPoint2: squiggleControlRightTwo)
        squiggle.addArc(withCenter: squiggleBottomCenter, radius: squiggleBottomRadius, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: true)
        squiggle.close()
        return squiggle
    }
    private func drawOval() -> UIBezierPath {
        let oval = UIBezierPath()
        oval.move(to: ovalBottomLeft)
        oval.addArc(withCenter: ovalTopCenter, radius: ovalTopRadius, startAngle: CGFloat.pi, endAngle: 0.0, clockwise: true)
        oval.addArc(withCenter: ovalBottomCenter, radius: ovalBottomRadius, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: true)
        oval.close()
        return oval
    }
    private func drawDiamond() -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: diamondTop)
        diamond.addLine(to: diamondRight)
        diamond.addLine(to: diamondBottom)
        diamond.addLine(to: diamondLeft)
        diamond.close()
        return diamond
    }
    
    override func draw(_ rect: CGRect){
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        roundedRect.lineWidth = 5.0
        
        if isMatched {
            UIColor.green.setStroke()
            UIColor.systemGray5.setFill()
        }
        else if isMisMatched {
            UIColor.red.setStroke()
            UIColor.systemGray5.setFill()
        }
        else if isSelected {
            UIColor.systemGray5.setFill()
            UIColor.clear.setStroke()
        }
        else if isDeselected {
            UIColor.white.setFill()
            UIColor.clear.setStroke()
        }
        else {
            UIColor.white.setFill()
            UIColor.clear.setStroke()
        }
        roundedRect.fill()
        roundedRect.stroke()
        
        if isFaceUp {
            let path = UIBezierPath()
            switch shape {
                case .squiggle:
                    path.append(drawSquiggle())
                case .oval:
                    path.append(drawOval())
                case .diamond:
                    path.append(drawDiamond())
            }
            showPath(path)
        }
        else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                cardBackImage.draw(in: bounds)
            }
        }
        
    }
    
    private func showPath(_ path: UIBezierPath) {
        var path = replicatePath(path)
        colorForPath.setStroke()
        path = shadePath(path)
        
        path.lineWidth = 2.0
        path.fill()
        path.stroke()
    }
    
    
    private func replicatePath(_ path: UIBezierPath) -> UIBezierPath {
        let replicatedPath = UIBezierPath()
        if count == 1 {
            replicatedPath.append(path)
        }
        else if count == 2 {
            let leftPath = UIBezierPath()
            leftPath.append(path)
            let leftTransform = CGAffineTransform(translationX: leftTwoPathTranslation.x, y: leftTwoPathTranslation.y)
            leftPath.apply(leftTransform)
            
            let rightPath = UIBezierPath()
            rightPath.append(path)
            let rightTransform = CGAffineTransform(translationX: rightTwoPathTranslation.x, y: rightTwoPathTranslation.y)
            rightPath.apply(rightTransform)
            replicatedPath.append(leftPath)
            replicatedPath.append(rightPath)
        }
        else if count == 3 {
            let leftPath = UIBezierPath()
            leftPath.append(path)
            let leftTransform = CGAffineTransform(translationX: leftThreePathTranslation.x, y: leftThreePathTranslation.y)
            leftPath.apply(leftTransform)
            
            let rightPath = UIBezierPath()
            rightPath.append(path)
            let rightTransform = CGAffineTransform(translationX: rightThreePathTranslation.x, y: rightThreePathTranslation.y)
            rightPath.apply(rightTransform)
            replicatedPath.append(leftPath)
            replicatedPath.append(path)
            replicatedPath.append(rightPath)
        }
        return replicatedPath
    }
    
    private func shadePath(_ path: UIBezierPath) -> UIBezierPath {
        let shadedPath = UIBezierPath()
        shadedPath.append(path)
        switch shade {
            case .filled:
                colorForPath.setFill()
            case .striped:
                UIColor.clear.setFill()
                shadedPath.addClip()
                var start = CGPoint(x: 0.0, y: 0.0)
                var end = CGPoint(x: self.bounds.size.width, y: 0.0)
                let dy: CGFloat = self.bounds.size.height / 10.0
                while start.y <= self.bounds.size.height {
                    shadedPath.move(to: start)
                    shadedPath.addLine(to: end)
                    start.y += dy//draw line straight across
                    end.y += dy
                }
            case .outlined:
                UIColor.clear.setFill()
        }
        return shadedPath
    }
    
    private var colorForPath: UIColor {
        switch color {
        case .green:
            return UIColor.green
        case .red:
            return UIColor.red
        case .purple:
            return UIColor.purple
        }
    }
    
    private var colorForFill: UIColor {
        switch color {
        case .green:
            return UIColor.green
        case .red:
            return UIColor.red
        case .purple:
            return UIColor.purple
        }
    }

}

extension CardView {
    //all the squiggle ratios & locations
    private struct SquiggleRatios {
        static let offsetPercentage:                    CGFloat = 0.20
        static let widthPercentage:                     CGFloat = 0.15
        static let controlHorizontalOffsetPercentage:   CGFloat = 0.10
        static let controlVerticalOffsetPercentage:     CGFloat = 0.40
    }
    
    private var squiggleTopLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height * SquiggleRatios.offsetPercentage)
    }
    private var squiggleBottomLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.offsetPercentage))
    }
    private var squiggleControlLeftOne: CGPoint {
        let topLeft = squiggleTopLeft
        return CGPoint(x: topLeft.x + (self.bounds.size.width * SquiggleRatios.controlHorizontalOffsetPercentage),
                       y: self.bounds.size.height * SquiggleRatios.controlVerticalOffsetPercentage)
    }
    private var squiggleControlLeftTwo: CGPoint {
        let topLeft = squiggleTopLeft
        return CGPoint(x: topLeft.x - (self.bounds.size.width * SquiggleRatios.controlHorizontalOffsetPercentage),
                       y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.controlVerticalOffsetPercentage))
    }
    private var squiggleTopRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height * SquiggleRatios.offsetPercentage)
    }
    private var squiggleBottomRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * SquiggleRatios.widthPercentage/2.0),
                       y: self.bounds.size.height - (self.bounds.size.height * SquiggleRatios.offsetPercentage))
    }
    private var squiggleControlRightOne: CGPoint {
        let controlLeftTwo = squiggleControlLeftTwo
        return CGPoint(x: controlLeftTwo.x + (self.bounds.size.width * SquiggleRatios.widthPercentage),
                       y: controlLeftTwo.y)
    }
    private var squiggleControlRightTwo: CGPoint {
        let controlLeftOne = squiggleControlLeftOne
        return CGPoint(x: controlLeftOne.x + (self.bounds.size.width * SquiggleRatios.widthPercentage),
                       y: controlLeftOne.y)
    }
    private var squiggleTopCenter: CGPoint {
        let topLeft = squiggleTopLeft
        let topRight = squiggleTopRight
        return CGPoint(x: (topLeft.x + topRight.x)/2.0,
                       y: topLeft.y)
    }
    private var squiggleBottomCenter: CGPoint {
        let bottomLeft = squiggleBottomLeft
        let bottomRight = squiggleBottomRight
        return CGPoint(x: (bottomLeft.x + bottomRight.x)/2.0,
                       y: bottomLeft.y)
    }
    private var squiggleTopRadius: CGFloat {
        let topLeft = squiggleTopLeft
        let topRight = squiggleTopRight
        return (topRight.x - topLeft.x)/2.0
    }
    private var squiggleBottomRadius: CGFloat {
        let bottomLeft = squiggleBottomLeft
        let bottomRight = squiggleBottomRight
        return (bottomRight.x - bottomLeft.x)/2.0
    }
}

extension CardView {
    private struct OvalRatios {
        static let offsetPercentage:                    CGFloat = 0.30
        static let widthPercentage:                     CGFloat = 0.15
    }
    
    private var ovalTopLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * OvalRatios.widthPercentage/2.0),
                       y: self.bounds.size.height * OvalRatios.offsetPercentage)
    }
    private var ovalBottomLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * OvalRatios.widthPercentage/2.0),
                       y: self.bounds.size.height - (self.bounds.size.height * OvalRatios.offsetPercentage))
    }
    private var ovalTopRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * OvalRatios.widthPercentage/2.0),
                       y: self.bounds.size.height * OvalRatios.offsetPercentage)
    }
    private var ovalBottomRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * OvalRatios.widthPercentage/2.0),
                       y: self.bounds.size.height - (self.bounds.size.height * OvalRatios.offsetPercentage))
    }
    private var ovalTopCenter: CGPoint {
        let topLeft = ovalTopLeft
        let topRight = ovalTopRight
        return CGPoint(x: (topLeft.x + topRight.x)/2.0,
                       y: topLeft.y)
    }
    private var ovalBottomCenter: CGPoint {
        let bottomLeft = ovalBottomLeft
        let bottomRight = ovalBottomRight
        return CGPoint(x: (bottomLeft.x + bottomRight.x)/2.0,
                       y: bottomLeft.y)
    }
    private var ovalTopRadius: CGFloat {
        let topLeft = ovalTopLeft
        let topRight = ovalTopRight
        return (topRight.x - topLeft.x)/2.0
    }
    private var ovalBottomRadius: CGFloat {
        let bottomLeft = ovalBottomLeft
        let bottomRight = ovalBottomRight
        return (bottomRight.x - bottomLeft.x)/2.0
    }
}

extension CardView {
    //all the diamond ratios & locations
    private struct DiamondRatios {
        static let offsetPercentage:                    CGFloat = 0.20
        static let widthPercentage:                     CGFloat = 0.15
    }
    
    private var diamondTop: CGPoint {
        let left = diamondLeft
        let right = diamondRight
        return CGPoint(x: (left.x + right.x)/2.0,
                       y: self.bounds.size.height * DiamondRatios.offsetPercentage)
    }
    private var diamondRight: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 + (self.bounds.size.width * DiamondRatios.widthPercentage/2.0),
                       y: self.bounds.size.height/2.0)
    }
    private var diamondBottom: CGPoint {
        let left = diamondLeft
        let right = diamondRight
        return CGPoint(x: (left.x + right.x)/2.0,
                       y: self.bounds.size.height - (self.bounds.size.height * DiamondRatios.offsetPercentage))
    }
    private var diamondLeft: CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0 - (self.bounds.size.width * DiamondRatios.widthPercentage/2.0),
                       y: self.bounds.size.height/2.0)
    }
}

extension CardView {
    //constants and ratios for path replication
    private var leftTwoPathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * -0.15, y: 0.0)
    }
    private var rightTwoPathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * 0.15, y: 0.0)
    }
    private var leftThreePathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * -0.25, y: 0.0)
    }
    private var rightThreePathTranslation: CGPoint {
        return CGPoint(x: self.bounds.size.width * 0.25, y: 0.0)
    }
}

