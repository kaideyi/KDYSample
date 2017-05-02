//
//  KYPlayerViewController.swift
//  KYPlayer
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import AVFoundation

// Audio, Video
// AVPlayerItem, AVPlayer, AVPlayerLayer

class KYPlayerViewController: UIViewController {

    // MARK: Properites
    
    var url: URL? {
        didSet {
        }
    }
    
    var playerView: KYPlayerView!
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "播放器"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        
        playerView = KYPlayerView()
        playerView.playerMaskView.maskDelegate = self as? PlayerMaskDelegate
        playerView.backgroundColor = .black
        self.view.addSubview(playerView)
        
        playerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.height.equalTo(playerView.snp.width).multipliedBy(9.0/16.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func interfaceOrientation(_ oriendtaion: UIDeviceOrientation) {
        /**
         *  Objective-C下对于全屏的处理，可惜在Swift下，不清楚怎么转换
             if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
             SEL selector = NSSelectorFromString(@"setOrientation:");
             NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
             [invocation setSelector:selector];
             [invocation setTarget:[UIDevice currentDevice]];
             int val = orientation;
             [invocation setArgument:&val atIndex:2];
             [invocation invoke];
             }
         */
        
        let rectWindow = playerView.convert(playerView.bounds, to: UIApplication.shared.keyWindow)
        playerView.removeFromSuperview()
        playerView.frame = rectWindow
        UIApplication.shared.keyWindow?.addSubview(playerView)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            self.playerView.bounds = CGRect(x: 0, y: 0, width: (self.playerView.superview?.bounds)!.height, height: (self.playerView.superview?.bounds)!.width)
            self.playerView.center = CGPoint(x: (self.playerView.superview?.bounds.minX)!, y: (self.playerView.superview?.bounds.minY)!)
            
        }) { (finished) in
            self.playerView.isFullScreen = true
        }
        
        refreshStatusBarOrientation(.landscapeRight)
    }
    
    func refreshStatusBarOrientation(_ oriendtaion: UIInterfaceOrientation) {
        UIApplication.shared.setStatusBarOrientation(oriendtaion, animated: true)
    }
    
    deinit {
    }
}

extension KYPlayerViewController: PlayerMaskDelegate {
    
    func handlePlayPauseButton(_ button: UIButton) {
        if playerView.bufferingState == .ready {
            if button.isSelected {
                playerView.avplayer.pause()
            } else {
                playerView.avplayer.play()
                
                // 5秒后，隐藏遮罩视图
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    self.playerView.hideMaskView()
                })
            }
            
            button.isSelected = !button.isSelected
        }
    }
    
    func handleFullscreenButton(_ button: UIButton) {
        if playerView.isFullScreen {
            interfaceOrientation(.portrait)
        } else {
            interfaceOrientation(.landscapeRight)
        }
    }
    
    func playerMaskTaped(withSlider slider: UISlider) {
        
    }
    
    func playerMaskDraging(withSlider slider: UISlider) {
        
    }
}

