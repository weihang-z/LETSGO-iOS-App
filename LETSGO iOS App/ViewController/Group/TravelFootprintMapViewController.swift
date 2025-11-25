//
//  TravelFootprintMapViewController.swift
//  LETSGO iOS App
//
//  Created by zft on 22/11/2025.
//
import UIKit
import MapKit

final class TravelFootprintMapViewController: UIViewController {
    private let mapView = MKMapView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let dataStore: UserContentDataStore
    private var cities: [CityVisit] {
        dataStore.visitedCities
    }

    init(dataStore: UserContentDataStore) {
        self.dataStore = dataStore
        super.init(nibName: nil, bundle: nil)
        title = "Travel Footprint"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addCityTapped)
        )
        configureMapView()
        configureTableView()
        layoutContent()
        reloadContent()
    }

    private func configureMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.pointOfInterestFilter = .includingAll
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
    }

    private func layoutContent() {
        view.addSubview(mapView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),

            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func reloadContent() {
        plotCities()
        tableView.reloadData()
        if cities.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No cities yet. Tap + to add one!"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .secondaryLabel
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
    }

    private func plotCities() {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = cities.map { visit -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = "\(visit.cityName), \(visit.country)"
            annotation.subtitle = visit.note
            annotation.coordinate = CLLocationCoordinate2D(latitude: visit.latitude, longitude: visit.longitude)
            return annotation
        }
        mapView.addAnnotations(annotations)
        if annotations.isEmpty {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
                latitudinalMeters: 8_000_000,
                longitudinalMeters: 8_000_000
            )
            mapView.setRegion(region, animated: true)
        } else {
            mapView.showAnnotations(annotations, animated: true)
        }
    }

    @objc private func addCityTapped() {
        let alert = UIAlertController(title: "Add City", message: "Enter the city details.", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "City name" }
        alert.addTextField { $0.placeholder = "Country/Region" }
        alert.addTextField {
            $0.placeholder = "Latitude (e.g. 31.2304)"
            $0.keyboardType = .decimalPad
        }
        alert.addTextField {
            $0.placeholder = "Longitude (e.g. 121.4737)"
            $0.keyboardType = .decimalPad
        }
        alert.addTextField { $0.placeholder = "Short note (optional)" }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self, let fields = alert?.textFields else { return }
            let cityName = fields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let country = fields[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let latText = fields[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let lonText = fields[3].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let note = fields[4].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard cityName.isEmpty == false, country.isEmpty == false else {
                self.showValidationError("City and country cannot be empty.")
                return
            }
            guard let latitude = Double(latText), let longitude = Double(lonText) else {
                self.showValidationError("Latitude and longitude must be numbers.")
                return
            }

            let visit = CityVisit(
                id: UUID(),
                cityName: cityName,
                country: country,
                latitude: latitude,
                longitude: longitude,
                note: note
            )
            self.dataStore.addVisitedCity(visit)
            self.reloadContent()
        }
        saveAction.isEnabled = true

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func showValidationError(_ message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TravelFootprintMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = cities[indexPath.row]
        var config = UIListContentConfiguration.subtitleCell()
        config.text = "\(city.cityName), \(city.country)"
        config.secondaryText = city.note.isEmpty ? "\(city.latitude), \(city.longitude)" : city.note
        config.image = UIImage(systemName: "mappin.and.ellipse")
        config.imageProperties.tintColor = .systemBlue
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let city = cities[indexPath.row]
        dataStore.removeVisitedCity(with: city.id)
        reloadContent()
    }
}
