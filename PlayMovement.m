//
//  playMovement.m
//  PlayBook
//
//  Created by Joseph Constan on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayMovement.h"


@implementation PlayMovement

@synthesize tokenArray, drawnObjects, placeNum;

- (id)initWithTokens:(NSMutableArray *)tokens drawings:(NSMutableArray *)drawings place:(NSUInteger)place
{
	if (self = [super init]) {
		self.tokenArray = tokens;
		self.drawnObjects = drawings;
		self.placeNum = place;
	}
	return self;
}

- (NSString *)description {
	NSMutableString *ret = [NSMutableString string];
	for (int i = 0; i < [tokenArray count]; i++) {
		[ret appendFormat:@"Token%d: %@ \r", i, [[tokenArray objectAtIndex:i] description]];
	}
	return (NSString *)ret;
}

+ (id)movementWithTokens:(NSMutableArray *)tokens drawings:(NSMutableArray *)drawings place:(NSUInteger)place
{
	return [[[PlayMovement alloc] initWithTokens:tokens drawings:drawings place:place] autorelease];
}

@end
