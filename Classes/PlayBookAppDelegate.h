//
//  PlayBookAppDelegate.h
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TokenView.h"
#import "DetailViewController.h"
#import "DrawSelectView.h"
#import "DrawnObjectView.h"
#import "PlayMovement.h"
#import "LoadPlayViewController.h"


@class RootViewController;
@class DetailViewController;

@interface PlayBookAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
