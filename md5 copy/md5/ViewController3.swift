//
//  ViewController3.swift
//  md5
//
//  Created by Jazeps on 29/04/2018.
//  Copyright © 2018 Jazeps. All rights reserved.
//

import UIKit

protocol ThirdViewControllerDelegate {
    func addPin(name: String, subtitle: String, latitude: Double, longitude: Double)
}

class ViewController3: UIViewController {
    var delegate: ThirdViewControllerDelegate?
    @IBOutlet var newPinName: UITextField!
    @IBOutlet var newPinSubtitle: UITextField!
    @IBOutlet var latitude_text: UITextField!
    @IBOutlet var longitude_text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        print("clicked")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPinClicked(_ sender: Any) {
        guard let textfield1 = latitude_text.text else {
            return
        }
        
        guard let textfield2 = longitude_text.text else {
            return
        }
        
        let latitude:Double = Double(textfield1)!
        let longitude:Double = Double(textfield2)!
        delegate?.addPin(name: newPinName.text!, subtitle: newPinSubtitle.text!, latitude: latitude, longitude: longitude)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
