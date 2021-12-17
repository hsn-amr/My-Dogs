//
//  DogsProtocols.swift
//  My Dogs
//
//  Created by administrator on 15/12/2021.
//

import Foundation
import UIKit

protocol DogsCoreDataOperations {
    
    func getDog(at index: Int) -> Dog
    
    func addNewDog(name: String, color: String, favoriteTreat: String, image: UIImage)
    
    func updateDog(name: String, color: String, favoriteTreat: String, image: UIImage, at index: Int)
    
    func deleteDog(at index: Int)
}
