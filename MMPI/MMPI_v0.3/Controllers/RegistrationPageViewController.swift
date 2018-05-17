//
//  RegistrationPageViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 07.03.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class RegistrationPageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UploadModelProtocol {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var sexView: UIView!
    @IBOutlet weak var sexPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneDatePickerButton: UIButton!
    @IBOutlet weak var doneSexPickerButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var registrationDoneItemButton: UIBarButtonItem!
    @IBOutlet weak var idTextField: UITextField!
    
    
    var uploadModel = UploadModel()
    var registeredUserId: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.text = ""
        
        // MARK: - Testing
        dateTextField.text = "21.09.1999"
        sexTextField.text = "Мужской"
        nameTextField.text = "Алексей Лямзин"
        idTextField.text = "5afc437851ad7d24a3aabaa7"
        
        dateTextField.delegate = self
        sexTextField.delegate = self
        uploadModel.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func itemsUploaded(items: NSArray) {
        if items[0] as! String != "" {
            registeredUserId = items[0] as! String
            performSegue(withIdentifier: "registrationSegue", sender: self)
        } else {
            warningLabel.text = "Не удалось зарегистрировать пользователя"
        }
    }
    
    // Сделать dateTextField и sexTextField недоступными для редактирования с клавиатуры
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateTextField || textField == sexTextField {
            return false
        }
        return true
    }
    
      //MARK: - Работа с полем "Дата рождения"
    
    // Сделать datePickerView видимым при редактировании поля "Дата рождения"
    @IBAction func dateTextFieldSelected(_ sender: Any) {
        dateTextField.text = "08.03.2000"
        sexView.isHidden = true
        datePickerView.isHidden = false
        
    }
    
    // Реализация изменения даты рождения в dateTextField с помощью datePickerView
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        // Функция для конвертации даты в стандартный для русскоговорящего пользователя формат
        func convertDateFormater(_ date: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "m/dd/yy"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd.mm.yyyy"
            return dateFormatter.string(from: date!)
        }
        let strDate = convertDateFormater(dateFormatter.string(from: datePicker.date) )
        dateTextField.text = strDate
    }
    
    // Скрыть datePickerView после окончания редактирования поля "Дата рождения"
    @IBAction func doneDatePickerButtonTouchDown(_ sender: Any) {
        datePickerView.isHidden = true
    }
    
    
    // Скрыть datePickerView после окончания редактирования даты рождения
    @IBAction func textFieldEditingEnd(_ sender: Any) {
        datePickerView.isHidden = true
    }
    
    //MARK: - Работа с полем "Пол"
    
    let sex = ["Мужской", "Женский"]
    
    // Задаем количество компонентов нашего sexPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Задаем название каждого из вариантов, предоставляемых sexPicker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sex[row]
    }
    
    // Задаем количество вариантов sexPicker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sex.count
    }
    
    // Реализация изменения пола в поле sexTextField с помощью sexPicker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sexTextField.text = sex[row]
    }
    
    // Сделать sexPicker видимым
    @IBAction func sexTextFieldSelected(_ sender: Any){
        sexTextField.text = "Мужской"
        sexView.isHidden = false
        datePickerView.isHidden = true
    }

    // Скрыть sexPicker после окончания редактирования поля "Пол"
    @IBAction func doneSexPickerButtonTouchDown(_ sender: Any) {
        sexView.isHidden = true
    }
    
    // Проверка введенных пользователем данных на непустоту
    
    // Обработка нажатия пользователем кнопки "Готово"
    @IBAction func registrationDoneButtonTouch(_ sender: Any) {
        // Функция, осуществляющая проверку введенных данных на непустоту
        func registrationInfoCheck(name: String, dateOfBirth: String, sex: String) -> Bool {
            if (name != "") && (dateOfBirth != "") && (sex != ""){
                return true
            }
            warningLabel.text = "Не вся необходимая информация введена пользователем"
            return false
        }
        
        let condition = registrationInfoCheck(name: nameTextField.text!, dateOfBirth: dateTextField.text!, sex: sexTextField.text!)
        
        if (condition == true) {
            uploadModel.uploadUser(name: nameTextField.text!, dateOfBirth: dateTextField.text!, sex: sexTextField.text!, specialistId: idTextField.text!)
        }
    }
    
    //MARK:- Передача значения поля "Пол" в mmpiTestingViewController
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! InstructionsViewController
        destination.sex = sexTextField.text!
        destination.dateOfBirth = dateTextField.text!
        destination.name = nameTextField.text!
        destination.specialistId = idTextField.text!
        destination.resultId = registeredUserId
        print(registeredUserId)
        
//        uploadModel.uploadUser(name: nameTextField.text!, dateOfBirth: dateTextField.text!, sex: sexTextField.text!, specialistId: idTextField.text!)
    }

}
