//
//  WeatherListViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/2/23.
//
//
import UIKit
import Foundation

struct WeatherType {
    var time: Int
    var weather: Int
}

struct WeatherData {
    var date: String
    var specialPatterns: Int
    var weatherTypes: [WeatherType]
    var possiblePatterns: Int? = nil
}

extension WeatherData {
    static let sampleWeatherData: [WeatherData] = [
        WeatherData(date: "05-28-2023", specialPatterns: 0, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)]),
        WeatherData(date: "05-29-2023", specialPatterns: 1, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)]),
        WeatherData(date: "06-01-2023", specialPatterns: 2, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)])
    ]
    
    static let weathertype = ["Clear/Fine", "Sunny", "Cloudy", "Rain/Snow Clouds", "Rain/Snow", "Heavy Rain/Snow"]
    
    static let specialPatterns = ["None of above", "Meteor shower or visit from Celeste", "No data"]
}

class WeatherListViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let weatherData = WeatherData.sampleWeatherData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = weatherData.date
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
//
//        let weatherTypeRegistration = UICollectionView.CellRegistration {
//            (cell: UICollectionViewListCell, indexPath: IndexPath, item: WeatherType) in
//            let weatherType = WeatherData.sampleWeatherData[indexPath.item].weatherTypes
//            let stackView = UIStackView(arrangedSubviews: String(weatherType.time), WeatherData.weathertype[weatherType.weather]])
//
//        }

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
//            switch item {
//            case WeatherData(let weatherData):
//                return collectionView.dequeueConfiguredReusableCell(using: <#T##UICollectionView.CellRegistration<Cell, Item>#>, for: <#T##IndexPath#>, item: <#T##Item?#>)
//            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
//        var weatherTitles = [String]()
//        for weather in WeatherData.sampleWeatherData {
//            snapshot.append([weather])
//
//        }
//        snapshot.appendSections([0])
        snapshot.appendItems(WeatherData.sampleWeatherData.map { $0.date })
        dataSource.apply(snapshot)
        
        collectionView.dataSource = dataSource
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
