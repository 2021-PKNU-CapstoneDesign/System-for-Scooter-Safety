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
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var reportImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.isTranslucent = false
        naviBar.backgroundColor = .systemBackground
        
        placeholderSetting()
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        //카메라
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .camera
        camera.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        self.present(camera, animated: true, completion: nil)
    }
    
    @IBAction func reportType(_ sender: UIButton) {
        let dropDown = DropDown()
        //가운데 view 생기는걸 reportType버튼쪽으로 이동
        dropDown.anchorView = reportTypeButton
        //버튼 가리는거 방지(?)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        //각진모서리 멈춰!! -> 근데 이거 안되는듯
        dropDown.cornerRadius = 15
        dropDown.dataSource = ["헬멧 미착용", "두명 이상 탑승", "기타"]
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            reportTypeButton.setTitle("\(item)", for: .normal)
        }
    }
    
    @IBAction func reportImage(_ sender: UIButton) {
        //갤러리
        let camera = UIImagePickerController()
        camera.delegate = self
        self.present(camera, animated: true, completion: nil)
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //이미지 저장
        if let image = info[.originalImage] as? UIImage {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedImage), nil)
                }
                
        //동영상 저장
        if let url = info[.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(savedVideo), nil)
                }
                picker.dismiss(animated: true, completion: nil)
        
        if let pickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            reportImage.image = pickImage
                    print(info)
                }
                dismiss(animated: true, completion: nil)

            }
    
    @objc func savedImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
            if let error = error {
                print(error)
                return
            }
            print("success")
        }
        
    @objc func savedVideo(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
            if let error = error {
                print(error)
                return
            }
            print("success")
        }
}

