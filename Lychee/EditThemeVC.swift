//
//  EditThemeVC.swift
//  Lychee
//
//  Created by Divya K on 2/19/19.
//  Copyright © 2019 Divya K. All rights reserved.
//

import Foundation
import UIKit

class MyCell: UICollectionViewCell {
    @IBOutlet weak var characterImageView:UIImageView!
}

class EditThemeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var themesCollection:UICollectionView!
    
    let imageNames = ["light red", "light yellow", "light orange", "light green", "light turqoise", "light blue", "light pink", "light purple", "light grey","pop red", "pop yellow", "pop orange", "pop green", "pop turqoise", "pop blue", "pop pink", "pop purple", "pop grey", "dark red", "dark yellow", "dark orange", "dark green", "dark turqoise", "dark blue", "dark pink", "dark purple", "dark grey"]
    
    var images = [UIImage]()
    
    override func viewDidLayoutSubviews() {
        themesCollection.dataSource = self
        themesCollection.delegate = self
        
        if let flowlayout = self.themesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.itemSize = CGSize(width: 50, height: 50)
        }
        
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
        themesCollection.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        if images.count == 27 {
            cell.characterImageView.image = images[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCell
        
        for c in collectionView.visibleCells {
            c.layer.backgroundColor = UIColor.clear.cgColor
        }
        //cell?.layer.backgroundColor = UIColor.green.cgColor
        
        //let selectedColor = cell.characterImageView.image.
    }
   
}
