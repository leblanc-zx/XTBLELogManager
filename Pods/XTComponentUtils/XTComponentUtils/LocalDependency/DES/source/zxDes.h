//
//  zxDes.h
//  SuntrontBlueTooth
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 apple. All rights reserved.
//

/** des加密 */
void des_encipher(const unsigned char *plaintext, unsigned char *ciphertext,
                  const unsigned char *key);

/** des解密 */
void des_decipher(const unsigned char *ciphertext, unsigned char *plaintext,
                  const unsigned char *key);
