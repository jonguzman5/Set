//
//  DeckView.swift
//  Set
//
//  Created by ジョナサン on 10/17/20.
//  Copyright © 2020 ジョナサン. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DeckView: UIView {
    var animationHasBeenShown = false

    override func layoutSubviews() {
        let grid = Grid(for: self.frame, withNoOfFrames: self.subviews.count, forIdeal: 2.0)
        for index in self.subviews.indices {
            if var frame = grid[index] {
                frame.size.width -= 5
                frame.size.height -= 5
                self.subviews[index].backgroundColor = UIColor.clear
                
                if !animationHasBeenShown {
                    self.subviews[index].frame.origin.x = 0
                    self.subviews[index].frame.origin.y = self.frame.size.height
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.75,
                        delay: 0,
                        options: [.curveEaseIn],
                        animations: { self.subviews[index].frame = frame },
                        completion: { finished in
                            UIView.transition(
                                with: (self.subviews[index] as? CardView)!,
                                duration: 0.6,
                                options: .transitionFlipFromLeft,
                                animations: {
                                    (self.subviews[index] as? CardView)!.isFaceUp = !(self.subviews[index] as? CardView)!.isFaceUp
                                    self.animationHasBeenShown = true
                                }
                            )
                        }
                    )
                }
                else {
                    self.subviews[index].frame = frame
                }
            }
        }
        super.layoutSubviews()
    }

}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

