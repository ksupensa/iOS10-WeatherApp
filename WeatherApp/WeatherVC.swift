//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Spencer Forrest on 22/12/2016.
//  Copyright © 2016 Spencer Forrest. All rights reserved.
// 

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var authorizationLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var currentWeatherLbl: UILabel!
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather = CurrentWeather()
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        currentWeather = CurrentWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("authorizedAlways")
            break
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            break
        case .denied:
            print("denied")
            break
        case .notDetermined:
            print("notDetermined")
            break
        case .restricted:
            print("restricted")
            break
        }
        
        // It will then call locationManager(_:didChangeAuthorization:)
        // Does nothing if CLLocationManager.authorizationStatus() != .notDetermined
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationAuthStatus(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude

            currentWeather.downloadWeatherData{
                self.downloadForecastData{
                    //setup UI to load downloaded data
                    self.updateMainUI()
                }
            }
        }
    }
    
    // Should be called only when authorization is changed
    // Seems to be called each time the app is launched
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            print("Authorization Granted")
            locationProvided()
            locationAuthStatus()
            break
        case .denied:
            // User denied your app access to Location Services, but can grant access from Settings.app
            print("Authorization Denied")
            warningMessage()
            break
        default:
            // Nothing happens
            break
        }
        
    }
    
    func warningMessage(){
        mainStackView.isHidden = true
        authorizationLbl.isHidden = false
    }
    
    func locationProvided(){
        mainStackView.isHidden = false
        authorizationLbl.isHidden = true
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete){
        //Downloading forecast weather data for Tableview
        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(forecastURL).responseJSON{
            response in
            let result = response.result
            if let dictionary = result.value as? Dictionary<String, AnyObject> {
                if let list = dictionary["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = Forecast(weatherDictionary: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                    
                    if !self.loadingView.isHidden {
                        self.loadingView.isHidden = true
                    }
                }
            }
            completed()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherVC", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        }
        
        return WeatherCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func updateMainUI(){
        dateLbl.text = currentWeather.date
        currentTempLbl.text = "\(currentWeather.currentTemp)"
        locationLbl.text = currentWeather.cityName
        currentWeatherLbl.text = currentWeather.weatherType
        currentWeatherImg.image = UIImage(named: currentWeather.weatherType)
    }
}

