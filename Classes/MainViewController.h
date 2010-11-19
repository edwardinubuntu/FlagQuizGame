//
//  MainViewController.h
//  FlagQuizGame
//
//  Created by Edward Chiang on 2010/11/15.
//  Copyright GSS 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIImageView *flagView;	// displays the flag image
	IBOutlet UILabel *answerLabel;	// displays if guess is correct
	IBOutlet UILabel *numCorrectLabel;	// displays quiz's progress
	NSMutableArray *bars;	//	stores Semented Controls
	NSMutableArray *fileNames;	// list of flag image file names
	NSMutableArray *quizCountries; // names of 10 countries in the quiz
	NSMutableDictionary *regions;	// store whether each region is enabled
	NSString *correctAnswer;	// the correct country for the current flag
	int totalGuesses; // number of guesses made
	int numCorrect;	//number of Segmented Controls displaying choices
	int guessRows;	// number of Segmented Controls displaying choices
}

// declare the three outlets as properties
@property (nonatomic, retain) IBOutlet UIImageView *flagView;
@property (nonatomic, retain) IBOutlet UILabel *answerLabel;
@property (nonatomic, retain) IBOutlet UILabel *numCorrectLabel;

// method declarations
- (IBAction)showInfo:(id)sender; // displays the FlipsideView
- (IBAction)submitGuess:sender;	// processes a guess
- (void)loadNextFlag;	// displays a new flag and country choices
- (void)setGuessRows:(int)rows;	// sets the number of Segmented Controls
- (void)resetQuiz;	// starts a new quiz
- (NSMutableDictionary *)regions;	// returns the regions dictionary

@end	// end interface MainViewController;

@interface NSString (displayName)	// begin NSString's displayName category
- (NSString *)converToDisplayName;	//converts file name to country name
@end // end category displayName of interface NSString
