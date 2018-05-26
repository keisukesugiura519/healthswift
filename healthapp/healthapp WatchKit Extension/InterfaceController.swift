//
//  InterfaceController.swift
//  healthapp WatchKit Extension
//
//  Created by 杉浦圭相 on 2018/04/28.
//  Copyright © 2018年 杉浦圭相. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    let helthStore = HKHealthStore()
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard  HKHealthStore.isHealthDataAvailable() else {
            self.label.setText("not available")
            return
        }
        //アクセス権を求める
        let dataTypes = Set([HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!])
        self.helthStore.requestAuthorization(toShare: nil, read: dataTypes) {
            (success, error) -> Void in
            guard success else {
                self.label.setText("not allowed")
                return
            }
        }
    }
    
    //BPMでデータを取得
    let heartRateUnit = HKUnit(from: "count/min")
    // HealthStoreへのクエリ
    var heartRateQuery: HKQuery?
    
    @IBAction func buttonTapped() {
        if self.heartRateQuery == nil {
            // start
            // クエリ生成
            self.heartRateQuery = self.createStreamingQuery()
            // クエリ実行
            self.helthStore.execute(self.heartRateQuery!)
            self.button.setTitle("Stop")
            self.label.setText("Mesageing...")
        } else {
            //end
            self.helthStore.stop(self.heartRateQuery!)
            self.heartRateQuery = nil
            self.button.setTitle("Start")
            self.label.setText("")
        }
    }
    let heartRateType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    //healthStoreへのクエリ生成
    private func createStreamingQuery() -> HKQuery {
        let predicate = HKQuery.predicateForSamples(withStart: NSDate() as Date, end: nil, options: [])
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples: samples)
            
        }
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            self.addSamples(samples: samples)
        }
        return query
    }
    
    private func addSamples(samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
        guard let quantity = samples.last?.quantity else {
            return
        }
        label.setText("\(quantity.doubleValue(for: heartRateUnit))")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
