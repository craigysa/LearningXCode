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
    //These declarations are not encapsulated. The fields are scoped as "protected" and can be accessed directly.
    __weak IBOutlet UIButton *redButton;
    //__weak IBOutlet UIButton *middleButton;
}
//Properties provide encapsulation even within the class. I'm still unclear why they must be dereferenced by self. in the .m file? The properties are automatically "synthesised" with fields having the same name, but prefixed with underscore. The fields **can** be accessed directly. **However** it is still better to usually access the fields via encapsulated accessor methods. The only places where direct access is recommended are: initialisers and custom accessor methods.
@property (strong, nonatomic) IBOutlet UIButton *roundedButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (copy, nonatomic) NSString *yourName;
@property (readonly) NSString *greeting;
@end
