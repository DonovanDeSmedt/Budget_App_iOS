//
//  ViewController.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 11/11/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

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
    
    
    var pickOptionCat = ["cat1", "cat2", "cat3", "cat4", "cat5"]
    var pickOptionSubCat = ["subcat1", "subcat2", "subcat3", "subcat4", "subcat5"]
    var isAddCat = false
    var isAddSubCat = false
    let catPickerview = UIPickerView()
    let subCatPickerview = UIPickerView()


    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAddCat.tag = 1
        btnAddCat.addTarget(self, action:#selector(addCatTapped(_:)), for: .touchUpInside)
        btnAddSubCat.tag = 2
        btnAddSubCat.addTarget(self, action:#selector(addCatTapped(_:)), for: .touchUpInside)

        
        catPickerview.delegate = self
        catPickerview.tag = 1

        subCatPickerview.delegate = self
        subCatPickerview.tag = 2
        
        txfCategory.inputView = catPickerview
        txfSubcategory.inputView = subCatPickerview
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        dateformatter.timeStyle = DateFormatter.Style.none
        
        txfDate.text = dateformatter.string(from: Date())
        
        txfDate.resignFirstResponder()
    }

    func addCatTapped(_ sender: UIButton){
        print(sender)
        if(sender.tag == 1){
            if(isAddCat){
                txfCategory.inputView = catPickerview
                txfCategory.placeholder = "Select a category"
                btnAddCat.setImage(UIImage(named: "Plus-50"), for: UIControlState.normal)
            }
            else{
                txfCategory.inputView = nil
                txfCategory.placeholder = "Add new category"
                btnAddCat.setImage(UIImage(named: "Minus-50"), for: UIControlState.normal)
            }
            isAddCat = !isAddCat

        }
        else if(sender.tag == 2){
            if(isAddSubCat){
                txfSubcategory.inputView = subCatPickerview
                txfSubcategory.placeholder = "Select a subcategory"
                btnAddSubCat.setImage(UIImage(named: "Plus-50"), for: UIControlState.normal)
            }
            else{
                txfSubcategory.inputView = nil
                txfSubcategory.placeholder = "Add new subcategory"
                btnAddSubCat.setImage(UIImage(named: "Minus-50"), for: UIControlState.normal)            }
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
        if pickerView.tag == 1 {
            return pickOptionCat.count
        }
        
        if pickerView.tag == 2 {
            return pickOptionSubCat.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return pickOptionCat[row]
        }
        
        if pickerView.tag == 2 {
            return pickOptionSubCat[row]
        }

        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            txfCategory.text = pickOptionCat[row]
        }
        
        if pickerView.tag == 2 {
            txfSubcategory.text = pickOptionSubCat[row]
        }
        
    }
    
//    ========================================
//    UIFunctions
//    ========================================
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView :UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
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
            lblTitle.text = "Insert expense";
        case 1:
            lblTitle.text = "Insert revenue";
        default:
            break; 
        }
        }
   
    
    @IBAction func AddNewItem(_ sender: UIButton) {
        let title = lblTitle.text
        let category = txfCategory.text
        let subCategory = txfSubcategory.text
        let date = 23
        print("Title: \(title), Category: \(category), Subcategory: \(subCategory), Date: \(date)")
        
    }
   
}

