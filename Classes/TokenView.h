//
//  TokenView.h
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenView.h"

typedef enum {
	TokenStyleOffense,
	TokenStyleDefense,
	TokenStyleBall,
	TokenStyleCone
} TokenViewStyle;

@interface TokenView : UIImageView {
	
	TokenViewStyle style;
	UITextField *numberField;
	BOOL hasMoved;
	NSMutableArray *containerArray;
	NSUInteger num;
}
@property (nonatomic) NSUInteger num;
@property (nonatomic, retain) UITextField *numberField;
@property (nonatomic) TokenViewStyle style;
@property (nonatomic) BOOL hasMoved;

- (id) initWithStyle:(TokenViewStyle)initStyle number:(NSUInteger)number;
- (void) destroyTokenFromArray:(NSMutableArray *)array;
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end
