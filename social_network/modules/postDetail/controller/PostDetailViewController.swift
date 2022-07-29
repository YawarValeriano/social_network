//
//  PostDetailViewController.swift
//  social_network
//
//  Created by admin on 7/17/22.
//

import UIKit
import Photos

class PostDetailViewController: UIViewController {
    var createNewPost = true
    var post: Post?
    var postDetailViewModel = PostDetailViewModel()
    var selectedCategory: CategoryType = .Action
    var hasChangedImage = false

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var categoryTypePicker: UIPickerView!
    @IBOutlet weak var movieUrlField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTypePicker.delegate = self
        categoryTypePicker.dataSource = self
        setTitle()
        loadDataIfNeeded()
        // Do any additional setup after loading the view.
    }

    private func loadDataIfNeeded() {
        if !createNewPost, let post = self.post {
            selectedCategory = post.category
            descriptionTextView.text = post.description
            categoryTypePicker.selectRow(post.category.elementIndex(), inComponent: 0, animated: true)
            movieUrlField.text = post.urlMovie ?? ""
            guard let imageStr = post.urlImage, let url = URL(string: imageStr) else { return }
            postImageView.image = ImageManager.shared.getUIImage(formURL: url)
        }
    }

    private func setTitle() {
        if createNewPost {
            title = "Create Post"
            saveChangesButton.setTitle("Save Post", for: .normal)
        } else {
            title = "Edit Post"
            saveChangesButton.setTitle("Update Post", for: .normal)
        }
    }

    private func showAddImageOptionAlert() {
        DispatchQueue.main.async {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            sheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
                // image from device
                self.showDeviceImageLibrary()
            })

            sheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                // image from device camera
                self.didTapCamera()
            })

            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.navigationController?.present(sheet, animated: true, completion: nil)

        }
    }

    @IBAction func savePost(_ sender: Any) {
        if createNewPost {
            postDetailViewModel.savePost(urlMovie: movieUrlField.text, description: descriptionTextView.text,
                                         category: selectedCategory, hasChangedImage: hasChangedImage, image: (postImageView.image?.jpegData(compressionQuality: 0.5))!) { result in
                switch result {
                case.success(()):
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true)
                case.failure(let error):
                    ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
                }
            }
        } else {
            postDetailViewModel.updatePost(documentId: post!.id!, urlMovie: movieUrlField.text, description: descriptionTextView.text, category: selectedCategory, oldUrlImage: post?.urlImage, hasChangedImage: hasChangedImage, imageData: postImageView.image!.jpegData(compressionQuality: 0.5)!) { result in
                switch result {
                case.success(()):
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true)
                case.failure(let error):
                    ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
                }
            }
        }
    }


    @IBAction func changeImage(_ sender: Any) {
        showAddImageOptionAlert()
    }


    // MARK: Device images
    func showDeviceImageLibrary() {
        let auth = PHPhotoLibrary.authorizationStatus()

        DispatchQueue.main.async {
            switch auth {
            case .notDetermined:
                self.requestLibraryAuthorization()
            case .restricted, .denied:
                ErrorHandler.shared.showError(withDescription: "Camera permission is needed. Please Add the permission from Settings.", viewController: self)
            case .authorized, .limited:
                self.presentDeviceImageViewController()
            @unknown default:
                break
            }
        }

    }

    func requestLibraryAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            self.showDeviceImageLibrary()
        }
    }

    func presentDeviceImageViewController() {
        let vc = DeviceImageViewController()
        vc.delegate = self

        navigationController?.present(vc, animated: true, completion: nil)
    }

    // MARK: Device camera
    func didTapCamera() {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)

        switch auth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        ErrorHandler.shared.showError(withDescription: "Camera permission is needed. Please Add the permission from Settings.", viewController: self)
                    }
                }
            }
        case .restricted, .denied:
            ErrorHandler.shared.showError(withDescription: "Camera permission is needed. Please Add the permission from Settings.", viewController: self)
        case .authorized:
            self.presentCamera()
        @unknown default:
            return
        }
    }

    func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

        let cameraVC = UIImagePickerController()
        cameraVC.delegate = self
        cameraVC.sourceType = .camera
        cameraVC.cameraDevice = .rear

        navigationController?.present(cameraVC, animated: true)
    }
}

extension PostDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        CategoryType.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        CategoryType.allCases[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = CategoryType.allCases[row]
    }

}

extension PostDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage,
           let data = image.jpegData(compressionQuality: 0.5) {
            self.postImageView.image = UIImage(data: data)
            self.hasChangedImage = true
        }
    }
}

extension PostDetailViewController: DeviceImageLibaryViewControllerDelegate {
    func onDevicePhotoSelected(selectedAsset: PHAsset) {

        selectedAsset.image { image in
            if let data = image?.jpegData(compressionQuality: 0.5) {
                self.postImageView.image = UIImage(data: data)
                self.hasChangedImage = true
            }
        }
    }
}

