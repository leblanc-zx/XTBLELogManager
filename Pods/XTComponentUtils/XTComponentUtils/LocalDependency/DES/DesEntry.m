//
//  DesEntry.m
//  SuntrontBlueTooth
//
//  Created by apple on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DesEntry.h"
#include "zxDes.h"

@implementation DesEntry

static int i_Con_Encrypt = 1;   //加密
static int i_Con_Decrypt = 0;   //解密

/**
 *  获取密文口令
 */
- (NSString *)desNFC:(NSString *)command random:(NSString *)random {
    
    NSString *str_Con_Key03 = @"2233445566778899AABBCCDDEEFF0011";
    NSString *str_Key = [self keyDisperse:str_Con_Key03 random:random];
    
    NSString *userData = command;
    Byte *fCardData = malloc(16);
    for (int k = 0; k < userData.length / 2; k++) {
        NSString *a = [userData substringWithRange:NSMakeRange(k*2, 2)];
        fCardData[k] = strtoul([a UTF8String], 0, 16) & 0xff;
    }
    
    int sum = 0;
    for (int j = 0; j < 15; j++) {
        sum += fCardData[j];
        
    }
    
    fCardData[15] = (Byte)(sum & 0xff);
    NSString *hex = [NSString stringWithFormat:@"%x",(fCardData[15 & 0xff])];
    if (hex.length == 1) {
        hex = [NSString stringWithFormat:@"0%@",hex];
    }
    NSString *newUserData = [NSString stringWithFormat:@"%@%@",userData,hex];
    
    NSMutableString *str_Encrypt = [[NSMutableString alloc] init];
    if (str_Key.length == 32) {
        for (int i = 0; i < 2; i ++) {
            [str_Encrypt appendString:[self OffSetEncryptDataTriDES:[newUserData substringWithRange:NSMakeRange(i*16, 16)] strKey:str_Key offset:0]];
        }
    }
    
    return [NSString stringWithFormat:@"%@%@",str_Encrypt,random];
    
}

- (NSString *)keyDisperse:(NSString *)str_RootKey random:(NSString *)str_DisperseDene {
    
    NSString *str_Result, *str_Left, *str_Right;
    
    if (str_RootKey.length == 32) {
        str_Left = [self OffSetEncryptDataTriDES:str_DisperseDene strKey:str_RootKey offset:0];
        str_Right = [self OffSetEncryptDataTriDES:[self _8ByteHexNot:str_DisperseDene] strKey:str_RootKey offset:0];
        str_Result = [NSString stringWithFormat:@"%@%@",str_Left,str_Right];
    } else {
        str_Result = [self OffSetEncryptDataTriDES:str_DisperseDene strKey:str_RootKey offset:0];
    }
    
    return str_Result;
    
}

- (NSString *)_8ByteHexNot:(NSString *)str_Data {
    
    NSMutableString *rtn = [[NSMutableString alloc] init];
    for (int i = 0; i < str_Data.length/2; i ++) {
        NSString *str_Data_i = [str_Data substringWithRange:NSMakeRange(i*2, 2)];
        NSString *hex = [NSString stringWithFormat:@"%lx",255 - strtoul([str_Data_i UTF8String], 0, 16)];
        if (hex.length == 1) {
            hex = [NSString stringWithFormat:@"0%@",hex];
        }
        [rtn appendString:hex];
    }
    return rtn.uppercaseString;
}

- (NSString *)OffSetEncryptDataTriDES:(NSString *)str_Data strKey:(NSString *)str_Key offset:(int)i_OffSet {
    if (i_OffSet * 2 + 16 > str_Data.length) {
        return @"";
    }
    
    NSString *str_Decrypt, *str_Left;
    
    str_Decrypt = [self TriDesOperation:[str_Data substringWithRange:NSMakeRange(i_OffSet * 2, 16 - i_OffSet * 2)] strKey:str_Key sign:i_Con_Encrypt];
    str_Left = [str_Data substringWithRange:NSMakeRange(i_OffSet*2 + 16, str_Data.length - i_OffSet*2-16)];
    
    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@",[str_Data substringWithRange:NSMakeRange(0, i_OffSet*2)] , str_Decrypt, str_Left];
    return resultStr;
    
}

