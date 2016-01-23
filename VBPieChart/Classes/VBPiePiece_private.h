//
//  VBPiePiece_private.h
//  VBPieChart
//
//  Created by Volodymyr Boichentsov on 17/01/2016.
//  Copyright © 2016 SAKrisT. All rights reserved.
//

#ifndef VBPiePiece_private_h
#define VBPiePiece_private_h

// Private class
@interface VBPiePieceData : NSObject
@property (nonatomic) NSInteger index;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *labelColor;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic) BOOL accent;

+ (UIColor*) defaultColors:(NSInteger)index;
+ (VBPiePieceData*) pieceDataWith:(NSDictionary*)object;
@end



#endif /* VBPiePiece_private_h */
