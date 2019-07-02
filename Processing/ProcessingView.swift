//
//  ProcessingView.swift
//  Processing
//
//  Created by Matthew Johnson on 6/20/19.
//  Copyright © 2019 Anandabits LLC. All rights reserved.
//

// A port of a Processing experiment by Marc Edwards

import SwiftUI

protocol ProcessingView: View {
    var renderClock: RenderClock { get }
}
extension ProcessingView {
    var frameCount: Int { renderClock.frameCount }
    var currentTime: CFTimeInterval { renderClock.currentTime }
}

extension ProcessingView { // Bjango helpers
    func timeCycle(totalFrames: Int, offset: Int = 0) -> CGFloat {
        timeCycle(totalFrames: CGFloat(totalFrames), offset: CGFloat(offset))
    }

    func timeCycle(totalFrames: CGFloat, offset: CGFloat = 0) -> CGFloat {
        ((CGFloat(frameCount) + offset).truncatingRemainder(dividingBy: totalFrames)) / totalFrames
    }

    func timeLoop(totalFrames: CGFloat, offset: CGFloat = 0) -> CGFloat {
        (CGFloat(frameCount) + offset).truncatingRemainder(dividingBy: CGFloat(totalFrames)) / CGFloat(totalFrames)
    }

    func timeRangeLoop(totalFrames: CGFloat, start: CGFloat, end: CGFloat, offset: CGFloat) -> CGFloat {
        if CGFloat(frameCount).truncatingRemainder(dividingBy: totalFrames) >= end + offset {
            return 1
        } else {
            let x = CGFloat(frameCount).truncatingRemainder(dividingBy: totalFrames).clamped(to: start...end) + offset
            return x.truncatingRemainder(dividingBy: abs(end - start)) / abs(end - start)
        }
    }

    func timeBounce(totalFrames: CGFloat, offset: CGFloat = 0) -> CGFloat {
        Ease.triangle(timeLoop(totalFrames: totalFrames, offset: offset))
    }

    func timeNoise(totalFrames: CGFloat, diameter: CGFloat, zOffset: CGFloat) -> CGFloat {
        perlin(
            cos(timeLoop(totalFrames: totalFrames) * .tau) * diameter + diameter,
            sin(timeLoop(totalFrames: totalFrames) * .tau) * diameter + diameter,
            zOffset
        )
    }
}

func lerp(start: CGFloat, end: CGFloat, position: CGFloat) -> CGFloat {
    start + position * (end - start)
}
