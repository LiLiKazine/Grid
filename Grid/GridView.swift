//
//  GridView.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/24.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit
import RxSwift

class GridView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var h1Top: NSLayoutConstraint!
    @IBOutlet weak var h2Top: NSLayoutConstraint!
    @IBOutlet weak var v1Leading: NSLayoutConstraint!
    @IBOutlet weak var v2Leading: NSLayoutConstraint!
    @IBOutlet weak var h1Line: ActiveLine!
    @IBOutlet weak var h2Line: ActiveLine!
    @IBOutlet weak var v1Line: ActiveLine!
    @IBOutlet weak var v2Line: ActiveLine!
    private let bag = DisposeBag()
    private var baseVal: CGFloat?

    private func move(_ constraint: NSLayoutConstraint, _ sender: UIPanGestureRecognizer, isHorizontal: Bool) {
        let translation = sender.translation(in: contentView)
        let offset = isHorizontal ? translation.y : translation.x
        if sender.state == .began {
            baseVal = constraint.constant
        }
        constraint.constant = offset + (baseVal ?? 0)
        if sender.state == .ended {
            baseVal = nil
        }
        contentView.layoutIfNeeded()
    }
    
    private func bindRx() {
        let pairs: [(ActiveLine, NSLayoutConstraint)] =
            [(h1Line, h1Top), (h2Line, h2Top), (v1Line, v1Leading), (v2Line, v2Leading)]
        for i in 0..<pairs.count{
            let pair = pairs[i]
            pair.0.panSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] sender in
                self?.move(pair.1, sender, isHorizontal: i<2)
            })
            .disposed(by: bag)
        }
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("GridView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        bindRx()
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
