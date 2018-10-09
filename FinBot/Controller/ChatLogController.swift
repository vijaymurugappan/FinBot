//
//  ChatLogController.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 10/3/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import ApiAI

private let reuseIdentifier = "Cell"

class ChatLogController: UICollectionViewController, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter message..."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        return textView
    }()
    
    let cellID = "cellID"
    var messages = [Message]()
    
    var users = [User]()
    var user: User?
    
    func observeProfile() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("Users").child(uid!)
        ref.observe(.value, with: { (Snapshot) in
            guard let dictionary = Snapshot.value as? [String: Any] else {
                return
            }
            let userVal = User(dictionary: dictionary)
            //potential of crashing if keys don't match
            userVal.setValuesForKeys(dictionary)
            self.users.append(userVal)
            self.user = self.users[0]
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        observeProfile()
        let image = UIImage(named: "combo_chart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image!, style: .plain, target: self, action: #selector(dashboard))
        navigationItem.title = "FIN BOT"
        let logImage = UIImage(named: "shutdown")
        let logoutBtn = UIBarButtonItem(image: logImage!, style: .plain, target: self, action: #selector(logoutPressed))
        navigationItem.leftBarButtonItem = logoutBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.keyboardDismissMode = .interactive
        setupKeyboardObservers()
    }
    
    @objc func dashboard() {
        let controller = ChartViewController()
        controller.user = self.user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func logoutPressed() {
        do {
            let ref = Database.database().reference()
            ref.child("messages").removeValue()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
            try Auth.auth().signOut()
        }
        catch let signOutErr {
            print(signOutErr.localizedDescription)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter message..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        //Layout Constraints
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        let sendButton = UIButton(type: .system)
        let img = UIImage(named: "paper_plane")
        sendButton.setImage(img!, for: .normal)
        //sendButton.tintColor = UIColor.blue
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //Layout Constraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        containerView.addSubview(inputTextView)
        
        //Layout Constraints
        inputTextView.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
        
    }()
    
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            handleVideoSelectedForUrl(videoURL)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        let fileName = UUID().uuidString + ".mov"
        let ref = Storage.storage().reference().child("message_movies").child(fileName)
        let uploadTask = Storage.storage().reference().child("message_movies").child(fileName).putFile(from: url, metadata: nil) { (metadata, err) in
            if err != nil {
                print("Failed upload of video: ", err!)
                return
            }
            ref.downloadURL(completion: { (urlV, error) in
                if error != nil {
                    print("Failed download URL: ", error!)
                    return
                }
                if let videoURL = urlV?.absoluteString {
                    if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                        
                        self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                            let properties = ["imageURL": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoURL": videoURL] as [String: Any]
                            self.sendMessageWithProperties(properties, sender: 1)
                            
                        })
                    }
                }
            })
        }
        uploadTask.observe(.progress) { (Snapshot) in
            if let completedUnit = Snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnit)
            }
        }
        uploadTask.observe(.success) { (Snapshot) in
            self.navigationItem.title = "CLERKIE CHATBOT"
        }
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    fileprivate func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey: Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                ref.downloadURL(completion: { (url, err) in
                    if err != nil {
                        print("Failed to download url:", err!)
                        return
                    }
                    if let imageUrl = url?.absoluteString {
                        completion(imageUrl)
                    }
                })
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupInitialMessages(inputText: String) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text": inputText, "sender": 0] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
        }
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (Snapshot) in
            guard let dictionary = Snapshot.value as? [String: AnyObject] else {
                return
            }
            let message = Message(dictionary: dictionary)
            //potential of crashing if keys don't match
            message.setValuesForKeys(dictionary)
            self.messages.append(message)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }, withCancel: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        let messageCell = messages[indexPath.item]
        cell.message = messageCell
        setupCell(cell: cell, messageCell: messageCell)
        cell.textView.text = messageCell.text
        if let text = messageCell.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if messageCell.imageURL != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = messageCell.videoURL == nil
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, messageCell: Message) {
        if messageCell.sender == 1 {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = ChatMessageCell.grayColor
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        if let messageImageUrl = messageCell.imageURL {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    @objc func handleSend() {
        if !(inputTextView.text?.isEmpty)! {
            let properties = ["text": inputTextView.text!]
            sendMessageWithProperties(properties as [String : Any], sender: 1)
        }
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
       let properties = ["imageURL": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String: Any]
        sendMessageWithProperties(properties, sender: 1)
    }
    
    fileprivate func sendMessageWithProperties(_ properties: [String: Any], sender: Int) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        var values: [String: Any] = ["sender": sender]
        properties.forEach({values[$0.key] = $0.value})
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            if properties.count == 3 {
                let sendVal: [String: Any] = ["text": "Thats a nice image you've got there!"]
                self.sendMessageWithProperties(sendVal, sender: 0)
            } else if properties.count == 4 {
                let sendVal: [String: Any] = ["text": "This video is so funny!"]
                self.sendMessageWithProperties(sendVal, sender: 0)
            } else {
                if sender == 1 {
                    self.requestResponse(text: values["text"] as! String)
                }
            }
            //CALL FUNCTION
        }
        inputTextView.text = nil
    }
    
    //AI FUNCTIONS - DIALOGFLOW
    
    func requestResponse(text: String) {
        let request = ApiAI.shared()?.textRequest()
        if text != "" {
            request?.query = text
        } else { return }
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let messages = response.result.fulfillment.messages {
                let textRespo = messages[0] as NSDictionary
                let text = textRespo.value(forKey: "speech")
                let val: [String: Any] = ["text": text!]
                self.sendMessageWithProperties(val, sender: 0)
                return
            } else {
                let val: [String: Any] = ["text": "Thanks for asking but I couldn't get you properly"]
                self.sendMessageWithProperties(val, sender: 0)
                return
            }
        }, failure: { (request, err) in
            print(err!)
        })
        ApiAI.shared()?.enqueue(request)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0

                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
            
        }
        
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {

                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1

            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }

}
