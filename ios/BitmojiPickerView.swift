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
    
    @objc var config: NSDictionary = [:] {
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
        
        let configBuilder = SCSDKBitmojiStickerPickerConfigBuilder()
        
        let theme = config.value(forKey: "theme");
        if(theme != nil){
            
            if(theme as! String == "custom"){
                let themeBuilder = SCSDKBitmojiStickerPickerThemeBuilder();
                themeBuilder.withBackgroundColor(UIColor.init(white: 1, alpha: 0))
                themeBuilder.withBorderColor(UIColor.init(white: 1, alpha: 0))
                themeBuilder.withSearchColor(UIColor.init(white: 1, alpha: 1))
                themeBuilder.withSubtextColor(UIColor.init(white: 1, alpha: 1))
                themeBuilder.withTitleTextColor(UIColor.init(white: 1, alpha: 1))
                configBuilder.withTheme(themeBuilder.build());
                
            }else{
                configBuilder.withTheme(theme as! String == "light" ? .light : .dark)
            }
        }
        
       
        
        let showSearch = config.value(forKey: "showSearch");
        if(showSearch != nil){
            configBuilder.withShowSearchBar(showSearch as! Bool || false)
        }
        
        let showPills = config.value(forKey: "showPills");
        if(showPills != nil){
            configBuilder.withShowSearchPills(showPills as! Bool || false)
        }
        
        let vc = SCSDKBitmojiStickerPickerViewController(config: configBuilder.build());
        
        
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