- (NSString *)TriDesOperation:(NSString *)str_Data strKey:(NSString *)str_Key sign:(int)i_Sign {
    
    NSString *str_Left, *str_Right, *str_Result;
    
    str_Left = [str_Key substringWithRange:NSMakeRange(0, 16)];
    str_Right = [str_Key substringWithRange:NSMakeRange(16, 16)];
    
    if (i_Sign == i_Con_Encrypt) {
        
        str_Result = [self desOperation:str_Data strKey:str_Left sign:i_Con_Encrypt];
        str_Result = [self desOperation:str_Result strKey:str_Right sign:i_Con_Decrypt];
        str_Result = [self desOperation:str_Result strKey:str_Left sign:i_Con_Encrypt];
        return str_Result;
        
    } else if (i_Sign == i_Con_Decrypt) {
        
        str_Result = [self desOperation:str_Data strKey:str_Left sign:i_Con_Decrypt];
        str_Result = [self desOperation:str_Result strKey:str_Right sign:i_Con_Encrypt];
        str_Result = [self desOperation:str_Result strKey:str_Left sign:i_Con_Decrypt];
        return str_Result;
        
    } else {
        return @"";
    }
    
}

- (NSString *)desOperation:(NSString *)str_Data strKey:(NSString *)str_Key sign:(int)i_Sign {
    if (i_Sign == i_Con_Encrypt) {
        //加密
        return [self EncryStr:str_Data key:str_Key];
    } else if (i_Sign == i_Con_Decrypt) {
        //解密
        return [self DecryStr:str_Data key:str_Key];
    } else {
        return @"";
    }
}

- (NSString *)EncryStr:(NSString *)str key:(NSString *)kkey {
    
    Byte *plaintext = malloc(8);
    Byte *key = malloc(8);
    Byte *ciphertext = malloc(8);
    
    for (int i = 0; i < 8; i++) {
        NSString *planintextStr = [str substringWithRange:NSMakeRange(i*2, 2)];
        plaintext[i] = strtoul([planintextStr UTF8String], 0, 16) & 0xff;
        
        NSString *keyStr = [kkey substringWithRange:NSMakeRange(i*2, 2)];
        key[i] = strtoul([keyStr UTF8String], 0, 16) & 0xff;
        
    }

    //c DES加密
    des_encipher(plaintext, ciphertext, key);
    
    NSMutableString *reslutStr = [[NSMutableString alloc] init];
    for (int i = 0; i < 8; i++) {
        
        NSString *hexStr = [NSString stringWithFormat:@"%x",ciphertext[i] & 0xff];
        if (hexStr.length == 1) {
            [reslutStr appendString:@"0"];
        }
        [reslutStr appendString:hexStr];
    }
    
    return reslutStr;
    
}

- (NSString *)DecryStr:(NSString *)str key:(NSString *)kkey {
    
    Byte *plaintext = malloc(8);
    Byte *key = malloc(8);
    Byte *ciphertext = malloc(8);
    
    for (int i = 0; i < 8; i++) {
        NSString *planintextStr = [str substringWithRange:NSMakeRange(i*2, 2)];
        plaintext[i] = strtoul([planintextStr UTF8String], 0, 16) & 0xff;
        
        NSString *keyStr = [kkey substringWithRange:NSMakeRange(i*2, 2)];
        key[i] = strtoul([keyStr UTF8String], 0, 16) & 0xff;
        
    }
    
    //c DES解密
    des_decipher(plaintext, ciphertext, key);
    
    NSMutableString *reslutStr = [[NSMutableString alloc] init];
    for (int i = 0; i < 8; i++) {
        
        NSString *hexStr = [NSString stringWithFormat:@"%x",ciphertext[i] & 0xff];
        if (hexStr.length == 1) {
            [reslutStr appendString:@"0"];
        }
        [reslutStr appendString:hexStr];
        
    }
    
    return reslutStr;
    
}



@end
