//
//  RootViewController.m
//  PlayBook
//
//  Created by Joseph Constan on 8/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"


@implementation RootViewController

@synthesize detailViewController, movementTableView, animationSpeedSlider, movements, 
			shouldReplaceMovement, currentSelectedRow, playNameField, commentTextView,
			comments;


- (NSUInteger)tokenCountForStyle:(TokenViewStyle)style {
	NSUInteger highestCount = 0;
	
	for (int i = 0; i < [movements count]; i++) {
		NSUInteger count = 0;
		for (int j = 0; j < [[[movements objectAtIndex:i] tokenArray] count]; j++) {
			if ([[[[movements objectAtIndex:i] tokenArray] objectAtIndex:j] style] == style) {
				count++;
			}
		}
		if (count > highestCount) {
			highestCount = count;
		}
	}
	
	return highestCount;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	playNameField.delegate = detailViewController;
	
	detailViewController.rootViewController = self;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 740.0);
	self.title = @"Menu";
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	movements = [[NSMutableArray alloc] init];
	comments = [[NSMutableDictionary alloc] init];
	commentTextView.font = [UIFont systemFontOfSize:13.0];
	
	currentSelectedRow = 0;
	animationSpeedSlider.maximumValue = 1.5;
	animationSpeedSlider.value = 0.8;
	shouldReplaceMovement = YES;
	
	[self addMovementButtonPressed];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSUInteger selectedIndexes[2] = {0, currentSelectedRow};
	[movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
	[self tableView:movementTableView didSelectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2]];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UITouches

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[playNameField resignFirstResponder];
}

#pragma mark -
#pragma mark Custom Buttons

- (IBAction)resetPlay {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"All unsaved progress will be lost." delegate:detailViewController cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
    [alert show];
    [alert release];
}

