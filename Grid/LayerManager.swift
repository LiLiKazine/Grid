//
//  LayerManager.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/25.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

class LayerManager {
    private(set) var layers: [GridMask]
    private(set) var curIndex: Int?
    
    init() {
        layers = []
    }
}
