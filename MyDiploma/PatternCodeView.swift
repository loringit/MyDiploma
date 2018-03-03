//
//  PatternCodeView.swift
//  MyDiploma
//
//  Created by Булат Якупов on 22.06.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class PatternCodeView: UIView {
    var dotViews = [UIView]()
    var trackPoint: CGPoint?
    
    override func draw(_ rect: CGRect) {
        if trackPoint == nil {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components = [CGFloat(0.5), CGFloat(0.5), CGFloat(0.5), CGFloat(0.8)]
        let color = CGColor(colorSpace: colorSpace, components: components)
        if let color = color {
            context?.setStrokeColor(color)
        }
        
        var from: CGPoint
        var lastDot: UIView?
        
        for dotView in dotViews {
            from = dotView.center
            print("drwaing dotview: \(dotView)")
            print("\tdrawing from: \(from.x), \(from.y)")
            if lastDot != nil {
                context?.move(to: CGPoint(x: CGFloat(from.x), y: CGFloat(from.y)))
            }
            else {
                context?.addLine(to: CGPoint(x: CGFloat(from.x), y: CGFloat(from.y)))
            }
            lastDot = dotView
        }
        
        let point = trackPoint
        if let point = point {
            print("\t to: \(point.x), \(point.y)")
            context?.addLine(to: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
            context?.strokePath()
        }
        trackPoint = nil
    }
    
    func clearDotViews() {
        dotViews.removeAll()
    }
    
    func add(dot view: UIView) {
        dotViews.append(view)
    }
    
    func drawLine(to point: CGPoint) {
        trackPoint = point
        self.setNeedsDisplay()
    }
}
