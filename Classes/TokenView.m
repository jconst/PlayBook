//
//  TokenView.m
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TokenView.h"


@implementation TokenView

@synthesize numberField, style, hasMoved, num;

- (id)initWithStyle:(TokenViewStyle)initStyle number:(NSUInteger)number {
	style = initStyle;
	num = number;
	numberField = nil;
	
    if ((self = [super initWithFrame:CGRectMake(0, 0, 50, 50)])) {
        switch (initStyle) {
			case TokenStyleOffense:
				self.image = [UIImage imageNamed:@"OffenseToken.png"];
				if (number > 9)
					numberField = [[UITextField alloc] initWithFrame:CGRectMake(13, 13, 25, 25)];
				else
					numberField = [[UITextField alloc] initWithFrame:CGRectMake(20, 13, 20, 25)];
				
				numberField.font = [UIFont boldSystemFontOfSize:22];
				numberField.text = [NSString stringWithFormat:@"%d", number];
				numberField.textColor = [UIColor whiteColor];
				[self addSubview:numberField];
				break;
				
			case TokenStyleDefense:
				self.image = [UIImage imageNamed:@"DefenseToken.png"];
				numberField = [[UITextField alloc] initWithFrame:CGRectMake(45, 14, 20, 30)];
				numberField.text = [NSString stringWithFormat:@"%d", number];
				numberField.textColor = [UIColor whiteColor];
				[self addSubview:numberField];
				break;
				
			case TokenStyleCone:
				self.image = [UIImage imageNamed:@"ConeToken.png"];
				numberField = nil;
				break;
			case TokenStyleBall:
				self.image = [UIImage imageNamed:@"BallToken.png"];
				numberField = nil;
				break;
			default:
				numberField = nil;
				break;
		}
    }
	return self;
}

- (NSString *)description {
	NSMutableString *ret = [NSMutableString string];
	
	[ret appendFormat:@"X: %f\r", self.frame.origin.x];
	[ret appendFormat:@"Y: %f\r", self.frame.origin.y];
	[ret appendFormat:@"Num: %d\r", num];
	[ret appendFormat:@"Style: %d\r", style];
	
	return (NSString *)ret;
}

- (void) destroyTokenFromArray:(NSMutableArray *)array 
{
	containerArray = array;
	[UIView beginAnimations:@"tokenDestroy" context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	self.center = CGPointMake(705, 886);
	self.bounds = CGRectMake(25, 25, 0, 0);
	[UIView commitAnimations];
}

 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{	
	[numberField removeFromSuperview];
	[self removeFromSuperview];
	[containerArray removeObject:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[numberField release];
    [super dealloc];
}


@end
