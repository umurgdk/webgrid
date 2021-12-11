//
//  FocusedPage.swift
//  Web Grid
//
//  Created by Umur Gedik on 8.12.2021.
//

import SwiftUI

struct PageFocusedValueKey: FocusedValueKey {
    typealias Value = Page
}

extension FocusedValues {
    var page: PageFocusedValueKey.Value? {
        get { return self[PageFocusedValueKey.self] }
        set { self[PageFocusedValueKey.self] = newValue }
    }
}
