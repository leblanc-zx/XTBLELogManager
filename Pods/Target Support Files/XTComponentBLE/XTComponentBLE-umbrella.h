#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XTBLEManager+Log.h"
#import "XTBLEManager.h"
#import "XTCBPeripheral.h"

FOUNDATION_EXPORT double XTComponentBLEVersionNumber;
FOUNDATION_EXPORT const unsigned char XTComponentBLEVersionString[];

