//
//  ImagePickerController.swift
//  Identify
//
//  Created by Gaurang Vyas on 11/10/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import Foundation
import UIKit

public protocol ImagePickerControllerDelegate: AnyObject {
    func imagePicker(didSelectImage image: UIImage?)
    func imagePickerDidViewImageTapped()
}

open class ImagePickerController: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerControllerDelegate?

    public init(presentationController: UIViewController,
                delegate: ImagePickerControllerDelegate,
                allowsEditing: Bool = true) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowsEditing
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera {
                AppDelegate.hasCameraAccess { granted in
                    if granted {
                        self.pickerController.sourceType = type
                        self.presentationController?.present(self.pickerController, animated: true)
                    }
                }
            } else {
                AppDelegate.hasPhotoLibraryAccess { granted in
                    if granted {
                        self.pickerController.sourceType = type
                        self.presentationController?.present(self.pickerController, animated: true)
                    }
                }
            }
        }
    }

    public func present(from sourceView: UIView, showViewMoreOption: Bool) {
        let alertController = UIAlertController(title: MessageString.chooseSource,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        if showViewMoreOption {
            let action = UIAlertAction(title: StringConst.viewPhoto, style: .default) { _ in
                self.delegate?.imagePickerDidViewImageTapped()
            }
            alertController.addAction(action)
        }

        if let action = self.action(for: .camera, title: StringConst.camerRoll) {
            alertController.addAction(action)
        }

        if let action = self.action(for: .photoLibrary, title: StringConst.photoLibrary) {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: StringConst.cancel, style: .cancel, handler: { _ in
            Helper.setNavigationAppearance()
        }))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.imagePicker(didSelectImage: image)
    }
}

extension ImagePickerController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePickerController: UINavigationControllerDelegate {
}
