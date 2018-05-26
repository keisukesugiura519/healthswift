//
//  ViewController.swift
//  healthapp
//
//  Created by 杉浦圭相 on 2018/04/28.
//  Copyright © 2018年 杉浦圭相. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    let heartRateUnit = HKUnit(from: "count/min")
    
    //心拍数を取得するためのデータを作成
    let DataType = Set([HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //心拍数データにアクセスするための許可を取得する。
        self.healthKitStore.requestAuthorization(toShare: nil, read: DataType) {
            (success, error) -> Void in
        }
    }
    
    @IBAction func buttonTapped() {
        
    }
    
    private func addSample(samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
        guard let quantity = samples.last?.quantity else {
            return
        }
        //Label.setText("\(quantity.doubleValue(for: heartRateUnit))")
        let rate = String(quantity.doubleValue(for: heartRateUnit))
        Label.text = rate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

