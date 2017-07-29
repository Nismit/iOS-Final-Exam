//
//  PhotoInfoViewController.swift
//  PhotoLibrary
//
//  Created by Derrick Park on 2017-07-21.
//  Copyright © 2017 Derrick Park. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var bookmarkIcon: UIBarButtonItem!
    
    var photo: Photo! {
        didSet{
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo) { (result) in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
        
        setIconColor(flag: photo.favorite)
    }
    
    func setIconColor(flag: Bool) {
        if(flag) {
            bookmarkIcon.tintColor = UIColor.red
        } else {
            bookmarkIcon.tintColor = UIColor.blue
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags"?:
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected Segue Identifier.")
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        let context = self.store.persistentContainer.viewContext
        
        if (photo.favorite) {
            // set to false from true
            photo.favorite = false
        } else {
            // set to true from false
            photo.favorite = true
        }
        
        do {
            try context.save()
            setIconColor(flag: photo.favorite)
        } catch let error {
            print("Core Data save failed: \(error)")
        }

    }
}
