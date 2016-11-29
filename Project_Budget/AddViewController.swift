//
//  ViewController.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 11/11/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import UIKit

class AddViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIPopoverPresentationControllerDelegate, ColorPickerDelegate{

    //    ========================================
    //    UIVariables
    //    ========================================
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txfCategory: UITextField!
    @IBOutlet weak var txfSubcategory: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var btnAddCat: UIButton!
    @IBOutlet weak var btnAddSubCat: UIButton!

    @IBOutlet weak var colorPreview: UIView!
    
    @IBOutlet weak var txfAmount: UITextField!
    
    
    
    // class varible maintain selected color value
    var selectedColor: UIColor = UIColor.blue
    var selectedColorHex: String = "0000FF"
    
    var pickOptionCat = ["cat1", "cat2", "cat3", "cat4", "cat5"]
    var pickOptionSubCat = ["subcat1", "subcat2", "subcat3", "subcat4", "subcat5"]
    var isAddCat = false
    var isAddSubCat = false
    let catPickerview = UIPickerView()
    let subCatPickerview = UIPickerView()
    let datePickerView = UIDatePicker()
    
    var category: Category?
    var subcategory: Subcategory?
    var categoryRepository: CategoryRepository = CategoryRepository()
    private let dateFormatter = DateFormatter()


    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        // set corner radious
        self.colorPreview.layer.cornerRadius = self.colorPreview.layer.frame.width/6
        // set default background color
        self.colorPreview.backgroundColor = self.selectedColor
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (openColorPicker(_:)))
        self.colorPreview.addGestureRecognizer(gesture)
        
        
        btnAddCat.addTarget(self, action:#selector(addCatTapped(_:)), for: .touchUpInside)
        btnAddSubCat.addTarget(self, action:#selector(addCatTapped(_:)), for: .touchUpInside)
    
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(AddViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        catPickerview.delegate = self
        subCatPickerview.delegate = self
        
        txfCategory.inputView = catPickerview
        txfSubcategory.inputView = subCatPickerview
        txfDate.inputView = datePickerView
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

    func addCatTapped(_ sender: UIButton){
        print(sender)
        if sender == btnAddCat  {
            if(isAddCat){
                txfCategory.inputView = catPickerview
                txfCategory.placeholder = "Select a category"
                btnAddCat.setImage(UIImage(named: "Plus-50"), for: .normal)
            }
            else{
                txfCategory.resignFirstResponder()
                txfCategory.inputView = nil
                txfCategory.placeholder = "Add new category"
                btnAddCat.setImage(UIImage(named: "Minus-50"), for: .normal)
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
                btnAddSubCat.setImage(UIImage(named: "Minus-50"), for: .normal)            }
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
        if pickerView == catPickerview{
            txfCategory.text = pickOptionCat[row]
        }
        
        if pickerView ==  subCatPickerview{
            txfSubcategory.text = pickOptionSubCat[row]
        }
        
    }

    func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        txfDate.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func OnChangeType(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            self.title = "New expense";
        case 1:
            self.title = "New revenue";
        default:
            break; 
        }
        }
    @IBAction func reset(){
        txfAmount.text = ""
        txfDate.text = ""
        txfCategory.text = ""
        txfSubcategory.text = ""
        addCatTapped(btnAddCat)
        addCatTapped(btnAddSubCat)
        
    }
    @IBAction func AddNewItem(_ sender: UIButton) {
        let title = self.navigationItem.title;
        let catName = txfCategory.text!
        let subcatName = txfSubcategory.text!
        let date = txfDate.text!
        let amount = Double(txfAmount.text!)!
        let type = title == "New expense" ? 0 : 1
        
        dateFormatter.locale = Locale(identifier: "nl")
        dateFormatter.dateFormat = "dd MM yyyy"
        
//        let dd = dateFormatter.date(from: date)!
        
        if isAddCat{
            //new category and new subcategory
            subcategory = Subcategory(name: subcatName, transaction: Transaction(amount: amount, date: Date()))
            category = Category(type: type, name: catName, subcat: subcategory!, color: self.selectedColor)
        }
        else if isAddSubCat {
            //get category and new subcategory
            subcategory = Subcategory(name: subcatName, transaction: Transaction(amount: amount, date: Date()))
            category = categoryRepository.getCategory(with: catName)
            category!.subcategories.append(subcategory!)
        }
        else{
            //get category and get subcategory
            category = categoryRepository.getCategory(with: catName)
            subcategory = categoryRepository.getSubCategory(with: subcatName, of: category!)
            subcategory!.transactions.append(Transaction(amount: amount, date: Date()))
        }
    
        reset()
        performSegue(withIdentifier: "added", sender: self)
        
    }
    @IBAction func openColorPicker(_ sender: AnyObject){
        self.showColorPicker()
    }

}
extension UITableViewController
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

