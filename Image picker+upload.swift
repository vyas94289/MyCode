//Image Picker

@IBAction func profileTapped(){
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: NSLocalizedString("TakePhoto", comment: ""), style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                self.present(picker,animated: true,completion: nil)
            } else {
                Drop.down("Sorry, this device has no camera".localized)
            }
        })
        let library = UIAlertAction(title: "ChooseFromLibrary".localized, style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing=true
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: Const.cancel, style: .cancel, handler: nil)
        action.addAction(camera)
        action.addAction(library)
        action.addAction(cancel)
        action.view.tintColor = UIColor.main
        if let popoverController = action.popoverPresentationController {
            popoverController.sourceView = imgAvatar
            popoverController.sourceRect = imgAvatar.bounds
        }
        self.present(action, animated: true, completion: nil)
    }
    
    ///Upload
    
    func dataRequest(){
        DataRequest.post(url: URLs.profile, param: ["id":UserData.id]) { (response) in
            switch response{
            case .success(let data):
                do{
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    if let info = profile.result?.first {
                        self.profile = info
                        self.setValues(info: info)
                    }
                   
                }catch(let error){
                    print(error.localizedDescription)
                }
                break
            case .failure(let error, let message):
                print(error)
                Drop.down(message, state: .error)
                break
            }
        }
    }
    @IBAction func updateProfile(){
        var errors:[String] = []
        self.textFields.forEach({
            if $0.hasErrorMessage{
                errors.append(($0.errorMessage ?? "").capitalized)
            }
        })
        if !errors.isEmpty{
            self.simpleAlertShow(title:Const.Alert, message:errors.joined(separator: "\n"))
            return
        }
        ProgressView.shared.showProgressView(self.view)
        let param = ["tasker_id":String(UserData.id),
                     "name":tfFirstName.text ?? "",
                     "lname":tfLastName.text ?? "",
                     "email":tfEmail.text ?? "",
                     "address":homeAddr,"zipcode":""]

        guard let url = URL(string: URLs.profile_upload) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let image = self.pickedImage{
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBody(parameters: param,
                                          boundary: boundary,
                                          data: UIImageJPEGRepresentation(image, 0.7)!,
                                          mimeType: "image/jpeg",
                                          filename: "profile_\(Const.randomString(length: 10)).jpeg", imageParamName: "image")
        }else{
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            } catch let error {
                print("failure ProfileVC",error.localizedDescription)
            }
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            var message:String = ""
            if let mError = error{
                if let err = mError as? URLError,
                    err.code == .notConnectedToInternet {
                    message = Const.networkError
                } else {
                    message = Const.wentWrong
                }
                ProgressView.shared.hideProgressView()
            }else if let mData = data{
                guard let dictionary = try? JSONSerialization.jsonObject(with: mData, options: .mutableLeaves) as? [String:Any] else {
                    return
                }
                if let status = dictionary?["status"] as? Int,status == 1{
                    ProgressView.shared.hideProgressViewWithSuccess(text: "Profile Successfully updated".localized, completion: {
                    })
                    return
                }else{
                    ProgressView.shared.hideProgressView()
                    message = dictionary?["error"] as? String ?? Const.wentWrong
                    self.dataRequest()
                }
                Drop.down(message, state: .error)
            }
        }
        task.resume()
    }
    private func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String,
                    imageParamName:String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(imageParamName)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
//MARK: - URLSession delegate
extension ProfileVC:URLSessionDelegate,URLSessionTaskDelegate{
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let percent = Int(uploadProgress*100)
        ProgressView.shared.text = "Updating... \(percent)%"
    }
}
