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
    @IBOutlet weak var layerItem: UIBarButtonItem!
    @IBOutlet var dropDown: DropDown!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var widgetContainer: UIView!
    @IBOutlet weak var mainIMV: UIImageView!
    @IBOutlet weak var gridView: GridView!    
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
    private var manager: LayerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = .init(layer: gridView)
        gridView.setLineColor(manager.colors[manager.curIndex])
        singleTapGesture.require(toFail: twiceTapGesture)
        NotificationCenter.default.rx
            .notification(UIDevice.orientationDidChangeNotification)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dropDown(false)
            })
        .disposed(by: bag)
        dropDown.removeSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] i in
                self?.manager.removeLayer(at: i)
                self?.dropDown(false)
            })
        .disposed(by: bag)
        dropDown.selectSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] i in
                self?.manager.select(at: i)
                self?.dropDown(false)
            })
            .disposed(by: bag)
        manager.removeSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { v in
                v.removeFromSuperview()
            })
        .disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fitIMV()
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
    
    @IBAction func layerAction(_ sender: UIBarButtonItem) {
        dropDown(sender.tintColor == .systemBlue)
    }
    
    @IBAction func addLayer(_ sender: UIButton) {
        if manager.layers.count == manager.colors.count { return }
        let newLayer = GridView(frame: mainIMV.frame)
        manager.addLayer(newLayer)
        widgetContainer.addSubview(newLayer)
        newLayer.translatesAutoresizingMaskIntoConstraints = true
        newLayer.center = mainIMV.center
        newLayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dropDown(false)
    }
    
    private func dropDown(_ open: Bool) {
        layerItem.tintColor = open ? .systemGray : .systemBlue
        dropDown.alpha = open ? 0 : 1
        layerItem.isEnabled = false
        if open {
            let layers = manager.layers
                .enumerated()
                .map { "Layer \($0.0)" }
            dropDown.setLayers(layers, selected: manager.curIndex)
            let anchor = layerItem.centralBottom(in: view)
            let point = dropDown.point
            let origin = CGPoint(x: anchor.x - point.x, y: anchor.y + 12)
            dropDown.frame.origin = origin
            let height = CGFloat(min(7, manager.layers.count+1)) *
                manager.cellHeight
                + dropDown.arrowSize.height
            dropDown.frame.size = .init(width: 300, height: height)
            view.addSubview(dropDown)
        }
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.dropDown.alpha = open ? 1 : 0
        }) { [weak self] _ in
            self?.layerItem.isEnabled = true
            if !open {
                self?.dropDown.removeFromSuperview()
            }
        }
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        dropDown(false)
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

