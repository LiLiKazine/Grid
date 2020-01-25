//
//  LayerManager.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/25.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

class LayerManager {
    private(set) var layers: [GridView]
    private(set) var curIndex: Int?
    let cellHeight: CGFloat = 72.0
    
    init(layer: GridView) {
        layers = [layer]
    }
    
    func addLayer(_ layer: GridView) {
        layers.append(layer)
    }
    
    func addLayers(_ layers: [GridView]) {
        self.layers.append(contentsOf: layers)
    }
    
    func removeLayer(at index: Int) {
        let _ = layers.remove(at: index)
    }
    
}
