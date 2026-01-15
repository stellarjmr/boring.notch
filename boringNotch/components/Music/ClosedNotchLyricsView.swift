//
//  ClosedNotchLyricsView.swift
//  boringNotch
//
//  Displays synced lyrics in closed notch state.
//

import SwiftUI
import Defaults

struct ClosedNotchLyricsView: View {
    @ObservedObject private var musicManager = MusicManager.shared
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.25)) { timeline in
            let currentElapsed: Double = {
                guard musicManager.isPlaying else { return musicManager.elapsedTime }
                let delta = timeline.date.timeIntervalSince(musicManager.timestampDate)
                let progressed = musicManager.elapsedTime + (delta * musicManager.playbackRate)
                return min(max(progressed, 0), musicManager.songDuration)
            }()
            
            let line: String = {
                if musicManager.isFetchingLyrics { return "♪" }
                if !musicManager.syncedLyrics.isEmpty {
                    return musicManager.lyricLine(at: currentElapsed)
                }
                return ""
            }()
            
            if !line.isEmpty {
                Text(line)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(
                        Defaults[.coloredSpectrogram]
                            ? Color(nsColor: musicManager.avgColor).ensureMinimumBrightness(factor: 0.6)
                            : .gray
                    )
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
        .opacity(musicManager.isPlaying ? 1 : 0)
    }
}
