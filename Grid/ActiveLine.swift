//
//  ActiveLine.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/24.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

class ActiveLine: UIView {
    @IBInspectable var isHorizontal: Bool = true
    @IBInspectable var lineColor: UIColor = .red
//    let panSubject: 
    
    private var lineRect: CGRect?
    
    private func initView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc func panned(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            shadow(show: true)
        case .ended:
            shadow(show: false)
        default:
            break
        }
    }
    
    private func shadow(show: Bool) {
        if let lineRect = self.lineRect {
            self.layer.shadowPath = .init(rect: lineRect, transform: nil)
            self.layer.shadowColor = lineColor.cgColor
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = show ? 5 : 0
            self.layer.shadowOpacity = show ? 1 : 0
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    
    override func draw(_ rect: CGRect) {
        let width = rect.size.width
        let height = rect.size.height
        let x = isHorizontal ? 0 : (rect.minX+rect.maxX)/2-0.5
        let y = isHorizontal ? (rect.minY+rect.maxY)/2-0.5 : 0
        lineRect = CGRect(x: x, y: y, width: isHorizontal ? width : 1, height: isHorizontal ? 1 : height)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        lineColor.setFill()
        context.fill(lineRect!)
    }
    
   

}
