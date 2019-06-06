//
//  ViewController.swift
//  Fusuma
//
//  Created by ytakzk on 01/31/2016.
//  Copyright (c) 2016 ytakzk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var fileUrlLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        showButton.layer.cornerRadius = 2.0
        fileUrlLabel.text = ""
    }

    @IBAction func showButtonPressed(_ sender: AnyObject) {
        // Show Fusuma
        let fusuma = FusumaViewController()

        fusuma.delegate = self
        fusuma.availableModes = [.library, .video, .camera]
        fusuma.photoSelectionLimit = 4
        fusumaSavesImage = true

        present(fusuma, animated: true, completion: nil)
    }
}

extension ViewController: FusumaDelegate {
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata?) {
        dismiss(animated: true)
        print("fusumaImageSelected")

        imageView.image = image

        guard let metaData = metaData else { return }
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
    }

    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode, metaData: [ImageMetadata]) {
        dismiss(animated: true)
        print("fusumaMultipleImageSelected")

        print("Number of selection images: \(images.count)")
        var count: Double = 0
        for image in images {
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                self.imageView.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        dismiss(animated: true)
        print("fusumaVideoCompleted")

        print("video completed and output to file: \(fileURL)")
        self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }

    func fusumaCameraRollUnauthorized() {
        print("fusumaCameraRollUnauthorized")

        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        })

        guard let vc = UIApplication.shared.delegate?.window??.rootViewController, let presented = vc.presentedViewController else {
            return
        }

        presented.present(alert, animated: true, completion: nil)
    }

    func fusumaCancel() {
        dismiss(animated: true)
        print("fusumaCancel")
    }
}
