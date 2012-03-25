//
//  DetailViewController.h
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayBookAppDelegate.h"

@class DrawSelectView, RootViewController;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    
	RootViewController *rootViewController;
    UIPopoverController *popoverController;
	NSString *title;
	UIToolbar *toolbar;
	UINavigationBar *navBar;
	UIBarButtonItem *movementsButton;
	
	NSUInteger tokenNumber[4];
	NSMutableArray *tokenArray[4];
	NSIndexPath *pathOfTouchedToken;
	NSMutableArray *drawnObjects;
	NSInteger indexOfDrawnObject;
	
	UIButton *playPause;
    UIButton *drawOnOffButton;
	UIImageView *recycleBin;
	UILabel *lcdLabel;
	DrawSelectView *drawSelectView;
	
	NSUInteger placeInAnimation;
	float animationDur;
	BOOL playShouldContinue;
	
    BOOL drawOnOff;
	BOOL shouldDraw;
}
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *movementsButton;
@property (nonatomic, retain) IBOutlet UIImageView *recycleBin;
@property (nonatomic, retain) IBOutlet UILabel *lcdLabel;
@property (nonatomic, retain) IBOutlet UIButton *playPause;
@property (nonatomic, retain) IBOutlet UIButton *drawOnOffButton;

@property (nonatomic, retain) DrawSelectView *drawSelectView;
@property (nonatomic, retain) NSMutableArray *drawnObjects;
@property (nonatomic, assign) RootViewController *rootViewController;

@property (nonatomic) NSUInteger placeInAnimation;
@property (nonatomic) float animationDur;
@property (nonatomic) BOOL playShouldContinue;

- (IBAction)movementsButtonPressed;
- (IBAction)clearDraw;
- (IBAction)playPausePressed;
- (IBAction)plusPressed;
- (IBAction)minusPressed;
- (IBAction)toggleDraw;

- (TokenView *)createTokenWithStyle:(TokenViewStyle)style;
- (NSMutableArray *)arrayOfAllTokens;
- (void)updateTokenArraysToArray:(NSArray *)arrOfAllTokens withDuration:(float)dur;
- (void)continueAnimation;
- (void)createTokens;
- (NSString *)twoDigitNumber:(NSUInteger)num;

@end