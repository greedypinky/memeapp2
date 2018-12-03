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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    // conform to UITableViewDataSource
    // each cell has the memeimage, and the text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        // set the data for the cell
        let meme = memelist[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = ("\(meme.upperText)\(meme.bottomText)")
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let detailController = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! MemeDetailViewController
      detailController.detailMeme = memelist[indexPath.row]
      self.navigationController!.pushViewController(detailController, animated: true)
        
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
