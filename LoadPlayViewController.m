//
//  LoadPlayViewController.m
//  PlayBook
//
//  Created by Joseph Constan on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadPlayViewController.h"


@implementation LoadPlayViewController

@synthesize rootViewController;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[NSUserDefaults standardUserDefaults] arrayForKey:@"SavedPlays"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *savedPlays = [[NSUserDefaults standardUserDefaults] arrayForKey:@"SavedPlays"];
	cell.textLabel.text = [[savedPlays objectAtIndex:[indexPath indexAtPosition:1]] objectForKey:@"playName"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray *trimmedArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"SavedPlays"]];
		[trimmedArray removeObjectAtIndex:[indexPath indexAtPosition:1]];
		[defaults setObject:trimmedArray forKey:@"SavedPlays"];
		
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *reorderedArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"SavedPlays"]];
	[reorderedArray exchangeObjectAtIndex:[toIndexPath indexAtPosition:1] withObjectAtIndex:[fromIndexPath indexAtPosition:1]];
	[defaults setObject:reorderedArray forKey:@"SavedPlays"];
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
   
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *savedPlays = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"SavedPlays"]];
	NSMutableDictionary *playFile = [savedPlays objectAtIndex:[indexPath indexAtPosition:1]];

	NSArray *movements = [playFile objectForKey:@"movementArray"];
	
	NSMutableArray *tokenArray = [NSMutableArray array];
	NSMutableArray *play = [NSMutableArray array];
	NSDictionary *movement;
	int highestStyleCount[4] = {0,0,0,0};
	
	//loop through all the movements
	for (int i = 0; i < [movements count]; i++) {
		movement = [movements objectAtIndex:i];
		[tokenArray removeAllObjects];
		int styleCount[4] = {0,0,0,0};
		//loop through the tokens in each movement
		for (int j = 0; j < [movement count]/4; j++) {
			
			//load the origin, number, and style and assign them to their corresponding number
			CGPoint tokenOrigin = CGPointMake([[movement objectForKey:[NSString stringWithFormat:@"token%dOriginX", j]] floatValue], 
											  [[movement objectForKey:[NSString stringWithFormat:@"token%dOriginY", j]] floatValue]);
			NSUInteger tokenNum = [[movement objectForKey:[NSString stringWithFormat:@"token%dNum", j]] unsignedIntegerValue];
			NSUInteger tokenStyle = [[movement objectForKey:[NSString stringWithFormat:@"token%dStyle", j]] unsignedIntegerValue];
			
			styleCount[tokenStyle]++;
			
			TokenView *token = [[TokenView alloc] initWithStyle:tokenStyle number:tokenNum];
			token.frame = CGRectMake(tokenOrigin.x, tokenOrigin.y, 50, 50);
			
			//NSLog(@"i=%d j=%d token: %@", i, j, token);
			[tokenArray addObject:token];
			[token release];
		} 
		//get highest count for each token style
		for (int j = 0; j < 4; j++) {
			if (styleCount[j] > highestStyleCount[j]) {
				highestStyleCount[j] = styleCount[j];
			}
		}
		//copy the movement to the play array
		NSMutableArray *tokenArrayCopy = [tokenArray copy];
		[play addObject:[PlayMovement movementWithTokens:tokenArrayCopy drawings:nil place:i]];
		[tokenArrayCopy release];
	}
	//create new tokens if necessary
	for (int j = 0; j < 4; j++) {
		int difference = highestStyleCount[j] - [rootViewController tokenCountForStyle:j];
		if (difference > 0) {
			for (int k = 0; k < difference; k++) {
				TokenView *newToken = [rootViewController.detailViewController createTokenWithStyle:j];
				newToken.hasMoved = YES;
			}
		}
	}
	
	//add the play dictionary to the movement array
	[rootViewController.movements removeAllObjects];
	[rootViewController.movements addObjectsFromArray:play];
	[rootViewController.movementTableView reloadData];	
	//load the comments
	rootViewController.commentTextView.text = @"";
	[rootViewController.comments setDictionary:[playFile objectForKey:@"comments"]];
	
	//set various other factors to make things load right
	rootViewController.shouldReplaceMovement = NO;
	NSUInteger indexes[2] = {0,0};
	[rootViewController.movementTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indexes length:2]
													  animated:YES scrollPosition:UITableViewScrollPositionNone];
	[rootViewController tableView:rootViewController.movementTableView didSelectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indexes length:2]];
	//set the title
	NSString *currentTitle = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
	rootViewController.playNameField.text = currentTitle;
	
	rootViewController.detailViewController.title = [NSString stringWithFormat:@"HoopCoach.org PlayBook: %@", currentTitle];
	[self.navigationController popToRootViewControllerAnimated:YES];
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
    [super dealloc];
}


@end

