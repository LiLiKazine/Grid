//
//  LayerCollectionCell.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/25.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit

class LayerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var checkIMV: UIImageView!
    private var completeion: () -> Void = {
        print("unsigned delete action.")
    }
    
    func setup(_ i: Int, selected: Bool, name: String, deleteAction: @escaping () -> Void) {
        checkIMV.isHidden = !selected
        deleteBtn.isHidden = i == 0
        nameLbl.text = name
        completeion = deleteAction
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        completeion()
    }
}
