//
//  RootViewController.h
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayBookAppDelegate.h"
#import "TokenView.h"

@class DetailViewController;

@interface RootViewController : UIViewController {
    DetailViewController *detailViewController;
	NSMutableArray *movements;
	NSMutableDictionary *comments;
	NSUInteger currentSelectedRow;
	BOOL shouldReplaceMovement;
	
	UISlider *animationSpeedSlider;
	UITableView *movementTableView;
	UITextField *playNameField;
	UITextView  *commentTextView;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableView *movementTableView;
@property (nonatomic, retain) IBOutlet UISlider *animationSpeedSlider;
@property (nonatomic, retain) IBOutlet UITextField *playNameField;
@property (nonatomic, retain) IBOutlet UITextView  *commentTextView;

@property (nonatomic, retain) NSMutableDictionary *comments;
@property (nonatomic, retain) NSMutableArray *movements;
@property (nonatomic) BOOL shouldReplaceMovement;
@property (nonatomic) NSUInteger currentSelectedRow;

- (NSUInteger)tokenCountForStyle:(TokenViewStyle)style;
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction) addMovementButtonPressed;
- (IBAction) playButtonPressed;
- (IBAction) saveButtonPressed;
- (IBAction) loadButtonPressed;
- (IBAction)resetPlay;

@end
