import UIKit

class OverviewViewController2: UICollectionViewController{
    
    private var model = CategoryRepository()
    
    
    


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0){
            return model.expenses.count
        }
        else{
            return model.revenues.count
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        var category:Category
        if(indexPath.section == 0){
            category = model.expenses[indexPath.row]
        }
        else{
            category = model.revenues[indexPath.row]
        }
        
        cell.categoryName.text = "\(category.name)"
        cell.totalPrice.text = "€ \(model.getTotalAmount(of: category))"
        cell.colorPreview.backgroundColor = UIColor().rgbToUIColor(category.color)
        let represenation = model.calcRepresentation(category: category)
        cell.percentage.text = "\(represenation)%"
        
        var bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.backgroundColor = UIColor.white

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "add":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! AddViewController
            destination.categoryRepository = model
            print("Go to addViewController")
        case "detail":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! DetailViewController
            let selectedIndex = collectionView!.indexPathsForSelectedItems!.first!
            if selectedIndex.section == 0 {
                destination.category = model.expenses[selectedIndex.row]
            }
            else {
                destination.category = model.revenues[selectedIndex.row]
            }
            print("Go to detailViewController")
        default:
            break
        }
    }
    
//    @IBAction func unwindFromAdd(_ segue: UIStoryboardSegue){
////        let source = segue.source as! AddViewController
////        if let category = source.category{
////            if(category.type == .expense){
////                model.expenses.append(category)
////                //collectionView?.insertItems(at: [IndexPath(row: model.expenses.count - 1, section: 0)], with: .automatic)
////            }
////            else{
////                model.revenues.append(category)
////                //collectionView?.insertItems(at: [IndexPath(row: model.revenues.count - 1, section: 1)], with: .automatic)
////
////            }
////            collectionView?.reloadData();
////            
////        }
//        
//        let source = segue.source as! AddViewController
//        if let category = source.category{
//            if(category.type == .expense){
//                model.addCategory(category, of: .expense)
////                tableView.insertRows(at: [IndexPath(row: model.expenses.count - 1, section: 0)], with: .automatic)
////                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//            }
//            else{
//                model.addCategory(category, of: .revenue)
////                tableView.insertRows(at: [IndexPath(row: model.revenues.count - 1, section: 1)], with: .automatic)
////                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
//            }
//            
//            collectionView?.reloadData();
//        }
//    }
//    @IBAction func unwindFrommDetail(_ segue: UIStoryboardSegue){
//        
//    }
}

