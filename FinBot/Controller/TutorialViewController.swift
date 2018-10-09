//
//  TutorialViewController.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 10/8/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var popView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var textDesc: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var counter: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.isHidden = true
        popView.layer.cornerRadius = 10
        popView.layer.masksToBounds = true
        popView.layer.shadowOpacity = 0.7
        popView.layer.shadowColor = UIColor.black.cgColor
        pageCtrl.isHidden = false
        titleLabel.text = "LINE CHART"
        textDesc.text = "Line charts represents the user's expenditure spent all over the year 2018 - Monthwise and each points represents the amount of dollars the user spent over that particular month and the red line in the duo line chart indicates the user's expenditure earned all over the year 2018"
        counter = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(updateTimer))
        tap.numberOfTapsRequired = 1
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        tapClose.numberOfTapsRequired = 1
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(updateTimer))
        swipe.direction = .left
        popView.addGestureRecognizer(swipe)
        popView.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(tapClose)
        // Do any additional setup after loading the view.
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTimer() {
        if(counter <= 2) {
            pageCtrl.currentPage = counter
            imgView.image = UIImage(named: String(counter+1))
            if(counter == 0) {
                titleLabel.text = "LINE CHART"
                textDesc.text = "Line charts represents the user's expenditure spent all over the year 2018 - Monthwise and each points represents the amount of dollars the user spent over that particular month and the red line in the duo line chart indicates the user's expenditure earned all over the year 2018"
            }
            if(counter == 1) {
                titleLabel.text = "PIE CHART"
                textDesc.text = "Pie chart represents the user's expenditure spent all over the year 2018 - Quarterwise and each quarter represents the amount of dollars the user spent over that particular 3 month quarter"
            }
            if(counter == 2) {
                titleLabel.text = "BAR CHART"
                textDesc.text = "bar charts represents the user's expenditure spent all over the year 2018 - Monthwise and each bar represents the amount of dollars the user spent over that particular month and its also represented horizontal wise"
                pageCtrl.isHidden = true
                closeBtn.isHidden = false
                return
            }
            counter! += 1
        }
    }

}
