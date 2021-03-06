//
//  LerpingMovementComponent.swift
//  glide
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import GameplayKit

/// Component that is used to move its entity via interpolating the distance between
/// entity's current position and a given target position.
/// This movement component manipulates the transform position directly.
public final class LerpingMovementComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 860
    
    /// Speed of the movement in points/s.
    public let speed: CGFloat
    /// Target point to reach, can be set dynamically.
    public var targetPoint: CGPoint?
    
    public init(speed: CGFloat) {
        self.speed = speed
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        guard
            let transform = transform,
            let targetPoint = targetPoint
        else {
            return
        }
        
        let lerpingTime = CGFloat(seconds) * speed
        
        /// Because of rounding floating pixels in the engine, we might never be able to
        /// change the current position, this is a safety against this behavior.
        var numberOfTries = 10
        var newLerped = transform.currentPosition.lerp(destination: targetPoint,
                                                       time: lerpingTime)
        var lerped = CGPoint(x: newLerped.x.glideRound, y: newLerped.y.glideRound)
        while lerped == transform.currentPosition, numberOfTries >= 0 {
            newLerped = newLerped.lerp(destination: targetPoint,
                                       time: lerpingTime)
            lerped = CGPoint(x: newLerped.x.glideRound, y: newLerped.y.glideRound)
            numberOfTries -= 1
        }
        transform.proposedPosition = newLerped
    }
}
