//
//  PlayMovement.h
//  PlayBook
//
//  Created by Joseph Constan on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlayMovement : NSObject {
	NSMutableArray *tokenArray;
	NSMutableArray *drawnObjects;
	NSUInteger placeNum;
}
@property (nonatomic, retain) NSMutableArray *tokenArray;
@property (nonatomic, retain) NSMutableArray *drawnObjects;
@property (nonatomic) NSUInteger placeNum;

+ (id)movementWithTokens:(NSMutableArray *)tokens drawings:(NSMutableArray *)drawings place:(NSUInteger)place;
- (id)initWithTokens:(NSMutableArray *)tokens drawings:(NSMutableArray *)drawings place:(NSUInteger)place;

@end
