//
//  MainViewController.m
//  FlagQuizGame
//
//  Created by Edward Chiang on 2010/11/15.
//  Copyright GSS 2010. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MainViewController.h"

static const int BAR_OFFSET = 247; // top Segmented Control's y-coordinate

@implementation MainViewController

// generate get and set methods for outlet properties
@synthesize flagView;
@synthesize answerLabel;
@synthesize numCorrectLabel;

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}
*/

- (void)initInstance {
	guessRows = 1;	// default to one row of choices
	bars = [[NSMutableArray alloc] init];
	fileNames = [[NSMutableArray alloc] init];
	
	// initialize the list of flags to be displayed
	quizCountries = [[NSMutableArray alloc] initWithCapacity:10];
	
	// Create the dictionary of regions
	regions = [[NSMutableDictionary alloc] init];
	
	// default all the regions to on
	NSNumber *yesBool = [NSNumber numberWithBool:YES];
	[regions setValue:yesBool forKey:@"Africa"];
	[regions setValue:yesBool forKey:@"Asia"];
	[regions setValue:yesBool forKey:@"Europe"];
	[regions setValue:yesBool forKey:@"North_America"];
	[regions setValue:yesBool forKey:@"Oceania"];
	[regions setValue:yesBool forKey:@"South_America"];
}

// called wehn the view finishes loading
- (void)viewDidLoad {
	
	[super viewDidLoad];	// call superclass's viewDidLoad method
	srandom(time(0));	// seed random number generator
	[self initInstance];
	
	[answerLabel setText:nil];	// clear answerLabel
	[numCorrectLabel setText:@"Question 1 of 10"];	// initialize label
	
	// get a list of all the png files in the app
	NSMutableArray *paths = [[[NSBundle mainBundle] 
							  pathsForResourcesOfType:@"png" inDirectory:nil] mutableCopy];
	
	// loop through each png file
	for (NSString *filename in paths) {
		// separate the file name from the rest of the path
		filename = [filename lastPathComponent];
		NSLog(@"File name is %@.", filename);
		[fileNames addObject:filename];	// add the display name
	} // end for
	
	NSLog(@"fileNames count is %i.", fileNames.count);
	[paths release];	// release the paths NSMutableArray
	[self resetQuiz];	// start a new quiz
}	// end fo viewDidLoad

// returns the NSMutableDictionary regions
- (NSMutableDictionary *) regions {
	return regions;
}

// called 3 seconds after the user guesses a correct flag
- (void)loadNextFlag {
	// get the file name of the next flag
	NSString *nextImageName = [[quizCountries lastObject] retain];
	[quizCountries removeLastObject];	// remove that flag from list
	correctAnswer = nextImageName;	// update the correct answer
	
	// create a new flag image using the given file name
	UIImage *nextImage = [UIImage imageNamed:nextImageName];
	
	// create a UIImageView for the next flag
	UIImageView *nextImageView = [[UIImageView alloc] initWithImage:nextImage];
	
	// delete the current flagView and put nextImageView in its place
	[nextImageView setFrame:[flagView frame]];	// copy the frame over
	[flagView removeFromSuperview];	// remove flagView from view
	[flagView release];	// release the flagView's memore
	flagView = nextImageView;	// reassign flagView to the new view
	[self.view addSubview:flagView];	// add the new view to view
	
	int offset = BAR_OFFSET + 40 * bars.count; // set offset for next bar
	
	// add new UISegmentedControls if necessary
	for (int i = bars.count; i < guessRows; i++) {
		// create a new bar with three empty items
		UISegmentedControl *bar = [[UISegmentedControl alloc] initWithItems:
									[NSArray arrayWithObjects:@"",@"",@"",nil]];
		bar.segmentedControlStyle = UISegmentedControlStyleBar;
		
		// make the segments stay selected only momentarily
		bar.momentary = YES;
		// tell the bar to call the given method whenever it's touched
		[bar addTarget:self action:@selector(submitGuess:) forControlEvents: UIControlEventValueChanged];
		CGRect frame = bar.frame; // get the current frame for the bar 
		frame.origin.y = offset; // position it below the last bar 
		frame.origin.x = 20; // give it some padding on the left
		// expand the bar to fill the screen with some padding on the right
		frame.size.width = self.view.frame.size.width - 40; 
		bar.frame = frame; // assign the new frame [self.view addSubview:bar]; // add the bar to the main view 
		[bars addObject:bar]; // add the bar to the list of bars 
		[bar release]; // release the bar Segmented Control
		offset += 40;	// increase the offset so the next bar is farther down
	}	// end for
	
	// delete bars if there are too many on the screen
	for (int i = bars.count; i > guessRows; i--) {
		UISegmentedControl *bar = [bars lastObject];	// get the last bar
		[bar removeFromSuperview];	// remove the bar from the main view
		[bars removeLastObject];	// remove the bar 
	}	// end for
	
	// enable all the bars
	for (UISegmentedControl *bar in bars) {
		bar.enabled = YES;	// enable in bars
		
		// enable each segment of the bar
		for (int i = 0; i < 3; i++) {
			[bar setEnabled:YES forSegmentAtIndex:i];
		}
	} // end for
	
	// shuffle filenames
	for (int i = 0; i < fileNames.count; i++) {
		// pick a random int between the current index and the end
		int n = (random() % (fileNames.count - i)) + i;
		
		// swap the object at index i with the index randomly picked
		[fileNames exchangeObjectAtIndex:i withObjectAtIndex:n];
	}	// end for
	
	// get the indext of the string with the correct answer
	int correct = [fileNames indexOfObject:correctAnswer];
	
	// put the correct answer at the end
	[fileNames exchangeObjectAtIndex:fileNames.count - 1 withObjectAtIndex:correct];
	
	int flagIndex = 0;	// start adding flags from the beginning
	
	// loop through each bar and choose incorrect answers to display
	for (int i = 0; i < guessRows; i++) {
		// get the bar at the current index
		UISegmentedControl *bar = (UISegmentedControl *)[bars objectAtIndex:i];
		int segmentIndex = 0;
		
		// loop through each segment of the bar
		while (segmentIndex < 3) {
			NSString *name;	// store country name
			
			// if there is another file name
			if (flagIndex < fileNames.count)
				name = [fileNames objectAtIndex:flagIndex];	// get filename
			else {
				name = nil;	// set name to nil
			}

			// if the region of the selected country is enabled
			[bar setTitle:[name converToDisplayName]
				forSegmentAtIndex:segmentIndex];
			++segmentIndex;
				 
			++flagIndex;	// move to the next entry in the array
		}	// end wihle
	}	// end for
	
	int z = random() % guessRows;	// pick a random bar
	UISegmentedControl *bar = [bars objectAtIndex:z];
	
	// put the correct answer on a randomly chosen segment
	[bar setTitle:[correctAnswer converToDisplayName] forSegmentAtIndex:random() % 3];
	
	// update the label to display the current question number
	[numCorrectLabel setText:[NSString stringWithFormat:@"Question %i of 10", numCorrect +1]];
	
	[answerLabel setText:nil];
}	// end method loadNextFlag

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	// set the controls on the filpside
	[controller setSwitches:regions];
	[controller setSelectedIndex:guessRows];
	
	[controller release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[fileNames release];
	[bars release];
	[quizCountries release];
	[flagView release];
	[answerLabel release];
	[numCorrectLabel release];
    [super dealloc];
} // end method dealloc

