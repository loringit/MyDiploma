//
//  GraphCodeView.swift
//  MyDiploma
//
//  Created by Булат Якупов on 10.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

enum DotPosition: Int {
    case topLeft = 1
    case top = 2
    case topRight = 3
    case left = 4
    case center = 5
    case right = 6
    case bottomLeft = 7
    case bottom = 8
    case bottomRight = 9
}

protocol GraphCodeViewDelegate {
    func graphCodeView(touchTime: Date, andDot: DotPosition)
    func graphCodeView(touchEndedInTime: Date, andDot: DotPosition?)
}

class GraphCodeView: UIView {
    var delegate: GraphCodeViewDelegate!
    var dots = [GraphCodeDot]()
    var path = UIBezierPath()
    var pathStarted = false
    var pathPoints = [CGPoint]()
    
    override func layoutIfNeeded() {
        if dots.isEmpty {
            for i in 1...9 {
                if let position = DotPosition(rawValue: i) {
                    let dot = GraphCodeDot(bounds: self.bounds, position: position)
                    dots.append(dot)
                    addSubview(dot)
                }
            }
            
            addConstraints([NSLayoutConstraint(item: dots[0], attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[0], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[0], attribute: .trailing, relatedBy: .equal, toItem: dots[1], attribute: .leading, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[0], attribute: .bottom, relatedBy: .equal, toItem: dots[3], attribute: .top, multiplier: 1.0, constant: 0)])
            
            addConstraints([NSLayoutConstraint(item: dots[1], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[1], attribute: .trailing, relatedBy: .equal, toItem: dots[2], attribute: .leading, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[1], attribute: .bottom, relatedBy: .equal, toItem: dots[4], attribute: .top, multiplier: 1.0, constant: 5)])
            
            addConstraints([NSLayoutConstraint(item: dots[2], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[2], attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[1], attribute: .bottom, relatedBy: .equal, toItem: dots[5], attribute: .top, multiplier: 1.0, constant: 5)])
            
            addConstraints([NSLayoutConstraint(item: dots[3], attribute: .bottom, relatedBy: .equal, toItem: dots[6], attribute: .top, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[3], attribute: .trailing, relatedBy: .equal, toItem: dots[4], attribute: .leading, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[3], attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)])
            
            addConstraints([NSLayoutConstraint(item: dots[4], attribute: .bottom, relatedBy: .equal, toItem: dots[7], attribute: .top, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[4], attribute: .trailing, relatedBy: .equal, toItem: dots[5], attribute: .leading, multiplier: 1.0, constant: 5)])
            
            addConstraints([NSLayoutConstraint(item: dots[5], attribute: .bottom, relatedBy: .equal, toItem: dots[8], attribute: .top, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[5], attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)])
            
            addConstraints([NSLayoutConstraint(item: dots[6], attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[6], attribute: .trailing, relatedBy: .equal, toItem: dots[7], attribute: .leading, multiplier: 1.0, constant: 5), NSLayoutConstraint(item: dots[3], attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)])
            
            addConstraints([NSLayoutConstraint(item: dots[7], attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[7], attribute: .trailing, relatedBy: .equal, toItem: dots[8], attribute: .leading, multiplier: 1.0, constant: 5)])
            
            addConstraints([NSLayoutConstraint(item: dots[8], attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[5], attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)])
            
            for i in 2...9 {
                dots[0].addConstraints([NSLayoutConstraint(item: dots[0], attribute: .width, relatedBy: .equal, toItem: dots[i], attribute: .width, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: dots[0], attribute: .height, relatedBy: .equal, toItem: dots[i], attribute: .height, multiplier: 1.0, constant: 0)])
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            for dot in dots {
                if touch.view!.frame.origin == dot.frame.origin {
                    dot.selected = true
                    delegate.graphCodeView(touchTime: Date(), andDot: dot.position)
                    
                    path.move(to: dot.center)
                    pathPoints.append(dot.center)
                    path.lineWidth = 5
                    UIColor.white.setStroke()
                    path.stroke()
                    pathStarted = true
                    
                    self.setNeedsDisplay()
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if pathStarted {
            for touch in touches {
                for dot in dots {
                    if touch.view!.frame.origin == dot.frame.origin {
                        dot.selected = true
                        delegate.graphCodeView(touchTime: Date(), andDot: dot.position)
                    
                        if let last = pathPoints.last {
                            if last.x != dot.center.x && last.y != dot.center.y {
                                pathPoints.append(dot.center)
                            }
                        }
                    
                        path.removeAllPoints()
                        for i in 0...(pathPoints.count - 1) {
                            let point = pathPoints[i]
                            if i == 0 {
                                path.move(to: point)
                            } else {
                                path.addLine(to: point)
                            }
                        }
                    
                        UIColor.white.setStroke()
                        path.stroke()
                    
                        self.setNeedsDisplay()
                    
                        return
                    }
                }
            
                path.removeAllPoints()
                for i in 0...(pathPoints.count - 1) {
                    let point = pathPoints[i]
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.addLine(to: touch.location(in: self))
                UIColor.white.setStroke()
                path.stroke()
            
                self.setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if pathStarted {
            for touch in touches {
                for dot in dots {
                    if touch.view!.frame.origin == dot.frame.origin {
                        dot.selected = true
                        delegate.graphCodeView(touchEndedInTime: Date(), andDot: dot.position)
                    
                        if let last = pathPoints.last {
                            if last.x != dot.center.x && last.y != dot.center.y {
                                pathPoints.append(dot.center)
                            }
                        }
                    
                        path.removeAllPoints()
                        for i in 0...(pathPoints.count - 1) {
                            let point = pathPoints[i]
                            if i == 0 {
                                path.move(to: point)
                            } else {
                                path.addLine(to: point)
                            }
                        }
                    
                        UIColor.white.setStroke()
                        path.stroke()
                    
                        self.setNeedsDisplay()
                    
                        return
                    }
                }
    
                path.removeAllPoints()
                for i in 0...(pathPoints.count - 1) {
                    let point = pathPoints[i]
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.addLine(to: touch.location(in: self))
                UIColor.white.setStroke()
                path.stroke()
            
                self.setNeedsDisplay()
            }
        }
    }
}

class GraphCodeDot: UIView {
    
    var position: DotPosition!
    var radius: CGFloat!
    var selected: Bool = false {
        didSet {
            if oldValue {
                circle.backgroundColor = UIColor.white
            } else {
                circle.backgroundColor = UIColor.clear
            }
        }
    }
    var ring = UIView()
    var circle = UIView()
    
    init(bounds: CGRect, position: DotPosition) {
        super.init(frame: CGRect.zero)
        
        self.position = position
        selected = false
        
        frame = CGRect(x: center.x, y: center.y, width: (bounds.width - 10)/3, height: (bounds.width - 10)/3)
        
        radius = (frame.width - 10)/6
        
        ring.backgroundColor = UIColor.black
        ring.layer.cornerRadius = ring.frame.height/2
        
        circle.layer.cornerRadius = ring.frame.height/2
        
        addSubview(ring)
        addSubview(circle)
        
        addConstraints([NSLayoutConstraint(item: ring, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 3), NSLayoutConstraint(item: ring, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 3), NSLayoutConstraint(item: ring, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 3), NSLayoutConstraint(item: ring, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 3), NSLayoutConstraint(item: circle, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: radius/2), NSLayoutConstraint(item: circle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: radius/2), NSLayoutConstraint(item: circle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: radius/2), NSLayoutConstraint(item: circle, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: radius/2)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(color: UIColor) {
        backgroundColor = color
        circle.backgroundColor = color
    }
}
