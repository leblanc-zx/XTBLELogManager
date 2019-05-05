//
//  XTUtils+DES.m
//  XTGeneralModule
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018年 新天科技股份有限公司. All rights reserved.
//

#import "XTUtils+DES.h"
#import "DesEntry.h"

@implementation XTUtils (DES)

/**
 获取密文口令

 @param command 明文
 @param random 随机数
 @return 密文
 */
+ (NSString *)desWithCommand:(NSString *)command random:(NSString *)random {
    DesEntry *desEntry = [[DesEntry alloc] init];
    return [desEntry desNFC:command random:random];
}

@end
