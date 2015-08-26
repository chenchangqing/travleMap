//
//  QueryIndexPageStrategyListBusiness.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class QueryIndexPageStrategyListBusiness: AbstractBusinessProtocol {
    
    private var strategyModelDataSourceProtocol : StrategyModelDataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
   
    // MARK: - implement
    
    var title : String {
        
        get {
            
            return "查询首页小编推荐的攻略"
        }
    }
    
    var isValid : Bool {
        
        get {
            
            return true
        }
    }
    
    var businessModel = BusinessModel()
    
    func execute() {
        
        // 开始查询
        strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01(), callback: { (success, msg, data) -> Void in
            
            self.businessModel.setValue(success, forKey: kSuccess)
            self.businessModel.setValue(msg, forKey: kMsg)
            self.businessModel.setValue(data, forKey: kData)
        })
    }
}
