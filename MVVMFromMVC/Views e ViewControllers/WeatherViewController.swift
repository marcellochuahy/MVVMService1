import UIKit

class WeatherViewController: UIViewController {
  
  // MARK: - Properties
  private let viewModel = WeatherViewModel()
  
  // MARK: - Outlets
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentIcon: UIImageView!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var forecastSummary: UITextView!
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.locationName.bind { [weak self] locationName in
      self?.cityLabel.text = locationName
    }
    
    viewModel.date.bind { [weak self] date in
      self?.dateLabel.text = date
    }
    
    viewModel.icon.bind { [weak self] image in
      self?.currentIcon.image = image
    }
    
    viewModel.summary.bind { [weak self] summary in
      self?.currentSummaryLabel.text = summary
    }
    
    viewModel.forecastSummary.bind { [weak self] forecast in
      self?.forecastSummary.text = forecast
    }
    
  }
  
  // MARK: - Actions
  @IBAction func promptForLocationWasTouched(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Escolha um lugar", message: "Utilize o formato abaixo:\n\nnome da cidade, estado, país" , preferredStyle: .alert)
    alert.addTextField()

    let submitAction = UIAlertAction(title: "Ok", style: .default) {
      [unowned alert, weak self] _ in
      
        guard let newLocation = alert.textFields?.first?.text else { return }
        self?.viewModel.changeLocation(to: newLocation)
      
    }
    alert.addAction(submitAction)
    
    present(alert, animated: true)
    
  }
  
}
