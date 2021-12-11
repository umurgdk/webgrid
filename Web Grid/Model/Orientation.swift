//
//  Orientation.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import Foundation

enum Orientation: String, Identifiable, CaseIterable {
    case portrait = "Portrait"
    case landscape = "Landscape"
    
    var id: String { rawValue }
}
