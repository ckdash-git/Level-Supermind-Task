import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var playPauseButton: UIButton!
    private var progressBar: UISlider!
    private var currentTimeLabel: UILabel!
    private var remainingTimeLabel: UILabel!
    private var backgroundImageView: UIImageView!
    
    private var player: AVPlayer?
    private var isSeeking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPlayer()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "PausePlaypic")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(overlayView)
        
        progressBar = UISlider()
        progressBar.minimumValue = 0
        progressBar.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        progressBar.addTarget(self, action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        view.addSubview(progressBar)
        
        currentTimeLabel = UILabel()
        currentTimeLabel.text = "00:00"
        currentTimeLabel.textColor = .white
        currentTimeLabel.textAlignment = .left
        currentTimeLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(currentTimeLabel)
        
        remainingTimeLabel = UILabel()
        remainingTimeLabel.text = "00:00"
        remainingTimeLabel.textColor = .white
        remainingTimeLabel.textAlignment = .right
        remainingTimeLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(remainingTimeLabel)
        
        playPauseButton = UIButton(type: .system)
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        playPauseButton.setTitleColor(.white, for: .normal)
        playPauseButton.backgroundColor = .systemBlue
        playPauseButton.layer.cornerRadius = 25
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            playPauseButton.widthAnchor.constraint(equalToConstant: 120),
            playPauseButton.heightAnchor.constraint(equalToConstant: 50),
            
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBar.bottomAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: -40),
            
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            currentTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            
            remainingTimeLabel.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupPlayer() {
        guard let url = URL(string: "https://v3.cdn.level.game/raag-pilu-mix-full-vers.mp3") else { return }
        player = AVPlayer(url: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self, !self.isSeeking else { return }
            self.updateProgress()
        }
    }
    
    @objc private func handlePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
            playPauseButton.backgroundColor = .systemBlue
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
            playPauseButton.backgroundColor = .systemGreen
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        isSeeking = true
        let currentTime = sender.value
        currentTimeLabel.text = formatTime(seconds: Double(currentTime))
        if let player = player, let currentItem = player.currentItem {
            remainingTimeLabel.text = "-" + formatTime(seconds: currentItem.duration.seconds - Double(currentTime))
        }
    }
    
    @objc private func sliderTouchEnded(_ sender: UISlider) {
        isSeeking = false
        guard let player = player else { return }
        let seconds = sender.value
        let time = CMTime(seconds: Double(seconds), preferredTimescale: 1)
        player.seek(to: time) { [weak self] _ in
            self?.player?.play()
            self?.playPauseButton.setTitle("Pause", for: .normal)
            self?.playPauseButton.backgroundColor = .systemGreen
        }
    }
    
    private func updateProgress() {
        guard let player = player, let currentItem = player.currentItem else { return }
        
        let currentTime = player.currentTime().seconds
        let duration = currentItem.duration.seconds
        
        guard duration.isFinite else { return }
        
        progressBar.maximumValue = Float(duration)
        progressBar.value = Float(currentTime)
        
        currentTimeLabel.text = formatTime(seconds: currentTime)
        remainingTimeLabel.text = "-" + formatTime(seconds: duration - currentTime)
    }
    
    @objc private func playerDidFinishPlaying() {
        progressBar.value = 0
        currentTimeLabel.text = "00:00"
        remainingTimeLabel.text = "00:00"
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.backgroundColor = .systemBlue
        player?.seek(to: .zero)
    }
    
    private func formatTime(seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
#Preview{
    ViewController()
}
