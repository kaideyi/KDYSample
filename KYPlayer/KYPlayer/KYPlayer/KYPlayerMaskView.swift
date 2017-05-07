//
//  KYPlayerMaskView.swift
//  KYPlayer
//
//  Created by kaideyi on 2017/5/6.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

public protocol PlayerMaskViewDelegate: NSObjectProtocol {
    
    func handlePlayPauseButton(_ button: UIButton)
    
    func handleFullscreenButton(_ button: UIButton)
    
    func playerMaskTaped(withSlider slider: UISlider)
    
    func playerMaskDraging(withSlider slider: UISlider)
    
    func playerMaskEnd(withSlider slider: UISlider)
}

// MARK:

class KYPlayerMaskView: UIView {
    
    // MARK: Properties
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let backBtn = UIButton()
        backBtn.backgroundColor = .clear
        backBtn.setImage(UIImage(named: "play_back_full"), for: .normal)
        backBtn.addTarget(self, action: #selector(clickBackBtnAction), for: .touchUpInside)
        
        return backBtn
    }()
    
    var lockButton: UIButton?
    
    lazy var pauseButton: UIButton = {
        let pauseBtn = UIButton()
        pauseBtn.backgroundColor = .clear
        pauseBtn.setImage(UIImage(named: "full_play_btn_hl"), for: .normal)
        pauseBtn.setImage(UIImage(named: "full_pause_btn_hl"), for: .selected)
        pauseBtn.setImage(UIImage(named: "full_pause_btn_hl"), for: .highlighted)
        pauseBtn.addTarget(self, action: #selector(clickPlayPauseBtnAction(_:)), for: .touchUpInside)
        
        return pauseBtn
    }()
    
    lazy var fullButton: UIButton = {
        let fullBtn = UIButton()
        fullBtn.backgroundColor = .clear
        fullBtn.setImage(UIImage(named: "player_fullscreen"), for: .normal)
        fullBtn.setImage(UIImage(named: "player_shrinkscreen"), for: .selected)
        fullBtn.setImage(UIImage(named: "player_shrinkscreen"), for: .highlighted)
        fullBtn.addTarget(self, action: #selector(clickFullScreenBtnAction(_:)), for: .touchUpInside)
        
        return fullBtn
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .white
        
        return label
    }()
    
    lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    lazy var playSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "thumbImage"), for: .normal)
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .clear
        slider.maximumValue = 1.0
        slider.minimumValue = 0.0
        
        slider.addTarget(self, action: #selector(handleSliderChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(handleSliderEnd(_:)), for: ([.touchUpInside, .touchCancel, .touchUpOutside]))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSliderTaped(_:)))
        slider.addGestureRecognizer(tapGesture)
        
        return slider
    }()
    
    lazy var bufferSlider: UISlider = {
        let slider = UISlider()
        slider.isUserInteractionEnabled = false
        slider.setThumbImage(UIImage(), for: .normal)
        slider.minimumTrackTintColor = .white
        slider.maximumValue = 1.0
        slider.minimumValue = 0.0
        
        return slider
    }()
    
    weak var maskDelegate: PlayerMaskViewDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        setupTopViews()
        setupBottomViews()
    }
    
    func setupTopViews() {
        self.addSubview(topView)
        
        topView.addSubview(backButton)
        
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(5)
            make.centerY.equalTo(topView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    
    func setupBottomViews() {
        self.addSubview(bottomView)
        
        bottomView.addSubview(timeLabel)
        bottomView.addSubview(totalTimeLabel)
        bottomView.addSubview(pauseButton)
        bottomView.addSubview(fullButton)
        bottomView.addSubview(bufferSlider)
        bottomView.addSubview(playSlider)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(40)
        }
        
        pauseButton.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(5)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        fullButton.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView).offset(-5)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(pauseButton.snp.right).offset(5)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(35)
        }
        
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(fullButton.snp.left).offset(-5)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(35)
        }
        
        bufferSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.left.equalTo(timeLabel.snp.right).offset(8)
            make.right.equalTo(totalTimeLabel.snp.left).offset(-8)
        }
        
        playSlider.snp.makeConstraints { (make) in
            make.edges.equalTo(bufferSlider)
        }
    }
    
    // MARK: - Event Response
    
    func clickBackBtnAction() {
    
    }
    
    func clickPlayPauseBtnAction(_ button: UIButton) {
        if let delegate = maskDelegate {
            delegate.handlePlayPauseButton(button)
        }
    }
    
    func clickFullScreenBtnAction(_ button: UIButton) {
        if let delegate = maskDelegate {
            delegate.handleFullscreenButton(button)
        }
    }
    
    func handleSliderTaped(_ slider: UISlider) {
        if let delegate = maskDelegate {
            delegate.playerMaskTaped(withSlider: slider)
        }
    }
    
    func handleSliderChanged(_ slider: UISlider) {
        if let delegate = maskDelegate {
            delegate.playerMaskDraging(withSlider: slider)
        }
    }
    
    func handleSliderEnd(_ slider: UISlider) {
        if let delegate = maskDelegate {
            delegate.playerMaskEnd(withSlider: slider)
        }
    }
}

