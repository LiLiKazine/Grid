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
    typealias Line = GridMask.Line
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var widgetContainer: UIView!
    @IBOutlet weak var mainIMV: UIImageView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var gridMask: GridMask!
    
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
        gridView.positionSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] position in
                let lines: [Line] = [
                    Line(anchorOffset: position.x1, isHorizontal: false),
                    Line(anchorOffset: position.x2, isHorizontal: false),
                    Line(anchorOffset: position.y1, isHorizontal: true),
                    Line(anchorOffset: position.y2, isHorizontal: true)
                ]
                self?.gridMask.update(lines: lines)
            })
        .disposed(by: bag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateIMV()
    }

    private func updateIMV() {
        if let _ = mainIMV.image {
            centerIMV()
            updateMaxZoomScale()
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
        let insets = widgetContainer.frame.size
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
    
    @IBAction func importAction(_ sender: UIBarButtonItem) {if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        }
        
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
        return widgetContainer
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerIMV()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            picker.delegate = nil
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage 
        picker.dismiss(animated: true) { [weak self] in
            picker.delegate = nil
            self?.mainIMV.image = image
            self?.updateIMV()
        }
    }
}

