//
//  FlagQuizGameAppDelegate.h
//  FlagQuizGame
//
//  Created by Edward Chiang on 2010/11/15.
//  Copyright (C) 1992-2009 by Deitel & Associates, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface FlagQuizGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

