//
//  Picker.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 29/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

/*
 Unused for now. My plan was to fetch all genres and add ability to filter results with picker selection
 */

//class PickerViewModel<T: SelectionIterable>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    var items: [T] = []
//    var selectedItem: ((T) -> Void)?
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return items[row].displayText
//    }
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return items.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedItem?(items[row])
//    }
//
//}
//
//
//class PickerView<T: SelectionIterable>: UIPickerView {
//    
//    var pickerViewModel: PickerViewModel<T>
//    
//    init(pickerViewModel: PickerViewModel<T>) {
//        self.pickerViewModel = pickerViewModel
//        
//        super.init(frame: .zero)
//        
//        self.delegate = pickerViewModel
//        self.dataSource = pickerViewModel
//    }
//    
//    @available(*, unavailable, message: "No XIB")
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
