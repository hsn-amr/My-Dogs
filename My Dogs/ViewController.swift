//
//  ViewController.swift
//  My Dogs
//
//  Created by administrator on 14/12/2021.
//

import UIKit
import CoreData



class ViewController: UICollectionViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dogs = [Dog]()

    // I Got it from StackOverFlow Website
    // https://stackoverflow.com/questions/14674986/uicollectionview-set-number-of-columns

    let columnLayout = ColumnFlowLayout(
           cellsPerRow: 2,
           minimumInteritemSpacing: 10,
           minimumLineSpacing: 10,
           sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       )

       override func viewDidLoad() {
           super.viewDidLoad()

           collectionView?.collectionViewLayout = columnLayout
           collectionView?.contentInsetAdjustmentBehavior = .always
           collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
       }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllDogs()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        let dog = dogs[indexPath.row]
        let image = UIImage(data: dog.image!)
        cell.cellImage.image = image
        
        return cell
    }
    
   
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Saving", sender: indexPath.row)
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Saving", sender: nil)
        print("adding")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let saveViewController = segue.destination as! SaveDogViewController
        saveViewController.dogsCoreDataOperations = self
        if sender != nil {
            saveViewController.index = (sender as? Int)
        }
    }
    func getDataFromUIImage(image: UIImage) -> Data{
        return image.jpegData(compressionQuality: 1.0)!
    }
    
    func fetchAllDogs(){
        let dogRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        
        do {
            let result = try managedObjectContext.fetch(dogRequest)
            dogs = result as! [Dog]
            print("Fetched")
            collectionView.reloadData()
        } catch {
            print("Fetching error \(error.localizedDescription)")
        }
    }
    
    func saveChangesOfContext() -> Bool {
        var hasSaved = false
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Saved")
                hasSaved = true
            } catch {
                print("saving error : \(error.localizedDescription)")
            }
        }
        return hasSaved
    }
}

extension ViewController: DogsCoreDataOperations{
    func getDog(at index: Int) -> Dog {
        return dogs[index]
    }
    
    func addNewDog(name: String, color: String, favoriteTreat: String, image: UIImage) {
        let newDog = Dog(context: managedObjectContext)
        newDog.name = name
        newDog.color = color
        newDog.favoriteTreat = favoriteTreat
        let dogImage = getDataFromUIImage(image: image)
        newDog.setValue(dogImage, forKeyPath: "image")
        if saveChangesOfContext() {
            dogs.append(newDog)
            collectionView.reloadData()
        }
    }
    
    func updateDog(name: String, color: String, favoriteTreat: String, image: UIImage, at index: Int) {
        let dog = dogs[index]
        dog.name = name
        dog.color = color
        dog.favoriteTreat = favoriteTreat
        let dogImage = getDataFromUIImage(image: image)
        dog.setValue(dogImage, forKeyPath: "image")
        if saveChangesOfContext() {
            dogs[index] = dog
            collectionView.reloadData()
        }
    }
    
    func deleteDog(at index: Int) {
        let dog = dogs[index]
        managedObjectContext.delete(dog)
        if saveChangesOfContext() {
            dogs.remove(at: index)
            collectionView.reloadData()
        }
    }
    
    
}
