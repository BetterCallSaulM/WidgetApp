//
//  AffirmationWidgetBundle.swift
//  AffirmationWidget
//
//  Created by Saul Machuca on 3/25/25.
//

import WidgetKit
import SwiftUI

@main
struct AffirmationWidgetBundle: WidgetBundle {
    var body: some Widget {
        AffirmationWidget()
        AffirmationWidgetControl()
        AffirmationWidgetLiveActivity()
    }
}
