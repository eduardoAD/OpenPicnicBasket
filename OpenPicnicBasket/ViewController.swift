//
//  ViewController.swift
//  OpenPicnicBasket
//
//  Created by Eduardo Alvarado Díaz on 2/9/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var basketTop: UIImageView!
    @IBOutlet var basketBottom: UIImageView!
    @IBOutlet var fabricTop: UIImageView!
    @IBOutlet var fabricBottom: UIImageView!
    @IBOutlet var bug: UIImageView!

    var isBugDead = false
    let squishPlayer: AVAudioPlayer
    var tap = UITapGestureRecognizer(target: nil, action: Selector())

    required init?(coder aDecoder: NSCoder) {
        let squishPath = NSBundle.mainBundle().pathForResource("squish", ofType: "caf")
        let squishURL = NSURL(fileURLWithPath: squishPath!)
        squishPlayer = try! AVAudioPlayer(contentsOfURL: squishURL)
        squishPlayer.prepareToPlay()

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func inicio(){
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: { () -> Void in

            var basketTopFrame = self.basketTop.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height

            var basketBottomFrame = self.basketBottom.frame
            basketBottomFrame.origin.y += basketBottomFrame.size.height

            self.basketTop.frame = basketTopFrame
            self.basketBottom.frame = basketBottomFrame

            }) { (success) -> Void in
                //print("Basket doors opened!")
        }

        UIView.animateWithDuration(1.0, delay: 1.7, options: .CurveEaseOut, animations: { () -> Void in

            var fabricTopFrame = self.fabricTop.frame
            fabricTopFrame.origin.y -= fabricTopFrame.size.height

            var fabricBottomFrame = self.fabricBottom.frame
            fabricBottomFrame.origin.y += fabricBottomFrame.size.height

            self.fabricTop.frame = fabricTopFrame
            self.fabricBottom.frame = fabricBottomFrame

            }) { (success) -> Void in
                //print("Napkins opened!")
                self.bug.alpha = 1.0
                self.moveBugLeft()
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.inicio()

        tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func moveBugLeft(){
        if isBugDead { return }

        UIView.animateWithDuration(1.0, delay: 1.5, options: [.CurveEaseInOut, .AllowUserInteraction], animations: { () -> Void in
            self.bug.center = CGPoint(x: 75, y: 200)
        }) { (finished) -> Void in
            self.faceBugRight()
        }
    }

    func moveBugRight(){
        if isBugDead { return }

        UIView.animateWithDuration(1.0, delay: 1.5, options: [.CurveEaseInOut, .AllowUserInteraction], animations: { () -> Void in
            self.bug.center = CGPoint(x: 230, y: 250)
            }) { (finished) -> Void in
                self.faceBugLeft()
        }
    }

    func faceBugRight(){
        if isBugDead { return }

        UIView.animateWithDuration(1.0, delay: 0.0, options: [.CurveEaseInOut, .AllowUserInteraction], animations: { () -> Void in
            self.bug.transform =  CGAffineTransformMakeRotation(CGFloat(M_PI))
            }) { (finished) -> Void in
                self.moveBugRight()
        }
    }

    func faceBugLeft(){
        if isBugDead { return }

        UIView.animateWithDuration(1.0, delay: 0.0, options: [.CurveEaseInOut, .AllowUserInteraction], animations: { () -> Void in
            self.bug.transform =  CGAffineTransformMakeRotation(CGFloat(0.0))
            }) { (finished) -> Void in
                self.moveBugLeft()
        }
    }

    func handleTap(gesture: UITapGestureRecognizer){
        let tapLocation = gesture.locationInView(bug.superview)
        if bug.layer.presentationLayer()!.frame.contains(tapLocation) {
            //print("Bug tapped!")
            if isBugDead { return }

            squishPlayer.play()
            isBugDead = true
            view.removeGestureRecognizer(tap)

            UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in

                self.bug.transform = CGAffineTransformMakeScale(1.25, 0.75)

            }, completion: { (finished) -> Void in

                UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: { () -> Void in
                    self.bug.alpha = 0.0
                }, completion: { (finished) -> Void in
                    self.bug.removeFromSuperview()
                })

            })
        }else{
            //print("Bug not tapped!")
        }
    }
}

