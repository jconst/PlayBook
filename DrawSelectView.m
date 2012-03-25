//
//  DrawSelectView.m
//  PlayBook
//
//  Created by Joseph Constan on 8/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DrawSelectView.h"


@implementation DrawSelectView

@synthesize isExpanded, selectedDrawMode;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        if (!(selectedDrawMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedDrawMode"])) {
			selectedDrawMode = DrawModeStyleCut;
		}
		[self loadStyle];
    }
    return self;
}

- (void) loadStyle 
{
	drawModeImages = [[NSArray alloc] initWithObjects:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrawModeCut.png"]] autorelease],
					  [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrawModePass.png"]] autorelease],
					  [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrawModeDribble.png"]] autorelease],
					  [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrawModeScreen.png"]] autorelease],
					  [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrawModeShot.png"]] autorelease],
					  [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrawModeFreehand.png"]] autorelease], nil];

	
	[[drawModeImages objectAtIndex:selectedDrawMode] setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[self addSubview:[drawModeImages objectAtIndex:selectedDrawMode]];
}

- (void) expandList 
{
	CGPoint initialCenter = [[drawModeImages objectAtIndex:selectedDrawMode] center];
	
	// load all the images behind the main one
	for (int i = 0; i < 6; i++) {
		if (i != selectedDrawMode) {
			[self insertSubview:[drawModeImages objectAtIndex:i] belowSubview:[drawModeImages objectAtIndex:selectedDrawMode]];
		}
	}
	
	// move them to the appropriate locales
	[UIView beginAnimations:@"expandList" context:nil];
	[UIView setAnimationDuration:0.7];
		
	for (int j = 0; j < 6; j++) {
		[[drawModeImages objectAtIndex:j] setCenter:CGPointMake(initialCenter.x - 100*j, initialCenter.y)];
	}
	[UIView commitAnimations];
}

- (void) closeList
{
	CGPoint initialCenter = [[drawModeImages objectAtIndex:0] center];
	
	[self bringSubviewToFront:[drawModeImages objectAtIndex:selectedDrawMode]];
	// stack them back up
	[UIView beginAnimations:@"closeList" context:nil];
	[UIView setAnimationDuration:0.7];
	
	self.bounds = [[drawModeImages objectAtIndex:0] bounds];
	
	for (int j = 0; j < 6; j++) {
		[[drawModeImages objectAtIndex:j] setCenter:initialCenter];
	}
	[UIView commitAnimations];
	isExpanded = NO;
}

#pragma mark -
#pragma mark Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (CGRectContainsPoint(self.bounds, [[touches anyObject] locationInView:self])) {
		didBeginTap = YES;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (CGRectContainsPoint(self.bounds, [[touches anyObject] locationInView:self]) && didBeginTap == YES && isExpanded == NO) {
		[self expandList];
		isExpanded = YES;
		didBeginTap = NO;
	}
	else if (CGRectContainsPoint(self.bounds, [[touches anyObject] locationInView:self]) && didBeginTap == YES && isExpanded == YES) {
		selectedDrawMode = DrawModeStyleCut;
		[self closeList];
		isExpanded = NO;
		didBeginTap = NO;
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
