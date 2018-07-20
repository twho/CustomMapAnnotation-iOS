//
//  ActionSheetManager.swift
//  CustomMapAnnotation
//
//  Created by Ho, Tsung Wei on 7/19/18.
//  Copyright © 2018 Michael Ho. All rights reserved.
//

import UIKit

open class ActionSheetManager: NSObject {
    
    public enum viewType: String {
        case audio = "AudioView"
        case info = "InfoView"
    }
    
    /**
     Setup action sheet view, this function is called by MapViewController only
     
     - Parameter vcPresent: the parent view call this action sheet view
     - Parameter type:      the type of the action sheet
     - Parameter dataObj:   the data object that will be used by action sheet
     - Parameter closed:    the task to be performed when close button is tapped
     - Parameter deleted:   the task to be performed when delete button is tapped
     */
    public func showAudioActionSheet(vcPresent: UIViewController, dataObj: AnyObject?, buttonItems: [CustomActionSheetItem] = [], dismissed: (() -> Void)? = nil) -> CustomActionSheet {
        var items = [CustomActionSheetItem]()
        
//        if let audioView = UINib(nibName: viewType.audio.rawValue, bundle: nil).instantiate(withOwner: vcPresent, options: nil)[0] as? AudioEditorView {
//            let editorViewItem = CustomActionSheetItem(type: .view, height: audioView.stackBtns.frame.origin.x + audioEditor.stackBtns.frame.size.height * 1.1)
//            audioView.parentVC = vcPresent
//
//            // Set audio editor view to action sheet
//            editorViewItem.view = audioEditor
//            items.append(editorViewItem)
//
//            for button in buttonItems {
//                items.append(button)
//            }
//        }
        
        let actionSheet = CustomActionSheet()
        actionSheet.showInView(vcPresent.view, items: items, gestureDismissal: false, closeBlock: dismissed)
        
        return actionSheet
    }
}
