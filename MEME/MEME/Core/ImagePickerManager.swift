//
//  ImagePickerManager.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ImagePickerManager: NSObject {
    private let imagePicker = UIImagePickerController()
    private let selectedImageRelay = PublishRelay<UIImage?>()
        
    var selectedImage: Observable<UIImage?> {
        return selectedImageRelay.asObservable()
    }
    
    override init() {
        super.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
    }
    
    func present(from viewController: UIViewController) {
        viewController.present(imagePicker, animated: true)
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImageRelay.accept(image)
        } else {
            selectedImageRelay.accept(nil)
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ImagePickerManager: UINavigationControllerDelegate {
    
}