- (IBAction)saveButtonPressed {
	if (playNameField.text.length <= 0) {
		UIAlertView *noNameAlert = [[[UIAlertView alloc] initWithTitle:@"Play Has No Name"
															   message:@"You must name your play before saving it." 
															  delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
		[noNameAlert show];
		return;
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *tempMovementArray = [NSMutableArray array];
	NSMutableDictionary *playFile = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *newMovement = [[NSMutableDictionary alloc] init];
	NSString *playName = playNameField.text;
	
	//update the current movement
	[movements replaceObjectAtIndex:currentSelectedRow withObject:[PlayMovement movementWithTokens:[detailViewController arrayOfAllTokens]
																						  drawings:detailViewController.drawnObjects
																							 place:currentSelectedRow]];
	
	//loop through all the movements
	for (int i = 0; i < [movements count]; i++) {
		[newMovement removeAllObjects];
		//loop through the tokens in each movement
		for (int j = 0; j < [[[movements objectAtIndex:i] tokenArray] count]; j++) {
		//save the origin, number, and style and assign them to their corresponding number
			[newMovement setObject:[NSNumber numberWithUnsignedInteger:[[[[movements objectAtIndex:i] tokenArray] objectAtIndex:j] frame].origin.x]
							forKey:[NSString stringWithFormat:@"token%dOriginX", j]];
			[newMovement setObject:[NSNumber numberWithUnsignedInteger:[[[[movements objectAtIndex:i] tokenArray] objectAtIndex:j] frame].origin.y]
							forKey:[NSString stringWithFormat:@"token%dOriginY", j]];
			[newMovement setObject:[NSNumber numberWithUnsignedInteger:[[[[movements objectAtIndex:i] tokenArray] objectAtIndex:j] num]]
							forKey:[NSString stringWithFormat:@"token%dNum", j]];
			[newMovement setObject:[NSNumber numberWithUnsignedInteger:[[[[movements objectAtIndex:i] tokenArray] objectAtIndex:j] style]]
							forKey:[NSString stringWithFormat:@"token%dStyle", j]];
		} //copy the movement to a temporary array
		NSMutableArray *arrayCopy = [newMovement copy];
		[tempMovementArray addObject:arrayCopy];
		[arrayCopy release];
	}
	//add the movement array to the play dictionary to be saved
	[playFile setObject:tempMovementArray forKey:@"movementArray"];
	[playFile setObject:playName forKey:@"playName"];
	NSMutableDictionary *commentsCopy = [comments copy];
	[playFile setObject:commentsCopy forKey:@"comments"];
	[commentsCopy release];
	/*------other info (drawings, etc) might go here later-----*/
	
	//add the play dictionary to the array of saved plays
	NSMutableArray *savedPlays;
	if ([defaults arrayForKey:@"SavedPlays"]) {
		savedPlays = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"SavedPlays"]];
	} else {
		savedPlays = [NSMutableArray array];
	}
	[savedPlays addObject:playFile];
	[defaults setObject:savedPlays forKey:@"SavedPlays"];
	
	[playFile release];
	[newMovement release];
	
	UIAlertView *savedAlert = [[[UIAlertView alloc] initWithTitle:@"Saved!"
														   message:[NSString stringWithFormat:@"Play \"%@\" has been saved.", playName] 
														  delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
	[savedAlert show];
}

- (IBAction)loadButtonPressed {
	//DELETE EVERYTHING
	//(but I should probably add something to ask for confirmation later)
	//[movementTableView reloadData];
	
	LoadPlayViewController *loadPlayViewController = [[[LoadPlayViewController alloc] init] autorelease];
	loadPlayViewController.rootViewController = self;
	[self.navigationController pushViewController:loadPlayViewController animated:YES];
}

- (IBAction)playButtonPressed {
	[movements replaceObjectAtIndex:currentSelectedRow withObject:[PlayMovement movementWithTokens:[detailViewController arrayOfAllTokens]
																						  drawings:detailViewController.drawnObjects
																							 place:currentSelectedRow]];
	[detailViewController.popoverController dismissPopoverAnimated:YES];
	detailViewController.placeInAnimation = 0;
	detailViewController.animationDur = 2.1-animationSpeedSlider.value;
	detailViewController.lcdLabel.text = @"00";
	detailViewController.playShouldContinue = YES;
	NSLog(@"currentSelectedRow: %d", currentSelectedRow);
	[detailViewController updateTokenArraysToArray:[[movements objectAtIndex:0] tokenArray] withDuration:0];
}

- (IBAction)addMovementButtonPressed {
	[movements addObject:[PlayMovement movementWithTokens:[detailViewController arrayOfAllTokens] drawings:detailViewController.drawnObjects place:[movements count]]];
	[movementTableView reloadData];
	NSUInteger selectedIndexes[2] = {0, currentSelectedRow};
	[movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [movements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	[[movements objectAtIndex:[indexPath indexAtPosition:1]] setPlaceNum:[indexPath indexAtPosition:1]];
    cell.textLabel.text = [NSString stringWithFormat:@"Movement %d", [indexPath indexAtPosition:1]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[movements removeObjectAtIndex:[indexPath indexAtPosition:1]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		if (currentSelectedRow >= [indexPath indexAtPosition:1]) {
			if (currentSelectedRow != 0) currentSelectedRow -= 1;
			[movementTableView reloadData];
			NSUInteger selectedIndexes[2] = {0, currentSelectedRow};
			[movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:selectedIndexes length:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
		}
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	//[movements exchangeObjectAtIndex:[fromIndexPath indexAtPosition:1] withObjectAtIndex:[toIndexPath indexAtPosition:1]];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellTitle = [[[aTableView cellForRowAtIndexPath:indexPath] textLabel] text];
	
	if (shouldReplaceMovement) {
		[movements replaceObjectAtIndex:currentSelectedRow withObject:[PlayMovement movementWithTokens:[detailViewController arrayOfAllTokens]
																									 drawings:detailViewController.drawnObjects
																										place:[indexPath indexAtPosition:1]]];
		if (commentTextView.text.length > 0)
			[comments setObject:commentTextView.text forKey:[NSString stringWithFormat:@"Movement %d", currentSelectedRow]];
	}
	detailViewController.playShouldContinue = NO;
	if ([[comments objectForKey:cellTitle] length] > 0) {
		commentTextView.text = [comments objectForKey:cellTitle];
	} else {
		commentTextView.text = @"";
	}

	NSLog(@"Next Movement: %@", [movements objectAtIndex:[indexPath indexAtPosition:1]]);
    [detailViewController updateTokenArraysToArray:[[movements objectAtIndex:[indexPath indexAtPosition:1]] tokenArray] withDuration:0.5];
	//[detailViewController.popoverController dismissPopoverAnimated:YES];
	currentSelectedRow = [indexPath indexAtPosition:1];
	detailViewController.lcdLabel.text = [detailViewController twoDigitNumber:currentSelectedRow];
	shouldReplaceMovement = YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [detailViewController release];
	[movements release];
	[comments release];
    [super dealloc];
}


@end

