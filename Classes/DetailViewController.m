//
//  DetailViewController.m
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"

@implementation DetailViewController

@synthesize toolbar, popoverController, recycleBin, drawSelectView, drawnObjects, rootViewController, placeInAnimation, animationDur, lcdLabel, playShouldContinue;
@synthesize	playPause, movementsButton, navBar, drawOnOffButton;

#pragma mark -
#pragma mark Custom Methods

- (void)setTitle:(NSString *)newTitle {
	navBar.topItem.title = newTitle;
	title = newTitle;
}

- (void)showHelp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hoopcoach.org/page/hoop-coach-playbook-support"]];
}

- (IBAction)toggleDraw {
    drawOnOff = !drawOnOff;

    [drawOnOffButton setTitle:(drawOnOff ? @"On" : @"Off") forState:UIControlStateNormal];
    [drawOnOffButton setTitle:(drawOnOff ? @"On" : @"Off") forState:UIControlStateHighlighted];

}

- (IBAction)clearDraw {
	for (int i = 0; i < [drawnObjects count]; i++) {
		if ([[drawnObjects  objectAtIndex:i] respondsToSelector:@selector(removeFromSuperview)]) { 
			[[drawnObjects objectAtIndex:i] removeFromSuperview];
		}
	}
	[drawnObjects removeAllObjects];
}

