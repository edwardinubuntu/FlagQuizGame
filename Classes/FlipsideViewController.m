//
//  FlipsideViewController.m
//  FlagQuizGame
//
//  Created by Edward Chiang on 2010/11/15.
//  Copyright (C) 1992-2009 by Deitel & Associates, Inc. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@implementation FlipsideViewController

@synthesize delegate;
@synthesize choicesControl;
@synthesize africaSwitch;
@synthesize asiaSwitch;
@synthesize europeSwitch;
@synthesize northAmericaSwitch;
@synthesize oceaniaSwitch;
@synthesize southAmericaSwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
	
	 // if none of the switches are selected
	if (africaSwitch.on) {
		// show an alert promting the user to select at leas one region 
	} else {
		// get the selected index of choicesControl
		int index = [choicesControl selectedSegmentIndex];
		
		// update the number of guess rows on the frontside
		[(MainViewController *)self.delegate setGuessRows:index + 1];
		
		// update the enabled regions on the fronside with the switch values
		NSMutableDictionary *regions = [(MainViewController *)self.delegate regions];
		[regions setValue:[NSNumber numberWithBool:africaSwitch.on] forKey: @"Africa"];
		[regions setValue:[NSNumber numberWithBool:asiaSwitch.on] forKey: @"Asia"];
		[regions setValue:[NSNumber numberWithBool:europeSwitch.on] forKey: @"Europe"];
		[regions setValue:[NSNumber numberWithBool: northAmericaSwitch.on] forKey:@"North_America"];
		[regions setValue:[NSNumber numberWithBool:oceaniaSwitch.on] forKey: @"Oceania"];
		[regions setValue:[NSNumber numberWithBool: southAmericaSwitch.on] forKey:@"South_America"];
		
		// create a new quiz on the frontside
		[(MainViewController *)self.delegate resetQuiz];
		// flip back to the frontside
		[self.delegate flipsideViewControllerDidFinish:self];

	} // end else
}

// update the switches with values from the frontside
- (void)setSwitches:(NSDictionary *)dictionary
{
	// update each switch with its corresponding entry in the dictionary
	[africaSwitch setOn:[[dictionary valueForKey:@"Africa"] boolValue]]; 
	[asiaSwitch setOn:[[dictionary valueForKey:@"Asia"] boolValue]]; 
	[europeSwitch setOn:[[dictionary valueForKey:@"Europe"] boolValue]]; 
	[northAmericaSwitch setOn:[[dictionary valueForKey:@"North_America"] boolValue]]; 
	[oceaniaSwitch setOn:[[dictionary valueForKey:@"Oceania"] boolValue]]; 
	[southAmericaSwitch setOn:[[dictionary valueForKey:@"South_America"] boolValue]];
	
}

// update choicesControl with the value from the frontside
- (void)setSelectedIndex:(int)index {
	choicesControl.selectedSegmentIndex = index; 
} // end method setSelectedIndex:

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[choicesControl release]; // release choicesControl UISegmentedControl 
	[africaSwitch release]; // release africaSwitch UISwitch
	[asiaSwitch release]; // release asiaSwitch UISwitch 
	[europeSwitch release]; // release europeSwitch UISwitch
	[northAmericaSwitch release]; // release northAmericaSwitch UISwitch
	[oceaniaSwitch release]; // release oceaniaSwitch UISwitch 
	[southAmericaSwitch release]; // release southAmericaSwitch UISwitch
    [super dealloc];
}


@end
