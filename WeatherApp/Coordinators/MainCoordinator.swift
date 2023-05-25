import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let apiManager = APIManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = WeatherInfoViewController.instantiate()
        let converterViewModel = WeatherInfoViewModel(apiManager: self.apiManager)
        vc.viewModel = converterViewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func loadCitySearchVC(completion: @escaping (String) -> Void, errorHandler:@escaping (String) -> ()) {
        let searchVC = SearchViewController.instantiate()
        searchVC.completionHandler = { cityName in
            completion(cityName)
        }
        searchVC.errorHandler = errorHandler
        self.navigationController.present(searchVC, animated: true)
    }
    
}
