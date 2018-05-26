@IBOutlet var mapView:GMSMapView!
mapView.delegate = self
mapView.isIndoorEnabled = false
mapView.isMyLocationEnabled = true

func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
       
        if driverMarkerArray.contains(where: {$0.marker == marker}) || currentPlaceToPick == .None{
            return nil
        }
        marker.tracksInfoWindowChanges = true
        let infoWindow = Bundle.main.loadNibNamed("PickupAnnotationView", owner: self, options: nil)?[0] as! PickupAnnotationVC
        
       // print("markerInfoWindow",currentPlaceToPick)
        let source:CLLocationCoordinate2D = self.currentPlaceToPick == .Source ? LocationInfo.shared.coordinate2D : self.sourceMarker.position
        if self.currentPlaceToPick == .Source{
            infoWindow.locationType.text = "Set Pickup Location".localized
        }else{
            infoWindow.locationType.text = "Set Destination Location".localized
        }
        Const.getTime(from: source, destination: marker.position, complition: { (route) in
            let minutes = Float(route.duration) / 60.0
            if minutes >= 60{
                infoWindow.time.text = String(format: "%.2f",Float(minutes/60))
                infoWindow.timeFormat.text = "HR"
            }else{
                infoWindow.time.text = String(Int(minutes))
                infoWindow.timeFormat.text = "MIN"
            }
        }, failure: {
            
        })
        
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        switch currentPlaceToPick {
        case .Source:
          //  self.pickupLoactionView.isHidden = true
           // self.destinationView.isHidden = false
            self.destinationView.isHidden = false
            self.stackView.addArrangedSubview(self.destinationView)
            self.stackView.removeArrangedSubview(self.pickupLoactionView)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.pickupLoactionView.isHidden = true
                self.stackView.layoutIfNeeded()
            })
            self.currentPlaceToPick = .Destination
            mapView.selectedMarker = nil;
            self.currentPlaceToPick = .Destination
            //to get closest distance
            self.sourceSelected = true
            self.rideBtnStack.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.rideBtnStack.layoutIfNeeded()
                self.rideBtnStack.superview?.layoutIfNeeded()
            })
            toggleCarView(show: true)
            self.driverListingRequest()
            break
        case .Destination:
            mapView.selectedMarker = nil;
            self.rideBtnStack.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.rideBtnStack.superview?.layoutIfNeeded()
                self.rideBtnStack.superview?.superview?.layoutIfNeeded()
            })
            self.currentPlaceToPick = .None
            break
        case .None:
            return
        }
        if sourceMarker != nil && destMarker != nil{
            let bounds = GMSCoordinateBounds(coordinate: sourceMarker.position, coordinate: destMarker.position)
            //top space of location detail view(12) + location view height(80) + marker height(40) = 132
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 150, left: 20, bottom: 20, right: 20))
            mapView.animate(with: update)
        }
    }
  //===================================================  
    class PickupAnnotationVC: UIView {
    @IBOutlet weak var popup:UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeFormat: UILabel!
    @IBOutlet weak var locationType: UILabel!
   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    override func awakeFromNib() {
        time.text = " "
        timeFormat.text = " "
        self.backgroundColor = UIColor.clear
    }
    override func didMoveToSuperview() {
        
    }
}
//======================
 func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D)
    {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
          print(url)
        Alamofire.request(url, method: .post, parameters: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(let data):
                    let response = data as! NSDictionary
                    // print(response)
                    if let status = response["status"] as? String,status == "ZERO_RESULTS"{
                        let alert = UIAlertController(title:Const.Alert, message: "No Route Found".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: Const.ok, style: .cancel))
                        alert.view.tintColor = UIColor.main
                        self.present(alert, animated: true)
                        return
                    }
                    guard  let routes = response["routes"] as? NSArray else{return}
                    if let row = routes.firstObject
                    {
                        let route = row as! NSDictionary
                        let routeOverviewPolyline = route["overview_polyline"] as! NSDictionary
                        let points = routeOverviewPolyline["points"] as? String
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 2
                        polyline.strokeColor = UIColor.main
                        polyline.map = self.mapView
                        if let legs = route["legs"] as? NSArray{
                            let first = legs.firstObject as! NSDictionary
                            let distance = first["distance"] as! NSDictionary
                            let distancetext = distance["text"] as? String
                            let value = distance["value"] as! Int //In Meter
                            let duration = first["duration"] as! NSDictionary
                            let durationValue = duration["value"] as! Int //In Second
                            TripRequestSession.tripDisance = Double(value)/1000.0
                            self.lblDistance.text = distancetext
                            if let date = Calendar.current.date(byAdding: .second, value: durationValue, to: Date()){
                                self.lblTime.attributedText = Const.imageWith(string: Const.dfTimeA().string(from: date), image: #imageLiteral(resourceName: "time-15px"), size: 15.0)
                            }
                            
                            print(value / 1000)
                            print(distance["text"] as! String)
                        }
                    }
                    break
                case .failure(_):
                    break
                }
                
        }
    }
