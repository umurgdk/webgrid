//
//  Device.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import Foundation

enum Device: String, Identifiable, CaseIterable {
    case iPhone13Mini = "iPhone 13 Mini"
    case iPhone13 = "iPhone 13"
    case macBook13 = "MacBook 13"
    case iPadPro11 = "iPad Pro 11in"
    case iPadPro13 = "iPad Pro 12.9in"
    case display1080p = "Display 1080p"
    case display720p = "Display 720p"
    
    var id: String { rawValue }
    
    var portraitSize: CGSize {
        switch self {
        case .iPhone13Mini:
            return CGSize(width: 375, height: 812)
        case .iPhone13:
            return CGSize(width: 390, height: 844)
        case .macBook13:
            return CGSize(width: 1440, height: 900)
        case .iPadPro11:
            return CGSize(width: 834, height: 1194)
        case .iPadPro13:
            return CGSize(width: 1024, height: 1366)
        case .display1080p:
            return CGSize(width: 1920, height: 1080)
        case .display720p:
            return CGSize(width: 1280, height: 720)
        }
    }
    
    var landscapeSize: CGSize {
        let portraitSize = self.portraitSize
        return CGSize(width: portraitSize.height, height: portraitSize.width)
    }
    
    func size(from orientation: Orientation) -> CGSize {
        switch orientation {
        case .portrait:
            return portraitSize
        case .landscape:
            return landscapeSize
        }
    }
}
