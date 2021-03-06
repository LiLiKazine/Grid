//
//  GridMask.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/24.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit
import RxSwift

class GridMask: UIView {
    
    @IBInspectable
    var hLineColor: UIColor = UIColor.systemRed
    @IBInspectable
    var vLineColor: UIColor = UIColor.systemIndigo
    @IBInspectable
    var lineAlpha: CGFloat = 0.2
    let measureSubject: PublishSubject<Measure> = .init()
    private var horizontals: [Line] = []
    private var verticals: [Line] = []
    
    func update(lines: [Line]) {
        let hs = lines.filter{ $0.isHorizontal }
        let vs = lines.filter { !$0.isHorizontal }
        guard hs.count >= 2 && vs.count >= 2 else {
            return
        }
        horizontals = hs
        verticals = vs
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
            let h2 = horizontals.popLast(), let h1 = horizontals.popLast(),
            let v2 = verticals.popLast(), let v1 = verticals.popLast()
        else { return }
        let gapH = abs(h1.anchorOffset-h2.anchorOffset)
        let gapV = abs(v1.anchorOffset-v2.anchorOffset)
        
        var offset = h1.anchorOffset.truncatingRemainder(dividingBy: gapH)
        let top = offset
        var path = UIBezierPath()
        context.saveGState()
        while offset < rect.height {
            path.move(to: .init(x: rect.minX, y: offset))
            path.addLine(to: .init(x: rect.maxX, y: offset))
            offset += gapH
        }
        let bottom = gapH - (offset - rect.height)
        context.addPath(path.cgPath)
        context.setStrokeColor(hLineColor.withAlphaComponent(lineAlpha).cgColor)
        context.setLineWidth(1)
        context.strokePath()
        context.restoreGState()
        
        path = UIBezierPath()
        offset = v1.anchorOffset.truncatingRemainder(dividingBy: gapV)
        let left = offset
        while offset < rect.width {
            path.move(to: .init(x: offset, y: rect.minY))
            path.addLine(to: .init(x: offset, y: rect.maxY))
            offset += gapV
        }
        let right = gapV - (offset - rect.width)
        context.addPath(path.cgPath)
        context.setStrokeColor(vLineColor.withAlphaComponent(lineAlpha).cgColor)
        context.setLineWidth(1)
        context.strokePath()
        let measure = Measure(gapH: gapH, gapV: gapV, top: top, right: right, bottom: bottom, left: left)
        measureSubject.onNext(measure)
    }
    
    struct Line {
        var anchorOffset: CGFloat
        var isHorizontal: Bool
        
        var x: CGFloat {
            return isHorizontal ? 0 : anchorOffset
        }
        
        var y: CGFloat {
            return isHorizontal ? anchorOffset : 0
        }
    }
    
    struct Measure {
        var gapH: CGFloat
        var gapV: CGFloat
        var top: CGFloat
        var right: CGFloat
        var bottom: CGFloat
        var left: CGFloat
    }

}
