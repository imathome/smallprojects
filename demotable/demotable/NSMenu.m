//
//  NSMenu.m
//  demotable
//
//  Created by Samuel Colak on 19/02/2019.
//  Copyright © 2019 Im-At-Home BV. All rights reserved.
//

#import "NSMenu.h"

@interface NSMenuCell () {
	
	NSString			*_text;
	NSUInteger			_indent;
	
	NSLayoutConstraint	*_indentConstraint;
	
}
	
@end

@implementation NSMenuCell

	@synthesize text=_text;
	@synthesize indent=_indent;
	
	- (NSString *) getText
	{
		return _text;
	}
	
	- (NSUInteger) getIndent
	{
		return _indent;
	}
	
	- (void)setIndent:(NSUInteger)indent
	{
		if (_indent == indent) return;
		_indent = indent;
		
		if (_indentConstraint) {
			
			_indentConstraint.constant = 8 + (_indent * 10);
			
			[_menuLabel layoutIfNeeded];
			
		} else {
			
			[self setNeedsLayout];
			
		}
		
	}
	
	- (void) setText:(NSString *)text
	{
		if ([text isEqualToString:_text]) return;
		_text = text;
		[self setNeedsLayout];
	}
	
	- (void) setup
	{
		_text = @"";
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self layoutSubviews];
	}
	
	- (void) layoutSubviews
	{
		
		[super layoutSubviews];
				
		if (!_menuLabel) {
			_menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
		}
		
		if (!_menuLabel.superview) {
			
			[self addSubview:_menuLabel];
			
			[self addConstraint:[NSLayoutConstraint constraintWithItem:_menuLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
			
			[self addConstraint:[NSLayoutConstraint constraintWithItem:_menuLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20]];
			
			[self addConstraint:[NSLayoutConstraint constraintWithItem:_menuLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:8]];
			
			_indentConstraint = [NSLayoutConstraint constraintWithItem:_menuLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:8 + (_indent * 10)];
			
			[self addConstraint:_indentConstraint];

			[_menuLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
			[_menuLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
			
		}
		
		_menuLabel.text = _text;
		
	}
	
	- (instancetype) init
	{
		self = [super init];
		if (self) {
			[self setup];
		}
		return self;
	}
	
@end


@interface NSMenu () {
	
	NSArray				*_menuItems;
	NSUInteger			_selectedIndex;
	
}
		
@end


@interface NSMenu (TableView) <UITableViewDelegate, UITableViewDataSource>
	
@end


@implementation NSMenu
	
	@synthesize eventSelector;
	@synthesize target;
	@synthesize menuItems=_menuItems;
	
	- (void) setup
	{
		_selectedIndex = NSNotFound;
		[self registerClass:[NSMenuCell class] forCellReuseIdentifier:@"MenuCell"];
		self.dataSource = self;
		self.delegate = self;
	}
	
	- (instancetype) init
	{
		self = [super init];
		if (self) {
			[self setup];
		}
		return self;
	}
	
	- (instancetype) initWithFrame:(CGRect)frame
	{
		self = [super initWithFrame:frame];
		if (self) {
			[self setup];
		}
		return self;
	}
	
	- (instancetype) initWithCoder:(NSCoder *)aDecoder
	{
		self = [super initWithCoder:aDecoder];
		if (self) {
			[self setup];
		}
		return self;
	}
	
	- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
	{
		self = [super initWithFrame:frame style:style];
		if (self) {
			[self setup];
		}
		return self;
	}
	
	- (NSUInteger) getSelectedIndex
	{
		return _selectedIndex;
	}
	
	- (NSArray *) getMenuItems
	{
		return _menuItems;
	}
	
	- (void) setupMenuWithOptions:(NSArray*)options withTarget:(id)target andCallback:(SEL)selector
	{
		_menuItems = options;
		
		self.target = target;
		self.eventSelector = selector;
		
		[self reloadData];
	}

@end


@implementation NSMenu (UITableView)
	
	- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
	{
		return _menuItems.count;
	}
	
	- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
	{
		return 44.0f;
	}
	
	- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
		NSMenuCell *_cellOut = [self dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
		
		NSDictionary *_menuItem = [_menuItems objectAtIndex:indexPath.section];
		
		if (indexPath.row == 0) {
			_cellOut.text = [_menuItem valueForKey:@"title"];
			_cellOut.indent = 0;
		} else {
			NSArray *_payload = [[_menuItems objectAtIndex:indexPath.section] valueForKey:@"payload"];
			_cellOut.text = [_payload objectAtIndex:(indexPath.row - 1)];
			_cellOut.indent = 1;
		}
		
		return _cellOut;
	}
	
	- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
		
		if (indexPath.row == 0) {
			
			[self beginUpdates];
			
			if (_selectedIndex != NSNotFound) {
				
				NSDictionary *_payload = [[_menuItems objectAtIndex:_selectedIndex] valueForKey:@"payload"];
				NSUInteger _count = _payload.count;
				NSMutableArray *_rows = [NSMutableArray new];
				
				for (int _counter=0; _counter<_count; _counter++) {
					[_rows addObject:[NSIndexPath indexPathForRow:(_counter+1) inSection:_selectedIndex]];
				}
				
				[self deleteRowsAtIndexPaths:_rows withRowAnimation:UITableViewRowAnimationTop];
				
			}

			if (_selectedIndex != indexPath.section) {
				
				_selectedIndex = indexPath.section;
				
				NSArray *_payload = [[_menuItems objectAtIndex:_selectedIndex] valueForKey:@"payload"];
				NSUInteger _count = _payload.count;
				NSMutableArray *_rows = [NSMutableArray new];
			
				for (int _counter=0; _counter<_count; _counter++) {
					[_rows addObject:[NSIndexPath indexPathForRow:(_counter+1) inSection:_selectedIndex]];
				}
				
				[self insertRowsAtIndexPaths:_rows withRowAnimation:UITableViewRowAnimationBottom];
				
			} else { // collapse the current menu
				
				_selectedIndex = NSNotFound;
				
			}
			
			[self endUpdates];
			
		}
			
		NSDictionary *_menu = [_menuItems objectAtIndex:indexPath.section];
		
		if (eventSelector) {
			
			NSString *_option = nil;
			
			if (indexPath.row == 0) {
				
				_option = [_menu valueForKey:@"title"];
				
			} else {
				
				NSArray *_payload = [_menu valueForKey:@"payload"];
				_option = [_payload objectAtIndex:(indexPath.row - 1)];
				
			}
			
			[target performSelectorOnMainThread:eventSelector withObject:_option waitUntilDone:NO];
			
		}
		
	}
	
	- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
		NSDictionary *_payload = [[_menuItems objectAtIndex:section] valueForKey:@"payload"];
		
		if (_selectedIndex == section) {
			return 1 + _payload.count;
		}
		
		return 1;
	}

@end
