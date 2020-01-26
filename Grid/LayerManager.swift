//
//  LayerManager.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/25.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit
import RxSwift

class LayerManager {
    private(set) var layers: [GridView]
    private(set) var curIndex: Int = 0 {
        didSet {
            updateUserInteraction(curIndex)
        }
    }
    private(set) var colors: [UIColor]
    let removeSubject: PublishSubject<GridView>
    let selectSubject: PublishSubject<GridView>
    let cellHeight: CGFloat = 72.0
    
    init(layer: GridView) {
        layers = [layer]
        removeSubject = .init()
        selectSubject = .init()
        colors = [
            .systemRed,
            .systemYellow,
            .systemBlue,
            .systemGreen,
            .systemPurple,
            .systemOrange,
            .systemPink,
            .systemTeal,
            .systemIndigo
        ]
    }
    
    func select(at index: Int) {
        guard index < layers.count else { return }
        curIndex = index
        selectSubject.onNext(layers[index])
    }
    
    func addLayer(_ layer: GridView) {
        layers.append(layer)
        curIndex = layers.count - 1
        layer.setLineColor(colors[curIndex])
    }
    
    func addLayers(_ layers: [GridView]) {
        self.layers.append(contentsOf: layers)
        curIndex = layers.count - 1
    }
    
    func removeLayer(at index: Int) {
        let layer = layers.remove(at: index)
        removeSubject.onNext(layer)
        if index == curIndex {
            curIndex = layers.count - 1
        }
    }
    
    private func updateUserInteraction(_ selected: Int? = nil) {
        for (i, v) in layers.enumerated() {
            v.isUserInteractionEnabled = i == selected
        }
    }
    
}
