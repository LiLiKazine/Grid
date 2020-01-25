//
//  DropDown.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/25.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

class DropDown: UIView {

    var arrowPosition: Position = .topRight
    @IBInspectable
    var arrowSize: CGSize = .init(width: 24, height: 16)
    @IBInspectable
    var arrowOffset: CGFloat = 10
    @IBInspectable
    var cornerRadius: CGFloat = 10
    @IBInspectable
    var bgColor: UIColor = .systemGray6
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        print(rect, rect.inset(by: insets()), insets())
        var path = UIBezierPath(roundedRect: rect.inset(by: insets()), cornerRadius: cornerRadius)
        context.saveGState()
        context.addPath(path.cgPath)
        context.setFillColor(bgColor.cgColor)
        context.fillPath()
        context.restoreGState()
        path = UIBezierPath()
        path.move(to: .init(x: rect.maxX-arrowOffset, y: rect.minY+arrowSize.height))
        path.addLine(to: .init(x: rect.maxX-arrowOffset-arrowSize.width, y: rect.minY+arrowSize.height))
        path.addLine(to: .init(x: rect.maxX-arrowOffset-arrowSize.width/2, y: rect.minY))
        path.close()
        context.addPath(path.cgPath)
        context.setFillColor(bgColor.cgColor)
        context.fillPath()
        
    }
    
    private func insets() -> UIEdgeInsets {
        var edges = Array<CGFloat>(repeating: 0, count: 4)
        switch arrowPosition.rawValue/3 {
        case 0:
            edges[0] = arrowSize.height
        case 1:
            edges[1] = arrowSize.width
        case 2:
            edges[2] = arrowSize.height
        case 3:
            edges[3] = arrowSize.width
        default:
            return .zero
        }
        return .init(top: edges[0], left: edges[3], bottom: edges[2], right: edges[1])
    }
    
    enum Position: Int {
        case top = 0, topLeft, topRight,
        right, rightTop, rightBottom,
        bottom, bottomLeft, bottomRight,
        left, leftTop, leftBottom
    }

}
