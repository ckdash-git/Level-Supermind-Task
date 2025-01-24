//
//  MusicPlayerView.swift
//  levelsSuperMind
//
//  Created by Chandan Kumar Dash on 23/01/25.
//

import UIKit

class MusicPlayerView: UIView {
    
    let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap Play to start"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    let progressBar: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        return slider
    }()
    
    let playedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "00:00"
        return label
    }()
    
    let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.text = "-00:00"
        return label
    }()
    
    let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.text = "00:00"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(playPauseButton)
        addSubview(stopButton)
        addSubview(statusLabel)
        addSubview(progressBar)
        addSubview(playedTimeLabel)
        addSubview(remainingTimeLabel)
        addSubview(totalTimeLabel)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        playedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -60),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stopButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 60),
            stopButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 10),
            
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            progressBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            playedTimeLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            playedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            
            remainingTimeLabel.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            
            totalTimeLabel.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor),
            totalTimeLabel.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 5)
        ])
    }
    
    func updateStatus(isPlaying: Bool) {
        playPauseButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        statusLabel.text = isPlaying ? "Playing..." : "Paused"
    }
    
    func updateProgressBar(progress: Float) {
        progressBar.value = progress
    }
    
    func updateTotalDuration(duration: Float) {
        progressBar.maximumValue = duration
        totalTimeLabel.text = formatTime(duration: duration)
    }
    
    func updatePlayedTime(playedTime: String) {
        playedTimeLabel.text = playedTime
    }
    
    func updateRemainingTime(remainingTime: String) {
        remainingTimeLabel.text = "-\(remainingTime)"
    }
    
    func addProgressBarTarget(target: Any, action: Selector) {
        progressBar.addTarget(target, action: action, for: .valueChanged)
    }
    
    private func formatTime(duration: Float) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
