//
//  FlipsideViewController.h
//  FlagQuizGame
//
//  Created by Edward Chiang on 2010/11/15.
//  Copyright GSS 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	
	// control for selecting th enumver of choices in the quiz
	IBOutlet UISegmentedControl *choicesControl;
	
	// switches to include/exclude each region in the quiz
	IBOutlet UISwitch *africaSwitch;
	IBOutlet UISwitch *asiaSwitch;
	IBOutlet UISwitch *europeSwitch;
	IBOutlet UISwitch *northAmericaSwitch;
	IBOutlet UISwitch *oceaniaSwitch;
	IBOutlet UISwitch *southAmericaSwitch;
} // end instance variable declarations

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISegmentedControl *choicesControl;
@property (nonatomic, retain) IBOutlet UISwitch *africaSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *asiaSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *europeSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *northAmericaSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *oceaniaSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *southAmericaSwitch;

- (IBAction)done:(id)sender;
- (void)setSwitches:(NSDictionary *)dictionary;	// set the switch's status
- (void)setSelectedIndex:(int)index;	// set selected segment
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

