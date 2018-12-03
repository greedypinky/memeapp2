//
//  MemeTableViewController.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-11-28.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    // conform to UITableViewDataSource
    // TODO: how to pass the memelist to this table?
    let memelist = MyMeme.memelist
    
    // Authors View Controller
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        // Initialize Tab Bar Item
//        tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "table"), tag: 0)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memelist.count
    }

    // conform to UITableViewDataSource
    // each cell has the memeimage, and the text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        // set the data for the cell
        let meme = memelist[indexPath.row]
        cell.imageView?.image = meme.memedImage
        
        cell.textLabel?.text = ("\(meme.upperText!)...\(meme.bottomText!)")
        
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        
        cell.accessibilityLabel? = "I am accessibility label"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let detailController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetail") as! MemeDetailViewController
      detailController.detailMeme = memelist[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        // push so that we can go back
      self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the title of the navigation bar
        //navigationController?.title = "Sent Meme"
        navigationItem.title = "Sent Meme"
        // Do any additional setup after loading the view.
        let tabItems = self.tabBarController?.tabBar.items
        tabItems?[0].image = UIImage(named: "table")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(create))
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        // need to set the icon from the TabBar
        
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
