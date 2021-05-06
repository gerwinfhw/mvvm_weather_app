//
//  ViewController.swift
//  mvvm_weather_app
//
//  Created by Gerwin on 04.04.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    fileprivate var weatherViewModel: WeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareWeatherTableView()
        prepareNavigationBar()
        prepareWeatherViewModel()
    }
    
    func prepareNavigationBar() {
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBarButtonItemTapped))
        navigationItem.setLeftBarButton(addBarButtonItem, animated: true)
    }
    
    func prepareWeatherTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.separatorStyle = .none
    }
    
    func prepareWeatherViewModel() {
        weatherViewModel = WeatherViewModel { [unowned self] (weathers) in
            switch weathers.editingStyle {
            case .none:
                self.weatherTableView.reloadData()
            case .insert(_, let indexPath):
                DispatchQueue.main.async {
                    self.weatherTableView.insertRows(at: [indexPath], with: .automatic)
                }
            case .delete(let indexPath):
                DispatchQueue.main.async {
                    self.weatherTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        weatherViewModel?.weatherViewModelDelegate = self
    }
    
    @objc func addBarButtonItemTapped() {
        self.ask(title: "Neue Stadt hinzufügen", question: "", placeholder: "Hier hinzufügen") { (input) in
            if let city = input {
                self.weatherViewModel?.addCity(newCity: city)
            }
        }
    }
}

extension ViewController {
    func ask(title: String?, question: String?, placeholder: String?, keyboardType: UIKeyboardType = .default, delegate: @escaping (_ answer: String?) -> Void) {
        let alert = UIAlertController(title: title, message: question, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            let answer = alert.textFields?.first?.text
            delegate(answer)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            delegate(nil)
        })
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: WeatherViewModelDelegate {
    func isInvalidInput(_ city: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: city + " ist eine ungültige Eingabe", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel?.weathers.cityWeathers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        
        cell.cityLabel.text =  weatherViewModel?.weathers.cityWeathers[indexPath.row].name
        cell.tempLabel.text = "\(Int(round(weatherViewModel?.weathers.cityWeathers[indexPath.row].main.temp ?? -999)))℃"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherViewModel?.deleteCity(atIndex: indexPath)
        }
    }
    
}
