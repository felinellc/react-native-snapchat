//
//  BitmojiPickerView.swift
//  RNSnapSDK
//
//  Created by Sam Gehly on 2/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
import Foundation;
import UIKit;
import SCSDKBitmojiKit;

//import RCTLog;

public class BitmojiPickerView: UIView, SCSDKBitmojiStickerPickerViewControllerDelegate {
    
    public func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
        self.onBitmojiSelected!(["url":bitmojiURL]);
    }
    
    @objc var onBitmojiSelected: RCTBubblingEventBlock?;
    
    weak var pickerViewController: SCSDKBitmojiStickerPickerViewController?
    
    var config: NSDictionary = [:] {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("nope") }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
       if pickerViewController == nil {
            embed()
        } else {
            pickerViewController?.view.frame = bounds
        }
    }
    
    private func embed() {
        guard
            let parentVC = parentViewController
            else {
                return
        }
        
        let config = SCSDKBitmojiStickerPickerConfig();
        
        
        let vc = SCSDKBitmojiStickerPickerViewController(config: config);
        
        
        parentVC.addChild(vc!)
        vc!.delegate = self;
        addSubview(vc!.view)
        vc!.view.frame = bounds
        vc!.didMove(toParent: parentVC)
        self.pickerViewController = vc
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
