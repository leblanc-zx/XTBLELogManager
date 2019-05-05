//
//  XTPriceGroupInfo.h
//  XTXTUtils
//
//  Created by apple on 2018/11/5.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 价格组信息<<4阶5价>>
 */
@interface XTPriceGroupInfo : NSObject

@property (nonatomic, assign) long price1;      //价格1
@property (nonatomic, assign) long devideCount1;//分界点1
@property (nonatomic, assign) long price2;      //价格2
@property (nonatomic, assign) long devideCount2;//分界点2
@property (nonatomic, assign) long price3;      //价格3
@property (nonatomic, assign) long devideCount3;//分界点3
@property (nonatomic, assign) long price4;      //价格4
@property (nonatomic, assign) long devideCount4;//分界点4
@property (nonatomic, assign) long price5;      //价格5

@end

NS_ASSUME_NONNULL_END
