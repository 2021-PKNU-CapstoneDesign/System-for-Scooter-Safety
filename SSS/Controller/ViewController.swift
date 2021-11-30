//
//  ViewController.swift
//  SSS
//
//  Created by Kang on 2021/11/17.
//

import UIKit
import DropDown
import CoreLocation
import Lottie

class ViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
  
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var reportTypeButton: UIButton!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var reportImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //뭔가 이상함..
//        let animationView = AnimationView(name: "64970-electric-scooter-baloon") // AnimationView(name: "lottie json 파일 이름")으로 애니메이션 뷰 생성
//        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300) // 애니메이션뷰의 크기 설정
//        animationView.center = self.view.center // 애니메이션뷰의 위치설정
//        animationView.contentMode = .scaleAspectFill // 애니메이션뷰의 콘텐트모드 설정
//
//        view.addSubview(animationView) // 애니메이션뷰를 메인뷰에 추가
//
//        animationView.play() // 애니메이션뷰 실행
        
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
        
        //각진모서리 멈춰!!
        dropDown.cornerRadius = 15
        dropDown.dataSource = ["헬멧 미착용", "두명 이상 탑승", "기타"]
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            reportTypeButton.setTitle("\(item)", for: .normal)
        }
    }
    
    @IBAction func LocationButton(_ sender: UIButton) {
        var locationManager:CLLocationManager!
        //위도와 경도
        var latitude: Double?
        var longitude: Double?
        
        //locationManager 인스턴스 생성 및 델리게이트 생성
        locationManager = CLLocationManager()
        locationManager.delegate = self
               
        //포그라운드 상태에서 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
               
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
               
        //위치업데이트
        locationManager.startUpdatingLocation()
               
        //위도 경도 가져오기
        let coor = locationManager.location?.coordinate
        latitude = coor?.latitude
        longitude = coor?.longitude
        
        var latitude_O = latitude!
        var longitude_O = longitude!
//        print(latitude!)
//        print(longitude!)
        
        //현재위치 불러오기
        let findLocation = CLLocation(latitude: latitude_O, longitude: longitude_O)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")//원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                //전체 주소
                if let name: String = address.last?.name {
                    if let admin: String = address.last?.administrativeArea {
                        if let locality: String = address.last?.locality  { self.locationAddress.text = admin + " " + locality + " " + name
                            
                        } }
                    }
                
            }
        }
    )
}
    
    @IBAction func reportImage(_ sender: UIButton) {
        //갤러리
        let camera = UIImagePickerController()
        camera.delegate = self
        self.present(camera, animated: true, completion: nil)
    }
    
    //화면 클릭 시 키보드 내리기 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
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

