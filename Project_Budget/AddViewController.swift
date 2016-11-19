//
//  ViewController.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 11/11/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import UIKit

class AddViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{

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
    
    @IBOutlet weak var txfAmount: UITextField!
    
    var pickOptionCat = ["cat1", "cat2", "cat3", "cat4", "cat5"]
    var pickOptionSubCat = ["subcat1", "subcat2", "subcat3", "subcat4", "subcat5"]
    var isAddCat = false
    var isAddSubCat = false
    let catPickerview = UIPickerView()
    let subCatPickerview = UIPickerView()
    let datePickerView = UIDatePicker()
    
    var transaction: Transaction?
    private let dateFormatter = DateFormatter()


    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
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
        let title = self.title
        let category = txfCategory.text!
        let subCategory = txfSubcategory.text!
        let date = txfDate.text!
        let amount = Int(txfAmount.text!)!
        let type = title == "expense" ? 0 : 1
        
        dateFormatter.locale = Locale(identifier: "nl")
        dateFormatter.dateFormat = "dd MM yyyy"
        
//        let dd = dateFormatter.date(from: date)!
        
        transaction = Transaction(type: type, cat: category, subCat: subCategory, amount: amount, date: Date(), color: UIColor.purple)

        reset()
        performSegue(withIdentifier: "added", sender: self)
        
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

