//
//  PHPickerManager.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class PHPickerManager {
    private let phPicker: PHPickerViewController
    private let selectedImageRelay = PublishRelay<UIImage?>()
        
    var selectedImage: Observable<UIImage?> {
        return selectedImageRelay.asObservable()
    }
    
    init() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
    }
    
    func present(from viewController: UIViewController) {
        viewController.present(phPicker, animated: true)
    }
}

extension PHPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard
            let itemProvider = results.first?.itemProvider,
            itemProvider.canLoadObject(ofClass: UIImage.self)
        else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage else {
                self?.selectedImageRelay.accept(nil)
                return
            }
            
            self?.selectedImageRelay.accept(image)
        }
    }
}
