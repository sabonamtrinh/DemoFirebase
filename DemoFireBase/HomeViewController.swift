//
//  HomeViewController.swift
//  DemoFireBase
//
//  Created by namtrinh on 30/12/2020.
//

import UIKit
import FirebaseAuth

struct Model {
    let image: Data
}

class HomeViewController: UIViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var storageTableview: UITableView!
    
    var models = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(handelLogOutBarButtonItem))
        self.navigationItem.setHidesBackButton(true, animated: true)
        uploadButton.layer.cornerRadius = 10
        downloadButton.layer.cornerRadius = 10
        storageTableview.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        storageTableview.delegate = self
        storageTableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func handelDownloadButton(_ sender: Any) {
        StorageManager.shared.downloadImage(with: "image/file.png") { (sucess, data) in
            if sucess {
                self.models = data
            } else {
                print("Error")
            }
        }
    }
    
    @IBAction func handelUpLoadButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera is not valiable!")
            }
        }))
        actionSheet.addAction((UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        })))
        actionSheet.addAction((UIAlertAction(title: "Cancel", style: .default, handler: nil)))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @objc func handelLogOutBarButtonItem(){
        let actionSheet = UIAlertController(title: "Log Out",
                                      message: "Are you sure you want to log out",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { _ in
                AuthManager.shared.logOut(completion: { success in
                    DispatchQueue.main.async {
                        if success {
                            // persent log in
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
                            // error
                            fatalError("Could not log out user")
                        }
                    }
                })
            }))
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        guard let imageData = image.pngData() else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        StorageManager.shared.upLoadImage(image: imageData) { (success) in
            if success {
                let actionSheet = UIAlertController(title: "Success", message: "Upload successfully", preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(actionSheet, animated: true, completion: nil)
            }
            else {
                print("Error")
            }
        }
    }
    
}

extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storageTableview.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
        cell.imageStorage.image = UIImage(data: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
