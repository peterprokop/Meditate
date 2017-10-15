import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var rythmLabel: UILabel!
    
    var timer: Timer!
    var scale = CGFloat(1)
    var isInflating = true
    
    let timerInterval = 0.02
    var cyclesPerMinute = CGFloat(5)
    var speed: CGFloat { return 0.02 / (60 / self.cyclesPerMinute / 2) }
    var firstLayout = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        timer = Timer.scheduledTimer(
            timeInterval: timerInterval,
            target: self,
            selector: #selector(timerCallback),
            userInfo: nil,
            repeats: true
        )
        
        updateRhytmLabel()
    }
    
    func updateRhytmLabel() {
        rythmLabel.text = "\(cyclesPerMinute) cycles/min"
    }

    @objc func timerCallback() {
        scale += isInflating ? speed : -speed
        
        if scale <= 0 {
            scale = 0
            isInflating = true
        } else if scale >= 1 {
            scale = 1
            isInflating = false
        }
        
        circleView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if firstLayout {
            circleView.layer.cornerRadius = circleView.frame.width/2
            circleView.layer.masksToBounds = true
            firstLayout = false
        }
    }
    
    @IBAction func panGestureCallback(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view).x / view.bounds.width
        
        if translation > 0.25 {
            cyclesPerMinute += 0.25
            sender.setTranslation(CGPoint.zero, in: view)
            updateRhytmLabel()
        } else if translation < -0.25 {
            cyclesPerMinute -= 0.25
            sender.setTranslation(CGPoint.zero, in: view)
            updateRhytmLabel()
        }
    }
}

