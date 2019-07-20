//
//  RenderClock.swift
//  Processing
//
//  Created by Matthew Johnson on 6/20/19.
//  Copyright © 2019 Anandabits LLC. All rights reserved.
//

import Combine
import QuartzCore
import SwiftUI

final class RenderClock: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    var preRenderAction: () -> Void
    private(set) var frameCount = 0
    private(set) var currentTime: CFTimeInterval = 0

    init(framesPerSecond: Int? = nil, preRenderAction: @escaping () -> Void = {}) {
        self.preRenderAction = preRenderAction
        let link = CADisplayLink(target: self, selector: #selector(tick))
        if let framesPerSecond = framesPerSecond {
            link.preferredFramesPerSecond = framesPerSecond
        }
        link.add(to: .current, forMode: .default)
    }

    @objc func tick(displaylink: CADisplayLink) {
        willChange.send()
        frameCount += 1
        currentTime = displaylink.timestamp
    }
}
