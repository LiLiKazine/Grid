//
//  ViewController.swift
//  Grid
//
//  Created by LiLi Kazine on 2020/1/23.
//  Copyright © 2020 LiLi Kazine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainIMV: UIImageView!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet var singleTapGesture: UITapGestureRecognizer!
    @IBOutlet var twiceTapGesture: UITapGestureRecognizer!
    private var constraints: [NSLayoutConstraint]{
        return [top, trailing, bottom, leading]
    }
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleTapGesture.require(toFail: twiceTapGesture)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateIMV()
    }

    private func updateIMV() {
        if let img = mainIMV.image {
            let insets = img.size.measureInsets(in: scrollView.frame.size).attributes
            updateMaxZoomScale()
            for i in 0...3 {
                constraints[i].constant = insets[i]
            }
            view.layoutIfNeeded()
        }
    }
    
    
    private func maxRatio() -> Double {
        if let img = mainIMV.image {
            let ratio = img.size.measureRatio(in: scrollView.frame.size)
            return max(ratio.ratioX, ratio.ratioY)
        }
        return 1.0
    }
    
    private func updateMaxZoomScale() {
        let ratio = maxRatio()
        scrollView.maximumZoomScale =
            ratio < 3.0 ? 3.0 : CGFloat(ratio)
        scrollView.minimumZoomScale =
            ratio > 1.0 ? CGFloat(1/ratio) : 1.0
    }
    
    private func centerIMV() {
        let insets = mainIMV.frame.size
            .measureInsets(in: scrollView.frame.size)
        .attributes
        for i in 0...3 {
            constraints[i].constant = max(insets[i], 0)
        }
        view.layoutIfNeeded()
    }
    
    private func fitIMV() {
        let ratio = maxRatio()
        scrollView.setZoomScale(CGFloat(1/ratio), animated: true)
    }
    
    @IBAction func importAction(_ sender: UIBarButtonItem) {
        UIImagePickerController.rx.createWithParent(self) { picker in
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
        }
        .flatMap {
            $0.rx.didFinishPickingMediaWithInfo
        }
        .take(1)
        .map { info in
            return info[.originalImage] as? UIImage
        }
        .bind(to: mainIMV.rx.image)
        .disposed(by: bag)
    }

    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        switch sender {
        case singleTapGesture:
            if let bar = navigationController?.navigationBar {
                navigationController?.setNavigationBarHidden(!bar.isHidden, animated: true)
            }
        case twiceTapGesture:
            fitIMV()
        default:
            break
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainIMV
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerIMV()
    }
}

