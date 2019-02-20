//
//  ViewController.m
//  demotable
//
//  Created by Samuel Colak on 19/02/2019.
//  Copyright © 2019 Im-At-Home BV. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

	- (void) optionSelected:(id)option
	{
		NSLog(@"option selected = %@", option);
	}
	
	- (void) viewDidLoad
	{
		[super viewDidLoad];
		
		NSArray *_options = @[
							  @{@"title":@"one", @"payload":@[@"option1", @"option2", @"option3"]},
							  @{@"title":@"two", @"payload":@[@"option4", @"option5", @"option6", @"option7"]},
							  @{@"title":@"three", @"payload":@[@"option8", @"option9"]}
							  ];

		[_menuExpander setupMenuWithOptions:_options withTarget:self andCallback:@selector(optionSelected:)];
	
	}


@end
