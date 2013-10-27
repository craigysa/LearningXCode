//
//  HelloWorldViewController.h
//  HelloWorld
//
//  Created by Craig Young on 2013/10/13.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface HelloWorldViewController : UIViewController <UITextFieldDelegate>{
    //Can be referenced directly in .m file
    __weak IBOutlet UIButton *redButton;
    //__weak IBOutlet UIButton *middleButton;
}
//Must be dereferenced by self. in the .m file
@property (strong, nonatomic) IBOutlet UIButton *roundedButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (copy, nonatomic) NSString *yourName;
@end