- (IBAction)playPausePressed {
	if ([playPause imageForState:0]==[UIImage imageNamed:@"PauseButton.png"]) {
		// PAUSE
		[playPause setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
		playShouldContinue = NO;
		animationDur = 0;
		placeInAnimation--;
		rootViewController.shouldReplaceMovement = NO;
		NSUInteger selectedIndexes[2] = {0, placeInAnimation};
		[rootViewController.movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
		rootViewController.currentSelectedRow = placeInAnimation;
		[playPause setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
	} else {
		// PLAY
		[playPause setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
		[rootViewController playButtonPressed];
	}
}

- (IBAction)plusPressed {
	//if there is a higher movement in the list to go to, then go to it
	if (rootViewController.currentSelectedRow+1 < [rootViewController.movements count]) {
		[rootViewController.movements replaceObjectAtIndex:rootViewController.currentSelectedRow withObject:[PlayMovement movementWithTokens:[self arrayOfAllTokens]
																																	drawings:drawnObjects
																																	   place:rootViewController.currentSelectedRow]];
		playShouldContinue = NO;
		[self updateTokenArraysToArray:[[rootViewController.movements objectAtIndex:rootViewController.currentSelectedRow+1] tokenArray] withDuration:0.5];
		rootViewController.currentSelectedRow += 1;
		
		NSUInteger selectedIndexes[2] = {0, rootViewController.currentSelectedRow};
		[rootViewController.movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
		lcdLabel.text = [self twoDigitNumber:rootViewController.currentSelectedRow];
	} else {
	//else create a higher movement and go to that
		[rootViewController addMovementButtonPressed];
		[self plusPressed];
	}
}

- (IBAction)minusPressed {
	if (rootViewController.currentSelectedRow > 0) {
		[rootViewController.movements replaceObjectAtIndex:rootViewController.currentSelectedRow withObject:[PlayMovement movementWithTokens:[self arrayOfAllTokens]
																							  drawings:drawnObjects
																								 place:rootViewController.currentSelectedRow]];
		playShouldContinue = NO;
		[self updateTokenArraysToArray:[[rootViewController.movements objectAtIndex:rootViewController.currentSelectedRow-1] tokenArray] withDuration:0.5];
		rootViewController.currentSelectedRow -= 1;
		
		NSUInteger selectedIndexes[2] = {0, rootViewController.currentSelectedRow};
		[rootViewController.movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
		lcdLabel.text = [self twoDigitNumber:rootViewController.currentSelectedRow];
	}
}

- (NSString *)twoDigitNumber:(NSUInteger)num {
	if (num > 9) {
		if (num > 99)
			return [NSString stringWithFormat:@"%d", (num % 100)];
		else
			return [NSString stringWithFormat:@"%d", num];
	} else
		return [NSString stringWithFormat:@"0%d", num];
}

- (TokenView *)createTokenWithStyle:(TokenViewStyle)style {
	NSUInteger lowestUnusedNumber = 1;
	TokenView *newToken;
	
	for (int k = 1; k < 100; k++) {
		BOOL didBreak = NO;
		for (int l = 0; l < [tokenArray[style] count]; l++) {
			lowestUnusedNumber = k;
			if ([[[[tokenArray[style] objectAtIndex:l] numberField] text] isEqualToString:[NSString stringWithFormat:@"%d", k]]) {
				didBreak = YES;
				break;
			}
		}
		//the above function breaks when it finds the lowest number that isn't taken 
		if (didBreak == NO) {
			newToken = [[TokenView alloc] initWithStyle:style number:lowestUnusedNumber];
			newToken.frame = CGRectMake(681, style*80+570, 50, 50);
			[tokenArray[style] addObject:newToken];
			[self.view addSubview:newToken];
			break;
		}
	}
	return [newToken autorelease];
}
	
- (NSMutableArray *)arrayOfAllTokens
{
	NSMutableArray *arr = [NSMutableArray array];
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < [tokenArray[i] count]; j++) {
			if ([[tokenArray[i] objectAtIndex:j] hasMoved] == YES) {
				TokenView *token = [[TokenView alloc] initWithStyle:i number:j+1];
				[token setFrame:[[tokenArray[i] objectAtIndex:j] frame]];
				[arr addObject:token];
				[token release];
			}
		}
	}
	return arr;
}

- (void)continueAnimation {
	placeInAnimation++;
	//playShouldContinue = YES;
	if (placeInAnimation >= [[rootViewController movements] count]) {
		playShouldContinue = NO;
		placeInAnimation -= 1;
		animationDur = 0;
		rootViewController.shouldReplaceMovement = NO;
		//NSUInteger selectedIndexes[2] = {0, 0};
		//[rootViewController.movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
		//rootViewController.currentSelectedRow = 0;
		[playPause setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
	}
	lcdLabel.text = [self twoDigitNumber:placeInAnimation];
	NSLog(@"%d", placeInAnimation);
	[self updateTokenArraysToArray:[[[rootViewController movements] objectAtIndex:placeInAnimation] tokenArray] withDuration:animationDur];
}

- (void)updateTokenArraysToArray:(NSArray *)arrOfAllTokens withDuration:(float)dur {
	[UIView beginAnimations:@"changeMovement" context:nil];
	if (playShouldContinue == YES) {	//if part of animation for all movements
		[UIView setAnimationDidStopSelector:@selector(continueAnimation)];
		[UIView setAnimationDelegate:self];
	} else {
		[UIView setAnimationDidStopSelector:nil];
		[UIView setAnimationDelegate:nil];
	}
	[UIView setAnimationDuration:dur];
	
	for (int i = 0; i < [arrOfAllTokens count]; i++) {
		NSUInteger style = [[arrOfAllTokens objectAtIndex:i] style];
		for (int j = 0; j < [tokenArray[style] count]; j++) {
			if ([[arrOfAllTokens objectAtIndex:i] num] == [[tokenArray[style] objectAtIndex:j] num] &&
				[[tokenArray[style] objectAtIndex:j] hasMoved] == YES) {
				[[tokenArray[style] objectAtIndex:j] setCenter:[[arrOfAllTokens objectAtIndex:i] center]]; 
			}
		}
	}
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [rootViewController.movements removeAllObjects];
        for (int i = 0; i < 4; i++) {
            for (TokenView *token in tokenArray[i]) {
                [token destroyTokenFromArray:tokenArray[i]];
            }
        }
        [rootViewController.movementTableView reloadData];
        [self createTokens];
        rootViewController.playNameField.text = @"";
        rootViewController.commentTextView.text = @"";
        [rootViewController addMovementButtonPressed];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	self.title = [NSString stringWithFormat:@"HoopCoach.org PlayBook: %@", textField.text];
}

#pragma mark -
#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	shouldDraw = YES;
	// acquire the index of token to move
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < [tokenArray[i] count]; j++) {
			if (CGRectContainsPoint([[tokenArray[i] objectAtIndex:j] frame], [[touches anyObject] locationInView:self.view])) {
				NSUInteger indexes[2] = {i, j};
				pathOfTouchedToken = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
				shouldDraw = NO;
			}
		}
	}
	//------------------------------------------------------------------------------------------------------------------------------//
	// Draw Menu
	
    if (drawOnOff == NO) {
        shouldDraw = NO;
        return;
    }
    
	// if the touch is not on anything else, draw with the selected tool
	if ((drawSelectView.isExpanded == NO && !CGRectContainsPoint(CGRectMake(drawSelectView.frame.origin.x, drawSelectView.frame.origin.y, 100, 100), 
																[[touches anyObject] locationInView:self.view])) || 
		(drawSelectView.isExpanded == YES && !CGRectContainsPoint(CGRectMake(drawSelectView.frame.origin.x - 500, drawSelectView.frame.origin.y, 600, 100), 
																[[touches anyObject] locationInView:self.view]) &&
		!CGRectContainsPoint(CGRectMake(playPause.frame.origin.x, playPause.frame.origin.y, 64, 64), [[touches anyObject] locationInView:self.view]))) {
		if (shouldDraw == YES) {
			DrawnObjectView *newDrawnObject = [[DrawnObjectView alloc] initWithOrigin:[[touches anyObject] locationInView:self.view] style:drawSelectView.selectedDrawMode];
			indexOfDrawnObject = [drawnObjects count];
			[self.view insertSubview:newDrawnObject belowSubview:drawSelectView];
			[drawnObjects addObject:newDrawnObject];
		} 
		else 
			shouldDraw = NO;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{

	// this function is ridiculously convoluted, I know...
	// if drawing, update the object
	if (shouldDraw == YES && [drawnObjects count] > 0) {
		[[drawnObjects objectAtIndex:indexOfDrawnObject] setHeadOrigin:[[touches anyObject] locationInView:self.view]];
	} else {
		//check if the user is dragging one of the tokens
		BOOL touchIsOnToken = NO;
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < [tokenArray[i] count]; j++) {
				if (CGRectContainsPoint([[tokenArray[i] objectAtIndex:j] frame], [[touches anyObject] previousLocationInView:self.view])) {
					touchIsOnToken = YES;
				}
			}
		}	
		if (touchIsOnToken == YES) {
			// if token has not been moved yet, create a new token to replace its spot with the lowest unused number

			if ([[tokenArray[[pathOfTouchedToken indexAtPosition:0]] objectAtIndex:[pathOfTouchedToken indexAtPosition:1]] hasMoved] == NO) {
				TokenViewStyle style = [pathOfTouchedToken indexAtPosition:0];
				[self createTokenWithStyle:style];
				[[tokenArray[[pathOfTouchedToken indexAtPosition:0]] objectAtIndex:[pathOfTouchedToken indexAtPosition:1]] setHasMoved:YES];
			}
            // move index to new touch location
			if (CGRectContainsPoint([[tokenArray[[pathOfTouchedToken indexAtPosition:0]] objectAtIndex:[pathOfTouchedToken indexAtPosition:1]] frame], 
									[[touches anyObject] previousLocationInView:self.view])) {
				CGPoint newCenter = [[tokenArray[[pathOfTouchedToken indexAtPosition:0]] objectAtIndex:[pathOfTouchedToken indexAtPosition:1]] center];
				newCenter.x += [[touches anyObject] locationInView:self.view].x - [[touches anyObject] previousLocationInView:self.view].x;
				newCenter.y += [[touches anyObject] locationInView:self.view].y - [[touches anyObject] previousLocationInView:self.view].y;
				[[tokenArray[[pathOfTouchedToken indexAtPosition:0]] objectAtIndex:[pathOfTouchedToken indexAtPosition:1]] setCenter:newCenter];
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	// Token Movement
	if (shouldDraw == YES && [drawnObjects count] > 0) {
		[[drawnObjects objectAtIndex:indexOfDrawnObject] setDoneDragging:YES];
	}
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < [tokenArray[i] count]; j++) {
			if (CGRectContainsPoint([[tokenArray[i] objectAtIndex:j] frame], [[touches anyObject] locationInView:self.view])) {
				// if touch is ended over the trash, destroy the token being dragged
				if (CGRectContainsPoint([recycleBin frame], [[touches anyObject] locationInView:self.view])) {
					[[tokenArray[i] objectAtIndex:j] destroyTokenFromArray:tokenArray[i]];
				}
				// release indexPath object
                //[pathOfTouchedToken release];
			}
		}
	}
	//------------------------------------------------------------------------------------------------------------------------------//
	// Draw Menu
	for (int i = 1; i < 6; i++) {
		if (CGRectContainsPoint(CGRectMake(drawSelectView.frame.origin.x-100*i, drawSelectView.frame.origin.y, 100, 100), 
								[[touches anyObject] locationInView:self.view]) && drawSelectView.isExpanded == YES) {
			drawSelectView.selectedDrawMode = i;
			[drawSelectView closeList];
		}
	}
	shouldDraw = NO;
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Menu";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

- (void)movementsButtonPressed {
	if (popoverController.popoverVisible)
		[self.popoverController dismissPopoverAnimated:YES];
	else
		[self.popoverController presentPopoverFromBarButtonItem:movementsButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation only between portrait and portrait upside-down
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark View lifecycle


- (void)createTokens {

	for (int i = 570; i < 890; i += 80) {
		NSUInteger style = (i-570)/80;
		
		tokenArray[style] = [[NSMutableArray alloc] init];
		TokenView *token = [[TokenView alloc] initWithStyle:style number:1];
		token.frame = CGRectMake(681, i, 50, 50);
		[tokenArray[style] addObject:token];
		[token release];
		[self.view addSubview:[tokenArray[style] lastObject]];
	}
	//auto-populate court with offense
	for (NSUInteger j = 2; j <= 6; j++) {
		TokenView *offToken = [[TokenView alloc] initWithStyle:TokenStyleOffense number:j];
		offToken.frame = CGRectMake(681, 570, 50, 50);
		[self.view insertSubview:offToken belowSubview:[tokenArray[TokenStyleOffense] lastObject]];
		if (j != 6) offToken.hasMoved = YES;
		[[tokenArray[TokenStyleOffense] objectAtIndex:0] setHasMoved:YES];
		[tokenArray[TokenStyleOffense] addObject:offToken];
		
		/*TokenView *defToken = [[TokenView alloc] initWithStyle:TokenStyleDefense number:j];
         defToken.frame = CGRectMake(681, 160, 50, 50);
         [self.view insertSubview:defToken belowSubview:[tokenArray[TokenStyleDefense] lastObject]];
         if (j != 6) defToken.hasMoved = YES;
         [tokenArray[TokenStyleDefense] addObject:defToken];*/
	}
	
	[UIView beginAnimations:@"populateCourt" context:nil];
	[UIView setAnimationDuration:0.9];
	
	// Offense
	CGRect imageFrame = [[tokenArray[TokenStyleOffense] objectAtIndex:0] frame];
	imageFrame.origin.x = 300;
	imageFrame.origin.y = 700;
	[[tokenArray[TokenStyleOffense] objectAtIndex:0] setFrame:imageFrame];
	
	imageFrame = [[tokenArray[TokenStyleOffense] objectAtIndex:1] frame];
	imageFrame.origin.x = 200;
	imageFrame.origin.y = 800;
	[[tokenArray[TokenStyleOffense] objectAtIndex:1] setFrame:imageFrame];
	
	imageFrame = [[tokenArray[TokenStyleOffense] objectAtIndex:2] frame];
	imageFrame.origin.x = 400;
	imageFrame.origin.y = 800;
	[[tokenArray[TokenStyleOffense] objectAtIndex:2] setFrame:imageFrame];
	
	imageFrame = [[tokenArray[TokenStyleOffense] objectAtIndex:3] frame];
	imageFrame.origin.x = 230;
	imageFrame.origin.y = 860;
	[[tokenArray[TokenStyleOffense] objectAtIndex:3] setFrame:imageFrame];
	
	imageFrame = [[tokenArray[TokenStyleOffense] objectAtIndex:4] frame];
	imageFrame.origin.x = 365;
	imageFrame.origin.y = 860;
	[[tokenArray[TokenStyleOffense] objectAtIndex:4] setFrame:imageFrame];
	
	
	//------------------------------------------------------------------------------//
    /*	// Defense
     imageFrame = [[tokenArray[TokenStyleDefense] objectAtIndex:0] frame];
     imageFrame.origin.x = 230;
     imageFrame.origin.y = 140;
     [[tokenArray[TokenStyleDefense] objectAtIndex:0] setFrame:imageFrame];
     
     imageFrame = [[tokenArray[TokenStyleDefense] objectAtIndex:1] frame];
     imageFrame.origin.x = 365;
     imageFrame.origin.y = 140;
     [[tokenArray[TokenStyleDefense] objectAtIndex:1] setFrame:imageFrame];
     
     imageFrame = [[tokenArray[TokenStyleDefense] objectAtIndex:2] frame];
     imageFrame.origin.x = 200;
     imageFrame.origin.y = 200;
     [[tokenArray[TokenStyleDefense] objectAtIndex:2] setFrame:imageFrame];
     
     imageFrame = [[tokenArray[TokenStyleDefense] objectAtIndex:3] frame];
     imageFrame.origin.x = 400;
     imageFrame.origin.y = 200;
     [[tokenArray[TokenStyleDefense] objectAtIndex:3] setFrame:imageFrame];
     
     imageFrame = [[tokenArray[TokenStyleDefense] objectAtIndex:4] frame];
     imageFrame.origin.x = 300;
     imageFrame.origin.y = 290;
     [[tokenArray[TokenStyleDefense] objectAtIndex:4] setFrame:imageFrame]; */
	
	[UIView commitAnimations];

}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawOnOff = YES;
    
    UIBarButtonItem *helpButton = [[[UIBarButtonItem alloc] initWithTitle:@"Instructions" style:UIBarButtonItemStyleBordered target:self action:@selector(showHelp)] autorelease];
    self.navBar.topItem.rightBarButtonItem = helpButton;
		
	lcdLabel.font = [UIFont fontWithName:@"Segmental" size:64.0];
	
    drawSelectView = [[DrawSelectView alloc] initWithFrame:CGRectMake(657, 390, 100, 100)];
	[self.view addSubview:drawSelectView];
	
	drawnObjects = [[NSMutableArray alloc] init];
    
    [self createTokens];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
	
	[drawnObjects release];
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
	for (int i = 0; i < 4; i++) {
		[tokenArray[i] removeAllObjects];
		[tokenArray[i] release];
	}
	[recycleBin release];
	[lcdLabel release];
	[playPause release];
	[drawSelectView release];
	[toolbar release];
    
	[popoverController release];

    [super dealloc];
}

@end
