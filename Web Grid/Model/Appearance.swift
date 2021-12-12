//
//  Appearance.swift
//  Web Grid
//
//  Created by Umur Gedik on 13.12.2021.
//

import Foundation
import SwiftUI

extension ColorScheme {
    var iconName: String {
        switch self {
        case .light: return "sun.min"
        case .dark: return "moon"
        @unknown default: return "sun.min"
        }
    }
}

enum Appearance: String, CaseIterable, Identifiable {
    case light
    case dark
    case system
    
    var id: String { rawValue }
    
    func colorScheme(system: ColorScheme) -> ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return system
        }
    }
    
    func iconName(system: ColorScheme) -> String {
        colorScheme(system: system).iconName
    }
    
    var title: String {
        switch self {
        case .light: return "Light Mode"
        case .dark: return "Dark Mode"
        case .system: return "Same as system"
        }
    }
    
    init(from colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        @unknown default:
            self = .light
        }
    }
}
