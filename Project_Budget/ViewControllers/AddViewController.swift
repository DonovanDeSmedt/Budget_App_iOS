//
//  ViewController.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 11/11/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import UIKit
import Foundation
import Realm
import RealmSwift

class AddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIPopoverPresentationControllerDelegate, ColorPickerDelegate{

    //    ========================================
    //    UIVariables
    //    ========================================
    
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var txfCategory: UITextField!
    @IBOutlet weak var txfSubcategory: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var btnAddCat: UIButton!
    @IBOutlet weak var btnAddSubCat: UIButton!

    @IBOutlet weak var colorPreview: UIView!
    
    @IBOutlet weak var colorText: UILabel!
    @IBOutlet weak var txfAmount: UITextField!
    
    
    
    // class varible maintain selected color value
    var selectedColor: UIColor = UIColor.blue
    var selectedColorHex: String = "0000FF"
    
    var pickOptionCat :[String] = []
    var pickOptionSubCat :[String] = [] // = ["subcat1", "subcat2", "subcat3", "subcat4", "subcat5"]
    var isAddCat = false
    var isAddSubCat = false
    let catPickerview = UIPickerView()
    let subCatPickerview = UIPickerView()
    let datePickerView = UIDatePicker()
    
    var category: Category?
    var subcategory: Subcategory?
    var categoryRepository: CategoryRepository?
    var currentType = TransactionType.expense
    private let dateFormatter = DateFormatter()

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        
        (segmentControl.subviews[0] as UIView).tintColor = Style.sectionHeaderBackgroundColor
        (segmentControl.subviews[1] as UIView).tintColor = Style.sectionHeaderBackgroundColor
        
