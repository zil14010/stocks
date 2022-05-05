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
import Charts
import Firebase
class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var stock_price: UITextField!
    
    @IBAction func logout(_ sender: UIButton) {
        do{
          try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.synchronize()
            exit(-1)
        }
        catch{
            showError()
            return
            
        }
    }
    @IBOutlet weak var result_button: UIButton!
    @IBOutlet weak var chart_button: UIButton!
    @IBAction func the_button(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LineChartViewController = storyBoard.instantiateViewController(withIdentifier: "LineChart") as! LineChartViewController
        //showError()
       // LineChartViewController.x.append(2.0)
       // LineChartViewController.y.append("s")
        self.present(LineChartViewController, animated: true, completion: {
           
        })
    }
    @IBOutlet weak var strike_price_label: UILabel!
    @IBOutlet weak var btnSelectFruit: UIButton!{ didSet{
        //testing.text = "114514"
        //handle()
    }}
  

    
    enum TradeType: String {
        case Call = "Call"
        case Put = "Put"
        case CoveredCall = "CoveredCall"
        
    }
 //   @IBOutlet weak var chartview: UIView!
    let transparentView = UIView()
    let tableView = UITableView()
    var what: String = ""
    var selectedButton = UIButton()
    
    var dataSource = [String]()
   // @IBOutlet weak var number_of_contract: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        result_button.isHidden = true
        chart_button.isHidden = true
        number_of_contract.delegate = self
        Skrike_Price.delegate = self
        price_pa_contract.delegate = self
        Target_Price.delegate = self
    //    var testVC: LineChartViewController = LineChartViewController();
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
 //   @IBOutlet weak var testing: UILabel?
    @IBOutlet weak var number_of_contract: UITextField!
    @IBOutlet weak var price_pa_contract: UITextField!
    @IBOutlet weak var Target_Price_Label: UILabel!
    @IBOutlet weak var Target_Price: UITextField!
    @IBOutlet weak var Skrike_Price: UITextField!
    @IBOutlet weak var stock_price_label: UILabel!
    @IBOutlet weak var break_even_label: UILabel!
    @IBOutlet weak var m_loss_label: UILabel!
    @IBOutlet weak var m_profit_label: UILabel!
    @IBOutlet weak var maxi_profit: UILabel!
    @IBOutlet weak var maxi_loss: UILabel!
    @IBOutlet weak var break_even: UILabel!
    @IBAction func result(_ sender: UIButton) {
        let pc0 = price_pa_contract.text!
        let n = number_of_contract.text!
        let sp = Skrike_Price.text!
        let tp = Target_Price.text!
        let stock_price = stock_price.text!
        var total_cost_local : Double
        var potential_profit_local : Double?
        var potential_returen_local : Double?
        let checking = price_pa_contract.text
        let checking2 = number_of_contract.text
      //  stock_price.isHidden = true
        if(checking == "" || checking2 == ""){
           // print("whshoklashdkahdkashd",object_getClass(pc0)?.description())
            showError()
            return
        }
        var type = btnSelectFruit.title(for: .normal)
        if(type == TradeType.Call.rawValue){
            //longcall
          //  self.stock_price.isHidden = true
            total_cost_local = Double(pc0)! * Double(n)! * 100
            potential_profit_local = (Double(tp)! - Double(sp)! - Double(pc0)!) / Double(pc0)!
            potential_returen_local = (Double(tp)! - Double(sp)! - Double(pc0)!) * Double(n)! * 100
            total_cost.text = String(format: "%.2f",total_cost_local) + "$"
            potential_profit.text = String(format: "%.2f",potential_profit_local!) + "%"
            potential_return.text = String(format: "%.2f",potential_returen_local!) + "$"
        }
        else if(type == TradeType.Put.rawValue){
           // self.stock_price.isHidden = true
            total_cost_local = Double(pc0)! * Double(n)! * 100
            potential_profit_local = (Double(sp)! - Double(tp)! - Double(pc0)!) / Double(pc0)! * 100
            potential_returen_local = (Double(sp)! - Double(tp)! - Double(pc0)!) * Double(n)! * 100
            total_cost.text = String(format: "%.2f",total_cost_local) + "$"
            potential_profit.text = String(format: "%.2f",potential_profit_local!) + "%"
            potential_return.text = String(format: "%.2f",potential_returen_local!) + "$"
        }
        //maxi profit: when premium + benifit = price of call * number of option * 100 + strike price * 100 * number - stock price * 100 * number of option
        else if(type == TradeType.CoveredCall.rawValue){
         //   pc0//premium
            let call_premium = Double(pc0)! * Double(n)! * 100
            let previous = Double(stock_price)! * Double(n)! * 100
            let current = Double(tp)! * Double(n)! * 100
            if(Double(sp)! > Double(tp)!){
                //would not execute contract
                let maxi_profit_local = call_premium + current - previous
                maxi_profit.text! = String(format: "%.2f", maxi_profit_local) + "$"

            }
            else if(Double(sp)! <= Double(tp)!){
                //would execute contract
                let maxi_profit_local = call_premium + (Double(sp)! - Double(stock_price)!) * Double(n)! * 100
                maxi_profit.text! = String(format: "%.2f", maxi_profit_local) + "$"
               
            }
            let maximum_loss = call_premium - Double(stock_price)! * Double(n)! * 100
            maxi_loss.text! = String(format: "%.2f", maximum_loss) + "$"
            let break_even_point = (call_premium + previous) / Double(n)! / 100
            break_even.text! =  String(format: "%.2f",break_even_point) + "$"
        
            
            
        }
        
        
    }
    @IBOutlet weak var testing1: UILabel!
    @IBOutlet weak var testing3: UILabel!
    @IBOutlet weak var testing2: UILabel!
    @IBOutlet weak var total_cost: UILabel!
    @IBOutlet weak var potential_profit: UILabel!
    @IBOutlet weak var potential_return: UILabel!

    func showError() {
        let alert = UIAlertController(title: "Cal Error", message: "nil input", preferredStyle: .alert)
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
       // testing?.text = dataSource[indexPath.row]
        if (dataSource[indexPath.row] == "Call" || dataSource[indexPath.row] == "Put"){
            UIView.transition(with: stock_price, duration: 1,
                                options: .transitionCrossDissolve,
                                animations: {
                self.stock_price.isHidden = true
                self.stock_price_label.isHidden = true
                self.testing1.isHidden = false
                self.testing2.isHidden = false
                self.testing3.isHidden = false
                self.total_cost.isHidden = false
                self.potential_profit.isHidden = false
                self.potential_return.isHidden = false
                self.maxi_loss.isHidden = true
                self.maxi_profit.isHidden = true
                self.break_even.isHidden = true
                self.m_loss_label.isHidden = true
                self.m_profit_label.isHidden = true
                self.break_even_label.isHidden = true
                self.Target_Price_Label.text = "Target Price"
                self.result_button.isHidden = false
                self.chart_button.isHidden = true
                if(self.dataSource[indexPath.row] == "Put"){
                self.btnSelectFruit.setTitleColor(.red, for: .normal)
                }
                if(self.dataSource[indexPath.row] == "Call"){
                self.btnSelectFruit.setTitleColor(.systemGreen, for: .normal)
                }
                })
            
        }
        if (dataSource[indexPath.row] == "CoveredCall"){
            UIView.transition(with: stock_price, duration: 1,
                              options: .transitionFlipFromLeft,
                                animations: {
                self.testing1.isHidden = true
                self.testing2.isHidden = true
                self.testing3.isHidden = true
                self.total_cost.isHidden = true
                self.potential_profit.isHidden = true
                self.potential_return.isHidden = true
                self.stock_price.isHidden = false
                self.stock_price_label.isHidden = false
                self.maxi_loss.isHidden = false
                self.maxi_profit.isHidden = false
                self.break_even.isHidden = false
                self.m_loss_label.isHidden = false
                self.m_profit_label.isHidden = false
                self.break_even_label.isHidden = false
                self.Target_Price_Label.text = "Current Price"
                self.btnSelectFruit.setTitleColor(.systemTeal, for: .normal)
                self.result_button.isHidden = false
                self.chart_button.isHidden = false

                            })
            //stock_price.isHidden = true
            
        }
        
    }
}
