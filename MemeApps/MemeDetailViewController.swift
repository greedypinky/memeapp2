//
//  MemeDetailViewController.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-11-28.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import UIKit

// This will show the Meme image
// with Navigation LeftBarButton "Sent Memes" to go back to the previous navigation stack
// and right button Edit which can navigate to the edit page
class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeUpper: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeBottom: UILabel!
    
    var detailMeme: MyMeme! // force unwrap - when do we want to do this?
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Init the detail view
        memeUpper.text = detailMeme.upperText
        memeImage.image = detailMeme.memedImage
        memeBottom.text = detailMeme.bottomText
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Detail page Navigation Right Button is Edit button
        // and click back - can go back to the previous List or Collection page.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(edit))
        
    }
    
    
    @objc func edit() {
        
        // TODO: Navigate back to the MemeViewController
        // present the viewcontroller
        // but push
        let memeVC = storyboard?.instantiateViewController(withIdentifier: "memeCreateView") as! MemeViewController
        memeVC.editMeme = detailMeme
        //navigationController?.present(memeVC, animated: true, completion: nil)
        memeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(memeVC, animated: true)
        
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
