//
//  ViewController.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 4/7/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let weatherViewModel = WeatherViewModel()
    var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        weatherViewModel.delegate = self
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        setupLocation()
        tableView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
    }
        
    @objc func refreshButtonTapped() {
        currentLocation = nil
        setupLocation()
    }
}

// location
extension ViewController: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        displayAlertIfNoAuthorization()
    }

    func displayAlertIfNoAuthorization() {
        var authorizationStatus: CLAuthorizationStatus?
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        switch authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse, .none:
            break
        case .denied, .notDetermined, .restricted:
            let alert = UIAlertController(title: "Error", message: "You need to enable location services in order to see weather data.", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty && currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        CLGeocoder().reverseGeocodeLocation(currentLocation) { placemark, error in
            guard let city = placemark?.first?.locality, let state = placemark?.first?.administrativeArea else { return }
            self.navigationItem.title = "\(city), \(state)"
        }
        weatherViewModel.fetchData(lat: lat, long: long)
    }
}
// tableview
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return weatherViewModel.dailyCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: weatherViewModel.hourly)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: weatherViewModel.daily[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        return 100
    }
    
    func createTableHeader() -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width/2.5))
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 20, width: view.frame.size.width - 20, height: view.frame.size.width / 8))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width - 20, height: view.frame.size.width / 6))
        
        locationLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        
        locationLabel.text = "Current Location"
        if let current = weatherViewModel.currentWeather {
            tempLabel.text = "\(Int(current.temp))°"
        }
        
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: WeatherViewModelProtocol {
    func refreshUI() {
        self.tableView.reloadData()
        self.tableView.tableHeaderView = createTableHeader()
    }
}
