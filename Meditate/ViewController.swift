import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var rythmLabel: UILabel!
    
    var timer: NSTimer!
    var scale = CGFloat(1)
    var isInflating = true
    
    let timerInterval = 0.02
    var cyclesPerMinute = CGFloat(5)
    var speed: CGFloat { return 0.02 / (60 / self.cyclesPerMinute / 2) }
    var firstLayout = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        updateRhytmLabel()
    }
    
    func updateRhytmLabel() {
        rythmLabel.text = "\(cyclesPerMinute) cycles/min"
    }

    func timerCallback() {
        scale += isInflating ? speed : -speed
        
        if scale <= 0 {
            scale = 0
            isInflating = true
        } else if scale >= 1 {
            scale = 1
            isInflating = false
        }
        
        circleView.transform = CGAffineTransformMakeScale(scale, scale)
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
        let translation = sender.translationInView(view).x / view.bounds.width
        
        if translation > 0.25 {
            cyclesPerMinute += 0.25
            sender.setTranslation(CGPoint.zero, inView: view)
            updateRhytmLabel()
        } else if translation < -0.25 {
            cyclesPerMinute -= 0.25
            sender.setTranslation(CGPoint.zero, inView: view)
            updateRhytmLabel()
        }
    }
}

