//
//  DrawSelectView.h
//  PlayBook
//
//  Created by Joseph Constan on 8/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	DrawModeStyleCut,
	DrawModeStylePass,
	DrawModeStyleDribble,
	DrawModeStyleScreen,
	DrawModeStyleShot,
	DrawModeStyleFreehand
} DrawModeStyle;

@interface DrawSelectView : UIView {
	NSArray *drawModeImages;
	UIImageView *mainImageView;
	
	DrawModeStyle selectedDrawMode;
	BOOL isExpanded;
	BOOL didBeginTap;
}
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) DrawModeStyle selectedDrawMode;

- (void) loadStyle;
- (void) closeList;
- (void) expandList;

@end
