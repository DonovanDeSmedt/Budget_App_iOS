import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate{
    
    let model :CategoryRepository = CategoryRepository.repositoryInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        UITabBar.appearance().backgroundColor = UIColor.yellow
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 || tabBarIndex == 2{
            model.readDb()
        }
    }
    
}
