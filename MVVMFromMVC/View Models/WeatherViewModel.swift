import Foundation

// No other UIKit types need to be permitted in the view model.
// A general rule of thumb is to never import UIKit in your view models.
import UIKit.UIImage

final class Box<T> {

  // MARK: - Typealias
  typealias Listener = (T) -> Void
  
  // MARK: - Properties
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }

  // MARK: - Initializers
  init(_ value: T) {
    self.value = value
  }

  // MARK: - Methods
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
  
}

public class WeatherViewModel {
  
  // MARK: - Properties
  
  let locationName        = Box("Loading...")
  let date                = Box(" ")
  let icon: Box<UIImage?> = Box(nil)  // no image initially
  let summary             = Box(" ")
  let forecastSummary     = Box(" ")
  
  // MARK: - Private properties
  static private let defaultAddress = "São Paulo, SP, Brasil"
  private let geocoder = LocationGeocoder()
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter
  }()
  private let tempFormatter: NumberFormatter = {
    let tempFormatter = NumberFormatter()
    tempFormatter.numberStyle = .none
    return tempFormatter
  }()
  
  

  // MARK: - Initializers
  
  init() {
    changeLocation(to: Self.defaultAddress)
  }
  
  // MARK: - Methods
  
  func changeLocation(to newLocation: String) {
    
    locationName.value = "Loading..."
    
    geocoder.geocode(addressString: newLocation) {
      
      [weak self] locations in
      
      guard let self = self else { return }
      
      if let location = locations.first {
        self.locationName.value = location.name
        self.fetchWeatherForLocation(location)
        return
      }
      
      self.locationName.value    = "Not found"
      self.date.value            = ""
      self.icon.value            = nil
      self.summary.value         = ""
      self.forecastSummary.value = ""
      
    }
  }

  private func fetchWeatherForLocation(_ location: Location) {
    
    WeatherbitService.weatherDataForLocation(latitude: location.latitude, longitude: location.longitude) {
      
      [weak self] (weatherData, error) in
      
      guard
        let self = self,
        let weatherData = weatherData
      else { return }
      
      let temp = self.tempFormatter.string(from: weatherData.currentTemp as NSNumber) ?? ""
      
      self.date.value            = self.dateFormatter.string(from: weatherData.date)
      self.icon.value            = UIImage(named: weatherData.iconName)
      self.summary.value         = "\(weatherData.description) - \(temp)℉"
      self.forecastSummary.value = "\nSummary: \(weatherData.description)"
      
    }
    
  }
  
}