        // set corner radious
        colorPreview.layer.cornerRadius = self.colorPreview.layer.frame.width/6
        // set default background color
        colorPreview.backgroundColor = self.selectedColor
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (openColorPicker(_:)))
        colorPreview.addGestureRecognizer(gesture)
        setColorPickerVisibility(isHidden: true)

        
        btnAddCat.addTarget(self, action:#selector(addBtnClicked(_:)), for: .touchUpInside)
        btnAddSubCat.addTarget(self, action:#selector(addBtnClicked(_:)), for: .touchUpInside)
    
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.locale = Locale(identifier: "nl")
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.addTarget(self, action: #selector(AddViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        updateListCategories()
        
        catPickerview.delegate = self
        subCatPickerview.delegate = self
        
        txfCategory.inputView = catPickerview
        txfSubcategory.inputView = subCatPickerview
        txfDate.inputView = datePickerView
        
    }
    
    func updateListCategories(){
//        pickOptionCat = (currentType == .expense ? categoryRepository?.expenses.map {$0.name} : categoryRepository?.revenues.map {$0.name})!
        pickOptionCat = categoryRepository!.categories.filter {$0.type == currentType}.map {$0.name}
    }
    // Override iPhone behavior that presents a popover as fullscreen.
    // i.e. now it shows same popover box within on iPhone & iPad
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        // show popover box for iPhone and iPad both
        return UIModalPresentationStyle.none
    }
    // MARK: Color picker delegate functions
    
    // called by color picker after color selected.
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        
        // update color value within class variable
        self.selectedColor = selectedUIColor
        self.selectedColorHex = selectedHexColor
        
        // set preview background to selected color
        self.colorPreview.backgroundColor = selectedUIColor
    }
    
    // MARK: - Utility functions
    
    // show color picker from UIButton
    fileprivate func showColorPicker(){
        
        // initialise color picker view controller
        let colorPickerVc = storyboard?.instantiateViewController(withIdentifier: "sbColorPicker") as! ColorPickerViewController
        
        // set modal presentation style
        colorPickerVc.modalPresentationStyle = .popover
        
        // set max. size
        colorPickerVc.preferredContentSize = CGSize(width: 265, height: 400)
        
        // set color picker deleagate to current view controller
        // must write delegate method to handle selected color
        colorPickerVc.colorPickerDelegate = self
        
        // show popover
        if let popoverController = colorPickerVc.popoverPresentationController {
            
            // set source view
            popoverController.sourceView = self.view
            
            // show popover form button
//            popoverController.sourceRect = self.changeColorButton.frame
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            
            // set popover delegate self
            popoverController.delegate = self
        }
        
        //show color popover
        present(colorPickerVc, animated: true, completion: nil)
    }
    
    func btn_clicked(_ sender: UIBarButtonItem) {
        // Do something
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        txfDate.text = dateFormatter.string(from: Date())
        
        txfDate.resignFirstResponder()
    }

    @IBAction func addBtnClicked(_ sender: UIButton){
        if sender == btnAddCat  {
            if(isAddCat){
                txfCategory.inputView = catPickerview
                txfCategory.placeholder = "Select a category"
                btnAddCat.setImage(UIImage(named: "Plus-50"), for: .normal)
                txfSubcategory.inputView = subCatPickerview
                txfSubcategory.placeholder = "Select a subcategory"
                btnAddSubCat.setImage(UIImage(named: "Plus-50"), for: .normal)
                setColorPickerVisibility(isHidden: true)
            }
            else{
                txfCategory.resignFirstResponder()
                txfCategory.inputView = nil
                txfCategory.placeholder = "Add new category"
                btnAddCat.setImage(UIImage(named: "Minus-50"), for: .normal)
                txfSubcategory.resignFirstResponder()
                txfSubcategory.inputView = nil
                txfSubcategory.placeholder = "Add new subcategory"
                btnAddSubCat.setImage(UIImage(named: "Minus-50"), for: .normal)
                setColorPickerVisibility(isHidden: false)
                
                colorPreview.isHidden = false
            }
            isAddCat = !isAddCat

        }
        else if sender == btnAddSubCat {
            if(isAddSubCat){
                txfSubcategory.inputView = subCatPickerview
                txfSubcategory.placeholder = "Select a subcategory"
                btnAddSubCat.setImage(UIImage(named: "Plus-50"), for: .normal)
            }
            else{
                txfSubcategory.resignFirstResponder()
                txfSubcategory.inputView = nil
                txfSubcategory.placeholder = "Add new subcategory"
                btnAddSubCat.setImage(UIImage(named: "Minus-50"), for: .normal)
            }
            isAddSubCat = !isAddSubCat

        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == catPickerview {
            return pickOptionCat.count
        }
        
        if pickerView == subCatPickerview {
            return pickOptionSubCat.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == catPickerview {
            return pickOptionCat[row]
        }
        
        if pickerView == subCatPickerview {
            return pickOptionSubCat[row]
        }

        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == catPickerview && pickOptionCat.count > 0{
            txfCategory.text = pickOptionCat[row]
            let selectedCategory = categoryRepository?.getCategory(with: txfCategory.text!.lowercased(), of: currentType)
            pickOptionSubCat = (selectedCategory?.subcategories.map {$0.name})!
        }
        
        if pickerView == subCatPickerview && pickOptionSubCat.count > 0 {
            txfSubcategory.text = pickOptionSubCat[row]
        }
        
    }
    private func setColorPickerVisibility (isHidden: Bool){
        colorPreview.isHidden = isHidden
        colorText.isHidden = isHidden
    }

    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txfDate.text = dateFormatter.string(from: sender.date)
    }
    

    @IBAction func onChangeType(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            self.title = "New expense"
            currentType = .expense
        case 1:
            self.title = "New revenue"
            currentType = .revenue
        default:
            break; 
        }
        updateListCategories()
        }
    @IBAction func reset(){
        txfAmount.text = ""
        txfDate.text = ""
        txfCategory.text = ""
        txfSubcategory.text = ""
        addBtnClicked(btnAddCat)
        addBtnClicked(btnAddSubCat)
        
    }
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        //Inputvalidation
        guard let catName = txfCategory.text, !catName.isEmpty else{
            updateValidation(for: txfCategory, valid: false)
            return
        }
        updateValidation(for: txfCategory, valid: true)
        
        guard let subcatName = txfSubcategory.text, !subcatName.isEmpty else {
            updateValidation(for: txfSubcategory, valid: false)
            return
        }
        updateValidation(for: txfSubcategory, valid: true)
        
        guard let date = txfDate.text, !date.isEmpty else {
            updateValidation(for: txfDate, valid: false)
            return
        }
        updateValidation(for: txfDate, valid: true)
        
        guard let amount = txfAmount.text, !amount.isEmpty else {
            updateValidation(for: txfAmount, valid: false)
            return
        }
        updateValidation(for: txfAmount, valid: true)
        
        //Creation Transaction object
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let trans = Transaction()
        trans.amount = Double(amount)!
        trans.date = dateFormatter.date(from: date)!
        
        
        do {
            let realm = try Realm()
            try! realm.write {
                
            
        //check if category already exist
        if (categoryRepository?.categoryExist(with: catName.lowercased(), of: currentType))! {
            category = categoryRepository?.getCategory(with: catName.lowercased(), of: currentType)
            
            //check if subcategory already exist
            if (categoryRepository?.subCategoryExist(of: category!, with: subcatName.lowercased()))! {
                subcategory = categoryRepository?.getSubCategory(with: subcatName.lowercased(), of: category!, with: currentType)
                
                //check if there is already an transaction on that day
                let transactionOnDay = subcategory!.transactions.filter{$0.date == trans.date}.first
                if let foundTransaction = transactionOnDay {
                    foundTransaction.amount += trans.amount
                }
                else{
                    subcategory!.transactions.append(trans)
                }
                
            }
            else{
                subcategory = Subcategory()
                subcategory!.name = subcatName
                subcategory!.transactions.append(trans)
                
                category!.subcategories.append(subcategory!)
            }
            
            //Object in db zoeken en updaten
            categoryRepository!.updateObjectDb(category: category!)
        }
        else{
            subcategory = Subcategory()
            subcategory?.name = subcatName
            subcategory?.transactions.append(trans)
            category = Category()
            category!.type = currentType
            category!.name = catName
            category!.subcategories.append(subcategory!)
            category!.color = self.selectedColor.rgb()!
            
            //Object aan db toevoegen
            categoryRepository!.addObjectDb(category: category!, update: false)
        }
            }
        } catch let error as NSError{
            fatalError(error.localizedDescription)
        }
        reset()
        performSegue(withIdentifier: "added", sender: self)
    
        
    }
    @IBAction func openColorPicker(_ sender: AnyObject){
        self.showColorPicker()
    }
    private func updateValidation(for inputField: UITextField, valid: Bool){
        if valid {
            inputField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            inputField.layer.borderWidth = 0.5
            inputField.layer.cornerRadius = 5.0
        }
        else {
            inputField.layer.borderColor = UIColor.red.cgColor
            inputField.layer.borderWidth = 0.5
            inputField.layer.masksToBounds = true
            inputField.layer.cornerRadius = 5
        }
        
    }

}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UITableViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

