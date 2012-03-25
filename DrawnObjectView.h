//
//  DrawnObjectView.h
//  PlayBook
//
//  Created by Joseph Constan on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayBookAppDelegate.h"


@interface DrawnObjectView : UIView {
	DrawModeStyle style;
	CGPoint tailOrigin;
	CGPoint headOrigin;
	CGMutablePathRef freehandPath;
	UIImageView *arrowheadImage;
	UIView *waveLine;
	UIView *shotLine;
	
	BOOL doneDragging;
}
@property (nonatomic) CGPoint headOrigin;
@property (nonatomic) BOOL doneDragging;

- (id)initWithOrigin:(CGPoint)firstOrigin style:(DrawModeStyle)newStyle;

@end
