//
//  ViewController.swift
//  SSS
//
//  Created by Kang on 2021/11/17.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
  
    @IBOutlet weak var reportTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
    }
    
    //textView placeholder
    func placeholderSetting() {
        reportTextView.delegate = self
        reportTextView.text = "신고내용을 작성해주세요."
        reportTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reportTextView.textColor == UIColor.lightGray {
            reportTextView.text = nil
            reportTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "신고내용을 작성해주세요."
                textView.textColor = UIColor.lightGray
        }
    }
}

