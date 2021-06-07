//
//  NetworkActivityPlugin.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation
import Moya
import ProgressHUD

static var plugins: [PluginType] {
        let activityPlugin = NetworkActivityPlugin { (state, targetType) in
            switch state {
            case .began:
                ProgressHUD.show()
            case .ended:
                ProgressHUD.dismiss()()
            }
        }
        
        return [
            activityPlugin
        ]
    }
    
