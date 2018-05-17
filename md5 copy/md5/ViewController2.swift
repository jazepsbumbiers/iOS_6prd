//
//  ViewController2.swift
//  md5
//
//  Created by Jazeps on 29/04/2018.
//  Copyright © 2018 Jazeps. All rights reserved.
//

import UIKit

protocol SecondViewControllerDelegate {
    func setHideDesc() -> Bool
    func setshow10km() -> Bool
    func setUserLatitude(latitude: Double) -> Double
    func setUserLongitude(longitude: Double) -> Double
}

class ViewController2: UIViewController {
    var delegate: SecondViewControllerDelegate?
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var latitudeBox: UITextField!
    @IBOutlet var longitudeBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        latitudeBox.text = delegate?.setUserLatitude(latitude: -999)
//        longitudeBox.text = delegate?.setUserLongitude(longitude: -999)
    }
    
    
    @IBAction func latitudeChanged(_ sender: UITextField) {
        guard let textfield = sender.text else {
            return
        }
        
        let latitude:Double = Double(textfield)!
        delegate?.setUserLatitude(latitude: latitude)
    }
    
    @IBAction func longitudeChanged(_ sender: UITextField) {
        guard let textfield = sender.text else {
            return
        }
        
        let longitude:Double = Double(textfield)!
        delegate?.setUserLongitude(longitude: longitude)
    }
    
    
    @IBAction func hideDescr(_ sender: Any) {
        let state:Bool = (delegate?.setHideDesc())!
        if ( state ) {
            firstButton.setTitle("On", for: .normal)
        }
        else {
            firstButton.setTitle("Off", for: .normal)
        }
        //firstButton.setTitle(firstButton.titleLabel?.text == "On" ? "Off" : "On", for: .normal)
    }
    
    @IBAction func show10kmr(_ sender: Any) {
        let state:Bool = (delegate?.setshow10km())!
        if ( state ) {
            secondButton.setTitle("On", for: .normal)
        }
        else {
            secondButton.setTitle("Off", for: .normal)
        }
        //secondButton.setTitle(secondButton.titleLabel?.text == "On" ? "Off" : "On", for: .normal)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kautkadsback", let vc = segue.destination as? ViewController2 {
            vc.delegate = self as! SecondViewControllerDelegate
        }
    }

    
}
