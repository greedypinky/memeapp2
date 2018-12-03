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
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var memeLabel: UILabel!
    
    
    var detailMeme: MyMeme! // force unwrap - when do we want to do this?
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: need to initialize the image and label
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