// called when the user touches one of the Segmated Control items
- (IBAction)submitGuess:sender {
	// get the index of the selected item
	int index = [sender	selectedSegmentIndex];
	
	// get the title of the bar at that segment, which is the guess
	NSString *guess = [sender titleForSegmentAtIndex:index];
	++totalGuesses;	// increment the number of times the user has guessed
	
	// if the guess is correct
	if ([guess isEqualToString:[correctAnswer converToDisplayName]]) {
		// make the text color a medium green
		answerLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
		answerLabel.text = @"Correct!";	// set the text in the label
		
		// get the correct answer from the correct file name
		NSString *correct = [correctAnswer converToDisplayName];
		
		// loop through each bar
		for (UISegmentedControl *bar in bars) {
			bar.enabled = NO; // don't let the user choose another answer
			// loop through the bar segments
			for (int i = 0; i < 3; i++) {
				// get the segment's title
				NSString *title = [bar titleForSegmentAtIndex:i];
				// if this segment does not have the correct choice
				if (![title isEqualToString:correct]) [bar setEnabled:NO forSegmentAtIndex:i]; // disable segment
				
			} // end for 
		}	// end for
		
		++numCorrect;	// increment the number of correct answers
		// is the game finished?
		if (numCorrect == 10)
		{
			// create the message which includes guess number and percentage
			NSString *message = [NSString stringWithFormat: @"%i guesses, %.02f%% correct", totalGuesses, 1000 / (float)totalGuesses];
			// create an alert to display the message
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Results" message:message delegate:self cancelButtonTitle: @"Reset Quiz" otherButtonTitles:nil];
			[alert show]; // show the alert
			[alert release]; // release the alert UIAlertView }
		}// end if
		else // the game is not finished so load another flag 
		{
			// load a new flag after 3 seconds
			[self performSelector:@selector(loadNextFlag) withObject:nil
					   afterDelay:3];
		} // end else
	}	// end if
	else {
		answerLabel.textColor = [UIColor redColor];
		answerLabel.text = @"Incorrect";
		
		// disable the incorrect choice
		[sender setEnabled:NO forSegmentAtIndex:index];
	} // end else	
}//	end of method submitGuess

// called when the user touches the "Reset Quiz" button in the alert
- (void)alertView:(UIAlertView *)alertView clickButtonAtIndex:(NSInteger)buttonIndex {
	[self resetQuiz];
}	// end method alertView

// set the number of bars for displaying choices
- (void)setGuessRows:(int)rows {
	guessRows = rows;
}	// end method

// rest the quiz
-(void)resetQuiz {
	numCorrect = 0;
	totalGuesses = 0;
	int i = 0;	// initialize i to 0
	
	// add 10 random file names to quizCountries
	while (i < 10) {
		NSLog(@"i is %i",i);
		int n = random() % fileNames.count;	// choose a random index
		NSLog(@"Random number %i",n);
		// get the filename from the end of the path
		NSString *filename = [fileNames objectAtIndex:n];
		NSLog(@"File name: %@",filename);
		
		// if it hasn't already been chosen
		if (![quizCountries containsObject:filename]) {
			[quizCountries addObject:filename];	// add the file to the list
			++i;	// increment i
		}	// end if
	} // end for
	
	[self loadNextFlag]; // load the first flag
}	// end method

@end

@implementation NSString (displayName)

-(NSString *)converToDisplayName {

	// get a mutable copy of the name for editing
	NSMutableString *displayName = [[self mutableCopy] autorelease];
	// remove the .png from the end of the name
	[displayName replaceOccurrencesOfString:@".png" withString:@"" 
									options:NSLiteralSearch range:NSMakeRange(0, displayName.length)];
	
	// replace all underscores with spaces
	[displayName replaceOccurrencesOfString:@"_" withString:@" " 
									options:NSLiteralSearch range:NSMakeRange(0, displayName.length)];
	
	NSLog(@"The file display name is: %@", displayName);
	return displayName;
}	// end method

@end

