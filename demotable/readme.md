
# Collapsable Menu (NSMenu)

For iOS, aTV Platform / Objective-C Only

## Overview

Small UITableview class that implements a mechanism to collapse and expand a number of options (supplied in an array)

## Experience Level

Required understanding of UITableViews, Delegates, Protocols and UIAnimation

## Dependancies (External or Internal)

None

## Functionality shows

	- Usage of NSConstraint
	- Dequeue and reuse functionality
	- Hiding and Showing cells when an option is selected (suspending UITableView events etc)
	- Indenting is provided to highlight options from menu-headers

A mov is provided to show the resulting code
	
## Exposed functions

	- (void) setupMenuWithOptions:(NSArray*)options withTarget:(id)target andCallback:(SEL)selector;

## Properties

	[readonly] menuItems
	[readonly] selectedIndex

## Example code

	[in the header]

	IBOutlet NSMenu *_menuExpander;

	[in the main]
	
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
			@{@"title":@"three", @"payload":@[@"option4", @"option5"]}
			];

		[_menuExpander setupMenuWithOptions:_options withTarget:self andCallback:@selector(optionSelected:)];

	}

Note that the selector is well defined and results in a simple parameter (the menu title or the option selected) being returned

## Extension

The code implements a NSMenuCell which is used to present the UITableViewCell - It is possible to dervive this from a class (or NIB) using the other functions provided for by the class. Note that if you do this, some changes are required in the implementation of the CellForIndexPath functionality in the UITableViewDelegate protocol stubs.


