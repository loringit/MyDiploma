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
        
        switch position {
        case .topLeft:
            center = CGPoint(x: (bounds.width - 10)/6, y: (bounds.height - 10)/6)
        case .top:
            center = CGPoint(x: (bounds.width - 10)/2 + 5, y: (bounds.height - 10)/6)
        case .topRight:
            center = CGPoint(x: 5 * (bounds.width - 10)/6 + 10, y: (bounds.height - 10)/6)
        case .left:
            center = CGPoint(x: (bounds.width - 10)/6, y: (bounds.height - 10)/2 + 5)
        case .center:
            center = CGPoint(x: (bounds.width - 10)/2 + 5, y: (bounds.height - 10)/2 + 5)
        case .right:
            center = CGPoint(x: 5 * (bounds.width - 10)/6 + 10, y: (bounds.height - 10)/2 + 5)
        case .bottomLeft:
            center = CGPoint(x: (bounds.width - 10)/6, y: 5 * (bounds.width - 10)/6 + 10)
        case .bottom:
            center = CGPoint(x: (bounds.width - 10)/2 + 5, y: 5 * (bounds.width - 10)/6 + 10)
        case .bottomRight:
            center = CGPoint(x: 5 * (bounds.width - 10)/6 + 10, y: 5 * (bounds.width - 10)/6 + 10)
        }
        
        radius = (bounds.width - 10)/6
        
        frame = CGRect(x: center.x, y: center.y, width: radius * 2, height: radius * 2)
        
        ring.frame = CGRect(x: center.x, y: center.y, width: radius * 2 - 6, height: radius * 2 - 6)
        ring.backgroundColor = UIColor.black
        ring.layer.cornerRadius = ring.frame.height/2
        
        circle.frame = CGRect(x: center.x, y: center.y, width: radius, height: radius)
        circle.layer.cornerRadius = ring.frame.height/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(color: UIColor) {
        backgroundColor = color
        circle.backgroundColor = color
    }
}
