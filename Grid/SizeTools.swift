//
//  ImageTools.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/23.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

extension CGSize {
    
    func measureInsets(in area: CGSize) -> UIEdgeInsets {
        let x = (area.width - self.width) * 0.5
        let y = (area.height - self.height) * 0.5
        return .init(top: y, left: x, bottom: y, right: x)
    }
    
    func measureRatio(in area: CGSize) -> (ratioX: Double, ratioY: Double) {
        if area.width == 0 || area.height == 0 {
            return (0, 0)
        }
        return (Double(self.width/area.width), Double(self.height/area.height))
    }
    
}

extension UIEdgeInsets {
    var attributes: [CGFloat] {
        return [self.top, self.right, self.bottom, self.left]
    }
}

extension UIBarButtonItem {
    func centralBottom(in parent: UIView) -> CGPoint {
        guard let view = self.value(forKey: "view")  as? UIView else { return .zero }
        let origin = view.frame.origin
        let size = view.frame.size
        let point = CGPoint(x: origin.x + size.width * 0.5, y: origin.y + size.height)
        return view.convert(point, to: parent)
    }
}
