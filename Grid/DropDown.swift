//
//  DropDown.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/25.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit
import RxSwift

class DropDown: UIView {

    @IBOutlet weak var layersCollection: UICollectionView!
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    var arrowPosition: Position = .topRight
    @IBInspectable
    var arrowSize: CGSize = .init(width: 24, height: 16)
    @IBInspectable
    var arrowOffset: CGFloat = 10
    @IBInspectable
    var cornerRadius: CGFloat = 10
    @IBInspectable
    var bgColor: UIColor = .systemGray6
    
    var point: CGPoint {
        return .init(x: frame.maxX - frame.minX - arrowOffset - arrowSize.width * 0.5, y: frame.minY)
    }
    
    let removeSubject: PublishSubject<Int> = .init()
    private(set) var layers: [String] = []
    
    func setLayers(_ layers: [String]) {
        self.layers = layers
        layersCollection.reloadData()
    }
    
    func removeLayer(at index: Int) {
        if index < layers.count {
            let _ = layers.remove(at: index)
            layersCollection.reloadData()
            removeSubject.onNext(index)
        }
    }
    
    override func draw(_ rect: CGRect) {
        collectionTopConstraint.constant = arrowSize.height
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        var path = UIBezierPath(roundedRect: rect.inset(by: insets()), cornerRadius: cornerRadius)
        context.saveGState()
        context.addPath(path.cgPath)
        context.setFillColor(bgColor.cgColor)
        context.fillPath()
        context.restoreGState()
        path = UIBezierPath()
        path.move(to: .init(x: rect.maxX-rect.minX-arrowOffset, y: rect.minY+arrowSize.height))
        path.addLine(to: .init(x: rect.maxX-rect.minX-arrowOffset-arrowSize.width, y: rect.minY+arrowSize.height))
        path.addLine(to: .init(x: rect.maxX-rect.minX-arrowOffset-arrowSize.width/2, y: rect.minY))
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

extension DropDown: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "layer", for: indexPath) as! LayerCollectionCell
        let i = indexPath.row
        cell.setup(i, name: layers[i]) { [weak self] in
            self?.removeLayer(at: i)
        }
        return cell
    }
    
    
}
