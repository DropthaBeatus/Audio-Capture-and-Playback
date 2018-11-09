//
//  extensions.swift
//  Audio Capture and Playback
//
//  Created by Liam Flaherty on 11/7/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}
