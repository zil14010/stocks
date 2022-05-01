//
//  CalculatorViewController.swift
//  stocks
//
//  Created by zipeng lin on 4/25/22.
//  Copyright © 2022 dk. All rights reserved.
//
//
//  ViewController.swift
//  DropDownSelection
//
//  Created by SHUBHAM AGARWAL on 26/07/19.
//  Copyright © 2019 SHUBHAM AGARWAL. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var stock_price: UITextField!
    
    @IBOutlet weak var btnSelectFruit: UIButton!{ didSet{
        //testing.text = "114514"
        //handle()
    }}
  

    
    enum TradeType: String {
        case Call = "Call"
        case Put = "Put"
        case CoveredCall = "CoveredCall"
        
    }
    let transparentView = UIView()
    let tableView = UITableView()
    var what: String = ""
    var selectedButton = UIButton()
    
    var dataSource = [String]()
   // @IBOutlet weak var number_of_contract: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        number_of_contract.delegate = self
        Skrike_Price.delegate = self
        price_pa_contract.delegate = self
        Target_Price.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == number_of_contract {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        if textField == Skrike_Price {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        if textField == Target_Price {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        if textField == price_pa_contract {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    @IBAction func onClickSelectFruit(_ sender: Any) {
        dataSource = ["Call", "Put", "CoveredCall"]
        selectedButton = btnSelectFruit
        addTransparentView(frames: btnSelectFruit.frame)
    }
    @IBOutlet weak var testing: UILabel?
    @IBOutlet weak var number_of_contract: UITextField!
    @IBOutlet weak var price_pa_contract: UITextField!
    @IBOutlet weak var Target_Price: UITextField!
    @IBOutlet weak var Skrike_Price: UITextField!
    
    @IBOutlet weak var stock_price_label: UILabel!
    
    @IBAction func result(_ sender: UIButton) {
        let pc0 = price_pa_contract.text!
        let n = number_of_contract.text!
        let sp = Skrike_Price.text!
        let tp = Target_Price.text!
        var stock_price = stock_price.text!
        var total_cost_local : Double
        var potential_profit_local : Double?
        var potential_returen_local : Double?
      //  stock_price.isHidden = true
        
        if(testing?.text == TradeType.Call.rawValue){
            //longcall
          //  self.stock_price.isHidden = true
            total_cost_local = Double(pc0)! * Double(n)! * 100
            potential_profit_local = (Double(tp)! - Double(sp)! - Double(pc0)!) / Double(pc0)!
            potential_returen_local = (Double(tp)! - Double(sp)! - Double(pc0)!) * Double(n)! * 100
            total_cost.text = String(format: "%.2f",total_cost_local) + "$"
            potential_profit.text = String(format: "%.2f",potential_profit_local!) + "%"
            potential_return.text = String(format: "%.2f",potential_returen_local!) + "$"
        }
        else if(testing?.text == TradeType.Put.rawValue){
           // self.stock_price.isHidden = true
            total_cost_local = Double(pc0)! * Double(n)! * 100
            potential_profit_local = (Double(sp)! - Double(tp)! - Double(pc0)!) / Double(pc0)! * 100
            potential_returen_local = (Double(sp)! - Double(tp)! - Double(pc0)!) * Double(n)! * 100
            total_cost.text = String(format: "%.2f",total_cost_local) + "$"
            potential_profit.text = String(format: "%.2f",potential_profit_local!) + "%"
            potential_return.text = String(format: "%.2f",potential_returen_local!) + "$"
        }
        
        else if(testing?.text == TradeType.CoveredCall.rawValue){
         //   pc0//premium
           // var maxi_profit = pc0 * n + (sp - stock_price)
         //   var break_even = stock_price - pc0 * n
         //   var max_loss = pc0 * n - stock_price
        }
        
        
       // self.stock_price.isHidden = false
        
    }
    @IBOutlet weak var testing1: UILabel!
    @IBOutlet weak var testing3: UILabel!
    @IBOutlet weak var testing2: UILabel!
    @IBOutlet weak var total_cost: UILabel!
    @IBOutlet weak var potential_profit: UILabel!
    @IBOutlet weak var potential_return: UILabel!
    /* @IBAction func onClickSelectGender(_ sender: Any) {
        dataSource = ["Male", "Female"]
        selectedButton = btnSelectGender
        addTransparentView(frames: btnSelectGender.frame)
    }*/
    func showError() {
        let alert = UIAlertController(title: "Logout Error", message: "Could not Logout", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
        testing?.text = dataSource[indexPath.row]
        if (dataSource[indexPath.row] == "Call" || dataSource[indexPath.row] == "Put"){
            UIView.transition(with: stock_price, duration: 3,
                                options: .transitionCrossDissolve,
                                animations: {
                self.stock_price.isHidden = true
                self.stock_price_label.isHidden = true
                            })
            //stock_price.isHidden = true
            
        }
        if (dataSource[indexPath.row] == "CoveredCall"){
            UIView.transition(with: stock_price, duration: 3,
                              options: .transitionFlipFromLeft,
                                animations: {
                self.stock_price.isHidden = false
                self.stock_price_label.isHidden = false
                            })
            //stock_price.isHidden = true
            
        }
        
    }
}
