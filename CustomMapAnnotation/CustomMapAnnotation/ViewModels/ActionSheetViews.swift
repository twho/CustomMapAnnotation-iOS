//
//  ActionSheetViews.swift
//  LocationAudioMessage
//
//  Created by Ho, Tsung Wei on 7/19/18.
//  Copyright © 2018 Michael Ho. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Built-in background images.
 
 - bubble: bubble background
 - square: square-shaped background
 - circle: circular background
 - heart:  heart-shaped background
 - flag:   flag background
 */
public enum ActionSheetButtonImg {
    case like
    case dislike
    case play
    case stop
    case pause
    case record
}

open class AudioView: UIView {
    
    let LOG_TAG = "[AudioView] "
    
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnPlay: ActionSheetButton!
    @IBOutlet weak var btnStop: ActionSheetButton!
    @IBOutlet weak var btnRecord: ActionSheetButton!
    private var buttons: [ActionSheetButton]!
    
    // Audio Utils
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    public typealias audioViewFunction = ((AudioView) -> ())
    
    private var onClickRecord: ((AudioView) -> Void)? = nil
    private var fetchAudio: audioViewFunction? = nil
    private var audioData: Any? = nil
    
    public var isTopBarHidden: Bool = false {
        didSet {
            labelTitle.isHidden = isTopBarHidden
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        btnPlay.addTarget(self, action: #selector(onClickBtnPlay), for: .touchUpInside)
        btnStop.addTarget(self, action: #selector(onClickBtnStop), for: .touchUpInside)
        btnRecord.addTarget(self, action: #selector(onClickBtnRecord), for: .touchUpInside)
        
        buttons = [btnPlay, btnStop, btnRecord]
    }
    
    public func configure(title: String? = nil, subTitle: String? = nil, theme: ResManager.Theme = .dark, fetchAudio: @escaping audioViewFunction, onClickRecord: audioViewFunction? = nil) {
        self.fetchAudio = fetchAudio
        configure(title: title, subTitle: subTitle, theme: theme, audioData: fetchAudio, onClickRecord: onClickRecord)
    }
    
    public func configure(title: String? = nil, subTitle: String? = nil, theme: ResManager.Theme = .dark, audioData: Any, onClickRecord: audioViewFunction? = nil) {
        self.audioData = audioData
        self.labelTitle.text = title
        self.labelSubTitle.text = subTitle
        
        if let onClickRecord = onClickRecord {
            self.onClickRecord = onClickRecord
        } else {
            btnRecord.isEnabled = false
        }
        
        setTheme(theme: theme)
    }
    
    @objc func onClickBtnPlay() {
        if nil != audioPlayer && (audioPlayer?.isPlaying)! {
            btnPlay.setImage(UIImage(named: "ic_play"), for: UIControlState())
            audioPlayer?.pause()
        } else {
            btnPlay.isLoading = true
            guard let audioData = audioData else { return }
            if nil != self.fetchAudio {
                self.fetchAudio!(self)
            } else {
                playAudio(resource: audioData)
            }
        }
    }
    
    func playAudio(resource: Any) {
        // Setup GUIs before playing audio
        btnRecord.isEnabled = false
        btnPlay.setImage(UIImage(named: "ic_pause"), for: UIControlState())
        btnPlay.isLoading = false
        
        do {
            if let data = (resource as? Data) {
                audioPlayer = try AVAudioPlayer(data: data)
            } else if let url = (resource as? URL) {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            }
            
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch let error as NSError {
            print(LOG_TAG + "\(error.description)")
        }
    }
    
    @objc func onClickBtnStop() {
        if nil != audioPlayer && (audioPlayer?.isPlaying)! {
            audioPlayer?.stop()
            audioPlayer = nil
        }
        
        btnPlay.setImage(UIImage(named: "ic_play"), for: UIControlState())
    }
    
    @objc func onClickBtnRecord() {
        if let onClickRecord = onClickRecord {
            onClickRecord(self)
        }
    }
    
    /**
     Set custom button image
     
     - Parameters:
        - leftBtnImg:  The image to be set to the left button.
        - midBtnImg:   The image to be set to the middle button.
        - rightBtnImg: The image to be set to the right button.
     */
    public func setButtonImage(leftBtnImg: UIImage? = nil, midBtnImg: UIImage? = nil, rightBtnImg: UIImage? = nil) {
        
        if let image = leftBtnImg {
            btnPlay.setImage(image, for: UIControlState())
        }
        
        if let image = midBtnImg {
            btnStop.setImage(image, for: UIControlState())
        }
        
        if let image = rightBtnImg {
            btnRecord.setImage(image, for: UIControlState())
        }
        
        self.setNeedsDisplay()
    }
    
    /**
     Setup different theme view colors.
     
     - Parameters:
        - theme:       The Theme of the action sheet.
        - bgColor:     The background color of the action sheet.
        - textColor:   The text color of the entire action sheet.
        - topBarColor: The background color of the top bar.
     */
    public func setTheme(theme: ResManager.Theme, bgColor: UIColor? = nil, textColor: UIColor? = nil, topBarColor: UIColor? = nil) {
        let themeColors = ResManager.getColorByTheme(theme: theme, bgColor: bgColor, textColor: textColor, topBarColor: topBarColor)
        
        labelTitle.textColor = themeColors.textColor
        labelSubTitle.textColor = themeColors.textColor
        self.backgroundColor = themeColors.bgColor.color
        self.labelTitle.backgroundColor = themeColors.TopBarColor
        
        for button in buttons {
            button.setButtonStyle(normal: themeColors.bgColor.color, clicked: themeColors.bgColor.tint, disabled: ResManager.Color.ltGray)
        }
        
        self.setNeedsDisplay()
    }
}

extension AudioView: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer = nil // Clean up
        btnPlay.setImage(UIImage(named: "ic_play"), for: UIControlState())
    }
}

open class InfoView: UIView {
    
    @IBOutlet weak var btnInfo: ActionSheetButton!
    @IBOutlet weak var btnLike: ActionSheetButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    public typealias infoViewFunction = ((InfoView) -> ())
    
    private var onClickLike: ((InfoView) -> Void)? = nil
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        btnLike.addTarget(self, action: #selector(onClickBtnLike), for: .touchUpInside)
    }
    
    public func configure(title: String? = nil, content: String, subTitle: String? = nil, image: UIImage, theme: ResManager.Theme = .dark, onClickLike: @escaping infoViewFunction) {
        self.labelTitle.text = title
        self.labelContent.text = content
        self.labelSubTitle.text = subTitle
        self.onClickLike = onClickLike
        self.btnInfo.setImageForAllState(image: image)
        setTheme(theme: theme)
    }
    
    @objc func onClickBtnLike() {
        if let onClickLike = onClickLike {
            onClickLike(self)
        }
    }
    
    /**
     Setup different theme view colors.
     
     - Parameters:
     - theme:       The Theme of the action sheet.
     - bgColor:     The background color of the action sheet.
     - textColor:   The text color of the entire action sheet.
     - topBarColor: The background color of the top bar.
     */
    public func setTheme(theme: ResManager.Theme, bgColor: UIColor? = nil, textColor: UIColor? = nil, topBarColor: UIColor? = nil) {
        let themeColors = ResManager.getColorByTheme(theme: theme, bgColor: bgColor, textColor: textColor, topBarColor: topBarColor)
        
        labelTitle.textColor = themeColors.textColor
        labelContent.textColor = themeColors.textColor
        labelSubTitle.textColor = themeColors.textColor
        self.backgroundColor = themeColors.bgColor.color
        self.labelTitle.backgroundColor = themeColors.TopBarColor
        btnLike.titleLabel?.textColor = themeColors.textColor
        btnLike.setButtonStyle(normal: themeColors.bgColor.color, clicked: themeColors.bgColor.tint, disabled: ResManager.Color.ltGray)
        btnInfo.setButtonStyle(normal: themeColors.bgColor.color, clicked: themeColors.bgColor.tint, disabled: ResManager.Color.ltGray)
        
        self.setNeedsDisplay()
    }
}
