//
//  DesEntry.h
//  SuntrontBlueTooth
//
//  Created by apple on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEntry : NSObject

/**
 *  获取密文口令
 */
- (NSString *)desNFC:(NSString *)command random:(NSString *)random;

@end
