//
//  DrawnObjectView.m
//  PlayBook
//
//  Created by Joseph Constan on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DrawnObjectView.h"


@implementation DrawnObjectView

@synthesize headOrigin, doneDragging;

- (id)initWithOrigin:(CGPoint)firstOrigin style:(DrawModeStyle)newStyle {
    if ((self = [super initWithFrame:CGRectMake(0, 0, 768, 1004)])) {
        // Initialization code
		style = newStyle;
		tailOrigin = firstOrigin;
		headOrigin = firstOrigin;
		freehandPath = CGPathCreateMutable();
		CGPathMoveToPoint(freehandPath, NULL, firstOrigin.x, firstOrigin.y);
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		waveLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DribblePattern.png"]];
		waveLine.clipsToBounds = YES;
		shotLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShotPattern.png"]];
		shotLine.clipsToBounds = YES;
    }
    return self;
}

- (void)setHeadOrigin:(CGPoint)newOrigin {
	if (doneDragging) return;
	headOrigin = newOrigin;
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	if (style == DrawModeStyleCut) {
		CGContextRef ctxt = UIGraphicsGetCurrentContext();
		CGMutablePathRef linePath = CGPathCreateMutable();
		CGPathMoveToPoint(linePath, NULL, tailOrigin.x, tailOrigin.y);
		// create line
		CGPathAddLineToPoint(linePath, NULL, headOrigin.x, headOrigin.y);
		
		// remove previous arrowhead
		if (arrowheadImage) { 
			[arrowheadImage removeFromSuperview];
			[arrowheadImage release];
		}
		// create new arrowhead
		arrowheadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowheadCut.png"]];
		// set rotation radians
		double rot = (headOrigin.y > tailOrigin.y) ? -(M_PI-atan((headOrigin.x - tailOrigin.x)/(tailOrigin.y - headOrigin.y))) 
												   :  atan((headOrigin.x - tailOrigin.x)/(tailOrigin.y - headOrigin.y));
		arrowheadImage.transform = CGAffineTransformMakeRotation(rot);
		arrowheadImage.center = headOrigin;
		[self addSubview:arrowheadImage];
		// add path to context
		CGContextAddPath(ctxt, linePath);
		// set the line width to a nice 5 pixels
		CGContextSetLineWidth(ctxt, 5.0);
		// stroke the path with a nice blue
		CGContextSetStrokeColorWithColor(ctxt, [[UIColor blueColor] CGColor]);
		CGContextStrokePath(ctxt);
		CGPathRelease(linePath);
	} else if (style == DrawModeStyleScreen) {
		CGContextRef ctxt = UIGraphicsGetCurrentContext();
		CGMutablePathRef linePath = CGPathCreateMutable();
		CGPathMoveToPoint(linePath, NULL, tailOrigin.x, tailOrigin.y);
		// create line
		CGPathAddLineToPoint(linePath, NULL, headOrigin.x, headOrigin.y);
		// GEOMETRY TIME!!!
		int a = headOrigin.x - tailOrigin.x;
		int b = tailOrigin.y - headOrigin.y;
		CGPathAddLineToPoint(linePath, NULL, headOrigin.x-((b*22)/hypot(a, b)), headOrigin.y-((a*22)/hypot(a, b)));
		CGPathAddLineToPoint(linePath, NULL, headOrigin.x+((b*22)/hypot(a, b)), headOrigin.y+((a*22)/hypot(a, b)));
		// add path to context
		CGContextAddPath(ctxt, linePath);
		// set the line width to a nice 5 pixels
		CGContextSetLineWidth(ctxt, 5.0);
		// stroke the path with a nice blue
		CGContextSetStrokeColorWithColor(ctxt, [[UIColor blueColor] CGColor]);
		CGContextStrokePath(ctxt);
		CGPathRelease(linePath);
	} else if (style == DrawModeStylePass) {
		CGContextRef ctxt = UIGraphicsGetCurrentContext();
		CGMutablePathRef linePath = CGPathCreateMutable();
		CGPathMoveToPoint(linePath, NULL, tailOrigin.x, tailOrigin.y);
		// create line
		CGPathAddLineToPoint(linePath, NULL, headOrigin.x, headOrigin.y);
		
		if (arrowheadImage) { 
			[arrowheadImage removeFromSuperview];
			[arrowheadImage release];
		}
		arrowheadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowheadCut.png"]];
		double rot = (headOrigin.y > tailOrigin.y) ? -(M_PI-atan((headOrigin.x - tailOrigin.x)/(tailOrigin.y - headOrigin.y))) 
		:  atan((headOrigin.x - tailOrigin.x)/(tailOrigin.y - headOrigin.y));
		arrowheadImage.transform = CGAffineTransformMakeRotation(rot);
		arrowheadImage.center = headOrigin;
		[self addSubview:arrowheadImage];
		// add path to context
		CGContextAddPath(ctxt, linePath);
		// set the line width to a nice 5 pixels
		CGFloat dash[2] = {20, 8};
		CGContextSetLineDash(ctxt, 8, dash, 2);
		CGContextSetLineWidth(ctxt, 5.0);
		// stroke the path with a nice blue
		CGContextSetStrokeColorWithColor(ctxt, [[UIColor blueColor] CGColor]);
		CGContextStrokePath(ctxt);
		CGPathRelease(linePath);
	}  else if (style == DrawModeStyleDribble) {	
		if ([waveLine respondsToSelector:@selector(removeFromSuperview)]) 
			[waveLine removeFromSuperview];
		if (arrowheadImage) {
			[arrowheadImage removeFromSuperview];
			[arrowheadImage release];
		}
		double ylen = tailOrigin.y - headOrigin.y;
		double xlen = headOrigin.x - tailOrigin.x;
		arrowheadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowheadCut.png"]];
		double rot = (headOrigin.y > tailOrigin.y) ? -(M_PI-atan(xlen/ylen)) 
												   : atan(xlen/ylen);
		
		arrowheadImage.transform = CGAffineTransformMakeRotation(rot);
		arrowheadImage.center = headOrigin;
		[self addSubview:arrowheadImage];
				
		waveLine.contentMode = UIViewContentModeBottom;
		//waveLine.frame = CGRectMake(headOrigin.x-7, headOrigin.y, 15, 1275);
		waveLine.bounds = CGRectMake(headOrigin.x-7, headOrigin.y, 15, hypot(xlen, ylen)-5);
		waveLine.transform = CGAffineTransformMakeRotation(rot);
		waveLine.center = CGPointMake(headOrigin.x - (xlen/2), headOrigin.y + (ylen/2));
		[self addSubview:waveLine];
	} else if (style == DrawModeStyleFreehand) {
		CGContextRef ctxt = UIGraphicsGetCurrentContext();
		// create line
		CGPathAddLineToPoint(freehandPath, NULL, headOrigin.x, headOrigin.y);
		// add path to context
		CGContextAddPath(ctxt, freehandPath);
		// set the line width to a nice 5 pixels
		CGContextSetLineWidth(ctxt, 5.0);
		// stroke the path with a nice blue
		CGContextSetStrokeColorWithColor(ctxt, [[UIColor blueColor] CGColor]);
		CGContextStrokePath(ctxt);
	} if (style == DrawModeStyleShot) {
		if ([shotLine respondsToSelector:@selector(removeFromSuperview)]) [shotLine removeFromSuperview];
		if (arrowheadImage) { 
			[arrowheadImage removeFromSuperview];
			[arrowheadImage release];
		}
		double ylen = tailOrigin.y - headOrigin.y;
		double xlen = headOrigin.x - tailOrigin.x;
		arrowheadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowheadShot.png"]];
		double rot = (headOrigin.y > tailOrigin.y) ? -(M_PI-atan(xlen/ylen)) 
		: atan(xlen/ylen);
		
		arrowheadImage.transform = CGAffineTransformMakeRotation(rot);
		arrowheadImage.center = headOrigin;
		[self addSubview:arrowheadImage];
		
		shotLine.contentMode = UIViewContentModeBottom;
		//shotLine.frame = CGRectMake(headOrigin.x-7, headOrigin.y, 15, 1275);//1275
		shotLine.bounds = CGRectMake(headOrigin.x-7, headOrigin.y, 15, hypot(xlen, ylen)-5);
		shotLine.transform = CGAffineTransformMakeRotation(rot);
		shotLine.center = CGPointMake(headOrigin.x - (xlen/2), headOrigin.y + (ylen/2));
		[self addSubview:shotLine];
	}
}

- (void)dealloc {
	CGPathRelease(freehandPath);
	
    [super dealloc];
}

@end
