//
//  LocationService.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/13/24.
//

import Foundation
import CoreLocation
import UIKit

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    var stores = [Store]()
    var closetRegions: [CLRegion] = []
    var lastLocation: CLLocation? {
        didSet {
            evaluateClosestRegions()
        }
    }
    var currentState: String?
    
    override init() {
        super.init()
        requestPermissionNotifications()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        stores = self.loadJson(filename: "walmartFinished")
    }
    
    func requestPermissionNotifications() {
        let application =  UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
                if( error != nil ){
                    print(error!)
                }
                else{
                    if( isAuthorized ){
                        print("authorized")
                        NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                    }
                    else{
                        let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                        if pushPreference == false {
                            let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        // Checking for setting is opened or not
                                        print("Setting is opened: \(success)")
                                    })
                                }
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                                print("user denied")
                                UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                            }))
                            let viewController = UIApplication.shared.keyWindow!.rootViewController
                            DispatchQueue.main.async {
                                viewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    private func filterStores() {
        guard currentState != "" else { return }
        stores = stores.filter({$0.state == currentState })
    }
    
    private func loadJson(filename fileName: String) -> [Store] {
        print("start \(fileName)")
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "files") {
            do {
                print("do")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Store].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
                
            }
        } else {
            print("else")
        }
        return []
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = manager.location else { return }
        self.lastLocation = lastLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        postLocalNotifications(eventTitle: "Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        postLocalNotifications(eventTitle: "Exited: \(region.identifier)")
    }
    
    private func postLocalNotifications(eventTitle:String){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
    }
    
    private func updateCurrentState(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let placeMark = placemarks?.first else { return }
            self.currentState = placeMark.administrativeArea
        })
    }
    
    private func evaluateClosestRegions() {
        guard let lastLocation else { return }
        updateCurrentState(from: lastLocation)
        var allDistance : [Double] = []

        //Calulate distance of each region's center to currentLocation
        for store in stores {
            let distance = lastLocation.distance(from: CLLocation(latitude: store.latitude, longitude: store.longitude))
            allDistance.append(distance)
        }
        let distanceOfEachRegionToCurrentLocation = zip(stores, allDistance)

        let tenNearbyStores = distanceOfEachRegionToCurrentLocation
            .sorted{ $0.1 < $1.1 }
            .prefix(10)

        // Remove all regions you were tracking before
        for region in locationManager.monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }

        tenNearbyStores.forEach {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: $0.0.latitude, longitude: $0.0.longitude), radius: 200, identifier: $0.0.fullAddress)
            print("start Monitoring \($0.0.fullAddress)")
            print("\($0.0.latitude) \($0.0.longitude)")
            region.notifyOnEntry = true
            region.notifyOnExit = false
            locationManager.startMonitoring(for: region)
        }
    }
}

extension LocationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .badge, .sound])
    }
}
