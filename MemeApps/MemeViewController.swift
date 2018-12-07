//
//  ViewController.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-10-21.
//  Copyright © 2018 Rita's company. All rights reserved.
//
import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    var editMeme:MyMeme?
    var memedImage: UIImage?
    var editMode:Bool = false
    
    var originalViewHight:CGFloat = 0
    
    // define the text attributes for the Upper and the Buttom text
    let memeTextAttributes:[NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
        NSAttributedString.Key.strokeWidth: -2.0]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) // need to disable the camera button if not available in the Simulator
        subscribeToKeyboardNotifications()
        upperTextField.delegate = self
        bottomTextField.delegate = self
        originalViewHight = view.frame.origin.y
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(share))
        //navigationItem.leftBarButtonItem?.isEnabled = false
        enableShare(bool: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        
        // Initialize the information of the Meme
        if let editImage = editMeme?.originalImage,
           let editUpper = editMeme?.upperText,
           let editBottom = editMeme?.bottomText {
            imageView.image = editImage
            upperTextField.text = editUpper
            bottomTextField.text = editBottom
            // In Edit mode we do not disable the upload button
            //navigationItem.leftBarButtonItem?.isEnabled = true
            enableShare(bool: true)
            
            editMode = true
            
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configAttributes(textField: upperTextField, withText: "Upper text")
        configAttributes(textField: bottomTextField, withText: "Bottom text")
    }
    
    func configAttributes(textField:UITextField,withText:String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center // try to fix the text not in center issue
        textField.attributedPlaceholder = NSAttributedString(string:withText, attributes:memeTextAttributes)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        let button = sender as? UIButton
        if button?.titleLabel?.text == "album" {
            print("set the source to album")
            presentImagePickerWith(sourceType: .photoLibrary)
        } else {
            presentImagePickerWith(sourceType: .camera)
        }
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController methods
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage {
            // set the image to the imageview
            imageView.image = originalImage
            
            // TODO: can also generate the image at this point
            if let image = generateMemedImage() {
                memedImage = image
                enableShare(bool: true)
            }
            
            dismiss(animated: true, completion: nil)
        
        }
        
       
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // shift up the frame to the hight of the keyboard's hight when keyboard is up
    @objc func keyboardWillShow(_ notification:Notification) {

        if bottomTextField.isEditing {
            if view.frame.origin.y == 0  {
                //view.frame.origin.y -= getKeyboardHeight(notification)
                view.frame.origin.y = -getKeyboardHeight(notification)
            }
        }
    }

    // return the keyboard's height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        let meme = MyMeme(original: imageView.image!, memed: memedImage!, upperText: upperTextField.text!,
                                bottomText: bottomTextField.text!)
        MyMeme.append(meme: meme)
    }
    
    @objc func share() {
        // check if the memedImage is generated, if it is generated we will share the content
        guard memedImage != nil else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, returnedItems, activityError) in
            
            if (success) {
                self.save()
                // navigate to the tableview
                //let tableView = self.storyboard?.instantiateViewController(withIdentifier: "memeTable") as! MemeTableViewController
               // let tableView = self.storyboard?.instantiateViewController(withIdentifier: "memeTable") as! MemeTableViewController
                
                // memeTabBarController
                let tableView = self.storyboard?.instantiateViewController(withIdentifier: "memeTabBarController") as! UITabBarController
                self.navigationController?.present(tableView, animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
        // how do we know the sharing is done?
        
        // TODO we navigate here to the tab controller?
    }
    
    @objc func cancel() {
        print("cancel")
        navigationController?.popViewController(animated: true)
    }
    
    func generateMemedImage() -> UIImage? {
        
        guard let _ = imageView.image else {
            return nil
        }
        // Hide toolbar and navbar
        hideTopAndButtomBar(hide:true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // UnHide toolbar and navbar
        hideTopAndButtomBar(hide:false)
        return memedImage
    }
    
    func hideTopAndButtomBar(hide:Bool) {
        
        toolBar.isHidden = hide
        self.navigationController?.setNavigationBarHidden(hide, animated: true)
    }
    
    func enableShare(bool:Bool) {
        
        navigationItem.leftBarButtonItem?.isEnabled = bool
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        print("tap around to dismiss keyboard!")
        view.endEditing(true)
        view.frame.origin.y = self.originalViewHight

        if let image = generateMemedImage() {
            memedImage = image
            enableShare(bool: true)
        }
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: Clear the textfield content
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    // Limit the width is not more than the current view's width
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        var newTextString = oldText.replacingCharacters(in: range, with: string)
        
        return true
    }
    
    // If user presses return button, generate the memed image and enable the share button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame.origin.y = originalViewHight
        if let image = generateMemedImage() {
            memedImage = image
            enableShare(bool: true)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
}


