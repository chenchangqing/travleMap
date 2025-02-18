//
//  StrategyDetailViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/10.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel
import GONMarkupParser

class StrategyDetailViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    dynamic var poiList     = [POIModel]()  // POI列表
    
    var strategyModel               : StrategyModel!    // 攻略model
    
    // MARK: - init
    
    init(strategyModel: StrategyModel) {
        
        super.init()
        
        self.strategyModel = strategyModel
    
    }
    
    // MARK: -
    
    /**
     * 排版攻略详情数据
     */
    func getStrategyTextViewData() -> NSMutableAttributedString {
        
        // 标题
        let strategyTitleString      = strategyModel.title != nil ? strategyModel.title! : ""
        
        // 创建时间
        let strategyCreateTimeString = (strategyModel.createTime != nil ? strategyModel.createTime! : "")
        
        // 喜欢人数
        let strategyLikeNumberString = strategyModel.likeNumber != nil ? "  [\(strategyModel.likeNumber!)人喜欢]" : ""
        
        // 详细信息
        let strategyContentString    = strategyModel.desc != nil ? strategyModel.desc! : ""
        
        // 组装文本
        let contentString = "<color value=\"blue\"><font size=\"21\">\(strategyTitleString)</font></color><br/><br/><font size=\"14\">\(strategyCreateTimeString)\(strategyLikeNumberString)</font><br/><br/><font size=\"14\">\(strategyContentString)\(strategyContentString)</font>"
        
        let attributedString = GONMarkupParserManager.sharedParser().attributedStringFromString(contentString)
        
        return attributedString
    }
}
