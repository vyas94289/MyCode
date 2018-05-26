
import UIKit
import MapKit
import CoreLocation
import Alamofire
protocol bussinessChangeDelegate {
    func didBusinessDataChange(data:[Business])
}
class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,filterDelegate
{
    var filter:Filter!
    var delegate:bussinessChangeDelegate?
    var data:[Business] = []
    var coordinates: [[Float]] = []
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBarItems()
        refresh()
       // marker(latitude: 37.33233141, longitude: 72.525563)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            for item in self.mapView.selectedAnnotations {
                self.mapView.deselectAnnotation(item, animated: false)
            }
        }
    }
    func refresh() {
        self.coordinates.removeAll()
        self.mapView.removeAnnotations(self.mapView.annotations)
        for row in self.data{
            self.coordinates.append([row.lat!,row.long!])
        }
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        for row in self.data
        {
            let point = annotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(row.lat ?? 0.0), longitude: CLLocationDegrees(row.long ?? 0.0)))
            point.name = row.title
            point.rating = row.rating
            point.costRange = row.cost_range
            point.reviews = row.reviews
            point.bId = row.id
            point.timing = row.timings
            self.mapView.addAnnotation(point)
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //marker(latitude: locValue.latitude, longitude: locValue.longitude)
        let span = MKCoordinateSpanMake(0.070, 0.070)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locValue.latitude , longitude: locValue.longitude), span: span)
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = customAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "pin")
        return annotationView
    }
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        
       
        if view.annotation is MKUserLocation
        {
            return
        }
        guard let starbucksAnnotation = view.annotation as? annotation else{
            return
        }
        let views = Bundle.main.loadNibNamed("annotationView", owner: nil, options: nil)
        guard let calloutView = views?[0] as? customAnnotation else { return }
        calloutView.ratingView.rating = starbucksAnnotation.rating ?? 0.0
        calloutView.lblTitle.text = starbucksAnnotation.name
        calloutView.lblReviews.text = "\(starbucksAnnotation.reviews ?? 0) Reviews"
        calloutView.lblCostRange.currencyRange(length: starbucksAnnotation.costRange)
        calloutView.mainView.isUserInteractionEnabled = true
        calloutView.mainView.tag = starbucksAnnotation.bId
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openTapped(sender:)))
        calloutView.mainView.addGestureRecognizer(tap)
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        let info = Const.isOpen(starbucksAnnotation.timing)
        if info.isOpen{
            calloutView.lblOpen.text = NSLocalizedString("open", comment: "")
            calloutView.lblOpen.textColor = UIColor.green
        }else{
            calloutView.lblOpen.textColor = UIColor.red
            calloutView.lblOpen.text = NSLocalizedString("closed", comment: "")
        }
    }
    func setBarItems()
    {
        //MARK: - filter button
        let filterButton = UIButton(type: .system)
        filterButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        filterButton.setImage(#imageLiteral(resourceName: "Filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(self.filter(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButton)
        //MARK: - list button
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        closeButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.close(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    func filter(_ sender:AnyObject){
        if self.filter != nil{
            performSegue(withIdentifier: "toFilter", sender: nil)
        }
    }
    func close(_ sender:AnyObject)
    {
        self.delegate?.didBusinessDataChange(data: self.data)
        self.navigationController?.popViewController(animated: true)
    }
    func openTapped(sender:UIGestureRecognizer)
    {
        self.performSegue(withIdentifier: "toDetail", sender: sender.view?.tag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"
        {
            if let vc = segue.destination as? DetailVC
            {
                if let id = sender as? Int{
                    vc.bId = id
                }
                
            }
        }
        if segue.identifier ==  "toFilter"{
            if let vc = segue.destination as? FilterVC
            {
                vc.delegate = self
                vc.filter = self.filter
            }
        }
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: customAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    func marker(latitude:Double,longitude:Double)
    {
        //23.075272, 72.525563
        let currentLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = currentLocation
        dropPin.title = "New York City"
        mapView.addAnnotation(dropPin)
    }
    func didFilter(filter: Filter) {
        ProgressView.shared.showProgressView((self.navigationController?.view)!)
        Alamofire.request(URLs.business_filter, method: .post, parameters: Const.filterToDict(filter: filter)).responseJSON
            { (response:DataResponse<Any>) in
                ProgressView.shared.hideProgressView()
                switch(response.result) {
                case .success(let data):
                    let response = data as! NSDictionary
                    guard let status = response.object(forKey: "status") as? Int else{
                        return
                    }
                    if status == 0
                    {
                        self.data.removeAll()
                        self.delegate?.didBusinessDataChange(data: self.data)
                        self.refresh()
                    }
                    else
                    {
                        guard let data = response["Result"] as? NSArray else{
                            return
                        }
                        self.data = Business.modelsFromDictionaryArray(array: data)
                        self.delegate?.didBusinessDataChange(data: self.data)
                        self.refresh()
                    }
                    break
                    
                case .failure(let encodingError):
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        Drop.down(Const.networkError, state: .warning)
                    } else {
                        print(encodingError)
                        Drop.down(Const.wentWrong, state: .info)
                    }
                    break
                    
                }
                
        }
        
    }

}


///=================

class customAnnotationView: MKAnnotationView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds;
        var isInside: Bool = rect.contains(point);
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point);
                if isInside
                {
                    break;
                }
            }
        }
        return isInside;
    }
}
//=========
class customAnnotation: UIView {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet var lblOpen:UILabel!
    @IBOutlet var lblReviews: UILabel!
    @IBOutlet var lblCostRange: UILabel!
    @IBOutlet var mainView: UIView!
    override func awakeFromNib() {
        ratingView.custom()
        mainView.layer.borderColor = UIColor.grayClr.cgColor
        mainView.layer.cornerRadius = 4
        mainView.layer.borderWidth = 1
    }
 
}
