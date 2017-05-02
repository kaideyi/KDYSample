//
//  KYPlayerMaskView.swift
//  KYPlayer
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

public protocol PlayerMaskDelegate: NSObjectProtocol {
    
    func handlePlayPauseButton(_ button: UIButton)
    
    func handleFullscreenButton(_ button: UIButton)
    
    func playerMaskTaped(withSlider slider: UISlider)
    
    func playerMaskDraging(withSlider slider: UISlider)
}

// MARK: 

class KYPlayerMaskView: UIView {
    
    // MARK: Properites
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    var backButton: UIButton?
    
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
    
    var isFullScreen: Bool = false {
        didSet {
            
        }
    }
    
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
        slider.addTarget(self, action: #selector(handleSliderPosition(_:)), for: .valueChanged)
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .clear
        slider.maximumValue = 1.0
        slider.minimumValue = 0.0
        
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
    
    weak var maskDelegate: PlayerMaskDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupAllViews() {
        setupTopViews()
        setupBottomViews()
    }
    
    func setupTopViews() {
        self.addSubview(topView)
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
    
    // MARK: - Public Methods
    
    // MARK: - Event Response
    
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
    
    func handleSliderPosition(_ slider: UISlider) {
        if let delegate = maskDelegate {
            delegate.playerMaskDraging(withSlider: slider)
        }
    }
}

