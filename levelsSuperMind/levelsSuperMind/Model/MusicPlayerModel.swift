//
//  MusicPlayerModel.swift
//  levelsSuperMind
//
//  Created by Chandan Kumar Dash on 23/01/25.
//

import AVFoundation

class MusicPlayerModel {
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    var isPlaying = false
    var progressUpdateHandler: ((Float, String, String) -> Void)?  // Pass both played time and remaining time
    
    init(urlString: String) {
        if let url = URL(string: urlString) {
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
    func playPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
            startProgressUpdates()
        }
        
        isPlaying.toggle()
    }
    
    func stop() {
        guard let player = player else { return }
        player.pause()
        player.seek(to: CMTime.zero)  // Reset the audio to the start
        isPlaying = false
        progressUpdateHandler?(0, "00:00", formatTime(duration: totalDuration)) // Reset time labels
    }
    
    func seekToTime(seconds: Float) {
        guard let player = player else { return }
        let targetTime = CMTime(seconds: Double(seconds), preferredTimescale: 1)
        player.seek(to: targetTime)
    }
    
    private func startProgressUpdates() {
        guard let player = player else { return }
        
        // Update progress periodically
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let remainingTime = self.totalDuration - Float(currentTime)
            self.progressUpdateHandler?(Float(currentTime), self.formatTime(duration: Float(currentTime)), formatTime(duration: remainingTime))
        }
    }
    
    var totalDuration: Float {
        guard let duration = playerItem?.duration else { return 0 }
        let durationSeconds = CMTimeGetSeconds(duration)
        return durationSeconds.isNaN ? 0 : Float(durationSeconds)
    }
    
    // Helper to format time in MM:SS format
    private func formatTime(duration: Float) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
