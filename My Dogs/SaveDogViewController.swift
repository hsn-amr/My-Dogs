//
//  SaveDogViewController.swift
//  My Dogs
//
//  Created by administrator on 14/12/2021.
//

import UIKit

class SaveDogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var dogColor: UITextField!
    @IBOutlet weak var dogFavoriteTreat: UITextField!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    var dogsCoreDataOperations: DogsCoreDataOperations?
    var index: Int?
    var savingMode = "adding"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let at = index{
            let dog = dogsCoreDataOperations?.getDog(at: at)
            dogName.text = dog?.name
            dogColor.text = dog?.color
            dogFavoriteTreat.text = dog?.favoriteTreat
            dogImageView.image = UIImage(data: (dog?.image)!)
            addButton.setTitle("Delete Dog", for: .normal)
            addButton.tintColor = .white
            addButton.backgroundColor = .red
            savingMode = "editing"
            updateButton.isEnabled = true
        }else {
            dogImageView.image = UIImage(named: "dog.jpg")
            updateButton.isEnabled = false
            savingMode = "adding"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoButtonClicked(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            dogImageView.image = image
        }
    }
    
    @IBAction func addNewDogButtonPressed(_ sender: UIButton) {
        if let name = dogName.text,
           let color = dogColor.text,
           let favoriteTreat = dogFavoriteTreat.text,
           let image = dogImageView.image {
            if !name.isEmpty && !color.isEmpty && !favoriteTreat.isEmpty {
                if savingMode == "adding" {
                    dogsCoreDataOperations?.addNewDog(name: name, color: color, favoriteTreat: favoriteTreat, image: image)
                }else if savingMode == "editing" {
                    dogsCoreDataOperations?.deleteDog(at: index!)
                }
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func updateButtonPressed(_ sender: UIBarButtonItem) {
        if let name = dogName.text,
           let color = dogColor.text,
           let favoriteTreat = dogFavoriteTreat.text,
           let image = dogImageView.image {
            if !name.isEmpty && !color.isEmpty && !favoriteTreat.isEmpty {
                dogsCoreDataOperations?.updateDog(name: name, color: color, favoriteTreat: favoriteTreat, image: image, at: index!)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
