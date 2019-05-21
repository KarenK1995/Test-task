//
//  AppModel.swift
//  LoopTestTask
//
//  Created by Karen Karapetyan on 5/8/19.
//  Copyright © 2019 Karen Karapetyan. All rights reserved.
//

import UIKit

struct Category {
    let name: String
    let images: [UIImage]
}

class Categories {
    
    static let shared = Categories()

    private init() {}
    
    private let categoryNames = ["Wallpapers", "Animals", "Textures & Patterns", "Nature", "Architecture", "Business & Work"]
    
    lazy var all = { () -> [Category] in
        let allCategories = categoryNames.map { (name) -> Category in
            let resourcePath = Bundle.main.resourcePath! + "/Images/\(name)/";
            let fileManager = FileManager.default
            let contents = try! fileManager.contentsOfDirectory(atPath: resourcePath)
            
            var images = [UIImage]()
            
            for fileName in contents {
                autoreleasepool {
                    let url = URL(fileURLWithPath: resourcePath + fileName)
                    let imageData = try! Data(contentsOf: url)
                    let image = UIImage(data: imageData)!//.scaledNTiems(n: 2)
                    images.append(image)
                }
            }
            
            let category = Category(name: name, images: images)
            return category
        }
        
        return allCategories
    }()
    
}
