//
//  RegisterViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/7.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class RegisterViewModel: RVMViewModel {
   
    private let smsDataSourceProtocol = SMSDataSource.shareInstance()
    
    dynamic var countryAndAreaCode:CountryAndAreaCode!  // 国家名称、国家码
    dynamic var zonesArray = NSArray()                  // 支持的区号数组
    dynamic var errorMsg = ""                           // 错误提示信息
    dynamic var telephone = ""                          // 手机号
    dynamic var isValidTelephone = false                // 手机号是否有效
    
    var searchZonesArrayCommand:RACCommand!             // 查询支持的区号数组命令
    var sendVerityCodeCommand:RACCommand!               // 发送验证码命令
    
    override init() {
        
        super.init()
        
        // 查询国家名称、国家码
        self.countryAndAreaCode = self.smsDataSourceProtocol.queryCountryAndAreaCode()
        
        setupSearchZonesArrayCommand()    // 初始化查询支持的区号数组命令
        setupSendVerityCodeCommand()      // 初始化发送验证码命令
        
        // 手机号是否有效
        RACObserve(self, "telephone").mapAs { (telephone:NSString) -> NSNumber in
            
            let zoneCode = self.countryAndAreaCode.areaCode.stringByReplacingOccurrencesOfString("+", withString: "")
            return self.smsDataSourceProtocol.isValidTelephone(telephone as String, zoneCode: zoneCode, zonesArray: self.zonesArray)
        } ~> RAC(self,"isValidTelephone")
        
        // 激活后开始更新数据
        didBecomeActiveSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            let tempSignal = self.smsDataSourceProtocol.queryZone()
            
            // 查询支持的区号数组
            self.searchZonesArrayCommand.execute(nil)
        }
    }
    
    // MARK: - setup
    
    /**
     * 初始化查询支持的区号数组命令
     */
    private func setupSearchZonesArrayCommand() {
        
        // 初始化查询命令
        searchZonesArrayCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.smsDataSourceProtocol.queryZone()
        })
        
        // 处理错误
        searchZonesArrayCommand.errors.subscribeNextAs { (error:NSError!) -> () in
            
            self.errorMsg = error.localizedDescription
        }
        
        // 更新支持的区号数组
        searchZonesArrayCommand.executionSignals.switchToLatest().subscribeNextAs { (zonesArray:NSArray) -> () in
            
            self.zonesArray = zonesArray
        }
    }
    
    /**
     * 初始化发送验证码命令
     */
    private func setupSendVerityCodeCommand() {
        
        // 是否可以执行
        let enabledSignal = RACObserve(self, "isValidTelephone")
        
        // 初始化发送验证码命令
        sendVerityCodeCommand = RACCommand(enabled: enabledSignal,signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            let zoneCode = self.countryAndAreaCode.areaCode.stringByReplacingOccurrencesOfString("+", withString: "")
            return self.smsDataSourceProtocol.getVerificationCodeBySMS(self.telephone, zone: zoneCode)
        })
        
        // 处理错误
        sendVerityCodeCommand.errors.subscribeNextAs { (error:NSError!) -> () in
            
            self.errorMsg = error.localizedDescription
        }
    }
}
