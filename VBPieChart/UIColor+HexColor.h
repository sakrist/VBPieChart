//
//  UIColor+HexColor.h
//  
//
//  Created by Jonas Schnelli on 01.07.10.
//  Modified by Vladimir Boichentsov on 23.10.11.
//  Copyright 2010 include7 AG. All rights reserved.
//

#ifndef _WOL_UICOLOR_HEX_COLOR_H__
#define _WOL_UICOLOR_HEX_COLOR_H__


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (HexColor)

- (NSString *) hexString;

+ (UIColor *) colorWithHex:(int)color;
+ (UIColor *) colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha;

+ (UIColor *) colorWithHexString:(NSString *)hexString;
+ (UIColor *) colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
@end


#endif