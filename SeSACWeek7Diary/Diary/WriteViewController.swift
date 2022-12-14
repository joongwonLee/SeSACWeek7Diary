//
//  WriteViewController.swift
//  SeSACWeek7Diary
//
//  Created by 이중원 on 2022/08/19.
//

import UIKit
import RealmSwift

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

//final 키워드를 사용하면 그 클래스는 상속 불가능!
//final => static dispatch 방식으로 바뀌기 때문에, 성능이 향상됨!
final class WriteViewController: BaseViewController {
    
    let repository = UserDiaryRepository()
    
    let mainView = WriteView()
    private let localRealm = try! Realm() //Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근
    
    override func loadView() { //super.loadView X
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
//        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func configure() {
        mainView.searchImageButton.addTarget(self, action: #selector(selectImageButtonClicked), for: .touchUpInside)
        mainView.sampleButton.addTarget(self, action: #selector(sampleButtonClicked), for: .touchUpInside)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = closeButton
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    //Realm + 이미지 도큐먼트 저장
    @objc func saveButtonClicked() {
        guard let title = mainView.titleTextField.text else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }
        
        let task = UserDiary(diaryTitle: title, diaryContent: mainView.contentTextView.text!, diaryDate: Date(), regdate: Date(), imageURL: nil)
        
        self.repository.createItem(item: task)
        if let image = mainView.photoImageView.image {
            saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
        }
        
        dismiss(animated: true)
    }
    
    
    //Realm Create Sample
    @objc func sampleButtonClicked() {
        
        let task = UserDiary(diaryTitle: "가오늘의 일기\(Int.random(in: 1...1000))", diaryContent: "일기 테스트 내용", diaryDate: Date(), regdate: Date(), imageURL: nil) // => Record
        
        self.repository.createItem(item: task)
        
    }
    
//    @objc func titleTextFieldClicked(_ textField: UITextField) {
//        guard let text = textField.text, text.count > 0 else {
//            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
//            return
//        }
//    }
    
    @objc func selectImageButtonClicked() {
        let vc = ImageSearchViewController()
        vc.delegate = self
        transitionViewController(vc, transitionStyle: .presentFullNavigation)
    }
}

extension WriteViewController: SelectImageDelegate {
    
    //언제 실행이 되면 될까?
    func sendImageData(image: UIImage) {
        mainView.photoImageView.image = image
        print(#function)
    }
}
