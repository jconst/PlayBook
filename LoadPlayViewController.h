//
//  LoadPlayViewController.h
//  PlayBook
//
//  Created by Joseph Constan on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayBookAppDelegate.h"


@interface LoadPlayViewController : UITableViewController {
	RootViewController *rootViewController;
}
@property (nonatomic, retain) RootViewController *rootViewController;

@end
