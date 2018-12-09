//
//  MemeCollectionViewController.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-11-28.
//  Copyright © 2018 Rita's company. All rights reserved.
//
// ref: https://developer.apple.com/documentation/uikit/uicollectionview#//apple_ref/doc/uid/TP40012177-CH1-SW35

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    
    let memelist = MyMeme.memelist
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(create))
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.title = "Sent Meme"
        
        self.tabBarItem.image = UIImage(named: "collection")
        self.tabBarItem.title = "Collection"
        
        let space:CGFloat = 3.0
        //  TODO: Test in Landscape mode
        // when in landscape,  this calculation is not appropriate
        // maybe the solution is detect the device mode and use height to calculate the dimension
        let orientation = UIDevice.current.orientation
        let dimension = UIDeviceOrientation.portrait == orientation ? ((view.frame.size.width - (2 * space)) / 3.0) : ((view.frame.size.height - (2 * space)) / 3.0)
        //let dimension = (view.frame.size.width - (2 * space)) / 3.0
        print("Dimension is \(dimension)")
        //let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowlayout.minimumInteritemSpacing = space
        flowlayout.minimumLineSpacing = space
        flowlayout.itemSize = CGSize(width: dimension, height: dimension)
  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // nagvigate to the create meme page
    @objc func create() {
        let createVC = storyboard?.instantiateViewController(withIdentifier: "memeCreateView") as! MemeViewController
        createVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memelist.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
    
        // TODO: Configure the cell
        if (memelist.count > 0) {
            let meme = memelist[indexPath.row]
            cell.memeImage?.image = meme.memedImage
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetail") as! MemeDetailViewController
        detailController.detailMeme = memelist[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        // push so that we can go back
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
