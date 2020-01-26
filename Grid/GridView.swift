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
    typealias Line = GridMask.Line
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var gridMask: GridMask!
    @IBOutlet weak var h1Top: NSLayoutConstraint!
    @IBOutlet weak var h2Top: NSLayoutConstraint!
    @IBOutlet weak var v1Leading: NSLayoutConstraint!
    @IBOutlet weak var v2Leading: NSLayoutConstraint!
    @IBOutlet weak var h1Line: ActiveLine!
    @IBOutlet weak var h2Line: ActiveLine!
    @IBOutlet weak var v1Line: ActiveLine!
    @IBOutlet weak var v2Line: ActiveLine!
    
    let positionSubject: PublishSubject<Position> = .init()
    private(set) var lineColor: UIColor = .clear
    private let bag = DisposeBag()
    private var baseVal: CGFloat?
    
    func setLineColor(_ color: UIColor) {
        for l in [h1Line, h2Line, v1Line, v2Line] {
            l?.lineColor = color
        }
        gridMask.hLineColor = color
        gridMask.vLineColor = color
    }
    
    private func move(_ constraint: NSLayoutConstraint, _ sender: UIPanGestureRecognizer, isHorizontal: Bool) {
        let translation = sender.translation(in: contentView)
        let offset = isHorizontal ? translation.y : translation.x
        if sender.state == .began {
            baseVal = constraint.constant
        }
        constraint.constant = offset + (baseVal ?? 0)
        if sender.state == .ended {
            baseVal = nil
            updated()
        }
        contentView.layoutIfNeeded()
    }
    
    private func updated() {
        let position = Position(x1: v1Line.offset, x2: v2Line.offset, y1: h1Line.offset, y2: h2Line.offset)
        positionSubject.onNext(position)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return h1Line.frame.contains(point) ||
            h2Line.frame.contains(point) ||
            v1Line.frame.contains(point) ||
            v2Line.frame.contains(point)
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
        
        positionSubject
            .map({ position -> [Line] in
                return [
                    Line(anchorOffset: position.x1, isHorizontal: false),
                    Line(anchorOffset: position.x2, isHorizontal: false),
                    Line(anchorOffset: position.y1, isHorizontal: true),
                    Line(anchorOffset: position.y2, isHorizontal: true)
                ]
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] lines in
                self?.gridMask.update(lines: lines)
            })
            .disposed(by: bag)
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
    
    
    struct Position {
        var x1: CGFloat
        var x2:  CGFloat
        var y1: CGFloat
        var y2: CGFloat
    }
}
