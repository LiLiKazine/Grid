//
//  GridView.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/24.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

class GridView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var h1Top: NSLayoutConstraint!
    @IBOutlet weak var h2Top: NSLayoutConstraint!
    @IBOutlet weak var v1Leading: NSLayoutConstraint!
    @IBOutlet weak var v2Leading: NSLayoutConstraint!
    
    
    @IBAction func panned(_ sender: UIPanGestureRecognizer) {
//        switch sender.state {
//        case .began:
//            <#code#>
//        case .ended
//        default:
//            <#code#>
//        }
        let offsetY = sender.translation(in: contentView).y
        h1Top.constant = offsetY
        contentView.layoutIfNeeded()
    }
    
    
    private func initView() {
        Bundle.main.loadNibNamed("GridView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
