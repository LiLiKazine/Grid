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
