//
//  ImagesViewController.swift
//  LoopTestTask
//
//  Created by Karen Karapetyan on 5/8/19.
//  Copyright © 2019 Karen Karapetyan. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var categoriesView: CategoriesSelectorView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var slider: UISlider!
    
    let cellID = "Cell"
    var selectedCategory = Categories.shared.all[0]
    
    let transition = PopAnimator()
    var selectedItemIndexPath: IndexPath?
    
    var cellWidth: CGFloat = 100 {
        didSet {
            let layout = imagesCollectionView.collectionViewLayout as! ImagesCollectionViewLayout
            layout.cellWidth = cellWidth
            layout.resetCache()
            imagesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: Methods
    private func initialSetup() {
        categoriesView.delegate = self
        
        imagesCollectionView.register(UINib(nibName: "ImageColectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        
        let layout = imagesCollectionView.collectionViewLayout as! ImagesCollectionViewLayout
        layout.delegate = self
        
        slider.maximumValue = Float(view.frame.width - 10)
        
//        let slider = CustomSlider(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 350, width: 80, height: 300))
//        view.addSubview(slider)
    }
    
    private func cellHeight(indexPath: IndexPath) -> CGFloat {
        let image = selectedCategory.images[indexPath.row]
        let height = cellWidth * image.size.height / image.size.width
        return height
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        cellWidth = CGFloat(sender.value)
    }
    
}

extension ImagesViewController: ImagesLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return cellHeight(indexPath: indexPath)
    }
}

extension ImagesViewController: CategoriesSelectorViewDelegate {
    
    func didSelectCategory(category: Category) {
        selectedCategory = category
        let layout = imagesCollectionView.collectionViewLayout as! ImagesCollectionViewLayout
        layout.resetCache()
        imagesCollectionView.reloadData()
        
        if !selectedCategory.images.isEmpty {
            imagesCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
        }
    }
}

extension ImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCategory.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageColectionViewCell
        cell.image = selectedCategory.images[indexPath.row]
        return cell
    }
}

extension ImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItemIndexPath = indexPath
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDetailsViewController") as! ImageDetailsViewController
        vc.image = selectedCategory.images[indexPath.row]
        vc.transitioningDelegate = self
        
        let cell = imagesCollectionView.cellForItem(at: selectedItemIndexPath!) as! ImageColectionViewCell
        let courceView = cell.imageView!
        
        vc.imageFrame = courceView.frame
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight(indexPath: indexPath))
    }
}

extension ImagesViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let cell = imagesCollectionView.cellForItem(at: selectedItemIndexPath!) as! ImageColectionViewCell
        let courceView = cell.imageView!
        let window = UIApplication.shared.delegate!.window!
        let frame = courceView.convert(courceView.frame, to: window)
        
        transition.originFrame = frame
        
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }

}
