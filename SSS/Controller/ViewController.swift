//
//  ViewController.swift
//  SSS
//
//  Created by Kang on 2021/11/17.
//

import UIKit
import DropDown

class ViewController: UIViewController, UITextViewDelegate {
  
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var reportTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
    }
    
    
    @IBAction func reportType(_ sender: UIButton) {
        //객체 생성
        let dropDown = DropDown()
        //가운데 view 생기는걸 reportType버튼쪽으로 이동
        dropDown.anchorView = reportTypeButton
        //버튼 가리는거 방지(?)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        //각진모서리 멈춰!!
        dropDown.cornerRadius = 0.5
        dropDown.dataSource = ["헬멧 미착용", "두명 이상 탑승", "기타"]
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            reportTypeButton.setTitle("\(item)", for: .normal)
        }
        
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

